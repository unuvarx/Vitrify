import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

enum SaveToGalleryResult { success, permissionDenied, saveFailed }

class GalleryService {
  static const String _folderName = 'vitrify_gallery';

  Future<Directory> _galleryDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${docsDir.path}/$_folderName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  // Üretilen görseli cihazda (uygulama içi galeri için) kalıcı olarak sakla
  Future<File> saveGeneratedImage(Uint8List bytes, String id) async {
    final dir = await _galleryDir();
    final file = File('${dir.path}/$id.jpg');
    return file.writeAsBytes(bytes);
  }

  // Kayıtlı tüm görselleri en yeniden eskiye sıralı döndürür
  Future<List<File>> listGeneratedImages() async {
    final dir = await _galleryDir();
    final entries = await dir.list().toList();
    final files = entries.whereType<File>().toList();
    files.sort(
      (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
    );
    return files;
  }

  Future<void> deleteImage(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Cihazın asıl fotoğraf galerisine kaydeder (sadece "ekleme" izni ister).
  // saveImageWithPath (dosya yolu bazlı) yerine bilerek saveImage (byte bazlı)
  // kullanıyoruz — path bazlı yöntem photo_manager'da native tarafta çökmelere
  // yol açan bilinen bir sorun sınıfı, byte vermek bu native karmaşıklığı azaltıyor.
  Future<SaveToGalleryResult> saveToDeviceGallery(File file) async {
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.addOnly,
      ),
    );

    if (!state.isAuth) return SaveToGalleryResult.permissionDenied;

    try {
      final bytes = await file.readAsBytes();
      await PhotoManager.editor.saveImage(
        bytes,
        filename: 'vitrify_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      return SaveToGalleryResult.success;
    } catch (_) {
      // Native taraf (photo_manager) bir hata döndürdü — uygulamayı
      // çökertmek yerine düzgün bir "başarısız" sonucu döndürüyoruz
      return SaveToGalleryResult.saveFailed;
    }
  }
}
