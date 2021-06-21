import 'dart:io';

import 'package:flutter/material.dart';
import 'package:masonry/masonry/presentation/constants/palette.dart';
import 'package:photo_view/photo_view.dart';

class DetailImagePage extends StatelessWidget {
  final File imageFile;
  const DetailImagePage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kDefaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        backgroundDecoration: BoxDecoration(color: kDefaultBackgroundColor),
        imageProvider: FileImage(imageFile),
        loadingBuilder: (context, event) => _ImageLoadingScreen(event: event),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 1.5,
      ),
    );
  }
}

class _ImageLoadingScreen extends StatelessWidget {
  final ImageChunkEvent? event;
  const _ImageLoadingScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          value: (event == null || event!.expectedTotalBytes == null)
              ? 0
              : event!.cumulativeBytesLoaded / event!.expectedTotalBytes!,
        ),
      ),
    );
  }
}
