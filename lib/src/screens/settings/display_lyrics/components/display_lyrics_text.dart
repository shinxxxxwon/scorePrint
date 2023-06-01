import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayLyricsText extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;

  DisplayLyricsText({this.orientation, this.bIsTablet});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기[넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Container(
        width: _size.width,
        height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
        alignment: Alignment.center,
        child: Text(
          '가사표시',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
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
