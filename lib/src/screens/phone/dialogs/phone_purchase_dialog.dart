import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PhonePurchaseDialog extends StatelessWidget {
  const PhonePurchaseDialog({Key? key}) : super(key: key);

//==============================================================================

  ///타이틀
  Widget _displayTitle(Orientation orientation, Size size){
    ///SJW Modify 2022-07-05 Start...1 ///가로 모드 세로 모드 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayTitle(size)
        : _landscapeDisplayTitle(size);
    // return Column(
    //   children: <Widget>[
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Icon(Icons.warning_amber_outlined, color: Colors.black),
    //         Text('이조 중복', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black,
    //           fontSize: orientation == Orientation.portrait
    //                       ? size.width * 0.035
    //                       : size.height * 0.035,
    //                 ),
    //             ),
    //         ),
    //       ],
    //     ),
    //
    //     Divider(thickness: 2.0, color: Colors.grey.withOpacity(0.5)),
    //
    //   ],
    // );
  }

  ///세로 모드 타이틀
  Widget _portraitDisplayTitle(Size size){
    return Column(
      children: <Widget>[
        Container(
          width: size.width * 0.7,
          height: size.height * 0.04,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.warning_amber_outlined, color: Colors.black, size: size.width * 0.08),
              Text('이조 중복', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.05, fontWeight: FontWeight.bold))),
            ],
          ),
        ),

        Container(
          height: size.height * 0.03,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/divider.png'),
            ),
          ),
        ),
      ],
    );
  }

  ///가로 모드 타이틀
  Widget _landscapeDisplayTitle(Size size){
    return Column(
      children: <Widget>[
        Container(
          width: size.height * 0.7,
          height: size.width * 0.04,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.warning_amber_outlined, color: Colors.black, size: size.height * 0.08),
              Text('이조 중복', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.05, fontWeight: FontWeight.bold))),
            ],
          ),
        ),

        Container(
          height: size.height * 0.03,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/divider.png'),
            ),
          ),
        ),
      ],
    );
  }

//==============================================================================

//==============================================================================

  ///content( 본문 )
  Widget _displayContent(Orientation orientation, Size size){
    ///SJW Modify 2022.06.28 Start...1  /// 세모 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayContent(size)
        : _landscapeDisplayContent(size);
    // return Container(
    //   width: orientation == Orientation.portrait ? size.width * 0.7 : size.height * 0.7,
    //   height: orientation == Orientation.portrait ? size.height * 0.1 : size.width * 0.1,
    //   alignment: Alignment.center,
    //   child: Text(
    //     '이미 구매하신 이조 선택입니다.',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontWeight: FontWeight.bold,
    //       fontSize: orientation == Orientation.portrait
    //           ? size.width * 0.035
    //           : size.height * 0.035,
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.28 End...1
  }

  ///세로 모드 content
  Widget _portraitDisplayContent(Size size){
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        '이미 구매하신 이조 선택 입니다.',
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
        '이미 구매하신 이조 선택 입니다.',
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: size.height * 0.035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///확인 버튼
  Widget _displayOkButton(BuildContext context, Orientation orientation, Size size){
    ///SJW Modify 2022.06.28 Stat...2 /// 세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayOkButton(context, size)
        : _landscapeDisplayOkButton(context, size);
    // return GestureDetector(
    //   onTap: () => Navigator.pop(context),
    //     child: Container(
    //       width: size.width,
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.06
    //           : size.width * 0.06,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           fit: BoxFit.contain,
    //           image: AssetImage('assets/images/buttons/ok_button.png'),
    //         ),
    //       ),
    //       ///SJW Modify 2022-06-08 Start...1
    //       ///GUI 적용
    //       // child: TextButton(
    //       //   onPressed: () {
    //       //     Navigator.of(context).pop();
    //       //   },
    //       //   child: Text('확인', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
    //       // ),
    //       ///SJW Modify 2022-06-08 Start...1
    //     ),
    // );
    ///SJW Modify 2022.06.28 End...2
  }

  ///세로 모드 확인 버튼
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
    // SizedBox(
    //   width: size.width,
    //   height: size.height * 0.06,
    //   child: TextButton(
    //     onPressed: () => Navigator.pop(context),
    //     child: Text(
    //       '확인',
    //       textAlign: TextAlign.center,
    //       style: GoogleFonts.lato(
    //         textStyle: TextStyle(
    //           color: Colors.blue,
    //           fontSize: size.width * 0.035,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.07.18 End...
  }

  ///가로 모드 확인 버튼
  Widget _landscapeDisplayOkButton(BuildContext context, Size size){
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
    // SizedBox(
    //   width: size.height,
    //   height: size.width * 0.06,
    //   child: TextButton(
    //     onPressed: () => Navigator.pop(context),
    //     child: Text(
    //       '확인',
    //       textAlign: TextAlign.center,
    //       style: GoogleFonts.lato(
    //         textStyle: TextStyle(
    //           color: Colors.blue,
    //           fontSize: size.height * 0.035,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.07.18 End...
  }

//==============================================================================

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Platform.isAndroid ?
        AlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(orientation, _size),
          actions: <Widget>[_displayOkButton(context, orientation, _size)],
        ) :
        CupertinoAlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(orientation, _size),
          actions: <Widget>[_displayOkButton(context, orientation, _size)],
        );
      },
    );
  }
}
