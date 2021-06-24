import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:masonry/masonry/models/preview_image.dart';
import 'package:masonry/masonry/presentation/constants/constants.dart';
import 'package:masonry/masonry/repositories/images/failures.dart';
import 'package:masonry/masonry/repositories/images/image_repository.dart';

final imageControllerErrorProvider =
    StateProvider<ImageRepositoryFailure?>((_) => null);
final imageControllerProvider =
    StateNotifierProvider<ImageController, AsyncValue<List<PreviewImage>>>(
        (ref) {
  final imageRepository = ref.watch(localImageRepositoryProvider);

  return ImageController(ref.read, imageRepository);
});

class ImageController extends StateNotifier<AsyncValue<List<PreviewImage>>> {
  int _page = 0;

  final ImageRepository _imageRepository;
  final Reader _read;
  ImageController(this._read, this._imageRepository,
      [AsyncValue<List<PreviewImage>>? state])
      : super(state ?? const AsyncValue.loading()) {
    _initImages();
  }

  Future<void> _initImages() async {
    _page = 0;

    state = const AsyncValue.loading();
    final Either<ImageRepositoryFailure, List<PreviewImage>> failureOrImages =
        await _imageRepository.fetchImages(_page, kFetchImagePageSize);

    failureOrImages.fold((failure) {
      state = AsyncValue.error(failure);
    }, (images) {
      state = AsyncValue.data(images);
      _page++;
    });
  }

  Future<void> fetchMoreImages() async {
    final Either<ImageRepositoryFailure, List<PreviewImage>> failureOrImages =
        await _imageRepository.fetchImages(_page, kFetchImagePageSize);

    failureOrImages.fold((failure) {
      _read(imageControllerErrorProvider).state = failure;
    }, (newImages) {
      state = state.whenData((images) {
        _page++;
        return images..addAll(newImages);
      });
    });
  }
}
