import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

class PhoneUserMenualSavePage extends StatelessWidget {
  const PhoneUserMenualSavePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return Scrollbar(
      hoverThickness: 3.0,
      thickness: 3.0,
      child: ListView(
        children: <Widget>[

          Container(
            height: Platform.isAndroid ? _size.height * 0.75 : _size.height * 0.7,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/Help_image_02.png'),
            ),
          ),

        ],
      ),
    );
  }
}