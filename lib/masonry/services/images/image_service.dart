import 'package:masonry/masonry/models/PreviewImage.dart';
import 'package:masonry/masonry/services/images/failures.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageService {
  static late Future<AssetPathEntity?> _album = _initAlbum();
  static late Future<bool> _isAuthorized = PhotoManager.requestPermission();

  static Future<AssetPathEntity?> _initAlbum() async {
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.image);

    if (albums.length < 1) return null;
    return albums[0];
  }

  static openSettings() {
    PhotoManager.openSetting();
  }

  static Future<List<PreviewImage>> fetchImages(int page, int pageSize) async {
    bool auth = await _isAuthorized;
    if (!auth) throw ImageServiceFailure.unauthorized();

    AssetPathEntity? alb = await _album;
    if (alb == null) throw ImageServiceFailure.albumNotFound();

    List<AssetEntity> images = await alb.getAssetListPaged(page, pageSize);

    return images.map((asset) => PreviewImage(asset: asset)).toList();
  }
}
