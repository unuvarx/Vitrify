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

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
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

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
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

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isGenerating = true;
      });

      // SignalR ile ANLIK takip (birincil); polling sadece güvenlik ağı
      await _trackJob(jobId);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isGenerating = false;
      });
      _showMessage(l10n.genericErrorMessage('$e'));
    }
  }

  // SignalR aboneliğini başlat + beklenmedik uzamalar için güvenlik ağı kur
  Future<void> _trackJob(String jobId) async {
    _fallbackTimer?.cancel();

    await _signalR.connectAndSubscribe(
      jobId,
      onReady: (data) => _handleImageReady(data),
      onFailed: (data) => _handleImageFailed(data),
    );

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

    setState(() {
      if (outputUrl != null) _generatedImages.add(outputUrl);
      _completedCount++;
    });

    if (outputUrl != null && jobItemId != null) {
      _persistGeneratedImage(outputUrl, jobItemId);
    }

    _checkIfJobFinished();
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

    setState(() => _failedCount++);
    _checkIfJobFinished();
  }

  // Backend başarısız kalemlerde CompletedItems'ı artırmıyor (JobProcessingService),
  // bu yüzden bitişi (başarılı + başarısız) >= toplam olarak sayıyoruz
  void _checkIfJobFinished() {
    if (_completedCount + _failedCount >= _totalCount) {
      _finishJob();
    }
  }

  Future<void> _finishJob() async {
    _fallbackTimer?.cancel();
    await _signalR.disconnect();

    if (!mounted) return;
    setState(() => _isGenerating = false);
    _loadCredits();

    if (_failedCount > 0) {
      _showMessage(AppLocalizations.of(context)!.createSomeFailed(_failedCount));
    }
  }

  // Güvenlik ağı: SignalR beklenenden uzun sürerse tek seferlik senkronizasyon
  // (birincil mekanizma DEĞİL — sadece son çare)
  Future<void> _reconcileViaPolling(String jobId) async {
    try {
      final status = await _api.getJobStatus(jobId);
      final images = List<String>.from(status['images'] ?? []);

      if (!mounted) return;
      setState(() {
        _generatedImages = images;
        _completedCount = images.length;
      });
    } catch (_) {
      // sessizce geç
    }

    await _signalR.disconnect();

    if (!mounted) return;
    setState(() => _isGenerating = false);
    _loadCredits();
    _showMessage(AppLocalizations.of(context)!.createTimeout);
  }

  Widget _brokenImagePlaceholder() {
    return Container(
      color: AppColors.derinGri,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.acikGri,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.derinGri,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createAppBarTitle),
        backgroundColor: AppColors.geceSiyahi,
        elevation: 0,
        actions: [
          // Kredi göstergesi
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.derinGri,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt,
                    color: AppColors.vitrifyMavisi, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_credits',
                  style: const TextStyle(
                    color: AppColors.safBeyaz,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.safBeyaz,
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
                  foregroundColor: AppColors.vitrifyMavisi,
                  side: const BorderSide(color: AppColors.vitrifyMavisi),
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
                            borderRadius: BorderRadius.circular(12),
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
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColors.safBeyaz,
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
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.safBeyaz,
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
                  color: AppColors.derinGri,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isGenerating ? l10n.createGenerating : l10n.createCompleted,
                          style: const TextStyle(
                            color: AppColors.safBeyaz,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$_completedCount / $_totalCount',
                          style: const TextStyle(color: AppColors.acikGri),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value:
                      _totalCount > 0 ? _completedCount / _totalCount : 0,
                      backgroundColor: AppColors.geceSiyahi,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.vitrifyMavisi,
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.safBeyaz,
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
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _generatedImages[index],
                      key: ValueKey(_generatedImages[index]),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.derinGri,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.vitrifyMavisi,
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