import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

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

  // Cihazın asıl fotoğraf galerisine kaydeder (sadece "ekleme" izni ister)
  Future<bool> saveToDeviceGallery(File file) async {
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.addOnly,
      ),
    );

    if (!state.isAuth) return false;

    await PhotoManager.editor.saveImageWithPath(
      file.path,
      title: 'vitrify_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    return true;
  }
}
