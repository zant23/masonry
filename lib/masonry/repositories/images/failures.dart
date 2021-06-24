import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masonry/masonry/repositories/core/failures.dart';

part 'failures.freezed.dart';

@freezed
class ImageRepositoryFailure extends RepositoryFailure
    with _$ImageRepositoryFailure {
  factory ImageRepositoryFailure.unAuthorized(String message) = Unauhtorized;
  factory ImageRepositoryFailure.albumNotFound(String message) = AlbumNotFound;
  factory ImageRepositoryFailure.unknown(String message) = Unknown;
}
