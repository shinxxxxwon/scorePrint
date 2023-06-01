
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/commandments_type_provider.dart';
import '../../../../resources/score/score_info_controller.dart';

class CommandmentsTypeMoveButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  final HttpCommunicate? httpCommunicate;

  CommandmentsTypeMoveButton({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 1,
      child: Consumer<CommandmentsTypeProvider>(
        builder: (context, commandmentsType, child) {
          ///SJW Modify 2022-06-02 Start...1
          ///GUI 적용
          // return Container(
          //   width: _size.width,
          //   height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
          //   alignment: Alignment.center,
          //   color: commandmentsType.nCommandmentsTypeValue == 0 ? Colors.deepPurpleAccent : Colors.grey,
          //   child: TextButton(
          //     onPressed: () => commandmentsType.changeCommandmentsTypeValue(0),
          //     child: Text(
          //       '이동도',
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

              if(context.read<PDFProvider>().bMakingScore){
                return;
              }

              DrawScore drawScore = DrawScore();
              await commandmentsType.changeCommandmentsTypeValue(0);

              Future.delayed(Duration(milliseconds: 500));

              await drawScore.changeOption(context, httpCommunicate!);

            },
            // child: Container(
            //   alignment: Alignment.center,
              ///SJW Modify 2023.03.14 Start...
              ///버튼 이미지 깜빡임 수정
              child: Image.asset(
                commandmentsType.nCommandmentsTypeValue == 0 ?  'assets/images/buttons/movedo_on_button.png' : 'assets/images/buttons/movedo_off_button.png',
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
