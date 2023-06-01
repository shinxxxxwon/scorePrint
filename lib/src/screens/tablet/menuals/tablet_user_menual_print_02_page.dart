import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class TabletUserMenualPrint02Page extends StatelessWidget {
  const TabletUserMenualPrint02Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return Scrollbar(
      thickness: 3.0,
      hoverThickness: 3.0,
      child: ListView(
        children: <Widget>[

          Container(
            height: Platform.isAndroid ? _size.height * 0.7 : _size.height * 0.7,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/Help_image_04.png'),
            ),
          ),

        ],
      ),
    );
  }
}
