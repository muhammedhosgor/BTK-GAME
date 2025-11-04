import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// 📸 Kamera veya galeriden resim seçme fonksiyonu
Future<File?> pickImage({required bool fromCamera}) async {
  final ImagePicker picker = ImagePicker();

  try {
    final XFile? pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85, // kaliteyi biraz düşürüp boyutu küçültür
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  } catch (e) {
    print('❌ Image pick error: $e');
    return null;
  }
}
