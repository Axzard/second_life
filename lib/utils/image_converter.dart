import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ImageConverter {
  // Convert file ke base64
  static Future<String> fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  // Convert base64 ke Uint8List (untuk Image.memory())
  static Uint8List base64ToBytes(String base64Str) {
    return base64Decode(base64Str);
  }
}
