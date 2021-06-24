import 'package:masonry/masonry/models/preview_image.dart';

abstract class ImageService {
  Future<List<PreviewImage>> fetchImages(int page, int pageSize,
      {bool shouldRequestPermission = true});
  Future<bool> requestPermission();
  bool get hasPermission;
}
