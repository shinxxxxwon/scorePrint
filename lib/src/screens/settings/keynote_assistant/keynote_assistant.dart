import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import 'component/keynote_setting_switch.dart';
import 'component/keynote_text.dart';

class KeynoteAssistant extends StatelessWidget {
  final Orientation? orientation;
  final bool? bTablet;
  final HttpCommunicate? httpCommunicate;

  KeynoteAssistant({this.orientation, this.bTablet, this.httpCommunicate});

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

              //조표인식 텍스트
              KeynoteText(orientation: orientation!, bIsTablet: bTablet!),

              //공백
              Expanded(flex: 3, child: SizedBox()),
              
              //조표인식 설정 스위치
              KeynoteSettingSwitch(orientation: orientation!, bIsTablet: bTablet!,httpCommunicate: httpCommunicate!),

              SizedBox(width: _size.width * 0.04),

            ],
          ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
