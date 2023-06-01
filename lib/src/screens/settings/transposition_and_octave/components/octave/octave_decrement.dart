
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../../../providers/octave_provider.dart';
import '../../../../../providers/transposition_provider.dart';
import '../../../../../resources/score/score_info_controller.dart';

class OctaveDecrement extends StatelessWidget {
  final Orientation? orientation;
  final int? nDanIndex;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  OctaveDecrement({this.orientation, this.nDanIndex, this.bIsTablet, this.httpCommunicate});

  ///옥타브 감소 아이콘 버튼
  Widget _decrementIconButton(BuildContext context, Size size){
    ///SJW Modify 2022-06-02 Start...1
    ///GUI 적용
    // return Platform.isAndroid ?
    //     IconButton(
    //       onPressed: (context.read<TranspositionProvider>().bIsDrum == true && nDanIndex == 2) ? null :
    //           (){
    //         context.read<OctaveProvider>().decreamentOctave(nDanIndex!);
    //       },
    //       icon: Icon(Icons.remove, size: bIsTablet == true ? 26 : 20),
    //     ) : CupertinoButton(
    //       onPressed: (context.read<TranspositionProvider>().bIsDrum == true && nDanIndex == 2) ? null :
    //           (){
    //         context.read<OctaveProvider>().decreamentOctave(nDanIndex!);
    //       },
    //       child: Icon(Icons.remove, size: bIsTablet == true ? 26 : 20),
    // );
    return Consumer<OctaveProvider>(
      builder: (context, octave, child){
        return GestureDetector(
          onTap:() async{
            if(nDanIndex == 1 && context.read<TranspositionProvider>().bOneIsDrum){
              return;
            }
            else if(nDanIndex == 2 && context.read<TranspositionProvider>().bTwoIsDrum){
              return;
            }
            else if(nDanIndex == 3 && context.read<TranspositionProvider>().bThreeIsDrum){
              return;
            }

            if(nDanIndex == 1 && octave.nOneOctaveValue <= -1 ){
              return;
            }
            else if(nDanIndex == 2 && octave.nTwoOctaveValue <= -1){
              return;
            }
            else if(nDanIndex == 3 && octave.nThreeOctaveValue <= -1){
              return;
            }

            if(context.read<PDFProvider>().bMakingScore){
              return;
            }



            DrawScore drawScore = DrawScore();
            await octave.decreamentOctave(nDanIndex!);

            // Future.delayed(Duration(milliseconds: 500));

            await drawScore.changeOption(context, httpCommunicate!);

          },
          child:buttonImage(context),
        );
      }
    );
    ///SJW Modify 2022-06-02 End...1
  }


  Widget buttonImage(BuildContext context){
    // if(httpCommunicate!.bIsPreViewScore == false){
    //   return Container(
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //         image: DecorationImage(
    //           fit: BoxFit.fill,
    //           image: AssetImage('assets/images/buttons/unUse_minus_button.png'),
    //         )
    //     ),
    //   );
    // }
    if ((nDanIndex == 1 && context.read<TranspositionProvider>().bOneIsDrum) || (nDanIndex == 1 && context.read<OctaveProvider>().nOneOctaveValue <= -1)) {
      // print('context.read<TranspositionProvider>().bOneIsDrum : ${context.read<TranspositionProvider>().bOneIsDrum}');
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
    else if ((nDanIndex == 2 && context.read<TranspositionProvider>().bTwoIsDrum) || (nDanIndex == 2 && context.read<OctaveProvider>().nTwoOctaveValue <= -1)) {
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
    else if ((nDanIndex == 3 && context.read<TranspositionProvider>().bThreeIsDrum) || (nDanIndex == 2 && context.read<OctaveProvider>().nThreeOctaveValue <= -1)) {
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
    else{
      // return Container(
      //   alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/minus_button.png'),
        //     )
        // ),
        ///SJW Modify 2023.03.14 Start...
        ///버튼 이미지 깜빡임 수정
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
        child: _decrementIconButton(context, _size),
      ),
    );
  }
}
