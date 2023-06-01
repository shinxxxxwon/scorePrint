
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../providers/dan_settings_provider.dart';
import 'components/print_type_all_print_button.dart';
import 'components/print_type_only_first_button.dart';
import 'components/print_type_only_three_button.dart';
import 'components/print_type_only_two_button.dart';
import 'components/print_type_text.dart';

class PrintType extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  PrintType({this.orientation, this.bIsTablet, this.httpCommunicate});

  ///출력 선택 버튼
  Widget _displayPrintTypeButtons(BuildContext context, Size size){

    int nDan = context.read<DanSettingsProvider>().nDan;

    switch(nDan){
      case 1: //1단 악보
        return Row(
            children: <Widget>[
              //출력선택 텍스트
              PrintTypeText(orientation: orientation!, bIsTablet: bIsTablet!),
              //공백
              Expanded(flex: 3, child: SizedBox(),),
              //전체 출력
              PrintTypeAllPrintButton(orientation: orientation!, bIsTablet: bIsTablet!),

              SizedBox(width: size.width * 0.04),
            ],
          );
        break;
      case 2: //2단 악보
        return Row(
          children: <Widget>[
            //출력선택 텍스트
            PrintTypeText(orientation: orientation!, bIsTablet: bIsTablet!),
            //공백
            Expanded(flex: 1, child: SizedBox()),
            //전체 출력
            PrintTypeAllPrintButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),
            //1보만
            PrintTypeOnlyFirstButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),
            //2보만
            PrintTypeOnlyTwoButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

            SizedBox(width: size.width * 0.04),
          ],
        );
      case 3: //3단 악보
        return Row(
          children: <Widget>[
            //출력선택 텍스트
            PrintTypeText(orientation: orientation!, bIsTablet: bIsTablet!,),
            //전체 출력
            PrintTypeAllPrintButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),
            //1보만
            PrintTypeOnlyFirstButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),
            //2보만
            PrintTypeOnlyTwoButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),
            //3보만
            PrintTypeOnlyThreeButton(orientation: orientation!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

            SizedBox(width: size.width * 0.04),
          ],
        );
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[

        Container(
          width: _size.width,
          height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          child: _displayPrintTypeButtons(context, _size),
        ),

      ],
    );
  }
}
