import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneEnsembleDialog extends StatelessWidget {
  const PhoneEnsembleDialog({Key? key}) : super(key: key);

  ///세로 모드 content
  Widget _portraitDisplayContent(Size size){
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        '앙상블 악보는 설정을 변경할 수 없습니다.',
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
        '앙상블 악보는 설정을 변경할 수 없습니다.',
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
        onTap: () => Navigator.pop(context),
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
        onTap: () => Navigator.pop(context),
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
