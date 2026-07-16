import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../config/app_colors.dart';
import '../services/api_service.dart';
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

  List<File> _selectedImages = [];
  List<String> _generatedImages = [];

  int _credits = 0;
  bool _isLoading = false;
  bool _isGenerating = false;

  int _completedCount = 0;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCredits();
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
    final settings = _storage.getThemeSettings();

    if (!settings.isValid) {
      _showMessage('Önce Tema sayfasını doldurun.');
      return;
    }

    if (_selectedImages.isEmpty) {
      _showMessage('En az bir ürün görseli seçin.');
      return;
    }

    final scenarios = settings.validScenarios;
    final requiredCredits = _selectedImages.length * scenarios.length;

    if (_credits < requiredCredits) {
      _showMessage(
        'Yetersiz kredi. Gerekli: $requiredCredits, Mevcut: $_credits',
      );
      return;
    }

    // Eski sonuçları temizle
    setState(() {
      _isLoading = true;
      _generatedImages = [];
      _completedCount = 0;
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

      // Polling ile takip et (tek kaynak → çakışma yok)
      _startStatusPolling(jobId);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isGenerating = false;
      });
      _showMessage('Hata: $e');
    }
  }

  // Periyodik durum kontrolü
  Future<void> _startStatusPolling(String jobId) async {
    int attempts = 0;
    const maxAttempts = 150; // 2sn × 150 = ~5 dakika

    while (_isGenerating && mounted && attempts < maxAttempts) {
      await Future.delayed(const Duration(seconds: 2));
      attempts++;

      if (!_isGenerating || !mounted) break;

      try {
        final status = await _api.getJobStatus(jobId);
        final images = List<String>.from(status['images'] ?? []);
        final total = status['totalItems'] as int;
        final jobStatus = status['status'] as String;

        if (!mounted) break;

        final isDone = jobStatus == 'done' || images.length >= total;

        setState(() {
          _generatedImages = images;
          _completedCount = images.length;
          _totalCount = total;

          if (isDone) {
            _isGenerating = false;
            _loadCredits();
          }
        });

        if (isDone) break;
      } catch (e) {
        // sessizce devam et
      }
    }

    // Timeout
    if (mounted && _isGenerating) {
      setState(() => _isGenerating = false);
      _showMessage('İşlem uzun sürdü. Lütfen tekrar deneyin.');
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oluştur'),
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
            const Text(
              'Ürün Görselleri',
              style: TextStyle(
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
                      ? 'Görsel Seç'
                      : '${_selectedImages.length} görsel seçildi',
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
                label: Text(_isLoading ? 'Gönderiliyor...' : 'Oluştur'),
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
                          _isGenerating ? 'Üretiliyor...' : 'Tamamlandı 🎉',
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
              const Text(
                'Üretilen Görseller',
                style: TextStyle(
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
                      errorBuilder: (context, error, stack) {
                        return Container(
                          color: AppColors.derinGri,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.acikGri,
                            ),
                          ),
                        );
                      },
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