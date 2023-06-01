
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/display_lyrics_provider.dart';
import '../../../../resources/score/score_info_controller.dart';

class DisplayLyricsBigButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  DisplayLyricsBigButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Consumer<DisplayLyricsProvider>(
        builder: (context, displayLyrics, child) {
          ///SJW Modify 2022-06-02 Start..1
          ///GUI 적용
          // return Container(
          //   width: _size.width,
          //   height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          //   alignment: Alignment.center,
          //   color: displayLyrics.nDisplayLyricsValue == 3 ? Colors.deepPurpleAccent : Colors.grey,
          //   child: TextButton(
          //     onPressed: () => displayLyrics.changeDisplayLyricsValue(3),
          //     child: Text(
          //       '대',
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
              //   await displayLyrics.changeDisplayLyricsValue(3);
              // }
              // catch(e){
              //   print('display lyrics big error : ${e.toString()}');
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
              await displayLyrics.changeDisplayLyricsValue(3);

              // Future.delayed(Duration(milliseconds: 500));

              await drawScore.changeOption(context, httpCommunicate!);
            },
            // child: Container(
            //   alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: displayLyrics.nDisplayLyricsValue == 3 ?
              //         AssetImage('assets/images/buttons/big_on_button.png') : AssetImage('assets/images/buttons/big_off_button.png'),
              //   ),
              // ),
              ///SJW Modify 2023.03.14 Start...
              ///버튼 이미지 깜빡임 수정
              child: Image.asset(
                displayLyrics.nDisplayLyricsValue == 3 ?  'assets/images/buttons/big_on_button.png' : 'assets/images/buttons/big_off_button.png',
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
              ///SJW Modify 2023.03.14 End...
            // ),
          );
          ///SJW MOdify 2022-06-02 End...1
        },
      ),
    );
  }
}
