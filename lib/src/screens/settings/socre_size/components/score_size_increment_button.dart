import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/score_size_provider.dart';

class ScoreSizeIncrementButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  ScoreSizeIncrementButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  Widget _showIncrementButton(Size size){
    return Consumer<ScoreSizeProvider>(
      builder: (context, scoreSize, child){
        return GestureDetector(
          onTap: () async {

            // try {
            //   await scoreSize.incrementScoreSize();
            // }
            // catch(e){
            //   print('score size increment error : ${e.toString()}');
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

            if(scoreSize.nScoreSizeValue > 5){
              return;
            }

            if(context.read<PDFProvider>().bMakingScore){
              return;
            }

            DrawScore drawScore = DrawScore();
            await scoreSize.incrementScoreSize();

            // Future.delayed(Duration(milliseconds: 500));

            await drawScore.changeOption(context, httpCommunicate!);

          },
          // child: Container(
          //   alignment: Alignment.center,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     fit: BoxFit.fill,
            //     image: scoreSize.nScoreSizeValue < 6 ? AssetImage('assets/images/buttons/plus_button.png') : AssetImage('assets/images/buttons/unUse_plus_button.png'),
            //   ),
            // ),
            ///SJW Modify 2023.03.14 Start...
            ///버튼 이미지 깜빡임 수정
            child: Image.asset(
              scoreSize.nScoreSizeValue < 6 ? 'assets/images/buttons/plus_button.png' : 'assets/images/buttons/unUse_plus_button.png',
              fit: BoxFit.fill,
              gaplessPlayback: true,
            ),
            ///SJW Modify 2023.03.14 End..
          // ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: SizedBox(
        // width: _size.width,
        height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
        // alignment: Alignment.center,
        child: _showIncrementButton(_size),
      ),
    );
  }
}

