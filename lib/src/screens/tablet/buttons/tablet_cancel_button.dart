
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../dialogs/tablet_cancel_dialog.dart';

class TabletCancelButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;

  TabletCancelButton({this.orientation, this.bIsTablet});

//==============================================================================

  ///취소 버튼
  Widget _cancelButton(BuildContext context, Size size){
    return orientation == Orientation.portrait
        ? _portraitCancelButton(context, size)
        : _landscapeCancelButton(context, size);
  }

  ///세로 모드 취소 버튼
  Widget _portraitCancelButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          Platform.isAndroid ?
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => TabletCancelDialog(orientation: orientation!, bIsTablet: bIsTablet!)
              ) :
              showCupertinoDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => TabletCancelDialog(orientation: orientation!, bIsTablet: bIsTablet!)
              );
        },
        child: Container(
          width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
          height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/buttons/cancel_button.png'),
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 취소 버튼
  Widget _landscapeCancelButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          Platform.isAndroid ?
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => TabletCancelDialog(orientation: orientation, bIsTablet: bIsTablet!)
              ) :
              showCupertinoDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => TabletCancelDialog(orientation: orientation!, bIsTablet: bIsTablet!)
              );
        },
        child: Container(
          ///SJW Modify 2023.02.09 Start...
          ///버튼 width가 넓어 줄임
          width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.3,
          ///SJW Modify 2023.02.09 End...
          height: Platform.isAndroid ? size.width * 0.07 : size.width * 0.07,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/buttons/cancel_button.png'),
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022.06.29 Start...1  ///세로 & 가로 모드 함수로 따로 구현
    return _cancelButton(context, _size);
    // return Positioned(
    //   ///SJW Modify 2022.04.19 Start...1 좌표 수정
    //   // top: orientation == Orientation.portrait ?
    //   //     Platform.isAndroid ?
    //   //         _size.height * 0.85 : _size.height * 0.85
    //   //     : Platform.isAndroid ?
    //   //         _size.height * 0.80 : _size.height * 0.80,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.height * 0.90 : _size.height * 0.90
    //       :Platform.isAndroid ?
    //           _size.height * 0.85 : _size.height * 0.85,
    //   ///SJW Modify 2022.04.19 End...1
    //
    //   right: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.width * 0.03 : _size.width * 0.03
    //       : Platform.isAndroid ?
    //           _size.width * 0.03 : _size.width * 0.03,
    //
    //     ///SJW Modify 2022.04.29 Start...1  GUI 적용
    //     // child: TextButton(
    //     //   onPressed: (){
    //     //     Platform.isAndroid ?
    //     //         showDialog(
    //     //           context: context,
    //     //           barrierDismissible: false,
    //     //           builder: (BuildContext context) => TabletCancelDialog(bIsTablet: bIsTablet!)
    //     //         ) :
    //     //         showCupertinoDialog(
    //     //           context: context,
    //     //           barrierDismissible: false,
    //     //           builder: (BuildContext context) => TabletCancelDialog(bIsTablet: bIsTablet!)
    //     //         );
    //     //   },
    //     //   child: Text(
    //     //     '닫기',
    //     //     style: TextStyle(
    //     //       fontWeight: FontWeight.bold,
    //     //       color: Colors.white,
    //     //       fontSize: Platform.isAndroid ? 18 : 24,
    //     //     ),
    //     //   ),
    //     // ),
    //     child: GestureDetector(
    //       onTap: () async {
    //         await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    //         Platform.isAndroid ?
    //         showDialog(
    //             context: context,
    //             barrierDismissible: false,
    //             builder: (BuildContext context) => TabletCancelDialog(bIsTablet: bIsTablet!, orientation: orientation!,)
    //         ) :
    //         showCupertinoDialog(
    //             context: context,
    //             barrierDismissible: false,
    //             builder: (BuildContext context) => TabletCancelDialog(bIsTablet: bIsTablet!, orientation: orientation!,)
    //         );
    //         });
    //       },
    //
    //       child: Container(
    //         width: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.3
    //             : Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.3,
    //
    //         height: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //         _size.height * 0.07 : _size.height * 0.07
    //             : Platform.isAndroid ?
    //         _size.height * 0.13 : _size.height * 0.13,
    //
    //         alignment: Alignment.center,
    //
    //         decoration: BoxDecoration(
    //           //color: Colors.blue,
    //           borderRadius: BorderRadius.circular(16.0),
    //           image: DecorationImage(image: AssetImage('assets/images/buttons/cancel_button.png'), fit: BoxFit.fill),
    //         ),
    //     ),
    //     ///SJW Modify 2022.04.29 End...1
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...1
  }
}
