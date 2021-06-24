import 'dart:io';
import 'dart:typed_data';

abstract class PreviewImage {
  String get id;

  double heightFor({required double width});
  Future<Uint8List?> previewWithFixedWidth(double width);
  Future<File?> fullImageFile();
}
