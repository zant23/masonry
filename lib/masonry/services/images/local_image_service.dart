import 'package:hooks_riverpod/all.dart';
import 'package:masonry/masonry/models/photo_manager_preview_image.dart';
import 'package:masonry/masonry/models/preview_image.dart';
import 'package:photo_manager/photo_manager.dart';

import 'failures.dart';
import 'image_service.dart';

final localImageServiceProvider = Provider<LocalImageService>((ref) {
  return LocalImageService();
});

class LocalImageService implements ImageService {
  late final Future<AssetPathEntity?> _album = _initAlbum();
  bool _hasPermission = false;

  static Future<AssetPathEntity?> _initAlbum() async {
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.image);

    if (albums.isEmpty) return null;
    return albums[0];
  }

  @override
  bool get hasPermission => _hasPermission;

  @override
  Future<List<PreviewImage>> fetchImages(int page, int pageSize,
      {bool shouldRequestPermission = true}) async {
    if (shouldRequestPermission && !hasPermission) {
      await requestPermission();
    }
    if (!hasPermission) throw ImageServiceFailure.unauthorized();

    final AssetPathEntity? alb = await _album;
    if (alb == null) throw ImageServiceFailure.albumNotFound();

    final List<AssetEntity> images =
        await alb.getAssetListPaged(page, pageSize);

    return images
        .map((asset) => PhotoManagerPreviewImage(asset: asset))
        .toList();
  }

  @override
  Future<bool> requestPermission() async {
    final bool hasPerm = await PhotoManager.requestPermission();
    _hasPermission = hasPerm;
    return PhotoManager.requestPermission();
  }
}
