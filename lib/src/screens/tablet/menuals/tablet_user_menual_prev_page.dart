import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class TabletUserMenualPrevPage extends StatefulWidget {
  const TabletUserMenualPrevPage({Key? key}) : super(key: key);

  @override
  State<TabletUserMenualPrevPage> createState() => _TabletUserMenualPrevPageState();
}

class _TabletUserMenualPrevPageState extends State<TabletUserMenualPrevPage> {

  late AssetImage _image;

  @override
  void initState() {
    // TODO: implement initState
    _image = AssetImage("assets/images/prev_guid.png");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    precacheImage(_image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022.08.05 Start...1 ///이미지 스크롤 -> 스크롤 + 확대 (PhotoView Packages)
    return Container(
      height: Platform.isAndroid ? _size.height * 0.7 : _size.height * 0.7,
      child: Scrollbar(
        thickness: 3.0,
        hoverThickness: 3.0,
        child: PhotoViewGallery.builder(
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                // value: event == null
                //     ? 0
                //     : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          itemCount: 1,
          scrollDirection: Axis.vertical,
          builder: (context, nIndex) {
            return PhotoViewGalleryPageOptions(
              imageProvider: _image,
              initialScale: PhotoViewComputedScale.covered,
              controller: PhotoViewController(initialPosition: Offset.zero),
              basePosition: Alignment.topCenter,
              minScale: PhotoViewComputedScale.covered,
              maxScale: PhotoViewComputedScale.covered * 3,
            );
          },
        ),
      ),
    );
    ///SJW Modify 2022.08.05 End...1
  }
}


