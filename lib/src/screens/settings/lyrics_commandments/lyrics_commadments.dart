import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/lyrics_commandments_commandments_button.dart';
import 'components/lyrics_commandments_lyrics_button.dart';
import 'components/lyrics_commandments_text.dart';

class LyricsCommandments extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  LyricsCommandments({this.orientation, this.bIsTablet, this.httpCommunicate});

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

              //가사/계명 텍스트
              LyricsCommandmentsText(orientation: orientation!, bIsTablet: bIsTablet!),

              //공백
              Expanded(flex: 2, child: SizedBox(),),

              //가사 버튼
              LyricsCommandmentsLyricsButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              //계명 버튼
              LyricsCommandmentsCommandmentsButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              SizedBox(width: _size.width * 0.04),

            ],
          ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
