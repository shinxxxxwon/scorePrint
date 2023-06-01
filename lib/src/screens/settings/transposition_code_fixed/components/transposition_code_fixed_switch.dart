
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../../providers/transposition_code_fixed_provider.dart';
import '../../../../resources/score/score_info_controller.dart';

class TranspositionCodeFixedSwitch extends StatelessWidget {
  final Orientation? orientaion;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  TranspositionCodeFixedSwitch({this.orientaion, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022-06-02 Start...1
    ///GUI 적용
    // return Expanded(
    //   flex: 1,
    //   child: Consumer<TranspositionCodeFixedProvider>(
    //     builder: (context, fixed, child) {
    //       return Container(
    //         width: _size.width,
    //         height: orientaion == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
    //         alignment: Alignment.center,
    //         child: Transform.scale(
    //           scale: bIsTablet == true ? 2.0 : 1.0,
    //           child: Platform.isAndroid ?
    //               Switch(
    //                 value: fixed.bTranspositionCodeFixedValue,
    //                 ///SJW Modify 2022.04.19 Start...1 활성화 상태 색상 변경
    //                 activeColor: Colors.red,
    //                 ///SJW Modify 2022.04.19 End...1
    //                 onChanged: (bool bState) => fixed.changeTranspositionCodeFixedValue(bState),
    //               ) : CupertinoSwitch(
    //                 value: fixed.bTranspositionCodeFixedValue,
    //                 ///SJW Modify 2022.04.19 Start...2 활성화 상태 색상 변경
    //                 activeColor: Colors.red,
    //                 ///SJW Modify 2022.04.19 End...2
    //                 onChanged: (bool bState) => fixed.changeTranspositionCodeFixedValue(bState),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
    return Expanded(
      flex: 1,
      child: Consumer<TranspositionCodeFixedProvider>(
        builder: (context, fixed, child){
          return GestureDetector(
            onTap: () async {
              // try {
              //   await fixed.changeTranspositionCodeFixedValue();
              // }
              // catch(e){
              //   print('transposition codefix error : ${e.toString()}');
              // }
              // finally {
              //   DrawScore drawScore = DrawScore();
              //   FutureBuilder(
              //     future: drawScore.reDrawSocre(context, httpCommunicate!),
              //     builder: (context, snapshot) {
              //       return CircularProgressIndicator();
              //     },
              //   );
              // }

              if(context.read<PDFProvider>().bMakingScore){
                return;
              }

              DrawScore drawScore = DrawScore();
              await fixed.changeTranspositionCodeFixedValue();

              // Future.delayed(Duration(milliseconds: 500));

              await drawScore.changeOption(context, httpCommunicate!);

            },
            // child: Container(
            //   alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: fixed.bTranspositionCodeFixedValue == true ?
              //         AssetImage('assets/images/buttons/switch_on.png') : AssetImage('assets/images/buttons/switch_off.png'),
              //   ),
              // ),
              ///SJW Modify 2023.03.14 Start...
              ///이미지 깜빡거림 수정
              child: Image.asset(
                fixed.bTranspositionCodeFixedValue == true ? 'assets/images/buttons/switch_on.png' : 'assets/images/buttons/switch_off.png',
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
              ///SJW Modify 2023.03.14 End..
            // ),
          );
        },
      ),
    );
    ///SJW Modify 2022-06-02 End...1
  }
}
