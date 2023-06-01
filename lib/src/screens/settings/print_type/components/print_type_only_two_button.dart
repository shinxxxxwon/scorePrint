
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/print_type_provider.dart';
import '../../../../resources/score/score_info_controller.dart';

class PrintTypeOnlyTwoButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  PrintTypeOnlyTwoButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Consumer<PrintTypeProvider>(
        builder: (context, printType, child) {
          ///SJW Modify 2022-06-02 Start...1
          ///GUI 적용
          return GestureDetector(
            onTap: () async {

              // try {
              //   await printType.changePrintTypeValue(2);
              // }
              // catch(e){
              //   print('print type only two error : ${e.toString()}');
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
              await printType.changePrintTypeValue(2);

              // Future.delayed(Duration(milliseconds: 500));

              await drawScore.changeOption(context, httpCommunicate!);

            },
            // child: Container(
            //   alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: printType.nPrintTypeValue == 2 ?
              //         AssetImage('assets/images/buttons/secondboprint_on_button.png') : AssetImage('assets/images/buttons/secondboprint_off_button.png'),
              //   ),
              // ),
              ///SJW Modify 2023.03.14 Start...
              ///버튼 이미지 깜빡임 수정
              child: Image.asset(
                printType.nPrintTypeValue == 2 ? 'assets/images/buttons/secondboprint_on_button.png' : 'assets/images/buttons/secondboprint_off_button.png',
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
              ///SJW Modify 2023.03.14 End..
            // ),
          );
          ///SJW Modify 2022-06-02 End...1
        },
      ),
    );
  }
}
