import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'components/commandments_type_fixed_button.dart';
import 'components/commandments_type_move_button.dart';
import 'components/commandments_type_text.dart';

class CommandmentsType extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  CommandmentsType({this.orientation, this.bIsTablet, this.httpCommunicate});

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

              //계명 종류 텍스트
              CommandmentsTypeText(orientation: orientation!, bIsTablet: bIsTablet!),

              //공백
              Expanded(flex: 2, child: SizedBox()),

              //이동도 버튼
              CommandmentsTypeMoveButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              //고정도 버튼
              CommandmentsTypeFixedButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

              SizedBox(width: _size.width * 0.04),

            ],
          ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
