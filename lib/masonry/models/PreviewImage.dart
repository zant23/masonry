import 'dart:io';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';

class PreviewImage {
  final AssetEntity _asset;
  final String id;

  PreviewImage({required AssetEntity asset})
      : _asset = asset,
        id = asset.id;

  double heightFor(double width) {
    return _asset.height * width / _asset.width;
  }

  Future<Uint8List?> previewWithFixedWidth(double width) {
    return _asset.thumbDataWithSize(
        width.round(), this.heightFor(width).round());
  }

  Future<File?> fullImageFile() {
    return _asset.file;
  }
}
