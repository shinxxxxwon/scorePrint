
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../../../providers/octave_provider.dart';

class OctaveValue extends StatelessWidget {
  final HttpCommunicate? httpCommunicate;
  final Orientation? orientation;
  final int? nDanIndex;
  final bool? bIsTablet;

  OctaveValue({this.httpCommunicate, this.orientation, this.nDanIndex, this.bIsTablet});

  ///옥타브 값 출력
  Widget _displayOctaveValue(Size size){
    return Consumer<OctaveProvider>(
      builder: (context, octave, child){
        if(nDanIndex == 1){
          ///SJW Modify 2022-06-02 Start...1
          ///GUI 적용
          // return Text(
          //   octave.nOneOctaveValue.toString(),
          //   style: TextStyle(
          //     ///SJW Modify 2022.04.19 Start...1 값에 따른 fontWeight 변경
          //     //fontWeight: FontWeight.bold,
          //     fontWeight: octave.nOneOctaveValue == 0 ? FontWeight.normal : FontWeight.bold,
          //     ///SJW Modify 2022.04.19 End...1
          //     color: Colors.black,
          //     fontSize: bIsTablet == true ? 22 : 16,
          //   ),
          // );
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/transposition_container.png'),
              )
            ),
            child: Text(
              httpCommunicate!.nScoreType == 17 ? '0' : octave.nOneOctaveValue.toString(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontWeight: octave.nOneOctaveValue == 0 ? FontWeight.normal : FontWeight.bold,
                  color: Colors.black,
                  fontSize: bIsTablet == true
                      ? orientation == Orientation.portrait ? size.width * 0.03 : size.height * 0.03
                      : orientation == Orientation.portrait ? size.width * 0.04 : size.height * 0.04,
                ),
              ),
            ),
          );
          ///SJW Modify 2022-06-02 End...1
        }else if(nDanIndex == 2){
          ///SJW Modify 2022-06-02 Start...2
          ///GUI 적용
          // return Text(
          //   octave.nTwoOctaveValue.toString(),
          //   style: TextStyle(
          //     ///SJW Modify 2022.04.19 Start...2 값에 따른 fontWeight 변경
          //     //fontWeight: FontWeight.bold,
          //     fontWeight: octave.nTwoOctaveValue == 0 ? FontWeight.normal : FontWeight.bold,
          //     ///SJW Modify 2022.04.19 End...2
          //     color: Colors.black,
          //     fontSize: bIsTablet == true ? 22 : 16,
          //   ),
          // );
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/transposition_container.png'),
              )
            ),
            child: Text(
              httpCommunicate!.nScoreType == 7 ? '0' : octave.nTwoOctaveValue.toString(),
              style: TextStyle(
                fontWeight: octave.nTwoOctaveValue == 0 ? FontWeight.normal : FontWeight.bold,
                color: Colors.black,
                fontSize: bIsTablet == true
                    ? orientation == Orientation.portrait ? size.width * 0.03 : size.height * 0.03
                    : orientation == Orientation.portrait ? size.width * 0.04 : size.height * 0.04,
              ),
            ),
          );
          ///SJW Modify 2022-06-02 End...2
        }else{
          ///SJW Modify 2022-06-02 Start...3
          ///GUI 적용
          // return Text(
          //   octave.nThreeOctaveValue.toString(),
          //   style: TextStyle(
          //     ///SJW Modify 2022.04.19 Start...3 값에 따른 fontWeight 변경
          //     //fontWeight: FontWeight.bold,
          //     fontWeight: octave.nThreeOctaveValue == 0 ? FontWeight.normal : FontWeight.bold,
          //     ///SJW Modify 2022.04.19 End...3
          //     color: Colors.black,
          //     fontSize: bIsTablet == true ? 22 : 16,
          //   ),
          // );
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/transposition_container.png'),
              )
            ),
            child: Text(
              octave.nThreeOctaveValue.toString(),
              style: TextStyle(
                fontWeight: octave.nThreeOctaveValue == 0 ? FontWeight.normal : FontWeight.bold,
                color: Colors.black,
                fontSize: bIsTablet == true
                    ? orientation == Orientation.portrait ? size.width * 0.03 : size.height * 0.03
                    : orientation == Orientation.portrait ? size.width * 0.04 : size.height * 0.04,
              ),
            ),
          );
          ///SJW Modify 2022-06-02 End...3
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 2,
      child: Container(
        width: _size.width,
        height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
        alignment: Alignment.center,
        child: _displayOctaveValue(_size),
      ),
    );
  }
}
