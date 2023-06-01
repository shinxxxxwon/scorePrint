
import 'package:elfscoreprint_mobile/src/providers/transposition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../models/http/http_communicate.dart';
import '../../../providers/dan_settings_provider.dart';

class PhoneShoppingDialog extends StatefulWidget {
  HttpCommunicate? httpCommunicate;

  PhoneShoppingDialog({this.httpCommunicate});

  @override
  _PhoneShoppingDialogState createState() => _PhoneShoppingDialogState();
}

class _PhoneShoppingDialogState extends State<PhoneShoppingDialog> {

  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);

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
  void didUpdateWidget(covariant PhoneShoppingDialog oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    // WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

//==============================================================================

  ///다이얼로그 Title
  Widget _displayTitle(Orientation orientation, Size size){
    ///SJW Modify 2022.06.27 Start...1 ///세로 & 가로 모드 따로 함수로 구현
    return orientation == Orientation.portrait
      ? _portraitDisplayTitle(size)
      : _landscapeDisplayTitle(size);
    ///SJW MOdify 2022.04.21 Start...1 아이콘 변경 및 구분선 추가
    // return Row(
    //   children: <Widget>[
    //     //카트 아이콘
    //     Icon(Icons.shopping_cart, color: Colors.black,),
    //
    //     //공백
    //     SizedBox(width: size.width * 0.03),
    //
    //     //장바구니 텍스트
    //     Text('저장'),
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
        //     Icon(Icons.save, color: Colors.black),
        //
        //     Text('저장', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
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
    //           image: AssetImage('assets/images/shopping_text.png'),
    //         ),
    //       ),
    //     ),
    //
    //     Container(
    //       height: orientation == Orientation.portrait
    //           ? size.height * 0.02
    //           : size.height * 0.02,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage('assets/images/divider.png'),
    //         ),
    //       ),
    //     ),
        ///SJW Modify 2022-06-03 End...1
    //   ],
    // );
    ///SJW Modify 2022.06.27 End...1
  }

  ///세로 모드 타이틀
  Widget _portraitDisplayTitle(Size size){
    return Column(
      children: <Widget>[
        // Platform.isAndroid ?
        Container(
          width: size.width * 0.5,
          height: size.height * 0.02,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/shopping_text.png'),
            ),
          ),
        ),
        ///SJW Modify 2022.07.15 Start...  ///IOS 다이얼로그 title 이미지로 교체
        // : Container(
        //   width: size.width,
        //   height: size.height * 0.04,
        //   alignment: Alignment.center,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Icon(Icons.shopping_cart, color: Colors.black, size: size.width * 0.08),
        //       Text('장바구니', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.05, fontWeight: FontWeight.bold)),)
        //     ],
        //   ),
        // ),
        ///SJW Modify 2022.07.15 End...

        Container(
          height: Platform.isAndroid ? size.width * 0.02 : size.height * 0.02,
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
          width: size.height * 0.5,
          height: size.width * 0.02,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/shopping_text.png'),
            ),
          ),
        ),
        ///SJW Modify 2022.07.15 Start... ///IOS 다이얼로그 title 이미지로 교체
        // : Container(
        //   width: size.height,
        //   height: size.width * 0.04,
        //   alignment: Alignment.center,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Icon(Icons.shopping_cart, color: Colors.black, size: size.height * 0.08,),
        //       Text('장바구니', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.05, fontWeight: FontWeight.bold))),
        //     ],
        //   ),
        // ),
        ///SJW Modify 2022.07.15 End...

        Container(
          height: Platform.isAndroid ? size.width * 0.02 : size.height * 0.02,
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

  ///단 텍스트
  Widget _displayDanText(Orientation orientation, int nDan, Size size){
    ///SJW Modify 2022.06.27 Start...2 ///세로 & 가로 모드 따로 함수로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayDanText(nDan, size)
        : _landscapeDisplayDantext(nDan, size);
    // return Expanded(
    //   flex: 1,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.height,
    //     height: orientation == Orientation.portrait ? size.height : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black),
    //     ),
    //     child: Text(
    //       '$nDan보',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.035
    //             : size.height * 0.035,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.27 End...2
  }

  ///세로 모드 단 텍스트
  Widget _portraitDisplayDanText(int nDan, Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height : size.height,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///n보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '$nDan보',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 단 텍스트
  Widget _landscapeDisplayDantext(int nDan, Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
        height: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///n보 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/bo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '$nDan보',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.height * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
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

  ///악보 정보
  Widget _displayInfo(BuildContext context, Orientation orientation, int nDan, Size size){
    ///SJW Modify 2022.06.27 Start...3 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayInfo(context, nDan, size)
        : _landscapeDisplayInfo(context, nDan, size);
    // return Expanded(
    //   flex: 2,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.height,
    //     height: orientation == Orientation.portrait ? size.height * 0.05 : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black),
    //     ),
    //     child: Text(
    //       //widget.httpCommunicate!.strMainKey!,
    //       getKeyInfo(context, nDan),
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.red,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.035
    //             : size.height * 0.035,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.27 End...3
  }

  ///세로 모드 악보 정보(키정보)
  Widget _portraitDisplayInfo(BuildContext context, int nDan, Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
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
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          //widget.httpCommunicate!.strMainKey!,
            (widget.httpCommunicate!.nScoreType == 7 && nDan == 2) ? "" : getKeyInfo(context, nDan),
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 악보 정보(키정보)
  Widget _landscapeDisplayInfo(BuildContext context, int nDan, Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
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
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          //widget.httpCommunicate!.strMainKey!,
          (widget.httpCommunicate!.nScoreType == 7 && nDan == 2) ? "" : getKeyInfo(context, nDan),
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: size.height * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
//==============================================================================

//==============================================================================

  ///조표 정보
  Widget _displayKeynote(BuildContext context, Orientation orientation, int nDan, Size size){

    String strMeterKey = context.watch<TranspositionProvider>().setMeterKey(nDan);
    ///SJW Modify 2022.06.27 Start...4 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayKeynote(context, strMeterKey, size, nDan)
        : _landscapeDisplayKeynote(context, strMeterKey, size , nDan);
    // return Expanded(
    //   flex: 2,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.height,
    //     height: orientation == Orientation.portrait ? size.height * 0.05 : size.width * 0.05,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black),
    //     ),
    //     child: Text(
    //       //'b ( 5개 )',
    //       //'${context.watch<TranspositionProvider>().setMeterKey(nDan)}',
    //       strMeterKey.length == 1 ? '$strMeterKey' : '${strMeterKey[0]}\t${strMeterKey[1]}',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.red,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.035
    //             : size.height * 0.035,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.27 End...4
  }

  ///세로 모드 조표 정보
  Widget _portraitDisplayKeynote(BuildContext context, String strMeterKey, Size size, int nDan) {
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
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          (widget.httpCommunicate!.nScoreType == 7 && nDan == 2)
              ? '드럼악보'
              : strMeterKey.length == 1 ? '$strMeterKey' : '${strMeterKey[0]}\t(${strMeterKey[1]})개',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

    ///가로 모드 조표 정보
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
          //   border: Border.all(color: Colors.black),
          // ),
          ///SJW Modify 2022.07.15
          child: Text(
            //'b ( 5개 )',
            //'${context.watch<TranspositionProvider>().setMeterKey(nDan)}',
            (widget.httpCommunicate!.nScoreType == 7 && nDan == 2)
                ? '드럼악보'
                : strMeterKey.length == 1 ? '$strMeterKey' : '${strMeterKey[0]}\t(${strMeterKey[1]})개',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.red,
                fontSize: size.height * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

//==============================================================================

  ///악보 단별 정보
  Widget _displayScoreInfo(BuildContext context, Orientation orientation, int nDan, Size size){
    print('nDan : $nDan');
    return Container(
      width: orientation == Orientation.portrait ? size.width : size.height,
      height: orientation == Orientation.portrait ? size.height * 0.05 : size.width * 0.05,
      child: Row(
        children: <Widget>[
          //단 텍스트
          _displayDanText(orientation, nDan, size),

          //단 악보 정보
          _displayInfo(context, orientation, nDan, size),

          //단 조표정보
          _displayKeynote(context, orientation, nDan, size),
        ],
      ),
    );
  }

//==============================================================================

  ///전간주 텍스트
  Widget _displayJeonKanjooText(Orientation orientation, Size size){
    ///SJW Modify 2022.06.27 Start...5  ///세로 & 가로 모두 함수로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayJeonKanjooText(size)
        : _landscapeDisplayJeonKanjooText(size);
    // return Expanded(
    //   flex: 1,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.height,
    //     height: orientation == Orientation.portrait ? size.height : size.height * 0.08,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black),
    //     ),
    //     child: Text(
    //       '전간주',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.035
    //             : size.height * 0.035,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.27 End...5  ///세로 & 가로 모두 함수로 구현
  }

  ///세로 모드 전간주 텍스트
  Widget _portraitDisplayJeonKanjooText(Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height : size.height,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///전간주 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '전간주',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 전간주 텍스트
  Widget _landscapeDisplayJeonKanjooText(Size size){
    return Expanded(
      flex: 2,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
        height: Platform.isAndroid ? size.height * 0.08 : size.height * 0.08,
        alignment: Alignment.center,
        ///SJW Modify 2022.07.15 Start... ///전간주 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_0.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: Text(
          '전간주',
          style: GoogleFonts.lato(
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

  ///전간주 유무 텍스트
  Widget _displayJeonKanjooInfo(Orientation orientation, Size size){
    ///SJW Modify 2022.06.27 Start...6  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayJeonKanjooInfo(size)
        : _landscapeDisplayJeonKanjooInfo(size);
    // return Expanded(
    //   flex: 3,
    //   child: Container(
    //     width: orientation == Orientation.portrait ? size.width : size.height,
    //     height: orientation == Orientation.portrait ? size.height : size.height * 0.08,
    //     alignment: Alignment.centerLeft,
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black),
    //     ),
    //     child: widget.httpCommunicate!.nViewJeonKanjoo == 0
    //         ? Text(
    //       '   표시안함',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.035
    //             : size.height * 0.035,
    //       ),
    //     )
    //         : Text(
    //       '   표시함',
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //         fontSize: orientation == Orientation.portrait
    //             ? size.width * 0.035
    //             : size.height * 0.035,
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.27 End...6
  }

  ///세로 모드 전간주 유무 텍스트
  Widget _portraitDisplayJeonKanjooInfo(Size size){
    return Expanded(
      flex: 4,
      child: Container(
        // width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height : size.height,
        alignment: Alignment.centerLeft,
        ///SJW Modify 2022.07.15 Start... ///전간주 유무 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_1.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: widget.httpCommunicate!.nViewJeonKanjoo == 0
            ? Text(
          '   표시안함',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : Text(
          '   표시함',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 전간주 유무 텍스트
  Widget _landscapeDisplayJeonKanjooInfo(Size size){
    return Expanded(
      flex: 4,
      child: Container(
        // width: Platform.isAndroid ? size.height : size.height,
        height: Platform.isAndroid ? size.height * 0.08 : size.height * 0.08,
        alignment: Alignment.centerLeft,
        ///SJW Modify 2022.07.15 Start... ///전간주 유무 텍스트 -> 이미지로 변경
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/jeonkanjoo_1.png'),
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        // ),
        ///SJW Modify 2022.07.15 End...
        child: widget.httpCommunicate!.nViewJeonKanjoo == 0
            ? Text(
          '   표시안함',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize:size.height * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : Text(
          '   표시함',
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: size.height * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================

  ///전간주 정보
  Widget _displayJeonKanjoo(Orientation orientation, Size size){
    return Container(
      // width: orientation == Orientation.portrait ? size.width : size.height,
      height: orientation == Orientation.portrait ? size.height * 0.05 : size.width * 0.05,
      child: Row(
        children: <Widget>[

          //전간주 텍스트
          _displayJeonKanjooText(orientation, size),

          //전간주 유무 텍스트
          _displayJeonKanjooInfo(orientation, size),

        ],
      ),
    );
  }

//==============================================================================

  ///안내문구 텍스트
  Widget _displayGuideLine(Orientation orientation, Size size){
    ///SJW Modify 2022.06.27 Start...7  ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayGuidLine(size)
        : _landscapeDisplayGuidLine(size);
    // return  Container(
    //   width: orientation == Orientation.portrait ? size.width : size.height,
    //   height: orientation == Orientation.portrait ? size.height * 0.1 : size.height * 0.15,
    //   //alignment: Alignment.center,
    //   child:  Text(
    //     '선택하신 내용을 확인해 주세요.\n저장 후에는 이조가 불가능합니다.\n진행하시겠습니까?',
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontWeight: FontWeight.bold,
    //       color: Colors.black,
    //       fontSize: orientation == Orientation.portrait ? size.width * 0.035: size.height * 0.035,
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.27 End...7
  }

  ///세로 모드 안내문구 텍스트
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

    return  Container(
      // width: Platform.isAndroid ? size.width : size.width,
      height: Platform.isAndroid ? size.height * 0.1 : size.height * 0.1,
      alignment: Alignment.center,
      child:  Text(
        str,
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

  ///가로 모드 안내문구 텍스트
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

    return  Container(
      // width: Platform.isAndroid ? size.height : size.height,
      height: Platform.isAndroid ? size.height * 0.15 : size.height * 0.15,
      alignment: Alignment.center,
      child:  Text(
        str,
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

  ///다이얼로그 콘텐트( 악보정보 & 전간주 표시 & 안내문구 )
  Widget _displayContent(BuildContext context, HttpCommunicate httpCommunicate, Orientation orientation, Size size, int nDan){
    return Container(
      width: orientation == Orientation.portrait ?  size.width * 0.5 : size.height * 0.5,
      height: orientation == Orientation.portrait ? (size.height * 0.11 * (nDan == 0 ? 1 : nDan)) + (size.height * 0.1) : (size.width * 0.05 * (nDan == 0 ? 1 : nDan)) + (size.width * 0.1),
      // alignment: Alignment.center,
        child: orientation == Orientation.portrait ?
            Column(
              children: <Widget>[
                //악보 단별 정보
                for(int nDanIndex=0; nDanIndex<nDan; nDanIndex++)
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
                      _displayJeonKanjoo(orientation, size),

                //안내문구
                _displayGuideLine(orientation, size),

              ],
            ) :
            ListView(
              children: <Widget>[

                //악보 단별 정보
                for(int nDanIndex=0; nDanIndex<nDan; nDanIndex++)
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
                _displayJeonKanjoo(orientation, size),

                //안내문구
                _displayGuideLine(orientation, size),

              ],
        ),
      // ),
    );
  }

//==============================================================================

  ///장바구니 이동 버튼
  Widget _goToCartButton(BuildContext context, Orientation orientation, Size size){
    ///SJW Modify 2022.06.27 Start...9  ///세로 & 가로 모드 함수 따로 구현
    return orientation == Orientation.portrait
        ? _portraitGoToCartButton(context, size)
        : _landscapeGoToCartButton(context, size);
    // return Expanded(
    //   flex: 1,
    //   ///SJW Modify 2022-06-03 Start...2
    //   ///GUI 적용
    //   // child: Container(
    //   //   height: orientation == Orientation.portrait ? size.height * 0.06 : size.height * 0.1,
    //   // child: TextButton(
    //   //   onPressed: (){
    //   //     httpCommunicate!.purchase(context, httpCommunicate!);
    //   //     Navigator.pop(context);
    //   //   },
    //   //   child: Text(
    //   //     '저장',
    //   //     style: TextStyle(
    //   //         fontWeight: FontWeight.bold,
    //   //         color: Colors.blue,
    //   //     ),
    //   //   ),
    //   // ),
    //
    //   // ),
    //   child: GestureDetector(
    //     onTap: (){
    //       widget.httpCommunicate!.purchase(context, widget.httpCommunicate!);
    //       Navigator.pop(context);
    //     },
    //     child: Container(
    //       height: orientation == Orientation.portrait ? size.height * 0.06 : size.width * 0.06,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage('assets/images/buttons/ok_button.png'),
    //         ),
    //       ),
    //     ),
    //   ),
      ///SJW Modify 2022-06-03 End...2
    // );
    ///SJW Modify 2022.06.27 End...9
  }

  ///세로 모드 장바구니 이동 버튼
  Widget _portraitGoToCartButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
      child: GestureDetector(
        onTap: (){
          widget.httpCommunicate!.purchase(context, widget.httpCommunicate!);
          Navigator.pop(context);
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
      ///SJW Modify 2022.07.15 Start... ///IOS 확인 버튼 이미지로 변경
      // : Container(
      //   height: size.height * 0.06,
      //   decoration: BoxDecoration(
      //     border: Border(
      //       right: BorderSide(
      //         color: Colors.grey,
      //         width: 1.0,
      //       ),
      //     ),
      //   ),
      //   child: TextButton(
      //     onPressed: (){
      //       widget.httpCommunicate!.purchase(context, widget.httpCommunicate!);
      //       Navigator.pop(context);
      //     },
      //     child: Text(
      //       '확인',
      //       textAlign: TextAlign.center,
      //       style: GoogleFonts.lato(
      //         color: Colors.blue,
      //         fontSize: size.width * 0.035,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      // ),
      ///SJW Modify 2022.07.15 End...
    );
  }

  ///가로 모드 장바구니 이동 버튼
  Widget _landscapeGoToCartButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
      child: GestureDetector(
        onTap: (){
          widget.httpCommunicate!.purchase(context, widget.httpCommunicate!);
          Navigator.pop(context);
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
      ///SJW Modify 2022.07.15 Start... ///IOS 확인 버튼 이미지로 교체
      // : Container(
      //   height: size.width * 0.06,
      //   decoration: BoxDecoration(
      //     border: Border(
      //       right: BorderSide(
      //         color: Colors.grey,
      //         width: 1.0,
      //       ),
      //     ),
      //   ),
      //   child: TextButton(
      //     onPressed: (){
      //       widget.httpCommunicate!.purchase(context, widget.httpCommunicate!);
      //       Navigator.pop(context);
      //     },
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
      // ),
      ///SJW Modify 2022.07.15 End...
    );
  }

//==============================================================================

//==============================================================================

  ///취소버튼
  Widget _cancelButton(BuildContext context, Orientation orientation, Size size){
    ///SJW Modify 2022.06.27 Start...10 ///세로 & 가로 모드 따로 함수로 구현
    return orientation == Orientation.portrait
        ? _portraitCancelButton(context, size)
        : _landscapeCancelButton(context, size);
    // return Expanded(
    //   flex: 1,
      ///SJW Modify 2022-06-03 Start...3
    //   ///GUI 적용
    //   // child: Container(
    //   //   height: orientation == Orientation.portrait ? size.height * 0.06 : size.height * 0.1,
    //   //   child: TextButton(
    //   //     onPressed: (){
    //   //       Navigator.pop(context);
    //   //     },
    //   //     child: Text(
    //   //       '취소',
    //   //       style: TextStyle(
    //   //         fontWeight: FontWeight.bold,
    //   //         color: Colors.red,
    //   //       ),
    //   //     ),
    //   //   ),
    //   // ),
    //   child: GestureDetector(
    //     onTap: () {
    //       Navigator.pop(context);
    //     },
    //     child: Container(
    //       height: orientation == Orientation.portrait ? size.height * 0.06 : size.width * 0.06,
    //       alignment: Alignment.center,
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage('assets/images/buttons/cancel_button2.png'),
    //         ),
    //       ),
    //     ),
    //   ),
      ///SJW Modify 2022-06-03 End...3
    // );
    ///SJW Modify 2022.06.27 End...10
  }

  ///세로 모드 취소 버튼
  Widget _portraitCancelButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
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
      ///SJW Modify 2022.07.15 Start... ///IOS 취소 버튼 이미지로 교체
      // : Container(
      //   height: size.height * 0.06,
      //   child: TextButton(
      //     onPressed:(){
      //       Navigator.pop(context);
      //     },
      //     child: Text(
      //       '취소',
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
      ///SJW Modify 2022.07.15 End...
    );
  }

  ///가로 모드 취소 버튼
  Widget _landscapeCancelButton(BuildContext context, Size size){
    return Expanded(
      flex: 1,
      // child: Platform.isAndroid ?
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
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
      ///SJW Modify 2022.07.15 Start... ///IOS 취소 버튼 이미지로 교체
      // : Container(
      //   height: size.width * 0.06,
      //   child: TextButton(
      //     onPressed: (){
      //       Navigator.pop(context);
      //     },
      //     child: Text(
      //       '취소',
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

  ///액션 버튼
  Widget _displayAction(BuildContext context, Orientation orientation, Size size){
    return Row(
      children: <Widget>[
        //장바구니 이동 버튼
        _goToCartButton(context, orientation, size),

        // Platform.isAndroid ?
        SizedBox(
          width: orientation == Orientation.portrait
              ? size.width * 0.01
              : size.height * 0.01,
        ),
        // SizedBox(),

        //취소버튼
        _cancelButton(context, orientation, size),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    //악보 단 개수
    int nDan = context.read<DanSettingsProvider>().nDan;
    print('nDan : $nDan');

    return OrientationBuilder(
      builder: (context, orientation) {
        return Platform.isAndroid
            ? AlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(context, widget.httpCommunicate!, orientation, _size, nDan),
          actions: <Widget>[
            _displayAction(context, orientation, _size),
          ],
        )
            : CupertinoAlertDialog(
          title: _displayTitle(orientation, _size),
          content: _displayContent(context, widget.httpCommunicate!, orientation, _size, nDan),
          actions: <Widget>[
            _displayAction(context, orientation, _size),
          ],
        );
      },
    );
  }
}
