import 'dart:collection';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:masonry/masonry/models/PreviewImage.dart';
import 'package:masonry/masonry/presentation/constants/constants.dart';
import 'package:masonry/masonry/presentation/constants/palette.dart';
import 'package:masonry/masonry/presentation/widgets/image_preview.dart';
import 'package:masonry/masonry/providers/images/failures.dart';
import 'package:masonry/masonry/providers/images/preview_image_provider.dart';
import 'package:provider/provider.dart';

class MasonryImagePage extends StatefulWidget {
  const MasonryImagePage({Key? key}) : super(key: key);

  @override
  _MasonryImagePageState createState() => _MasonryImagePageState();
}

class _MasonryImagePageState extends State<MasonryImagePage> {
  late final double columnWidth =
      MediaQuery.of(context).size.width / kMasonryColumns;

  Map<String, Widget> previewContainerCache = HashMap();

  Widget _buildPreviewContainer(PreviewImage preview) {
    previewContainerCache.putIfAbsent(
        preview.id,
        () => PreviewImageContainer(
              key: Key(preview.id),
              previewImage: preview,
              width: columnWidth,
              height: preview.heightFor(columnWidth),
              padding: EdgeInsets.all(4),
            ));

    return previewContainerCache[preview.id]!;
  }

  @override
  void initState() {
    if (context.read<PreviewImageProvider>().previewImages.isEmpty) {
      _fetchMoreImagePreviews();
    }
    super.initState();
  }

  _fetchMoreImagePreviews() async {
    dartz.Option<ImageProviderFailure> failureOption =
        await context.read<PreviewImageProvider>().fetchImages();

    failureOption.fold(
        () => null,
        (failure) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failure.message))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: kDefaultBackgroundColor,
              height: 160,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  'Bilder',
                  style: kH1TextStyle,
                ),
              ),
            ),
          ),
          SliverAppBar(
            toolbarHeight: 50,
            pinned: true,
            actions: [PopupMenuButton(itemBuilder: (context) => [])],
          ),
          Selector<PreviewImageProvider, List<PreviewImage>>(
              selector: (_, assetImageProvider) =>
                  assetImageProvider.previewImages,
              builder: (context, imageAssets, child) {
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: kMasonryColumns,
                  itemCount: imageAssets.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == imageAssets.length - 20) {
                      _fetchMoreImagePreviews();
                    }
                    return _buildPreviewContainer(imageAssets[index]);
                  },
                  staggeredTileBuilder: (int index) => StaggeredTile.count(1,
                      imageAssets[index].heightFor(columnWidth) / columnWidth),
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                );
              })
        ],
      ),
    );
  }
}
