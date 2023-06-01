
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/screens/phone/menual/phone_user_manual_screen.dart';
import 'package:elfscoreprint_mobile/src/screens/phone/phone_pdf_page_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../models/http/http_communicate.dart';
import '../../providers/score_image_provider.dart';
import 'buttons/phone_cancel_button.dart';
import 'buttons/phone_print_button.dart';
import 'buttons/phone_settings_button.dart';
import 'buttons/phone_shopping_button.dart';
import 'score/phone_score_preview_screen.dart';

import 'dart:convert';

class PhoneMainScreen extends StatefulWidget {
  // final Orientation? orientation;
  HttpCommunicate? httpCommunicate;

  PhoneMainScreen({Key? key,/* this.orientation,*/ this.httpCommunicate}) : super(key: key);

  @override
  State<PhoneMainScreen> createState() => _PhoneMainScreenState();
}

class _PhoneMainScreenState extends State<PhoneMainScreen> {
  Widget _displayPhoneMainScreen(BuildContext context, Size size, Uint8List uintData){

    return OrientationBuilder(
      builder: (context, orientation) {
        // print('orientation : $orientation');
        return Stack(
          children: <Widget>[

            //Title
            ///SJW Modify 2023.05.18 Start...
            ///뷰어로 바뀌어서 미리보기/인쇄 타이틀 주석
            // _appTitle(orientation, size),
            ///SJW Moidfy 2023.05.18 End...

            //도움말
            ///SJW Modify 2023.05.18 Start...
            ///뷰어로 바뀌어서 도움말 주석
            _displayUserManual(context, orientation, size),
            ///SJW Modify 2023.05.18 End...

            //악보 미리보기
            KeyedSubtree(key: ValueKey(context.read<PDFProvider>().nKeyValue), child: PhoneScorePreviewScreen(orientation: orientation, httpCommunicate: widget.httpCommunicate!, uintData: uintData)),

            //악보 페이지 수
            // widget.httpCommunicate!.bIsPreViewScore == false ?
            // PhonePdfPageIndex(httpCommunicate: widget.httpCommunicate!, orientation: orientation) : SizedBox(),

            //구매 시 악보 금액과 장수 표시
            widget.httpCommunicate!.bIsPreViewScore == true ?
            _displayScorePrice(size, orientation, context) : SizedBox(),

            //구매 or 인쇄 버튼
            // widget.httpCommunicate!.bIsPreViewScore == true ?
            // PhoneShoppingButton(orientation: orientation, httpCommunicate: widget.httpCommunicate!) :
            // PhonePrintButton(orientation: orientation, httpCommunicate: widget.httpCommunicate!),
            //
            //설정 버튼
            PhoneSettingsButton(orientation: orientation, httpCommunicate: widget.httpCommunicate!,),
            //
            // //취소 버튼
            // PhoneCancelButton(orientation: orientation),

          ],
        );
      },
    );
  }
//==============================================================================

//==============================================================================
  ///Title
  _appTitle(Orientation orientation, Size size){
    ///SJW Modify 2022.06.24 Start...1  ///세로 & 가로모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitAppTitle(size)
        : _landscapeAppTitle(size);
    // return Positioned(
    //     top: orientation == Orientation.portrait ?
    //     Platform.isAndroid ?
    //     size.height * 0.03 : size.height * 0.03
    //         :Platform.isAndroid ?
    //     size.height * 0.03 : size.height * 0.03,
    //
    //     left: orientation == Orientation.portrait ?
    //     Platform.isAndroid ?
    //     size.width * 0.05 : size.width * 0.05
    //         :Platform.isAndroid ?
    //     size.width * 0.05 : size.width * 0.05,
    //
    //     child: httpCommunicate!.bIsPreViewScore == true ?
    //     Text('편집하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
    //         : Text('인쇄하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
    // );
    ///SJW Modify 2022.06.24 End...1
  }

  Future<void> printFontData(int nIndex) async{
    // final byteData = await rootBundle.load('assets/fonts/ElfScore.ttf');
    // Uint8List bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    // String baseString = base64.encode(bytes);
    // print('baseString : $bytes');

  }

  ///세로모드 타이틀
  Widget _portraitAppTitle(Size size){

    ///악보 폰트 찍기
    //  IconData fontData = IconData(0x0021, fontFamily: 'ElfScore');
    //  print('FontData.code : ${fontData.codePoint}');

    return Positioned(
        top: Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        child: widget.httpCommunicate!.bIsPreViewScore == true
            ? Text('미리보기', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.05, fontWeight: FontWeight.bold)))
        // ? Icon(fontData)
        // ? Text('${String.fromCharCode(fontData.codePoint)}', style: TextStyle(fontFamily: 'ElfScore', ),)
            : Text('인쇄', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.05, fontWeight: FontWeight.bold)))
    );
  }

  ///가로모드 타이틀
  Widget _landscapeAppTitle(Size size){
    return Positioned(
        top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
        left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        child: widget.httpCommunicate!.bIsPreViewScore == true
            ? Text('미리보기', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.05, fontWeight: FontWeight.bold)))
            : Text('인쇄', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.05, fontWeight: FontWeight.bold)))
    );
  }

