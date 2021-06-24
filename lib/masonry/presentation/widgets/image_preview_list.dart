import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:masonry/masonry/controllers/image_controller.dart';
import 'package:masonry/masonry/models/preview_image.dart';
import 'package:masonry/masonry/presentation/constants/constants.dart';
import 'package:masonry/masonry/presentation/constants/palette.dart';
import 'package:masonry/masonry/presentation/widgets/image_preview.dart';
import 'package:masonry/masonry/repositories/images/failures.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class ImagePreviewList extends HookWidget {
  const ImagePreviewList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final imagePreviewListState = useProvider(imageControllerProvider);

    return imagePreviewListState.when(
        data: (images) => _buildData(context, images),
        loading: () => _buildLoading(),
        error: (error, stacktrace) => _buildError(error));
  }

  Widget _buildData(BuildContext context, List<PreviewImage> previewImages) {
    return SliverWaterfallFlow(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (index ==
              previewImages.length - (2 * kFetchImagePageSize / 3).round()) {
            context.read(imageControllerProvider.notifier).fetchMoreImages();
          }
          return _buildPreviewContainer(context, previewImages[index]);
        }, childCount: previewImages.length),
        gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: kMasonryColumns));
  }

  Widget _buildLoading() {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultTextColor),
        ),
      ),
    );
  }

  Widget _buildError(Object error) {
    String message = 'Ups something went wrong.';
    try {
      message = (error as ImageRepositoryFailure).message;
    } catch (e) {}

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget _buildPreviewContainer(BuildContext context, PreviewImage preview) {
    return PreviewImageContainer(
      key: Key(preview.id),
      previewImage: preview,
      width: MediaQuery.of(context).size.width / kMasonryColumns,
      padding: const EdgeInsets.all(4),
    );
  }
}
