import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/display_lyrics_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:elfscoreprint_mobile/src/screens/settings/display_lyrics/components/display_lyrics_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'components/display_lyrics_big_button.dart';
import 'components/display_lyrics_middle_button.dart';
import 'components/display_lyrics_none_button.dart';
import 'components/display_lyrics_small_button.dart';
import 'components/display_lyrics_text.dart';

class DisplayLyrics extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  DisplayLyrics({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[

        Container(
          width: _size.width,
          height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          child: httpCommunicate!.nFileDataType != 2 ?
            Row(
              children: <Widget>[

                //가사표시 텍스트
                DisplayLyricsText(orientation: orientation!, bIsTablet: bIsTablet!),

                //안함 버튼
                DisplayLyricsNoneButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

                //소 버튼
                DisplayLyricsSmallButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

                //중 버튼
                DisplayLyricsMiddleButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

                //대 버튼
                DisplayLyricsBigButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

                SizedBox(width: _size.width * 0.04),

              ],
            ) :
            Row(
              children: <Widget>[
                DisplayLyricsText(orientation: orientation!, bIsTablet: bIsTablet!),

                Expanded(flex: 3, child: SizedBox()),

                DisplayLyricsSwitch(httpCommunicate: httpCommunicate!),
              ],
            ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}



