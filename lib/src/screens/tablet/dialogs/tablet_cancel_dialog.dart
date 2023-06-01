import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TabletCancelDialog extends StatefulWidget {
  bool? bIsTablet;
  Orientation? orientation;

  TabletCancelDialog({this.bIsTablet, this.orientation});
  @override
  _TabletCancelDialogState createState() => _TabletCancelDialogState();
}

class _TabletCancelDialogState extends State<TabletCancelDialog> {

//==============================================================================

  ///Title
  Widget _displayTitle(Orientation orientation, Size size){
    ///SJW Modify 2022.07.06 Start...1  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayTitle(size)
        : _landscapeDisplayTitle(size);
    ///SJW Modify 2022.04.21 Start...1  레이아웃 변경
    // return Row(
    //   children: <Widget>[
    //
    //     //아이콘
    //     Icon(Icons.logout, color: Colors.black, size: 24),
    //
    //     //텍스트
    //     Text(
    //       '  이전화면으로 이동',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //         fontSize: 24,
    //       ),
    //     ),
    //
    //   ],
    // );
    // return Column(
    //   children: <Widget>[

        ///SJW Modify 2022-06-03 Start...1
        ///GUI 적용
        // Row(
        //   children: <Widget>[
        //
        //     Expanded(flex: 1, child: SizedBox()),
        //
        //     Icon(Icons.exit_to_app, color: Colors.black),
        //
        //     Text('이전화면으로 이동', style: TextStyle(fontWeight: FontWeight.bold)),
        //
        //     Expanded(flex: 1, child: SizedBox()),
        //
        //   ],
        // ),
        //
        // Divider(thickness: 2.0, color: Colors.grey.withOpacity(0.5)),
    //     Container(
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.02
    //           : size.width * 0.02,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage('assets/images/prev_screen_text.png'),
    //         ),
    //       ),
    //     ),
    //
    //     Container(
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.03
    //           : size.width * 0.03,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage('assets/images/divider.png'),
    //         ),
    //       ),
    //     ),
    //     ///SJW Modify 2022-06-03 End...1
    //
    //   ],
    // );
    ///SJW Modify 2022.07.06 End...1
  }

  ///세로 모드 타이틀
  Widget _portraitDisplayTitle(Size size){
    return Column(
      children: <Widget>[
        // Platform.isAndroid ?
            Container(
              height: size.height * 0.02,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/prev_screen_text.png'),
                ),
              ),
            ),
            ///SJW Modify 2022.07.15 Start... ///IOS 타이틀 텍스트 -> 이미지로 변경
            // Container(
            //   height: size.height * 0.03,
            //   alignment: Alignment.center,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Icon(Icons.logout, color: Colors.black, size: size.width * 0.05),
            //       Text('이전화면으로 이동', style: GoogleFonts.lato(color: Colors.black, fontSize: size.width * 0.03, fontWeight: FontWeight.bold),),
            //     ],
            //   ),
            // ),
            ///SJW Modify 2022.07.15 End...

        Container(
          height: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
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
        // Platform.isAndroid ?
            Container(
              height: size.width * 0.02,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/prev_screen_text.png'),
                ),
              ),
            ),
            ///SJW Modify 2022.07.15 Start... ///IOS 타이틀 텍스트 -> 이미지로 변경
            // Container(
            //   height: size.width * 0.03,
            //   alignment: Alignment.center,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Icon(Icons.logout, color: Colors.black, size: size.height * 0.05),
            //       Text('이전화면으로 이동', style: GoogleFonts.lato(color: Colors.black, fontSize: size.height * 0.03, fontWeight: FontWeight.bold)),
            //     ],
            //   ),
            // ),
            ///SJW Modify 2022.07.15 End...

