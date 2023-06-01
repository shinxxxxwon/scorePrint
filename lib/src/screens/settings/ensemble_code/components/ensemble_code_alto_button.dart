
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

class EnsembleCodeAltoButton extends StatefulWidget {
  EnsembleCodeAltoButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  @override
  State<EnsembleCodeAltoButton> createState() => _EnsembleCodeAltoButtonState();
}

class _EnsembleCodeAltoButtonState extends State<EnsembleCodeAltoButton> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Consumer<EnsembleCodeProvider>(
        builder: (context, ensembleCode, _) {
          ///SJW Modify 2022-06-02 Start...1
          ///GUI 적용
          return GestureDetector(
            onTap: () async {

              if(context.read<PDFProvider>().bMakingScore){
                return;
              }

              DrawScore drawScore = DrawScore();
              await ensembleCode.changeEnsembleCode(2);

              // Future.delayed(Duration(milliseconds: 800));

              await drawScore.changeOption(context, widget.httpCommunicate!);

            },
            // child:  Container(
            //         alignment: Alignment.center,
                    ///SJW Modify 2023.03.14 Start...
                    ///버튼 이미지 깜빡임 수정
                    child: Image.asset(
                      ensembleCode.nEnsembleCode == 2 ?  'assets/images/buttons/alto_on_button.png' : 'assets/images/buttons/alto_off_button.png',
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