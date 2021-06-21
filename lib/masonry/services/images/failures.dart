import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class ImageServiceFailure with _$ImageServiceFailure {
  factory ImageServiceFailure.unauthorized() = Unauthorized;
  factory ImageServiceFailure.albumNotFound() = AlbumNotFound;
}
