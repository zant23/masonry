import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:masonry/masonry/models/preview_image.dart';
import 'package:masonry/masonry/repositories/images/failures.dart';
import 'package:masonry/masonry/services/images/failures.dart';
import 'package:masonry/masonry/services/images/image_service.dart';
import 'package:masonry/masonry/services/images/local_image_service.dart';

final localImageRepositoryProvider = Provider<ImageRepository>((ref) {
  final imageService = ref.read(localImageServiceProvider);

  return ImageRepository(imageService);
});

class ImageRepository {
  final ImageService _imageService;
  ImageRepository(this._imageService);

  Future<Either<ImageRepositoryFailure, bool>> requestPermission() {
    return Task<bool>(() => _imageService.requestPermission())
        .attempt()
        .map((either) => either.leftMap((failure) =>
            _failureToImageRepositoryFailure(failure as ImageServiceFailure)))
        .run();
  }

  Future<Either<ImageRepositoryFailure, List<PreviewImage>>> fetchImages(
      int page, int pageSize,
      {bool shouldRequestPermission = true}) async {
    return Task<List<PreviewImage>>(() => _imageService.fetchImages(
            page, pageSize, shouldRequestPermission: shouldRequestPermission))
        .attempt()
        .map((either) => either.leftMap((failure) =>
            _failureToImageRepositoryFailure(failure as ImageServiceFailure)))
        .run();
  }

  ImageRepositoryFailure _failureToImageRepositoryFailure(
      ImageServiceFailure imageServiceFailure) {
    return imageServiceFailure.map(
        unauthorized: (_) => ImageRepositoryFailure.unAuthorized(
            'Please open your App Settings!'),
        albumNotFound: (_) => ImageRepositoryFailure.albumNotFound(
            'Could not find the album. Maybe you havent taken any pictures yet.'));
  }
}
