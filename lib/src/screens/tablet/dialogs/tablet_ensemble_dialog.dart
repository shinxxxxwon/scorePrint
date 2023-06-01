import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TabletEnsembleDialog extends StatelessWidget {
  const TabletEnsembleDialog({Key? key}) : super(key: key);

  ///Content
  Widget _displayContent(Orientation orientation, Size size){
    return Container(
      width: orientation == Orientation.portrait
          ? size.width * 0.5
          : size.height * 0.5,
      height: orientation == Orientation.portrait
          ? size.height * 0.1
          : size.width * 0.1,
      alignment: Alignment.center,
      child: Text(
        '앙상블 악보는 설정을 변경할 수 없습니다.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: orientation == Orientation.portrait
              ? size.width * 0.025
              : size.height * 0.025,
        ),
      ),
    );
  }

  Widget _displayOKButton(BuildContext context, Orientation orientation, Size size) {
    ///SJW Modify 2022.07.06 Start...1  ///가로 & 세로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayOkButton(context, size)
        : _landscapeDisplayOkButton(context, size);
  }

  Widget _landscapeDisplayOkButton(BuildContext context, Size size) {
    ///SJW Modify 2022.07.18 Start... ///확인 버튼 텍스트 -> 이미지 버튼으로 변경
    // return Platform.isAndroid ?
    return Container(
      height: size.width * 0.05,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Image(
          image: AssetImage('assets/images/buttons/ok_button.png'),
        ),
      ),
    );
  }

  Widget _portraitDisplayOkButton(BuildContext context, Size size) {
    ///SJW Modify 2022.07.18 Start... ///확인 버튼 텍스트 -> 이미지 버튼으로 변경
    // return Platform.isAndroid ?
    return Container(
      height: size.height * 0.05,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Image(
          image: AssetImage('assets/images/buttons/ok_button.png'),
        ),
      ),
    );
  }

  ///Action
  Widget _displayAction(BuildContext context, Orientation orientation, Size size){
    return _displayOKButton(context, orientation, size);
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
          actions: <Widget>[_displayAction(context, orientation, _size)],
        ) :
        CupertinoAlertDialog(
          content: _displayContent(orientation, _size),
          actions: <Widget>[_displayAction(context, orientation, _size)],
        );
      },
    );
  }
}
