
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../../../models/http/http_communicate.dart';
import '../../../../../providers/transposition_provider.dart';
import '../../../../../resources/score/score_info_controller.dart';

class TranspositionIncrement extends StatelessWidget {
  final Orientation? orientation;
  final int? nDanIndex;
  final bool? bTablet;
  HttpCommunicate? httpCommunicate;

  TranspositionIncrement({this.orientation, this.nDanIndex, this.httpCommunicate, this.bTablet});

  ///이조 증가 버튼
  Widget _incrementIconButton(BuildContext context){
    ///SJW Modify 2022-06-02 Start...1
    ///GUI 적용
    // return Platform.isAndroid ?
    // IconButton(
    //   onPressed: ((httpCommunicate!.bIsPreViewScore == false) ||  (context.read<TranspositionProvider>().bIsDrum == true && nDanIndex == 2)) ? null :
    //       (){context.read<TranspositionProvider>().incrementTranspositionValue(nDanIndex!);},
    //   icon: Icon(Icons.add, size: bTablet == true ? 26 : 20,),
    // ) : CupertinoButton(
    //   onPressed: ((httpCommunicate!.bIsPreViewScore == false) ||  (context.read<TranspositionProvider>().bIsDrum == true && nDanIndex == 2)) ? null :
    //       (){context.read<TranspositionProvider>().incrementTranspositionValue(nDanIndex!);},
    //   child: Icon(Icons.add, size: bTablet == true ? 26 : 20,),
    // );
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
                if(nDanIndex == 1 && trans.nOneTranspositionValue >= trans.nActMaxKey ){
                  return;
                }
              }
              else{
                if(nDanIndex == 1 && trans.nOneTranspositionValue > 10 ){
                  return;
                }
                else if(nDanIndex == 2 && trans.nTwoTranspositionValue > 10){
                  return;
                }
                else if(nDanIndex == 3 && trans.nThreeTranspositionValue > 10){
                  return;
                }
              }

              // try {
              //   await trans.incrementTranspositionValue(nDanIndex!);
              // }
              // catch(e){
              //   print('transposition increment error : ${e.toString()}');
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
              context.read<PDFProvider>().nButtonClickCount++;
              DrawScore drawScore = DrawScore();
              await trans.incrementTranspositionValue(httpCommunicate!, nDanIndex!);

              // Future.delayed(Duration(milliseconds: 500));

              await drawScore.changeOption(context, httpCommunicate!);

            },
            child: ButtonImage(context)
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
        //       image: AssetImage('assets/images/buttons/unUse_plus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/unUse_plus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    if ((nDanIndex == 1 && context.read<TranspositionProvider>().bOneIsDrum) || (nDanIndex == 1 && context.read<TranspositionProvider>().nOneTranspositionValue > 10)) {
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/unUse_plus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/unUse_plus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    else if ((nDanIndex == 2 && context.read<TranspositionProvider>().bTwoIsDrum) || (nDanIndex == 2 && context.read<TranspositionProvider>().nTwoTranspositionValue > 10)) {
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/unUse_plus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/unUse_plus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    else if ((nDanIndex == 3 && context.read<TranspositionProvider>().bThreeIsDrum) || (nDanIndex == 3 && context.read<TranspositionProvider>().nThreeTranspositionValue > 10)) {
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/unUse_plus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/unUse_plus_button.png',
          fit: BoxFit.fill,
          gaplessPlayback: true,
        // ),
        ///SJW Modify 2023.03.14 End..
      );
    }
    else if((nDanIndex == 1 && context.read<TranspositionProvider>().nOneTranspositionValue >= context.read<TranspositionProvider>().nActMaxKey)){
      return Image.asset(
        'assets/images/buttons/unUse_plus_button.png',
        fit: BoxFit.fill,
        gaplessPlayback: true,
      );
    }
    else if((nDanIndex == 2 && context.read<TranspositionProvider>().nTwoTranspositionValue >= context.read<TranspositionProvider>().nActMaxKey)){
      return Image.asset(
        'assets/images/buttons/unUse_plus_button.png',
        fit: BoxFit.fill,
        gaplessPlayback: true,
      );
    }
    else if((nDanIndex == 3 && context.read<TranspositionProvider>().nThreeTranspositionValue >= context.read<TranspositionProvider>().nActMaxKey)){
      return Image.asset(
        'assets/images/buttons/unUse_plus_button.png',
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
        //       image: AssetImage('assets/images/buttons/plus_button.png'),
        //     )
        // ),
        return Image.asset(
          'assets/images/buttons/plus_button.png',
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
        child: _incrementIconButton(context),
      ),
    );
  }
}
