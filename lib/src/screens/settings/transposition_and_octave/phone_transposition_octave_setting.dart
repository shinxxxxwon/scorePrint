
import 'package:elfscoreprint_mobile/src/providers/octave_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../models/http/http_communicate.dart';
import 'components/display_bo_text.dart';
import 'components/octave/octave_decrement.dart';
import 'components/octave/octave_increment.dart';
import 'components/octave/octave_text.dart';
import 'components/octave/octave_value.dart';
import 'components/transposition/transposition_decrement.dart';
import 'components/transposition/transposition_increment.dart';
import 'components/transposition/transposition_text.dart';
import 'components/transposition/transposition_value.dart';

class PhoneTranspositionOctaveSetting extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final int? nDanIndex;
  HttpCommunicate? httpCommunicate;

  PhoneTranspositionOctaveSetting({this.orientation, this.bIsTablet, this.nDanIndex, this.httpCommunicate});


  // ///이조, 옥타브 설정 UI
  // Widget _displayUI(BuildContext context, Size size){
  //   return Row(
  //     children: <Widget>[
  //
  //       //보 텍스트
  //       DisplayBoText(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!),
  //
  //       Expanded(
  //         flex: 3,
  //         child: Container(
  //           width: size.width,
  //           height: orientation == Orientation.portrait ? size.height : size.width,
  //           child: Column(
  //             children: <Widget>[
  //
  //               //이조
  //               Row(
  //                 children: <Widget>[
  //                   //이조 텍스트
  //                   TranspositionText(orientation: orientation!, bIsTablet: bIsTablet!),
  //
  //                   //이조 값 텍스트
  //                   TranspositionValue(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!),
  //
  //                   //이조 감소 버튼
  //                   TranspositionDecrement(orientation: orientation!, nDanIndex: nDanIndex!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!),
  //
  //                   //이조 증가 버튼
  //                   TranspositionIncrement(orientation: orientation!, nDanIndex: nDanIndex!, httpCommunicate: httpCommunicate!, bTablet: bIsTablet!),
  //
  //                 ],
  //               ),
  //
  //               //옥타브
  //                Row(
  //                   children: <Widget>[
  //
  //                     //옥타브 텍스트
  //                     OctaveText(orientation: orientation!, bIsTablet: bIsTablet!),
  //
  //                     //옥타브 값
  //                     OctaveValue(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!),
  //
  //                     //옥타브 감소 버튼
  //                     OctaveDecrement(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!),
  //
  //                     //옥타브 증가 버튼
  //                     OctaveIncrement(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!),
  //
  //                   ],
  //                 ),
  //             ],
  //        );
  // }

  @override
  Widget build(BuildContext context) {


    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;
    bool bIsAct = httpCommunicate!.nFileDataType == 2 ? true : false;

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: orientation == Orientation.portrait ?
                  Platform.isAndroid ?
                    _size.width : _size.width
                      : Platform.isAndroid ?
                    _size.width : _size.width,
          height: httpCommunicate!.nFileDataType != 2 ?
            orientation == Orientation.portrait ? _size.height * 0.11 : _size.width * 0.11 :
            orientation == Orientation.portrait ? _size.height * 0.06 : _size.width * 0.06,
          child: Row(
            children: <Widget>[

              //보 텍스트
              DisplayBoText(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet! ,bIsAct: bIsAct),

              Expanded(
                flex: 4,
                // child: Container(
                //   width: _size.width,
                //   height: orientation == Orientation.portrait ? _size.height : _size.width,
                  child: Column(
                    children: <Widget>[

                     Row(
                       children: <Widget>[
                         //이조 텍스트
                         TranspositionText(orientation: orientation!, bIsTablet: bIsTablet!),
                         //이조 값 출력
                         TranspositionValue(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!),
                         //이조 감소 아이콘
                         TranspositionDecrement(orientation: orientation!, nDanIndex: nDanIndex!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!),
                         //이조 증가 아이콘
                         TranspositionIncrement(orientation: orientation!, nDanIndex: nDanIndex!, httpCommunicate: httpCommunicate!, bTablet: bIsTablet!),

                         SizedBox(width: _size.width * 0.04,)
                       ],
                     ),

                     context.read<OctaveProvider>().bIsOctave ?
                     Row(
                       children: <Widget>[
                         //옥타브 텍스트
                         OctaveText(orientation: orientation!, bIsTablet: bIsTablet!),
                         //옥타브 값
                         OctaveValue(httpCommunicate: httpCommunicate!, orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!),
                         //옥타브 감소 아이콘
                         OctaveDecrement(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!,),
                         //옥타브 증가 아이콘
                         OctaveIncrement(orientation: orientation!, nDanIndex: nDanIndex!, bIsTablet: bIsTablet!, httpCommunicate: httpCommunicate!),

                         SizedBox(width: _size.width * 0.04,)
                       ],
                     ) : SizedBox(),

                    ],
                  ),
                // ),
              ),

            ],
          ),
        ),

        Divider(thickness: 2.0,),
      ],
    );
  }
}
