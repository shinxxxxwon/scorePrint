import 'dart:io';

import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneGoChrome extends StatelessWidget {
  final bool? bIsPreview;
  const PhoneGoChrome({Key? key, this.bIsPreview}) : super(key: key);

  ///세로 모드 content
  Widget _portraitDisplayContent(Size size){
    return Container(
      width: size.width * 0.8,
      height: size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        bIsPreview == false ? '웹에서 악보를 선택하여 실행하는 앱입니다.\n\n확인 버튼을 클릭시, 홈페이지로 이동 됩니다.' : '잘못된 접근입니다.\n다시 시도해주세요.',
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: size.width * 0.035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ///가로 모드 content
  Widget _landscapeDisplayContent(Size size){
    return Container(
      width: size.height * 0.7,
      height: size.width * 0.1,
      alignment: Alignment.center,
      child: Text(
        bIsPreview == false ? '웹에서 악보를 선택하여 실행하는 앱입니다.\n\n확인 버튼을 클릭시, 홈페이지로 이동 됩니다.' : '잘못된 접근입니다.\n다시 시도해주세요.',
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: size.height * 0.035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _displayContent(Orientation orientation, Size size) {
    ///SJW Modify 2022.06.28 Start...1  /// 세모 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayContent(size)
        : _landscapeDisplayContent(size);
  }

  Widget _portraitDisplayOkButton(BuildContext context, Size size){
    ///SJW Modify 2022.07.18 Start... ///확인 버튼 텍스트 -> 이미지 버튼으로 변경
    // return Platform.isAndroid ? GestureDetector(
    return Container(
      height: size.height * 0.06,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          BridgeNative bridgeNative = BridgeNative();
          await bridgeNative.OpenChrome();
        },
        child: Image(
          image: AssetImage('assets/images/buttons/ok_button.png'),
        ),
      ),
    );
    ///SJW Modify 2022.07.18 End...
  }

  ///가로 모드 확인 버튼
  Widget _landscapeDisplayOkButton(BuildContext context, Size size) {
    ///SJW Modify 2022.07.18 Start... ///확인 버튼 텍스트 -> 이미지 버튼으로 변경
    // return Platform.isAndroid ?
    return Container(
      height: size.width * 0.06,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          BridgeNative bridgeNative = BridgeNative();
          await bridgeNative.OpenChrome();
        },
        child: Image(
          image: AssetImage('assets/images/buttons/ok_button.png'),
        ),
      ),
    );
  }

  ///확인 버튼
  Widget _displayOkButton(BuildContext context, Orientation orientation, Size size) {
    ///SJW Modify 2022.06.28 Stat...2 /// 세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayOkButton(context, size)
        : _landscapeDisplayOkButton(context, size);
  }

  @override
  Widget build(BuildContext context) {
    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Platform.isAndroid ?
        AlertDialog(
          content: _displayContent(orientation, _size),
          actions: <Widget>[_displayOkButton(context, orientation, _size)],
        ) :
        CupertinoAlertDialog(
          content: _displayContent(orientation, _size),
          actions: <Widget>[_displayOkButton(context, orientation, _size)],
        );
      },
    );
  }
}
