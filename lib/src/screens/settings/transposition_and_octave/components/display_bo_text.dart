import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

class DisplayBoText extends StatelessWidget {
  final Orientation? orientation;
  final int? nDanIndex;
  final bool? bIsAct;
  final bool? bIsTablet;

  DisplayBoText(
      {this.orientation, this.nDanIndex, this.bIsTablet, this.bIsAct});

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery
        .of(context)
        .size;

    String strImagePath = "";

    if (nDanIndex == 1) {
      strImagePath = "assets/images/first_bo.png";
    } else if (nDanIndex == 2) {
      strImagePath = "assets/images/second_bo.png";
    } else {
      strImagePath = "assets/images/third_bo.png";
    }

    return Expanded(
      flex: 1,
      child: Container(
        width: orientation == Orientation.portrait
            ? Platform.isAndroid
            ? _size.width
            : _size.width
            : Platform.isAndroid
            ? _size.width
            : _size.width,
        height:
        orientation == Orientation.portrait ? _size.height : _size.height,
        alignment: Alignment.center,
        child: bIsAct == false
            ? Container(
            width: orientation == Orientation.portrait
                ? _size.width * 0.15
                : _size.height * 0.15,
            height: orientation == Orientation.portrait
                ? _size.height * 0.08
                : _size.width * 0.08,
            alignment: Alignment.center,

            ///SJW Modify 2022.04.29 Start...1  GUI 적용
            // child: Text(
            //   '$nDanIndex보',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: bIsTablet == true ? 22 : 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            child: Image(
              image: AssetImage(strImagePath),
              fit: BoxFit.fill,
            )

          ///SJW Modify End...1
        )
            : Container(
          width: orientation == Orientation.portrait
              ? _size.width * 0.15
              : _size.height * 0.15,
          height: orientation == Orientation.portrait
              ? _size.height * 0.08
              : _size.width * 0.08,
          alignment: Alignment.center,
          child:Text(
            '이조',
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
      ),
    );
  }
}