        Container(
          height: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
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

  ///Content
  Widget _displayContent(Orientation orientation, Size size){
    ///SJW Modify 2022.07.06 Start...2  ///가로 & 세로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayContent(size)
        : _landscapeDisplayContent(size);
    // return Container(
    //   width: orientation == Orientation.portrait ?
    //   size.width * 0.5 : size.width * 0.3,
    //   height: size.height * 0.1,
    //   alignment: Alignment.center,
    //   child: Text(
    //     '이전화면으로 이동하시면\n설정값이 저장되지 않습니다.\n이동하시겠습니까?',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontWeight: FontWeight.bold,
    //       color: Colors.black,
    //       fontSize: size.width * 0.025,
    //     ),
    //   ),
    // );
    // return Container(
    //   width: orientation == Orientation.portrait
    //       ? size.width * 0.5
    //       : size.height * 0.5,
    //   height: orientation == Orientation.portrait
    //       ? size.height * 0.1
    //       : size.width * 0.1,
    //   alignment: Alignment.center,
    //   child: Text(
    //     '이전화면으로 이동하시면\n설정값이 저장되지 않습니다.\n이동하시겠습니까?',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontWeight: FontWeight.bold,
    //       color: Colors.black,
    //       fontSize: orientation == Orientation.portrait
    //           ? size.width * 0.025
    //           : size.height * 0.025,
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.07.06 End...2
  }

  ///가로 모드 content
  Widget _portraitDisplayContent(Size size){
    return Container(
      width: Platform.isAndroid ? size.width * 0.5 : size.width * 0.5,
      height: Platform.isAndroid ? size.height * 0.1 : size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        '이전화면으로 이동하시면\n설정값이 저장되지 않습니다.\n이동하시겠습니까?',
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: size.width * 0.025,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ///세로 모드 context
  Widget _landscapeDisplayContent(Size size){
    return Container(
      width: Platform.isAndroid ? size.height * 0.5 : size.height * 0.5,
      height: Platform.isAndroid ? size.width * 0.1 : size.width * 0.1,
      alignment: Alignment.center,
      child: Text(
        '이전화면으로 이동하시면\n설정값이 저장되지 않습니다.\n이동하시겠습니까?',
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: size.height * 0.025,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///이동 버튼
  Widget _displayMoveButton(Orientation orientation, Size size){
    ///SJW Modify 2022.07.06 Start...3  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayOkButton(size)
        : _landscapeDisplayOkButton(size);
    // return Expanded(
    //   flex: 1,
      ///SJW Modify 2022-06-03 Start...2
      ///GUI 적용
      // child: Container(
      //   width: size.width * 0.25,
      //   height: size.height * 0.05,
      //   alignment: Alignment.center,
      //   child: TextButton(
      //     onPressed: () => exit(0),
      //     child: Text(
      //       '이동',
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         color: Colors.red,
      //         fontSize: 18,
      //       ),
      //     ),
      //   ),
      // ),
    //   child: GestureDetector(
    //     onTap: () => exit(0),
    //     child: Container(
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.05
    //           : size.width * 0.05,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           fit: BoxFit.fill,
    //           image: AssetImage('assets/images/buttons/ok_button.png'),
    //         ),
    //       ),
    //     ),
    //   ),
      ///SJW Modify 2022-06-03 End...2
    // );
    ///SJW Modify 2022.07.06 End...3
  }

  ///세로 모드 확인 버튼
  Widget _portraitDisplayOkButton(Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
          child: GestureDetector(
            onTap: (){
              if(Platform.isAndroid){
                SystemNavigator.pop();
              }
              else{
                exit(0);
              }
            },
            child: Container(
              height: size.height * 0.06,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/buttons/ok_button.png'),
                ),
              ),
            ),
          ),
          ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
          // Container(
          //   height: size.height * 0.05,
          //   decoration: BoxDecoration(
          //     border: Border(
          //       right: BorderSide(color: Colors.grey, width: 1.0),
          //     ),
          //   ),
          //   child: TextButton(
          //     onPressed: () => exit(0),
          //     child: Text(
          //       '확인',
          //       style: GoogleFonts.lato(
          //         color: Colors.red,
          //         fontSize: size.width * 0.025,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          ///SJW Modify 2022.07.15 End...
    );
  }

  ///가로 모드 확인 버튼
  Widget _landscapeDisplayOkButton(Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
          child: GestureDetector(
            onTap: (){
              if(Platform.isAndroid){
                SystemNavigator.pop();
              }
              else{
                exit(0);
              }
            },
            child: Container(
              height: size.width * 0.06,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/buttons/ok_button.png'),
                ),
              ),
            ),
          ),
          ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
          // Container(
          //   height: size.width * 0.05,
          //   decoration: BoxDecoration(
          //     border: Border(
          //       right: BorderSide(color: Colors.grey, width: 1.0),
          //     ),
          //   ),
          //   child: TextButton(
          //     onPressed: () => exit(0),
          //     child: Text(
          //       '확인',
          //       style: GoogleFonts.lato(
          //         color: Colors.red,
          //         fontSize: size.height * 0.025,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          ///SJW Modify 2022.07.15 End...
    );
  }

//==============================================================================

//==============================================================================

