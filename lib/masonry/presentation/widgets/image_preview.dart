import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:masonry/masonry/models/PreviewImage.dart';
import 'package:masonry/masonry/presentation/constants/palette.dart';
import 'package:masonry/masonry/presentation/pages/detail_image_page.dart';

class PreviewImageContainer extends StatelessWidget {
  final PreviewImage previewImage;
  final double width;
  final EdgeInsets? padding;
  const PreviewImageContainer(
      {Key? key, required this.previewImage, required this.width, this.padding})
      : super(key: key);

  _onTap(BuildContext context) async {
    File? imageFile = await previewImage.fullImageFile();
    if (imageFile != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailImagePage(imageFile: imageFile)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: previewImage.previewWithFixedWidth(width),
      builder: (BuildContext context, snapshot) {
        return Material(
          child: Padding(
            padding: padding ?? EdgeInsets.all(0),
            child: InkWell(
              onTap: () => _onTap(context),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                      width: width,
                      height: previewImage.heightFor(width),
                      color: kPreviewBackgroundColor,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: (snapshot.data != null)
                            ? ExtendedImage.memory(snapshot.data!,
                                width: width,
                                height: previewImage.heightFor(width),
                                fit: BoxFit.cover)
                            : SizedBox.shrink(),
                      ))),
            ),
          ),
        );
      },
    );
  }
}
