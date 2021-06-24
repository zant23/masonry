import 'dart:io';
import 'dart:typed_data';

import 'package:masonry/masonry/models/preview_image.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoManagerPreviewImage implements PreviewImage {
  final AssetEntity _asset;

  @override
  final String id;

  PhotoManagerPreviewImage({required AssetEntity asset})
      : _asset = asset,
        id = asset.id;

  @override
  double heightFor({required double width}) {
    return _asset.height * width / _asset.width;
  }

  @override
  Future<Uint8List?> previewWithFixedWidth(double width) {
    return _asset.thumbDataWithSize(
        width.round(), heightFor(width: width).round());
  }

  @override
  Future<File?> fullImageFile() {
    return _asset.file;
  }
}
