import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masonry/masonry/providers/core/failures.dart';

part 'failures.freezed.dart';

@freezed
class ImageProviderFailure extends ProviderFailure with _$ImageProviderFailure {
  factory ImageProviderFailure.unAuthorized(String message) = Unauhtorized;
  factory ImageProviderFailure.albumNotFound(String message) = AlbumNotFound;
  factory ImageProviderFailure.unknown(String message) = Unknown;
}
