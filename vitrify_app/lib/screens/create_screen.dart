import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/gallery_service.dart';
import '../services/signalr_service.dart';
import '../services/storage_service.dart';
import '../widgets/app_alert.dart';
import '../widgets/refreshable.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> implements Refreshable {
  final _api = ApiService();
  final _storage = StorageService();
  final _picker = ImagePicker();
  final _signalR = SignalRService();
  final _gallery = GalleryService();
  final _dio = Dio();

  List<File> _selectedImages = [];
  List<String> _generatedImages = [];

  int _credits = 0;
  bool _isLoading = false;
  bool _isGenerating = false;

  int _completedCount = 0;
  int _failedCount = 0;
  int _totalCount = 0;

  Timer? _fallbackTimer;
  Timer? _stragglerTimer;

  @override
  void initState() {
    super.initState();
    _loadCredits();
    // Uygulama kapatılıp yeniden açılmış olabilir — SignalR/timer gibi
    // bellek-içi mekanizmalar bu sırada kaybolur, bu yüzden yarım kalmış
    // (sonucu hiç görülmemiş) bir job var mı diye cihazda kalıcı olarak
    // sakladığımız kayda bakıyoruz
    _resumePendingJobIfAny();
  }

  // MainScreen bu sekmeye her geçildiğinde çağırır — kredi sayısını tazeler
  // ve (aktif olarak takip etmiyorsak) yarım kalmış bir job olup olmadığını
  // kontrol eder — SignalR kopmuş/hiç bağlanamamış olsa bile sonucu kaçırmayız
  @override
  Future<void> refresh() async {
    await _loadCredits();
    if (!_isGenerating) {
      await _resumePendingJobIfAny();
    }
  }

  Future<void> _resumePendingJobIfAny() async {
    final pendingJobId = _storage.getPendingJobId();
    if (pendingJobId == null) return;
    await _reconcilePendingJob(pendingJobId);
  }

  // SignalR'a hiç güvenmeyen, sadece backend'e soran bağımsız senkronizasyon.
  // Uygulama önceki oturumda kapansa/çökse/arkada SignalR bağlantısı kopsa
  // bile bu, job'un gerçek sonucunu er ya da geç yakalar.
  Future<void> _reconcilePendingJob(String jobId) async {
    try {
      final status = await _api.getJobStatus(jobId);
      final images = List<String>.from(status['images'] ?? []);

      for (final url in images) {
        if (_generatedImages.contains(url)) continue;
        final itemId = Uri.parse(url).pathSegments.last.replaceAll('.jpg', '');
        await _persistGeneratedImage(url, itemId);
      }

      if (!mounted) return;

      final isDone = status['status'] == 'done';
      setState(() {
        _generatedImages = images;
        _completedCount = images.length;
        _totalCount = (status['totalItems'] as num?)?.toInt() ?? images.length;
        if (isDone) _isGenerating = false;
      });

      if (isDone) {
        await _storage.clearPendingJob();
        _loadCredits();
      }
      // Henüz bitmediyse kaydı silmiyoruz — bir sonraki açılışta/sekme
      // dönüşünde tekrar kontrol edilecek
    } catch (_) {
      // sessizce geç — bağlantı yoksa bir sonraki fırsatta tekrar denenecek
    }
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _stragglerTimer?.cancel();
    _signalR.disconnect();
    _dio.close();
    super.dispose();
  }

  Future<void> _loadCredits() async {
    try {
      final credits = await _api.getCredits();
      if (!mounted) return;
      setState(() => _credits = credits);
    } catch (e) {
      // sessizce geç
    }
  }

  // Görsel seç (çoklu)
  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isEmpty) return;

    setState(() {
      _selectedImages = images.map((x) => File(x.path)).toList();
      _generatedImages = [];
      _completedCount = 0;
      _totalCount = 0;
    });
  }

  // Görsel kaldır
  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  // ÜRETİMİ BAŞLAT
  Future<void> _generate() async {
    final l10n = AppLocalizations.of(context)!;
    final settings = _storage.getThemeSettings();

    if (!settings.isValid) {
      _showMessage(l10n.createFillThemeFirst);
      return;
    }

    if (_selectedImages.isEmpty) {
      _showMessage(l10n.createSelectAtLeastOneImage);
      return;
    }

    final scenarios = settings.validScenarios;
    final requiredCredits = _selectedImages.length * scenarios.length;

    if (_credits < requiredCredits) {
      _showMessage(l10n.createInsufficientCredits(requiredCredits, _credits));
      return;
    }

    // Eski sonuçları temizle
    setState(() {
      _isLoading = true;
      _generatedImages = [];
      _completedCount = 0;
      _failedCount = 0;
      _totalCount = requiredCredits;
    });

    try {
      // Backend'e job gönder (ANINDA cevap döner)
      final result = await _api.createJob(
        images: _selectedImages,
        scenePrompt: settings.scenePrompt,
        scenarios: scenarios,
        aspectRatio: settings.aspectRatio,
      );

      final jobId = result['jobId'] as String;

      // Job backend'de oluşturuldu — buradan sonra ne olursa olsun (SignalR
      // kopsa, uygulama kapansa) bu kaydı cihazda tutuyoruz; bir sonraki
      // açılışta/sekme dönüşünde gerçek sonucu backend'den sorup buluruz.
      // Bu noktadan sonraki bir hata artık "işlem hiç olmadı" demek DEĞİL.
      await _storage.savePendingJob(jobId);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isGenerating = true;
      });

      // SignalR ile ANLIK takip (birincil, best-effort); bağlanamazsa
      // _trackJob içindeki fallback timer ve pending job kaydı sonucu
      // yine de yakalar
      await _trackJob(jobId);
    } catch (e) {
      // Bu yalnızca createJob() başarısız olduğunda (job hiç oluşmadıysa)
      // tetiklenir — bu noktada gerçekten hiçbir şey olmamıştır, kredi de
      // düşmemiştir
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isGenerating = false;
      });
      _showMessage(l10n.genericErrorMessage);
    }
  }

  // SignalR aboneliğini başlat + beklenmedik uzamalar için güvenlik ağı kur.
  // SignalR bağlanamazsa (arkaya alınmış, ağ kopmuş vb.) burada asla
  // fırlatmıyoruz — pending job kaydı zaten job'u güvenceye almış durumda,
  // bu yalnızca canlı güncelleme için "best-effort" bir katman.
  Future<void> _trackJob(String jobId) async {
    _fallbackTimer?.cancel();

    try {
      await _signalR.connectAndSubscribe(
        jobId,
        onReady: (data) => _handleImageReady(data),
        onFailed: (data) => _handleImageFailed(data),
      );
    } catch (_) {
      // sessizce geç — aşağıdaki fallback timer ve pending job kaydı
      // sonucu er ya da geç yakalayacak
    }

    _fallbackTimer = Timer(const Duration(minutes: 5), () {
      if (mounted && _isGenerating) {
        _reconcileViaPolling(jobId);
      }
    });
  }

  void _handleImageReady(Map<String, dynamic> data) {
    if (!mounted) return;

    final outputUrl = data['outputUrl'] as String?;
    final jobItemId = data['jobItemId'] as String?;
    final jobId = data['jobId'] as String?;

    setState(() {
      if (outputUrl != null) _generatedImages.add(outputUrl);
      _completedCount++;
    });

    if (outputUrl != null && jobItemId != null) {
      _persistGeneratedImage(outputUrl, jobItemId);
    }

    _checkIfJobFinished(jobId);
  }

  // Görseli cihaza kalıcı olarak kaydeder (Galeri sekmesinde listelenebilsin diye)
  Future<void> _persistGeneratedImage(String outputUrl, String jobItemId) async {
    try {
      final response = await _dio.get<List<int>>(
        outputUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null) return;

      await _gallery.saveGeneratedImage(Uint8List.fromList(bytes), jobItemId);
    } catch (_) {
      // sessizce geç — galeriye kaydedilemedi, üretim sonucu yine de gösteriliyor
    }
  }

  void _handleImageFailed(Map<String, dynamic> data) {
    if (!mounted) return;

    final jobId = data['jobId'] as String?;
    setState(() => _failedCount++);
    _checkIfJobFinished(jobId);
  }

  // Backend başarısız kalemlerde CompletedItems'ı artırmıyor (JobProcessingService),
  // bu yüzden bitişi (başarılı + başarısız) >= toplam olarak sayıyoruz
  void _checkIfJobFinished(String? jobId) {
    if (_completedCount + _failedCount >= _totalCount && jobId != null) {
      _finishJob(jobId);
    }
  }

  Future<void> _finishJob(String jobId) async {
    _fallbackTimer?.cancel();
    await _signalR.disconnect();
    await _storage.clearPendingJob();

    if (!mounted) return;
    setState(() => _isGenerating = false);
    _loadCredits();

    if (_failedCount > 0) {
      _showMessage(AppLocalizations.of(context)!.createSomeFailed(_failedCount));

      // Backend (Hangfire) başarısız kalemleri arka planda otomatik tekrar
      // dener — biz artık dinlemeyi bıraktığımız için sonradan başarılı
      // olursa Galeri'ye hiç düşmezdi. Bir kez daha kontrol edip yakalıyoruz.
      _scheduleStragglerCheck(jobId, List<String>.from(_generatedImages));
    }
  }

  // Hangfire'ın gecikmeli tekrar denemesi (backoff dakikalarca sürebiliyor)
  // sonradan başarılı olursa (biz artık canlı dinlemiyorken) yeni görselleri
  // yakalayıp hem Galeri'ye kaydeder hem de ekrandaki gride ekler. Tek seferlik
  // kontrol yerine, tekrar denemenin geç gelme ihtimaline karşı belirli
  // aralıklarla birkaç kez kontrol eder.
  void _scheduleStragglerCheck(String jobId, List<String> knownImages) {
    _stragglerTimer?.cancel();
    var attempts = 0;
    const maxAttempts = 20; // ~10 dakika boyunca 30 saniyede bir kontrol
    _stragglerTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      attempts++;
      try {
        final status = await _api.getJobStatus(jobId);
        final images = List<String>.from(status['images'] ?? []);
        final newImages = images.where((url) => !knownImages.contains(url)).toList();

        for (final url in newImages) {
          final itemId = Uri.parse(url).pathSegments.last.replaceAll('.jpg', '');
          await _persistGeneratedImage(url, itemId);
          knownImages.add(url);
        }

        if (newImages.isNotEmpty && mounted) {
          setState(() => _generatedImages.addAll(newImages));
        }

        if (status['status'] == 'done' || attempts >= maxAttempts) {
          timer.cancel();
        }
      } catch (_) {
        if (attempts >= maxAttempts) timer.cancel();
      }
    });
  }

  // Güvenlik ağı: SignalR beklenenden uzun sürerse tek seferlik senkronizasyon
  // (birincil mekanizma DEĞİL — sadece son çare). Gerçek işi zaten
  // _reconcilePendingJob yapıyor; job hâlâ bitmediyse kaydı SİLMİYORUZ —
  // arka planda bitince push bildirimi gelecek, sekmeye dönünce de otomatik
  // yakalanacak, kullanıcıya sadece "bekleme uzadı" diye haber veriyoruz.
  Future<void> _reconcileViaPolling(String jobId) async {
    await _reconcilePendingJob(jobId);
    await _signalR.disconnect();

    if (!mounted || !_isGenerating) return;

    setState(() => _isGenerating = false);
    _showMessage(AppLocalizations.of(context)!.createTimeout);
  }

  Widget _brokenImagePlaceholder() {
    return Container(
      color: AppColors.derinGri(context),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.acikGri(context),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    AppAlert.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createAppBarTitle),
        backgroundColor: AppColors.derinGri(context),
        elevation: 0,
        actions: [
          // Kredi göstergesi
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.derinGri(context),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt,
                    color: AppColors.vitrifyMavisi(context), size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_credits',
                  style: TextStyle(
                    color: AppColors.safBeyaz(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- GÖRSEL SEÇME ----
            Text(
              l10n.createProductImagesTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.safBeyaz(context),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isGenerating ? null : _pickImages,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(
                  _selectedImages.isEmpty
                      ? l10n.createSelectImages
                      : l10n.createImagesSelected(_selectedImages.length),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.vitrifyMavisi(context),
                  side: BorderSide(color: AppColors.vitrifyMavisi(context)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Seçilen görseller önizleme
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.file(
                              _selectedImages[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (!_isGenerating)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColors.safBeyaz(context),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 32),

            // ---- OLUŞTUR BUTONU ----
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_isLoading || _isGenerating) ? null : _generate,
                icon: _isLoading
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.safBeyaz(context),
                  ),
                )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isLoading ? l10n.createSubmitting : l10n.createGenerateButton),
              ),
            ),

            // ---- İLERLEME ----
            if (_isGenerating || _generatedImages.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.derinGri(context),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isGenerating ? l10n.createGenerating : l10n.createCompleted,
                          style: TextStyle(
                            color: AppColors.safBeyaz(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$_completedCount / $_totalCount',
                          style: TextStyle(color: AppColors.acikGri(context)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value:
                      _totalCount > 0 ? _completedCount / _totalCount : 0,
                      backgroundColor: AppColors.geceSiyahi(context),
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.vitrifyMavisi(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ---- ÜRETİLEN GÖRSELLER ----
            if (_generatedImages.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                l10n.createGeneratedImagesTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.safBeyaz(context),
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _generatedImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      _generatedImages[index],
                      key: ValueKey(_generatedImages[index]),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.derinGri(context),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.vitrifyMavisi(context),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stack) =>
                          _brokenImagePlaceholder(),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}