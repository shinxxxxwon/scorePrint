
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/screens/settings/display_code/components/display_code_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'components/display_code_big_button.dart';
import 'components/display_code_middle_button.dart';
import 'components/display_code_none_button.dart';
import 'components/display_code_small_button.dart';
import 'components/display_code_text.dart';

class DisplayCode extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  DisplayCode({this.orientation, this.bIsTablet, this.httpCommunicate});

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

                //코드 표시 텍스트
                DisplayCodeText(orientation: orientation!, bIsTablet: bIsTablet!),

                //안함 버튼
                DisplayCodeNoneButton(orientaion: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

                //소 버튼
                DisplayCodeSmallButton(orientation: orientation!, bIsTablet: bIsTablet!,httpCommunicate: httpCommunicate!),

                //중 버튼
                DisplayCodeMiddleButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

                //대 버튼
                DisplayCodeBigButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),

                SizedBox(width: _size.width * 0.04),

              ],
            ) :
            Row(
              children: <Widget>[
                DisplayCodeText(orientation: orientation!, bIsTablet: bIsTablet!),

                Expanded(flex: 3, child: SizedBox()),

                DisplayCodeSwitch(httpCommunicate: httpCommunicate!),
              ],
            ),
        ),

        Divider(thickness: 2.0,),

      ],
    );
  }
}
