
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import '../dialogs/phone_cancel_dialog.dart';

class PhoneCancelButton extends StatelessWidget {
  final Orientation? orientation;

  PhoneCancelButton({this.orientation});

//==============================================================================

  ///세로모드 버튼 UI
  Widget _portraitPhoneCancelButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.88 : size.height * 0.88,
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          Platform.isAndroid
              ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PhoneCancelDialog())
              : showCupertinoDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PhoneCancelDialog());
        },
        child:Container(
          ///SJW Modify 2023.05.18 Start...
          ///뷰어로 변경되면서 버튼 사이즈 변경
          // width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
          width: Platform.isAndroid ? size.width * 0.4 : size.width * 0.4,
          ///SJW Modify 2023.05.18 End...
          height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
          decoration: BoxDecoration(
            //color: Colors.blue,
            image: DecorationImage(
              fit: BoxFit.fill,
              ///SJW Modify 2023.05.18 Start...
              ///뷰어로 변경되면서 버튼 이미지 변경
              // image: AssetImage('assets/images/buttons/print_button.png'),
              image: AssetImage('assets/images/buttons/next_button.png'),
              ///SJW Modify 2023.05.18 End...
            ),
          ),
        ),
      ),
    );
  }

  ///가로모드 버튼 UI
  Widget _landscapePhoneCancelButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.08,
      child: GestureDetector(
        onTap: (){
          Platform.isAndroid
              ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PhoneCancelDialog())
              : showCupertinoDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PhoneCancelDialog());
        },
        child:Container(
          ///SJW Modify 2023.02.09 Start...
          ///버튼 width가 넓어 줄임
          width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.27,
          ///SJW Modify 2023.02.09 End...
          height: Platform.isAndroid ? size.height * 0.13 : size.height * 0.13,
          decoration: BoxDecoration(
            //color: Colors.blue,
            image: DecorationImage(
              fit: BoxFit.fill,
              ///SJW Modify 2023.05.18 Start...
              ///뷰어로 변경되면서 버튼 이미지 변경
              // image: AssetImage('assets/images/buttons/print_button.png'),
              image: AssetImage('assets/images/buttons/next_button.png'),
              ///SJW Modify 2023.05.18 End...
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

    ///SJW Modify 2022.06.24 Start...1  ///세로 & 가로모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitPhoneCancelButton(context, _size)
        : _landscapePhoneCancelButton(context, _size);
    // return Positioned(
    //   ///SJW Modify 2022.04.21 Start...1  좌표수정
    //   // top: orientation == Orientation.portrait ?  ///세로모드
    //   //       Platform.isAndroid ?
    //   //         _size.height * 0.85 : _size.height * 0.83
    //   //       : Platform.isAndroid ?                  ///가로모드
    //   //         _size.height * 0.80 : _size.height * 0.80,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.height * 0.90 : _size.height * 0.88
    //       :Platform.isAndroid ?
    //           _size.height * 0.85 : _size.height * 0.85,
    //   ///SJW Modify 2022.04.21 End...1
    //
    //   right: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //           _size.width * 0.03 : _size.width * 0.03
    //         : Platform.isAndroid ?
    //           _size.width * 0.03 : _size.width * 0.08,
    //
    //     ///SJW Modify 2022.04.29 Start...1  GUI적용
    //     // child: TextButton(
    //     //   onPressed: (){
    //     //     Platform.isAndroid
    //     //         ? showDialog(
    //     //         context: context,
    //     //         barrierDismissible: false,
    //     //         builder: (BuildContext context) => PhoneCancelDialog())
    //     //         : showCupertinoDialog(
    //     //         context: context,
    //     //         barrierDismissible: false,
    //     //         builder: (BuildContext context) => PhoneCancelDialog());
    //     //   },
    //     //   child: Text(
    //     //     '닫기',
    //     //     style: TextStyle(
    //     //       fontWeight: FontWeight.bold,
    //     //       color: Colors.white,
    //     //     ),
    //     //   ),
    //     // ),
    //     child: GestureDetector(
    //       onTap: (){
    //         Platform.isAndroid
    //             ? showDialog(
    //             context: context,
    //             barrierDismissible: false,
    //             builder: (BuildContext context) => PhoneCancelDialog())
    //             : showCupertinoDialog(
    //             context: context,
    //             barrierDismissible: false,
    //             builder: (BuildContext context) => PhoneCancelDialog());
    //       },
    //       child:Container(
    //         width: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.3
    //             : Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.27,
    //
    //         height: orientation == Orientation.portrait ? _size.height * 0.07 : _size.height * 0.13,
    //         decoration: BoxDecoration(
    //           //color: Colors.blue,
    //           image: DecorationImage(
    //             fit: BoxFit.fill,
    //             image: AssetImage('assets/images/buttons/cancel_button.png'),
    //           ),
    //         ),
    //     ),
    //     ///SJW Modify 2022.04.29 End...1
    //   ),
    // );
    ///SJW Modify 2022.06.24 End...1
  }
}
