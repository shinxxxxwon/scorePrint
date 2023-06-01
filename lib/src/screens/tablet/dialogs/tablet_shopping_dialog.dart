
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../../models/http/http_communicate.dart';
import '../../../providers/dan_settings_provider.dart';
import '../../../providers/transposition_provider.dart';

class TabletShoppingDialog extends StatefulWidget {
  HttpCommunicate? httpCommunicate;

  TabletShoppingDialog({this.httpCommunicate});

  @override
  _TabletShoppingDialogState createState() => _TabletShoppingDialogState();
}

class _TabletShoppingDialogState extends State<TabletShoppingDialog> {


//==============================================================================

  ///Title
  Widget _displayTitle(Orientation orientation, Size size) {
    ///SJW Modify 2022.06.29 Start...1  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayTitle(size)
        : _landscapeDisplayTitle(size);
    // return Column(
    //   children: <Widget>[
    //     ///SJW Modify 2022-06-03 Start...1
    //     ///GUI 적용
    //     // Row(
    //     //   children: <Widget>[
    //     //
    //     //     Expanded(flex: 1, child: SizedBox(),),
    //     //
    //     //     //카트 아이콘
    //     //     Icon(Icons.save, color: Colors.black, size: 24),
    //     //
    //     //     //텍스트
    //     //     Text('저장',
    //     //         style: TextStyle(
    //     //             fontWeight: FontWeight.bold,
    //     //             color: Colors.black,
    //     //             fontSize: 24)),
    //     //
    //     //     Expanded(flex: 1, child: SizedBox(),),
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
    //           image: AssetImage('assets/images/shopping_text.png'),
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
    //   ],
    // );
    ///SJW Modify 2022.06.29 End...1
  }

