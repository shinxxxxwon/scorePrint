
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/ensemble_code_provider.dart';
import '../../../../resources/score/score_info_controller.dart';

class EnsembleCodeNoneButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  EnsembleCodeNoneButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Consumer<EnsembleCodeProvider>(
        builder: (context, ensembleCode, child) {
          ///SJW Modify 2022-06-02 Start...1
          ///GUI 적용
          // return Container(
          //   width: _size.width,
          //   height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          //   alignment: Alignment.center,
          //   color: ensembleCode.nEnsembleCode == 0 ? Colors.deepPurpleAccent : Colors.grey,
          //   child: TextButton(
          //     onPressed: () => ensembleCode.changeEnsembleCode(0),
          //     child: Text(
          //       '안함',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //         fontSize: bIsTablet == true ? 22 : 16,
          //       ),
          //     ),
          //   ),
          // );
          return GestureDetector(
            onTap:() async {

              // try {
              //   await ensembleCode.changeEnsembleCode(0);
              // }
              // catch(e){
              //   print('ensemble code none error : ${e.toString()}');
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
              await ensembleCode.changeEnsembleCode(0);

              // Future.delayed(Duration(milliseconds: 800));

              await drawScore.changeOption(context, httpCommunicate!);

            },
            // child: Container(
            //   alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: ensembleCode.nEnsembleCode == 0 ?
              //         AssetImage('assets/images/buttons/none_on_button.png') : AssetImage('assets/images/buttons/none_off_button.png'),
              //   ),
              // ),
              ///SJW Modify 2023.03.14 Start...
              ///버튼 이미지 깜빡임 수정
              child: Image.asset(
                ensembleCode.nEnsembleCode == 0 ? 'assets/images/buttons/none_on_button.png' : 'assets/images/buttons/none_off_button.png',
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
