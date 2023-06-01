import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneCancelDialog extends StatefulWidget {
  const PhoneCancelDialog({Key? key}) : super(key: key);

  @override
  _PhoneCancelDialogState createState() => _PhoneCancelDialogState();
}

class _PhoneCancelDialogState extends State<PhoneCancelDialog> {

//==============================================================================

  ///타이틀
  Widget _displayTitle(Orientation orientation, Size size){
    ///SJW Modify 2022.06.28 Start...1 /// 세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayTitle(size)
        : _landscapeDisplayTitle(size);
    // ///SJW Modify 2022.04.21 Start...1 구분선 추가
    // // return Row(
    // //   children: <Widget>[
    // //     Icon(Icons.exit_to_app),
    // //     SizedBox(width: size.width * 0.03,),
    // //     Text('이전화면으로  이동', style: TextStyle(fontWeight: FontWeight.bold),),
    // //   ],
    // // );
    // return Column(
    //   children: <Widget>[
    //
    //     ///SJW Modify 2022-06-03 Start...1
    //     ///GUI 적용
    //     // Row(
    //     //   children: <Widget>[
    //     //
    //     //     Expanded(flex: 1, child: SizedBox(),),
    //     //
    //     //     Icon(Icons.exit_to_app, color: Colors.black),
    //     //
    //     //     Text('이전화면으로 이동', style: TextStyle(fontWeight: FontWeight.bold)),
    //     //
    //     //     Expanded(flex: 1, child: SizedBox(),),
    //     //
    //     //   ],
    //     // ),
    //     //
    //     // Divider(thickness: 2.0, color: Colors.grey.withOpacity(0.5)),
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
    //
    //     ///SJW Modify 2022-06-03 End...1
    //   ],
    // );
    ///SJW Modify 2022.06.28 End...1
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
        //   height: size.height * 0.04,
        //   alignment: Alignment.center,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Icon(Icons.logout, color: Colors.black, size: size.width * 0.08),
        //       Text('이전화면으로 이동', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.05, fontWeight: FontWeight.bold)),)
        //     ],
        //   ),
        // ),
        ///SJW Modify 2022.07.15 End...

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

  ///가로모드 타이틀
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
        //   width: size.height,
        //   height: size.width * 0.04,
        //   alignment: Alignment.center,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Icon(Icons.logout, color: Colors.black, size: size.height * 0.05),
        //       Text('이전화면으로 이동', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.03, fontWeight: FontWeight.bold)))
        //     ],
        //   ),
        //  ),
        ///SJW Modify 2022.07.15 End...

        Container(
          height: size.width * 0.03,
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
    ///SJW Modify 2022.06.28 Start...1  ///세로 & 기로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayContent(size)
        : _landscapeDisplayContent(size);
    // return Container(
    //   width: orientation == Orientation.portrait ? size.width * 0.7 : size.height * 0.7,
    //   height: orientation == Orientation.portrait ? size.height * 0.1 : size.width * 0.1,
    //   ///SJW Modify 2022.04.21 Start...2  가운데 정렬
    //   alignment: Alignment.center,
    //   ///SJW Modify 2022.04.21 End...2
    //   child: Text(
    //     '이전화면으로 이동하시면\n설정값이 저장 되지 않습니다.\n이동하시겠습니까?',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.035
    //             : size.height * 0.035,
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.28 End...1
  }

  ///세로모드 content
  Widget _portraitDisplayContent(Size size){
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        '이전화면으로 이동하시면\n설정값이 저장 되지 않습니다.\n이동하시겠습니까?',
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: size.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ///가로모드 content
  Widget _landscapeDisplayContent(Size size){
    return Container(
      width: size.height * 0.7,
      height: size.width * 0.1,
      alignment: Alignment.center,
      child: Text(
        '이전화면으로 이동하시면\n설정값이 저장 되지 않습니다.\n이동하시겠습니까?',
        textAlign: TextAlign.center,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: size.height * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///확인 버튼
  Widget _displayOkButton(Orientation orientation, Size size){
    ///SJW Modify 2022.06.28 Start...2  ///세로 & 가로모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayOkButton(size)
        : _landscapeDisplayOkButton(size);
    // return Expanded(
    //   flex: 1,
    //   ///SJW Modify 2022-06-03 Start...2
    //   ///GUI 적용
    //   // child: Container(
    //   //   height: orientation == Orientation.portrait ? size.height * 0.06 : size.height * 0.1,
    //   //   decoration: BoxDecoration(
    //   //     borderRadius: BorderRadius.circular(16.0),
    //   //   ),
    //   //   child: TextButton(
    //   //     onPressed: () {
    //   //       Platform.isAndroid ?
    //   //       SystemNavigator.pop() :
    //   //       exit(0);
    //   //     },
    //   //     child: Text('이동', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
    //   //   ),
    //   // ),
    //   child: GestureDetector(
    //     onTap: (){
    //       Platform.isAndroid ?
    //       SystemNavigator.pop() :
    //       exit(0);
    //     },
    //     child: Container(
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.06
    //           : size.width * 0.06,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage('assets/images/buttons/ok_button.png'),
    //         ),
    //       ),
    //     ),
    //   ),
    //   ///SJW Modify 2022-06-03
    // );
    ///SJW Modify 2022.06.28 End...2
  }

  ///세로모드 확인 버튼
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
          width: size.width,
          height: size.height * 0.06,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/buttons/ok_button.png'),
            ),
          ),
        ),
      ),
      ///SJW Modiy 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
      // Container(
      //   height: size.height * 0.06,
      //   decoration: BoxDecoration(
      //     border: Border(
      //       right: BorderSide(color: Colors.grey, width: 1.0),
      //     ),
      //   ),
      //   child: TextButton(
      //     onPressed: () => exit(0),
      //     child: Text(
      //       '확인',
      //       textAlign: TextAlign.center,
      //       style: GoogleFonts.lato(
      //         textStyle: TextStyle(
      //           color: Colors.red,
      //           fontSize: size.width * 0.035,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      ///SJW Modiy 2022.07.15 End...
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
              image: AssetImage('assets/images/buttons/ok_button.png'),
            ),
          ),
        ),
      ),
      ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
      // Container(
      //   width: size.width * 0.25,
      //   height: size.width * 0.06,
      //   decoration: BoxDecoration(
      //     border: Border(
      //       right: BorderSide(color: Colors.grey, width: 1.0),
      //     ),
      //   ),
      //   child: TextButton(
      //     onPressed: () => exit(0),
      //     child: Text(
      //       '확인',
      //       textAlign: TextAlign.center,
      //       style: GoogleFonts.lato(
      //         textStyle: TextStyle(
      //           color: Colors.red,
      //           fontSize: size.height * 0.035,
      //           fontWeight: FontWeight.bold,
      //         ),
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
    ///SJW Modify 2022.06.28 Start...3 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayCancelButton(context, size)
        : _landscapeDisplayCancelButton(context, size);
    // return Expanded(
    //   flex: 1,
    //   ///SJW Modify 2022-06-03 Start...3
    //   ///GUI 적용
    //   // child: Container(
    //   //   height: orientation == Orientation.portrait ? size.height * 0.06 : size.height * 0.1,
    //   //   decoration: BoxDecoration(
    //   //     borderRadius: BorderRadius.circular(16.0),
    //   //   ),
    //   //   child: TextButton(
    //   //     onPressed: () {
    //   //       Navigator.of(context).pop();
    //   //     },
    //   //     child: Text('취소', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
    //   //   ),
    //   // ),
    //   child: GestureDetector(
    //     onTap: () => Navigator.pop(context),
    //     child: Container(
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.06
    //           : size.width * 0.06,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //           image: DecorationImage(
    //             image: AssetImage('assets/images/buttons/cancel_button2.png'),
    //           )
    //       ),
    //     ),
    //   ),
    //   ///SJW Modify 2022-06-03 End...3
    // );
    ///SJW Modify 2022.06.28 End...3
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
              image: AssetImage('assets/images/buttons/cancel_button2.png'),
            ),
          ),
        ),
      ),
      ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
      // Container(
      //   height: size.height * 0.06,
      //   child: TextButton(
      //     onPressed: () => Navigator.pop(context),
      //     child: Text(
      //       '취소',
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
      // ),
      ///SJW Modify 2022.07.15 End...
    );
  }

  ///가로모드 취소 버튼
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
              image: AssetImage('assets/images/buttons/cancel_button.png'),
            ),
          ),
        ),
      ),
      ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으로 변경
      // Container(
      //   height: size.width * 0.06,
      //   child: TextButton(
      //     onPressed: () => Navigator.pop(context),
      //     child: Text(
      //       '취소',
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
      // ),
      ///SJW Modify 2022.07.15 End...
    );
  }

//==============================================================================

  @override
  void initState() {
    // TODO: implement initState
    // WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.portraitUp,
    // ]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PhoneCancelDialog oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // WidgetsFlutterBinding.ensureInitialized();
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
          actions: <Widget>[
            Row(
              children: <Widget>[

                //이동 버튼
                _displayOkButton(orientation, _size),


               SizedBox(width: orientation == Orientation.portrait ? _size.width * 0.01 : _size.height * 0.01),

                //취소 버튼
                _displayCancelButton(context, orientation, _size),

              ],
            ),
          ],
        ) :
        CupertinoAlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(orientation, _size),
          actions: <Widget>[
            Row(
              children: <Widget>[

                //이동 버튼
                _displayOkButton(orientation, _size),

                SizedBox(width: orientation == Orientation.portrait ? _size.width * 0.01 : _size.height * 0.01),

                //취소 버튼
                _displayCancelButton(context, orientation, _size),

              ],
            ),
          ],
        );
      },
    );
  }
}

