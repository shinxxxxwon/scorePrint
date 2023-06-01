import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'components/score_size_decrement_button.dart';
import 'components/score_size_increment_button.dart';
import 'components/score_size_text.dart';
import 'components/score_size_value.dart';

class ScoreSize extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  ScoreSize({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[

        Container(
          width: _size.width,
          height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          child: Row(
            children: <Widget>[

              SizedBox(width: _size.width * 0.02),

              //악보 크기 텍스트
              ScoreSizeText(orientation: orientation!, bIsTablet: bIsTablet!),

              //UI용 공백
              Expanded(flex: 1, child: SizedBox()),

              //악보 사이즈 값
              ScoreSizeValue(orientation: orientation!, bIsTablet: bIsTablet!),

              //감소 버튼
              ScoreSizeDecrementButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

              //증가 버튼
              ScoreSizeIncrementButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              SizedBox(width: _size.width * 0.04,)
            ],
          ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
