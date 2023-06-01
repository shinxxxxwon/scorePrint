import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/display_code_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DisplayCodeSwitch extends StatelessWidget {
  const DisplayCodeSwitch({Key? key, this.httpCommunicate}) : super(key: key);

  final HttpCommunicate? httpCommunicate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Consumer<DisplayCodeProvider>(
        builder: (context, displayCode, child){
          return GestureDetector(
            onTap: () async {
              DrawScore drawScore = DrawScore();
              displayCode.changeActDisplayCodeValue(displayCode.nActDisplayCode == 1 ? 0 : 1);

              // Future.delayed(const Duration(milliseconds: 500));
              drawScore.changeOption(context, httpCommunicate!);
            },
            // child: Container(
            //   alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: displayCode.nActDisplayCode == 1 ? displayCode.switchOn : displayCode.switchOff,
              //       // AssetImage('assets/images/buttons/switch_on.png') : AssetImage('assets/images/buttons/switch_off.png'),
              //   ),
              // ),
              ///SJW Modify 2023.03.14 Start...
              ///버튼 이미지 깜빡임 수정
              child: Image.asset(
                displayCode.nActDisplayCode == 1 ?  'assets/images/buttons/switch_on.png' : 'assets/images/buttons/switch_off.png',
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
              ///SJW Modify 2023.03.14 End...
            // ),
          );
        },
      ),
    );
  }
}
