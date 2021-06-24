import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:masonry/masonry/controllers/image_controller.dart';
import 'package:masonry/masonry/presentation/constants/constants.dart';
import 'package:masonry/masonry/presentation/constants/palette.dart';
import 'package:masonry/masonry/presentation/widgets/image_preview_list.dart';
import 'package:masonry/masonry/repositories/images/failures.dart';

class MasonryImagePage extends StatefulWidget {
  const MasonryImagePage({Key? key}) : super(key: key);

  @override
  _MasonryImagePageState createState() => _MasonryImagePageState();
}

class _MasonryImagePageState extends State<MasonryImagePage> {
  late final double columnWidth =
      MediaQuery.of(context).size.width / kMasonryColumns;

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
          ProviderListener(
            provider: imageControllerErrorProvider,
            onChange:
                (context, StateController<ImageRepositoryFailure?> failure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(failure.state!.message)));
            },
            child: const ImagePreviewList(),
          )
        ],
      ),
    );
  }
}
