import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'componens/lyrics_type_original_language.dart';
import 'componens/lyrics_type_sound_language.dart';
import 'componens/lyrics_type_text.dart';

class LyricsType extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  LyricsType({this.orientation, this.bIsTablet, this.httpCommunicate});

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

              //가사 종류 텍스트
              LyricsTypeText(orientation: orientation!, bIsTablet: bIsTablet!),

              //공백
              Expanded(flex: 2, child: SizedBox(),),

              //원어 버튼
              LyricsTypeOriginalLanguage(orientaion: orientation!, bIsTablet: bIsTablet!,httpCommunicate: httpCommunicate!),

              //독음 버튼
              LyricsTypeSoundLanguage(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

              SizedBox(width: _size.width * 0.04),

            ],
          ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
