import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PhoneUserMenualPrint extends StatefulWidget {
  const PhoneUserMenualPrint({Key? key}) : super(key: key);

  @override
  State<PhoneUserMenualPrint> createState() => _PhoneUserMenualPrintState();
}

class _PhoneUserMenualPrintState extends State<PhoneUserMenualPrint> {

  late AssetImage _image;

  @override
  void initState() {
    // TODO: implement initState
    _image = Platform.isAndroid ? AssetImage("assets/images/aos_guid.png") : AssetImage("assets/images/ios_guid.png");
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

    Size _size = MediaQuery.of(context).size;

    return Container(
      height: Platform.isAndroid ? _size.height * 0.75 : _size.height * 0.7,
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
          builder: (context, nIndex){
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
  }
}

