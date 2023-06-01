
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/lyrics_commandments_provider.dart';
import '../../../../resources/score/score_info_controller.dart';

class LyricsCommandmentsCommandmentsButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  LyricsCommandmentsCommandmentsButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Consumer<LyricsCommandmentsProvider>(
        builder: (context, lyricsCommandments, child) {
          return GestureDetector(
            onTap: ()async {

              // try {
              //   // await lyricsCommandments.changeLyricsCommandmentsValue(1);
              //   Future.wait([lyricsCommandments.changeLyricsCommandmentsValue(1)]);
              // }
              // catch(e){
              //   print('lyrics commandments commandments error : ${e.toString()}');
              // }
              // finally {
              //   DrawScore drawScore = DrawScore();
              //   // FutureBuilder(
              //   //   future: drawScore.reDrawSocre(context, httpCommunicate!),
              //   //   builder: (context, snapshot) {
              //   //     return CircularProgressIndicator();
              //   //   },
              //   // );
              //   await drawScore.reDrawSocre(context, httpCommunicate!);
              // }

              if(context.read<PDFProvider>().bMakingScore){
                return;
              }

              DrawScore drawScore = DrawScore();
              await lyricsCommandments.changeLyricsCommandmentsValue(1);

              // Future.delayed(Duration(milliseconds: 500));

              await drawScore.changeOption(context, httpCommunicate!);

            },
            // child: Container(
            //   alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: lyricsCommandments.nLyricsCommandmentsValue == 1 ?
              //     AssetImage('assets/images/buttons/commandments_on_button.png') : AssetImage('assets/images/buttons/commandments_off_button.png'),
              //   ),
              // ),
              ///SJW Modify 2023.03.14 Start...
              ///버튼 이미지 깜빡임 수정
              child: Image.asset(
                lyricsCommandments.nLyricsCommandmentsValue == 1 ? 'assets/images/buttons/commandments_on_button.png' : 'assets/images/buttons/commandments_off_button.png',
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
              ///SJW Modify 2023.03.14 End..
            // ),
          );
        },
      ),
    );
  }
}
