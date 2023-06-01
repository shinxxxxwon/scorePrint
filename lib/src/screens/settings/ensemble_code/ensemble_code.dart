import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'components/ensemble_code_alto_button.dart';
import 'components/ensemble_code_none_button.dart';
import 'components/ensemble_code_tenor_button.dart';
import 'components/ensemble_code_text.dart';

class EnsembleCode extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  EnsembleCode({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //다바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[

        Container(
          width: _size.width,
          height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          child: Row(
            children: <Widget>[

              //합주코드 텍스트
              EnsembleCodeText(orientation: orientation!, bIsTablet: bIsTablet!),

              //공백
              Expanded(flex: 1, child: SizedBox()),

              //안함 버튼
              EnsembleCodeNoneButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              //테너 버튼
              EnsembleCodeTenorButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              //알토 버튼
              EnsembleCodeAltoButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              SizedBox(width: _size.width * 0.04),

            ],
          ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