  ///세로 모드 타이틀
  Widget _portraitDisplayTitle(Size size){
    return Column(
      children: <Widget>[
        // Platform.isAndroid ?
            Container(
              // width: size.width * 0.5,
              height: size.height * 0.02,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/shopping_text.png'),
                ),
              ),
            ),
            ///SJW Modify 2022.07.15 Start... ///IOS 타이틀 텍스트 -> 이미지로 변경
            // Container(
            //   // width: size.width,
            //   height: size.height * 0.03,
            //   alignment: Alignment.center,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Icon(Icons.shopping_cart, color: Colors.black, size: size.width * 0.05),
            //       Text('장바구니', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.03, fontWeight: FontWeight.bold))),
            //     ],
            //   ),
            // ),
            ///SJW Modify 2022.07.15 End...

        Container(
          // width: Platform.isAndroid ? size.width : size.width,
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
              // width: size.height * 0.5,
              height: size.width * 0.02,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/shopping_text.png'),
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
             //       Icon(Icons.shopping_cart, color: Colors.black, size: size.height * 0.05,),
             //       Text('장바구니 담기', style: GoogleFonts.lato(color: Colors.black, fontSize: size.height * 0.03, fontWeight: FontWeight.bold),)
             //     ],
             //   ),
             // ),
             ///SJW Modify 2022.07.15 End...

        Container(
          // width: size.height,
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

  ///단 텍스트
  Widget _displayDanText(Orientation orientation, int nDan, Size size) {
    ///SJW Modify 2022.06.29 Start...2  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayDanText(nDan, size)
        : _landscapeDisplayDanText(nDan, size);
    // return Expanded(
    //   flex: 1,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.width,
    //     height: orientation == Orientation.portrait
    //         ? size.height * 0.05
    //         : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black, width: 2.0),
    //     ),
    //     child: Text(
    //       '$nDan보',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //         fontSize: orientation == Orientation.portrait
    //           ? size.width * 0.025
    //           : size.height * 0.025,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...2
  }

  ///세로 모드 단 텍스트
  Widget _portraitDisplayDanText(int nDan, Size size){
    return Expanded(
      flex: 1,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.height,
        height: Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///n보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '$nDan보',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 단 텍스트
  Widget _landscapeDisplayDanText(int nDan, Size size){
    return Expanded(
      flex: 1,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.height,
        height: size.width * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///n보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '$nDan보',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///구매 악보 키 정보
  String getKeyInfo(BuildContext context, int nDan){
    if(nDan == 1) {
      return '${context
          .watch<TranspositionProvider>()
          .pKeyChordTransPos1[context
          .watch<TranspositionProvider>()
          .nOneTranspositionValue + 11].strKeyChord}';
    }
    else if(nDan == 2)
    {
      return '${context
          .watch<TranspositionProvider>()
          .pKeyChordTransPos2[context
          .watch<TranspositionProvider>()
          .nTwoTranspositionValue + 11].strKeyChord}';
    }
    else{
      return '${context
          .watch<TranspositionProvider>()
          .pKeyChordTransPos3[context
          .watch<TranspositionProvider>()
          .nThreeTranspositionValue + 11].strKeyChord}';
    }
  }

//==============================================================================

//==============================================================================

  ///단 악보 정보
  Widget _displayInfo(BuildContext context, Orientation orientation, int nDan, Size size) {
    String strKey = context.watch<TranspositionProvider>().setKeyChord(nDan);

    ///SJW Modify 2022.06.29 Start...3  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayInfo(context, strKey, size, nDan)
        : _landscapeDisplayInfo(context, strKey, size, nDan);
    // return Expanded(
    //   flex: 2,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.height,
    //     height: orientation == Orientation.portrait
    //         ? size.height * 0.05
    //         : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black, width: 2.0),
    //     ),
    //     child: Text(
    //       '$strKey',
    //       //widget.httpCommunicate!.strMainKey!,
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.red,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.025
    //             : size.height * 0.025,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...3
  }

  ///세로 모드 악보 정보
  Widget _portraitDisplayInfo(BuildContext context, String strKey, Size size, int nDan){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.height,
        height: Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///악보 정보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_1.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          (widget.httpCommunicate!.nScoreType == 7 && nDan == 2) ? "" : '$strKey',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 악보 정보
  Widget _landscapeDisplayInfo(BuildContext context, String strKey, Size size, int nDan){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.width,
        height: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///악보 정보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_1.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          (widget.httpCommunicate!.nScoreType == 7 && nDan == 2) ? "" : '$strKey',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///단 조표 정보
  Widget _displayKeynote(BuildContext context, Orientation orientation, int nDan, Size size) {
    String strMeterKey = context.read<TranspositionProvider>().setMeterKey(nDan);

    ///SJW Modify 2022.06.29 Start...4  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayKeynote(context, strMeterKey, size, nDan)
        : _landscapeDisplayKeynote(context, strMeterKey, size, nDan);
    // // print("조표 :: ${strMeterKey}개 Len : ${context.watch<TranspositionProvider>().pKeyChordTransPos.length}");
    // return Expanded(
    //   flex: 2,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.height,
    //     height: orientation == Orientation.portrait
    //         ? size.height * 0.5
    //         : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black, width: 2.0),
    //     ),
    //     child: Text(
    //        // '${context.watch<TranspositionProvider>().pKeyChordTransPos[11]}',
    //       //'${context.watch<TranspositionProvider>().setMeterKey(nDan)}',
    //       '${strMeterKey}개',
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold, color: Colors.black,
    //           fontSize: orientation == Orientation.portrait
    //               ? size.width * 0.025
    //               : size.height * 0.025,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...4
  }

  ///세로 모드 단 조표 정보
  Widget _portraitDisplayKeynote(BuildContext context, String strMeterKey, Size size, int nDan){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///조표 정보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_2.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          (widget.httpCommunicate!.nScoreType == 7 && nDan == 2)
              ? '드럼악보'
              : strMeterKey.length == 1 ? '$strMeterKey' : '${strMeterKey[0]}\t(${strMeterKey[1]})개',

          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 단 조표 정보
  Widget _landscapeDisplayKeynote(BuildContext context, String strMeterKey, Size size, int nDan){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
        height: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///조표 정보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_2.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          (widget.httpCommunicate!.nScoreType == 7 && nDan == 2)
              ? '드럼악보'
              : strMeterKey.length == 1 ? '$strMeterKey' : '${strMeterKey[0]}\t(${strMeterKey[1]})개',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================
  ///악보 단별 정보
  Widget _displayScoreInfo(BuildContext context, Orientation orientation, int nDan, Size size) {
    return Container(
      // width: orientation == Orientation.portrait ? size.width : size.height,
      height: orientation == Orientation.portrait
          ? size.height * 0.05
          : size.width * 0.05,
      child: Row(
        children: <Widget>[
          //단 텍스트
          _displayDanText(orientation, nDan, size),

          //단 악보 정보
          _displayInfo(context, orientation, nDan, size),

          //단 조표 정보
          _displayKeynote(context, orientation, nDan, size),
        ],
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///전간주 텍스트
  Widget _displayJeonkanjooText(Orientation orientation, Size size) {
    ///SJW Modify 2022.06.29 Start...5 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayJeonkanjooText(size)
        : _landscapeDisplayJeonkanjooText(size);
    // return Expanded(
    //   flex: 1,
    //   child: Container(
    //     width: orientation == Orientation.portrait
    //         ? size.width
    //         : size.height,
    //     height: orientation == Orientation.portrait
    //         ? size.height * 0.05
    //         : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black, width: 2.0),
    //     ),
    //     child: Text(
    //       '전간주',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.025
    //             : size.height * 0.025,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...5
  }

  ///세로 모드 전간주 텍스트
  Widget _portraitDisplayJeonkanjooText(Size size){
    return Expanded(
      flex: 1,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///전간주 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '전간주',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 전간주 텍스트
  Widget _landscapeDisplayJeonkanjooText(Size size){
    return Expanded(
      flex: 1,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
        height: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///전긴주 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '전간주',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///전간주 유무 텍스트
  Widget _displayJeonkanjooInfo(Orientation orientation, Size size) {
    ///SJW Modify 2022.07.05 Start...1  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayJeonkanjooInfo(size)
        : _landscapeDisplayJeonkanjooInfo(size);
    // return Expanded(
    //   flex: 2,
    //   child: Container(
    //     width: orientation == Orientation.portrait
    //         ? size.width
    //         : size.height,
    //     height: orientation == Orientation.portrait
    //         ? size.height * 0.05
    //         : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black, width: 2.0),
    //     ),
    //     child: widget.httpCommunicate!.nViewJeonKanjoo == 0
    //         ? Text(
    //       '전간주 표시함',
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           color: Colors.black,
    //           fontSize: orientation == Orientation.portrait
    //               ? size.width * 0.025
    //               : size.height * 0.025,
    //       ),
    //     )
    //         : Text(
    //       '전간주 표시안함',
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           color: Colors.black,
    //           fontSize: orientation == Orientation.portrait
    //               ? size.width * 0.025
    //               : size.height * 0.025,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.07.05 End..1
  }

  ///세로모드 전간주 유무 텍스트
  Widget _portraitDisplayJeonkanjooInfo(Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///전간주 유무 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_1.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0)
        // ),
        ///SJW Modify 2022.07.15 End...
        child: widget.httpCommunicate!.nViewJeonKanjoo == 0 ?
            Text(
              '   표시안함',
              style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: size.width * 0.025,
                fontWeight: FontWeight.bold,
              ),
            )
            : Text(
              '   표시함',
              style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: size.width * 0.025,
              fontWeight: FontWeight.bold,
            ),
        ),
      ),
    );
  }

  ///가로모드 전간주 유무 텍스트
  Widget _landscapeDisplayJeonkanjooInfo(Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
        height: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///전간주 유무 텍스트 -> 이미지 변환
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_1.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 2.0),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: widget.httpCommunicate!.nViewJeonKanjoo == 0 ?
            Text(
              '   표시안함',
              style: GoogleFonts.lato(
                color: Colors.black,
                fontSize: size.height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            )
            : Text(
                '   표시함',
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.bold,
                ),
        ),
      ),
    );
  }

//==============================================================================

  ///전간주 유무
  Widget _displayJeonkanjoo(Orientation orientation, Size size) {
    return Expanded(
      flex: 1,
      child: Container(
        // width: size.width,
        height: size.height * 0.05,
        child: Row(
          children: <Widget>[
            //전간주 텍스트
            _displayJeonkanjooText(orientation, size),

            //전간주 유무 텍스트
            _displayJeonkanjooInfo(orientation, size),
          ],
        ),
      ),
    );
  }


//==============================================================================

  ///안내문구
  Widget _displayGuidLine(Orientation orientation, Size size) {
    ///SJW Modify 2022.07.05 Start...4
    return orientation == Orientation.portrait
        ? _portraitDisplayGuidLine(size)
        : _landscapeDisplayGuidLine(size);
    // return Expanded(
    //   flex: 2,
    //   child: Container(
    //     width: orientation == Orientation.portrait
    //         ? size.width
    //         : size.height,
    //     height: orientation == Orientation.portrait
    //         ? size.height
    //         : size.width,
    //     alignment: Alignment.center,
    //     child: Text(
    //       '선택하신 내용을 확인해 주세요.\n저장 후에는 이조가 불가능 합니다.\n저장하시겠습니까?',
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           color: Colors.black,
    //           fontSize: orientation == Orientation.portrait
    //               ? size.width * 0.025
    //               : size.height * 0.025,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.07.05 End...4
  }

  ///세로 모드 안내문구
  Widget _portraitDisplayGuidLine(Size size){
    String str = '';

    if(widget.httpCommunicate!.nScoreType == 40 || widget.httpCommunicate!.nScoreType == 41 || widget.httpCommunicate!.nScoreType == 42
        || widget.httpCommunicate!.nScoreType == 43 || widget.httpCommunicate!.nScoreType == 44)
    {
      str = '선택하신 내용을 확인해 주세요.\n저장하시겠습니까?';
    }
    else
    {
      str = '선택하신 내용을 확인해 주세요.\n저장 후에는 이조가 불가능 합니다.\n저장하시겠습니까?';
    }

    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height : size.height,
        alignment: Alignment.center,
        child: Text(
          str,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: size.width * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ///가로 모드 안내문구
  Widget _landscapeDisplayGuidLine(Size size){
    String str = '';

    if(widget.httpCommunicate!.nScoreType == 40 || widget.httpCommunicate!.nScoreType == 41 || widget.httpCommunicate!.nScoreType == 42
      || widget.httpCommunicate!.nScoreType == 43 || widget.httpCommunicate!.nScoreType == 44)
      {
        str = '선택하신 내용을 확인해 주세요.\n저장하시겠습니까?';
      }
    else
      {
        str = '선택하신 내용을 확인해 주세요.\n저장 후에는 이조가 불가능 합니다.\n저장하시겠습니까?';
      }

    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
        height: Platform.isAndroid ? size.width : size.width,
        alignment: Alignment.center,
        child: Text(
          str,
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: size.height * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

//==============================================================================

  ///Content
  Widget _displayContent(BuildContext context, HttpCommunicate httpCommunicate, Orientation orientation, Size size) {
    //단 수
    int nDan = context.read<DanSettingsProvider>().nDan;

    return Container(
      width: orientation == Orientation.portrait
          ? size.width * 0.50
          : size.height * 0.50,
      height: orientation == Orientation.portrait
          ? (size.height * 0.1 * (nDan == 0 ? 1 : nDan)) + (size.height * 0.1)
          : (size.width * 0.1 * (nDan == 0 ? 1 : nDan)) + (size.width * 0.1),
      child: Column(
        children: <Widget>[
          //단 별 악보 정보
          for (int nDanIndex = 0; nDanIndex < nDan; nDanIndex++)
            _displayScoreInfo(context, orientation, nDanIndex+1, size),

          //공백
          SizedBox(
            height: orientation == Orientation.portrait
                ? size.height * 0.01
                : size.width * 0.01,
          ),

          //전간주 정보
          // if(httpCommunicate.nScoreType == 0 || httpCommunicate.nScoreType == 5 ||
          //     httpCommunicate.nScoreType == 6 || httpCommunicate.nScoreType == 7 ||
          //     httpCommunicate.nScoreType == 8)
          _displayJeonkanjoo(orientation, size),

          //안내문구
          _displayGuidLine(orientation, size),
        ],
      ),
    );
  }

//==============================================================================

  ///확인 버튼
  Widget _displayOkButton(BuildContext context, Orientation orientation, Size size) {
    ///SJW Modify 2022.07.05 Start...2 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayOkButton(context, size)
        : _landscapeDisplayOkButton(context, size);
    // return Expanded(
    //   flex: 1,
    //   ///SJW Modify 2022-06-03 Start...1
    //   ///GUI 적용
    //   // child: Container(
    //   //   width: orientation == Orientation.portrait
    //   //       ? size.width * 0.2
    //   //       : size.width * 0.1,
    //   //   height: size.height * 0.05,
    //   //   alignment: Alignment.center,
    //   //   child: TextButton(
    //   //     onPressed: (){
    //   //       httpCommunicate!.purchase(context, httpCommunicate!);
    //   //       //Navigator.of(context).pop();
    //   //     },
    //   //     child: Text(
    //   //       '확인',
    //   //       style: TextStyle(
    //   //         fontWeight: FontWeight.bold,
    //   //         color: Colors.blue,
    //   //         fontSize: 18,
    //   //       ),
    //   //     ),
    //   //   ),
    //   // ),
    //   child: GestureDetector(
    //     onTap: (){
    //       widget.httpCommunicate!.purchase(context, widget.httpCommunicate!);
    //       //Navigator.of(context).pop();
    //     },
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
    //   ///SJW Modify 2022-06-03 End...1
    //
    // );
    ///SJW Modify 2022.07.05 End...2
  }

  ///세로 모드 확인 버튼
  Widget _portraitDisplayOkButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
      child: GestureDetector(
        onTap: () => widget.httpCommunicate!.purchase(context, widget.httpCommunicate!),
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
      //     onPressed: () => widget.httpCommunicate!.purchase(context, widget.httpCommunicate!),
      //     child: Text(
      //       '확인',
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


  ///가로 모드 확인 버튼
  Widget _landscapeDisplayOkButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
          child :GestureDetector(
            onTap: () => widget.httpCommunicate!.purchase(context, widget.httpCommunicate!),
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
          //     onPressed: () => widget.httpCommunicate!.purchase(context, widget.httpCommunicate!),
          //     child: Text(
          //       '확인',
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

//==============================================================================

  ///취소 버튼
  Widget _displayCancelButton(BuildContext context, Orientation orientation, Size size) {
    ///SJW Modify 2022.07.05 Start...3  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayCancelButton(context, size)
        : _landscapeDisplayCancelButton(context, size);
    // return Expanded(
    //   flex: 1,
    //   ///SJW Modify 2022-06-03 Start...2
    //   ///GUI 적용
    //   // child: Container(
    //   //   width: orientation == Orientation.portrait
    //   //       ? size.width * 0.2
    //   //       : size.width * 0.1,
    //   //   height: size.height * 0.05,
    //   //   alignment: Alignment.center,
    //   //   child: TextButton(
    //   //     onPressed: () => Navigator.of(context).pop(),
    //   //     child: Text(
    //   //       '취소',
    //   //       style: TextStyle(
    //   //         fontWeight: FontWeight.bold,
    //   //         color: Colors.red,
    //   //         fontSize: 18,
    //   //       ),
    //   //     ),
    //   //   ),
    //   // ),
    //   child: GestureDetector(
    //     onTap: () => Navigator.of(context).pop(),
    //     child: Container(
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.05
    //           : size.width * 0.05,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           fit: BoxFit.fill,
    //           image: AssetImage('assets/images/buttons/cancel_button2.png'),
    //         ),
    //       ),
    //     ),
    //   ),
    //   ///SJW Modify 2022-06-03 End...2
    // );
    ///SJW Modify 2022.07.05 End...3
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
          ///SJW Modify 2022.07.15 Start... ///IOS 텍스트 버튼 -> 이미지 버튼으러 변경
          // SizedBox(
          //   height: size.height * 0.05,
          //   child: TextButton(
          //     onPressed: () => Navigator.pop(context),
          //     child: Text(
          //       '취소',
          //       textAlign: TextAlign.center,
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

  ///가로 모드 취소 버튼
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

  ///Action
  Widget _displayAction(
      BuildContext context, Orientation orientation, Size size) {
    return Row(
      children: <Widget>[
        //확인
        _displayOkButton(context, orientation, size),

        SizedBox(width: size.width * 0.01,),

        //취소
        _displayCancelButton(context, orientation, size),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TabletShoppingDialog oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Platform.isAndroid
            ? AlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(context, widget.httpCommunicate!, orientation, _size),
          actions: <Widget>[_displayAction(context, orientation, _size)],
        )
            : CupertinoAlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(context, widget.httpCommunicate!, orientation, _size),
          actions: <Widget>[_displayAction(context, orientation, _size)],
        );
      },
    );
  }
}
