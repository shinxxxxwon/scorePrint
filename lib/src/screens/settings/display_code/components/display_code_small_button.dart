
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../../providers/display_code_provider.dart';
import '../../../../resources/score/score_info_controller.dart';

class DisplayCodeSmallButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  DisplayCodeSmallButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Consumer<DisplayCodeProvider>(
        builder: (context, displayCode, child) {
          ///SJW Modify 2022-06-02 Start...1
          ///GUI 적용
          // return Container(
          //   width: _size.width,
          //   height: _size.height,
          //   alignment: Alignment.center,
          //   color: displayCode.nDisplayCodeValue == 1 ? Colors.deepPurpleAccent : Colors.grey,
          //   child: TextButton(
          //     onPressed: () => displayCode.changeDisplayCodeValue(1),
          //     child: Text(
          //       '소',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //         fontSize: bIsTablet == true ? 22 : 16,
          //       ),
          //     ),
          //   ),
          // );
          return GestureDetector(
            onTap: () async {

              // try {
              //   await displayCode.changeDisplayCodeValue(1);
              // }
              // catch(e){
              //   print('displaycode small error : ${e.toString()}');
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
              await displayCode.changeDisplayCodeValue(1);

              // Future.delayed(Duration(milliseconds: 500));

              await drawScore.changeOption(context, httpCommunicate!);
            },

            // child: Container(
            //   alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: displayCode.nDisplayCodeValue == 1 ? displayCode.smallOnButton : displayCode.smallOffButton,
              //         // AssetImage('assets/images/buttons/small_on_button.png') : AssetImage('assets/images/buttons/small_off_button.png'),
              //   ),
              // ),
              ///SJW Modify 2023.03.14 Start...
              ///버튼 이미지 깜빡임 수정
              child: Image.asset(
                displayCode.nDisplayCodeValue == 1 ?  'assets/images/buttons/small_on_button.png' : 'assets/images/buttons/small_off_button.png',
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
              ///SJW Modify 2023.03.14 End...
            // ),
          );
          ///SJW Modify 2022-06-02 End...1
        },
      ),
    );
  }
}
