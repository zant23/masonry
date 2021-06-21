import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class PreviewImage {
  final AssetEntity asset;
  final String id;

  PreviewImage({required this.asset}) : id = asset.id;

  double heightFor(double width) {
    return asset.height * width / asset.width;
  }

  Future<Uint8List?> preview(double width) {
    return asset.thumbDataWithSize(
        width.round(), this.heightFor(width).round());
  }

  Future<File?> fullImageFile() {
    return asset.file;
  }
}
