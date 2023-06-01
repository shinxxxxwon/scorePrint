import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'components/transposition_code_fixed_switch.dart';
import 'components/transposition_code_fixed_text.dart';

class TranspositionCodeFixed extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  TranspositionCodeFixed({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[

        Container(
          width: _size.width,
          height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          child: Row(
            children: <Widget>[

              SizedBox(width: _size.width * 0.04),

              //이조시 코드 고정 텍스트
              TranspositionCodeFixedText(orientation: orientation!, bIsTablet: bIsTablet!),

              //공백
              Expanded(flex: 3, child: SizedBox()),

              //이조시 코드 고정 설정 스위치
              TranspositionCodeFixedSwitch(orientaion: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              SizedBox(width: _size.width * 0.04),

            ],
          ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
