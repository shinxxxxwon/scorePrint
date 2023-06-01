import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

class KeynoteText extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;

  KeynoteText({this.orientation, this.bIsTablet});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 2,
      child: Container(
        width: _size.width,
        height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
        alignment: Alignment.centerLeft,
        child: Text(
          '조표 인식 도우미',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: bIsTablet == true
                  ? orientation == Orientation.portrait ? _size.width * 0.025 : _size.height * 0.025
                  : orientation == Orientation.portrait ? _size.width * 0.035 : _size.height * 0.035,
            ),
          ),
        ),
      ),
    );
  }
}
