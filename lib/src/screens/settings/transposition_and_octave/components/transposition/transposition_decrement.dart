
import 'dart:async';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:elfscoreprint_mobile/src/resources/score/score_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../../../models/http/http_communicate.dart';
import '../../../../../providers/transposition_provider.dart';

class TranspositionDecrement extends StatelessWidget {
  final Orientation? orientation;
  final int? nDanIndex;
  final bool? bIsTablet;
  HttpCommunicate? httpCommunicate;

  TranspositionDecrement({this.orientation, this.nDanIndex, this.bIsTablet, this.httpCommunicate});

  ///감소 아이콘 버튼
  Widget _decrementIconButton(BuildContext context){
    ///SJW Modify 2022-06-02 Start...1
    ///GUI 적용
    // return Platform.isAndroid ?
    //     IconButton(
    //       onPressed: ((httpCommunicate!.bIsPreViewScore == false) ||  (context.read<TranspositionProvider>().bIsDrum == true && nDanIndex == 2)) ?
    //       null :
    //       (){context.read<TranspositionProvider>().decrementTranspositionValue(nDanIndex!);},
    //       icon: Icon(Icons.remove, size: bIsTablet == true ? 26 : 20),
    //     ) :
    //     CupertinoButton(
    //       onPressed:((httpCommunicate!.bIsPreViewScore == false) ||  (context.read<TranspositionProvider>().bIsDrum == true && nDanIndex == 2)) ?
    //       null :
    //           (){context.read<TranspositionProvider>().decrementTranspositionValue(nDanIndex!);},
    //       child: Icon(Icons.remove, size: bIsTablet == true ? 26 : 20),
    //     );
    return Consumer<TranspositionProvider>(
      builder: (context, trans, child){
        return GestureDetector(
          onTap:() async {
            ///SJW Modify 2022.12.22 Start... 릴리즈할때는 주석 해제야함
            ///테스트 관계로 인쇄에서도 이조 가능하도록 하기위함
            if(httpCommunicate!.bIsPreViewScore == false) {
              return null;
            }
            ///SJW Modify 2022.12.22 End...
            if (nDanIndex == 1 && trans.bOneIsDrum) {
              return;
            }
            else if (nDanIndex == 2 && trans.bTwoIsDrum) {
              return;
            }
            else if (nDanIndex == 3 && trans.bThreeIsDrum) {
              return;
            }

            if(httpCommunicate!.nFileDataType == 2){  ///ACT
              if(nDanIndex == 1 && trans.nOneTranspositionValue <= trans.nActMinKey){
                return;
              }
            }
            else{
              if(nDanIndex == 1 && trans.nOneTranspositionValue < -10 ){
                return;
              }
              else if(nDanIndex == 2 && trans.nTwoTranspositionValue < -10){
                return;
              }
              else if(nDanIndex == 3 && trans.nThreeTranspositionValue < -10){
                return;
              }
            }

            if(context.read<PDFProvider>().bMakingScore){
              return;
            }

            DrawScore drawScore = DrawScore();
            await trans.decrementTranspositionValue(httpCommunicate!, nDanIndex!);

            // Future.delayed(Duration(milliseconds: 500));

            await drawScore.changeOption(context, httpCommunicate!);

          },
          child: ButtonImage(context),
        );
      },
    );
    ///SJW Modify 2022-06-02 End...1
  }

  Widget ButtonImage(BuildContext context){
    if(httpCommunicate!.bIsPreViewScore == false){
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/unUse_minus_button.png'),
        //     )
        // ),
        ///SJW Modify 2023.03.14 Start...
        ///버튼 이미지 깜빡임 수정
        return Image.asset(
          'assets/images/buttons/unUse_minus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    if ((nDanIndex == 1 && context.read<TranspositionProvider>().bOneIsDrum) || (nDanIndex == 1 && context.read<TranspositionProvider>().nOneTranspositionValue < -10)) {
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/unUse_minus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/unUse_minus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    else if ((nDanIndex == 2 && context.read<TranspositionProvider>().bTwoIsDrum) || (nDanIndex == 2 && context.read<TranspositionProvider>().nTwoTranspositionValue < -10)) {
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/unUse_minus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/unUse_minus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    else if ((nDanIndex == 3 && context.read<TranspositionProvider>().bThreeIsDrum) || (nDanIndex == 2 && context.read<TranspositionProvider>().nThreeTranspositionValue < -10)) {
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/unUse_minus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/unUse_minus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    else if((nDanIndex == 1 && context.read<TranspositionProvider>().nOneTranspositionValue <= context.read<TranspositionProvider>().nActMinKey)){
      return Image.asset(
        'assets/images/buttons/unUse_minus_button.png',
        fit: BoxFit.fill,
        gaplessPlayback: true,
      );
    }
    else if((nDanIndex == 2 && context.read<TranspositionProvider>().nTwoTranspositionValue <= context.read<TranspositionProvider>().nActMinKey)){
      return Image.asset(
        'assets/images/buttons/unUse_minus_button.png',
        fit: BoxFit.fill,
        gaplessPlayback: true,
      );
    }
    else if((nDanIndex == 3 && context.read<TranspositionProvider>().nThreeTranspositionValue <= context.read<TranspositionProvider>().nActMinKey)){
      return Image.asset(
        'assets/images/buttons/unUse_minus_button.png',
        fit: BoxFit.fill,
        gaplessPlayback: true,
      );
    }
    else{
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/minus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/minus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: SizedBox(
        // width: _size.width,
        height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
        // alignment: Alignment.center,
        child: _decrementIconButton(context),
      ),
    );
  }
}