//==============================================================================

//==============================================================================
  ///도움말
  Widget _displayUserManual(BuildContext context, Orientation orientation, Size size){
    return orientation == Orientation.portrait
        ? _portraitDisplayUserManual(context, size)
        : _landscapeDisplayUserManual(context, size);
  }

  Widget _portraitDisplayUserManual(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.01,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.01,
      child: Platform.isAndroid ?
      IconButton(
        constraints: BoxConstraints(),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneUserMenualScreen())),
        icon: Icon(Icons.help_outline, size: size.width * 0.08, color: Colors.black),
      ) :
      CupertinoButton(
        onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => PhoneUserMenualScreen())),
        child: Icon(Icons.help_outline, size: size.width * 0.08, color: Colors.black,),
      ),
    );
  }

  Widget _landscapeDisplayUserManual(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.005 : size.height * 0.005,
      left: Platform.isAndroid ? size.width * 0.04 : size.width * 0.02,
      child: Platform.isAndroid ?
      IconButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneUserMenualScreen())),
        icon: Icon(Icons.help_outline, size: size.height * 0.08, color: Colors.black),
      ) :
      CupertinoButton(
        onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => PhoneUserMenualScreen())),
        child: Icon(Icons.help_outline, size: size.height * 0.08, color: Colors.black),
      ),
    );
  }

//==============================================================================

//==============================================================================
  ///악보 가격 표시
  Widget _displayScorePrice(Size size, Orientation orientation, BuildContext context){
    String strPrice =
    widget.httpCommunicate!.nViewJeonKanjoo == 0 ?
    widget.httpCommunicate!.strScorePrice!.split(',').first :
    widget.httpCommunicate!.strScorePrice!.split(',').last ;

    ///SJW Modify 2022.06.24 Start...2  ///세로 & 가로모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitDisplayScorePageNum(context, size)
        : _landscapeDisplayScorePageNum(context, size);
    // return Positioned(
    //   ///SJW Modify 2022.04.21 Start...1  좌표 변경
    //   // top: orientation == Orientation.portrait ?      ///세로모드
    //   // Platform.isAndroid ?
    //   // size.height * 0.75 : size.height * 0.76
    //   //     : Platform.isAndroid ?                    ///가로모드
    //   // size.height * 0.65 : size.height * 0.65,
    //
    //   top: orientation == Orientation.portrait ?    ///세로모드
    //       Platform.isAndroid ?
    //           size.height * 0.80 : size.height * 0.81
    //       :Platform.isAndroid ?
    //           size.height * 0.70 : size.height * 0.70,
    //   ///SJW Modify 2022.04.21 End...1
    //
    //   left: orientation == Orientation.portrait ?     ///세로모드
    //   Platform.isAndroid ?
    //   size.width * 0.05 : size.width * 0.05
    //       : Platform.isAndroid ?                  ///가로모드
    //   size.width * 0.05 : size. width * 0.07,
    //
    //   child: Text(
    //       '총 악보 장수 : ${context.read<ScoreImageProvider>().scoreImageList.length}장',
    //       style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
    //   ),
    // );
    ///SJW Modify 2022.06.24 End...2
  }

  ///세로모드 악보 장수
  Widget _portraitDisplayScorePageNum(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.83 : size.height * 0.82,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: Text(
        '총 악보 장수 : ${widget.httpCommunicate!.nFileDataType != 1 ? context.read<PDFProvider>().scorePageData.length : context.read<PDFProvider>().nTiffTotalNum}장',
        style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.red, fontSize: size.width * 0.05, fontWeight: FontWeight.bold)),
      ),
    );
  }

  ///가로모드 악보 장수
  Widget _landscapeDisplayScorePageNum(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.75 : size.height * 0.75,
      left: Platform.isAndroid ? size.width * 0.05 : size. width * 0.05,
      child: Text(
        '총 악보 장수 : ${widget.httpCommunicate!.nFileDataType != 1 ? context.read<PDFProvider>().scorePageData.length : context.read<PDFProvider>().nTiffTotalNum}장',
        style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.red, fontSize: size.height * 0.05, fontWeight: FontWeight.bold)),
      ),
    );
  }
//==============================================================================

//==============================================================================
  @override
  Widget build(BuildContext context) {

    //print('httpCommunicate : ${httpCommunicate!.nScorePrice}');
    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    Uint8List? uintData;

    uintData = context.watch<PDFProvider>().uinPdfData!;

    return Platform.isAndroid
        ? MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Scaffold(
        body: _displayPhoneMainScreen(context, _size, uintData),
      ),
    )
        : CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: CupertinoPageScaffold(
        child: _displayPhoneMainScreen(context, _size, uintData),
      ),
    );
  }
}
