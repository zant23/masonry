import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:masonry/masonry/models/PreviewImage.dart';
import 'package:masonry/masonry/presentation/constants/constants.dart';
import 'package:masonry/masonry/providers/images/failures.dart';
import 'package:masonry/masonry/services/images/failures.dart';
import 'package:masonry/masonry/services/images/image_service.dart';

class PreviewImageProvider extends ChangeNotifier {
  List<PreviewImage> _previewImages = [];

  int _currentPage = 0;

  List<PreviewImage> get previewImages => List.unmodifiable(_previewImages);

  void openSettings() {
    ImageService.openSettings();
  }

  Future<Option<ImageProviderFailure>> fetchImages() async {
    try {
      List<PreviewImage> assets =
          await ImageService.fetchImages(_currentPage, kFetchImagePageSize);
      _previewImages.addAll(assets);
      _currentPage++;
      notifyListeners();
      return none();
    } catch (e) {
      return some(_toImageProviderFailure(e));
    }
  }

  static ImageProviderFailure _toImageProviderFailure(Object error) {
    try {
      return (error as ImageServiceFailure).map(
          unauthorized: (_) => ImageProviderFailure.unAuthorized(
              'The App is not authorized to view Images. Please go to the App Settings to change that.'),
          albumNotFound: (_) => ImageProviderFailure.albumNotFound(
              "It seems like you havent taken any pictures yet."));
    } catch (e) {
      return ImageProviderFailure.unknown('The app seems to have a problem.');
    }
  }
}