  ///취소 버튼
  Widget _displayCancelButton(BuildContext context, Orientation orientation, Size size){
    ///SJW Modify 2022.07.06 Start...4
    return orientation == Orientation.portrait
        ? _portraitDisplayCancelButton(context, size)
        : _landscapeDisplayCancelButton(context, size);
    // return Expanded(
    //   flex: 1,
      ///SJW Modify 2022-06-03 Start...3
      ///GUI 적용
      // child: Container(
      //   width: size.width * 0.25,
      //   height: size.height * 0.05,
      //   alignment: Alignment.center,
      //   child: TextButton(
      //     onPressed: () => Navigator.of(context).pop(),
      //     child: Text(
      //       '취소',
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         color: Colors.blue,
      //         fontSize: 18,
      //       ),
      //     ),
      //   ),
      // ),
      // child: GestureDetector(
      //   onTap: () {
      //     SystemChrome.setPreferredOrientations([]);
      //     Navigator.of(context).pop();
      //   },
      //   child: Container(
      //     height: orientation == Orientation.portrait
      //         ? size.height * 0.05
      //         : size.width * 0.05,
      //     alignment: Alignment.center,
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         fit: BoxFit.fill,
      //         image: AssetImage('assets/images/buttons/cancel_button2.png'),
      //       ),
      //     ),
      //   ),
      // ),
      ///SJW Modify 2022-06-03 End...3
    // );
    ///SJW Modify 2022.07.06 End...4
  }

  ///세로 모드 취소 버튼
  Widget _portraitDisplayCancelButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: size.height * 0.06,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/buttons/cancel_button2.png'),
                ),
              ),
            ),
          ),
          ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
          // SizedBox(
          //   height: size.height * 0.05,
          //   child: TextButton(
          //     onPressed: () => Navigator.pop(context),
          //     child: Text(
          //       '취소',
          //       textAlign: TextAlign.center,
          //       style: GoogleFonts.lato(
          //         color: Colors.blue,
          //         fontSize: size.width * 0.025,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          ///SJW Modify 2022.07.15 End...
    );
  }

  ///가로 모드 취고 버튼
  Widget _landscapeDisplayCancelButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: size.width * 0.06,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/buttons/cancel_button2.png'),
                ),
              ),
            ),
          ),
          ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
          // SizedBox(
          //   height: size.width * 0.05,
          //   child: TextButton(
          //     onPressed: () => Navigator.pop(context),
          //     child: Text(
          //       '취소',
          //       textAlign: TextAlign.center,
          //       style: GoogleFonts.lato(
          //         color: Colors.blue,
          //         fontSize: size.height * 0.025,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          ///SJW Modify 2022.07.15 End...
    );
  }

//==============================================================================

  ///Action
  Widget _displayAction(BuildContext context, Orientation orientation, Size size){
    return Row(
      children: <Widget>[

        //이동 버튼
        _displayMoveButton(orientation, size),

       SizedBox(width: size.width * 0.01),

        //취소 버튼
        _displayCancelButton(context, orientation, size),

      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TabletCancelDialog oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

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
          actions: <Widget>[_displayAction(context, orientation, _size)],
        ) :
        CupertinoAlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(orientation, _size),
          actions: <Widget>[_displayAction(context, orientation, _size)],
        );
      },
    );
  }
}
