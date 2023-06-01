

import 'dart:typed_data';
import 'dart:ui';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:elfscoreprint_mobile/src/screens/settings/transposition_and_octave/phone_transposition_octave_setting.dart';
import 'package:elfscoreprint_mobile/src/screens/tablet/score/tablet_pdf_page_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';

import '../../models/http/http_communicate.dart';
import '../../providers/dan_settings_provider.dart';
import '../../providers/print_type_provider.dart';
import '../../providers/score_image_provider.dart';
import 'buttons/tablet_cancel_button.dart';
import 'buttons/tablet_print_button.dart';
import 'buttons/tablet_settings_button.dart';
import 'buttons/tablet_shopping_button.dart';
import 'menuals/tablet_user_menual_screen.dart';
import 'score/tablet_score_preview.dart';


class TabletMainScreen extends StatefulWidget {
  // final Orientation? orientation;
  HttpCommunicate? httpCommunicate;

  TabletMainScreen({Key? key, this.httpCommunicate,/* this.orientation*/}) : super(key: key);

  @override
  State<TabletMainScreen> createState() => _TabletMainScreenState();
}

class _TabletMainScreenState extends State<TabletMainScreen> {

  ///UI
  Widget _displatTabletMainScreen(BuildContext context, Size size, Uint8List uintData){

    List<int> nCurTranspos = [0, 0, 0];

    // print("??: ${context.read<PrintTypeProvider>().bPrintResult}");
    // print("${context.read<ScoreImageProvider>().scoreImageList.length}");
    if(context.read<PrintTypeProvider>().bPrintResult) exit(0);

    // DrawScore drawScore = DrawScore();
    // drawScore.makePDF(context.read<PDFProvider>().pdf);

    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          children: <Widget>[

            //Title 텍스트
            ///SJW Modify 2023.05.18 Start...
            ///뷰어로 바뀌어서 미리보기/인쇄 타이틀 주석
            // _appTitle(orientation, size),
            ///SJW Modify 2023.05.18 End...

            //도움말
            ///SJW Modify 2023.05.18 Start...
            ///뷰어로 바뀌어서 도움말 주석
            _displayUserMenual(context, orientation, size),
            ///SJW Modify 2023.05.18 End...

            //악보표시
            KeyedSubtree(key: ValueKey(context.read<PDFProvider>().nKeyValue),child: TabletScorePreview(orientation: orientation, httpCommunicate: widget.httpCommunicate!, uintData: uintData)),

            //악보 페이징
            // TabletPdfPageIndex(httpCommunicate: widget.httpCommunicate!, orientation: orientation,),

            //장수
            widget.httpCommunicate!.bIsPreViewScore == true ?
            _displayScorePrice(context, orientation, size) : SizedBox(),

            ///SJW Modify 2023.05.22 Start...
            ///뷰어로 바뀌면서 주석
            //구매하기 버튼
            // widget.httpCommunicate!.bIsPreViewScore == true ?
            // TabletShoppingButton(orientation: orientation, httpCommunicate: widget.httpCommunicate!) :
            // TabletPrintButton(orientation: orientation, httpCommunicate: widget.httpCommunicate!),
            ///SJW Modify 2023.05.22 End...

            //설정 버튼
            TabletSettingsButton(orientation: orientation, httpCommunicate: widget.httpCommunicate!, bIsTablet: true),

            ///SJW Modify 2023.05.22 Start...
            ///뷰어로 바뀌면서 주석
            //닫기 버튼
            // TabletCancelButton(orientation: orientation, bIsTablet: true,),
            ///SJW Modify 2023.05.22 End...

          ],
        );
      },
    );
  }

//==============================================================================

  ///도움말
  Widget _displayUserMenual(BuildContext context, Orientation orientation, Size size){
    return orientation == Orientation.portrait
        ? _displayPortraitUserMenual(context, orientation, size)
        : _displayLandscapeUserMenual(context, orientation, size);
  }

  ///세로 모드 도움말
  Widget _displayPortraitUserMenual(BuildContext context, Orientation orientation, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.02 : size.height * 0.02,
      left: Platform.isAndroid ? size.width * 0.04 : size.width * 0.03,
      child: Platform.isAndroid ?
      IconButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TabletUserMenualScreen(orientation: orientation,))),
        icon: Icon(Icons.help_outline, color: Colors.black, size: size.width * 0.06),
      ) :
      CupertinoButton(
        onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => TabletUserMenualScreen(orientation: orientation))),
        child: Icon(Icons.help_outline, color: Colors.black, size: size.width * 0.06),
      ),
    );
  }

  ///가로 모드 도움말
  Widget _displayLandscapeUserMenual(BuildContext context, Orientation orientation, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.02 : size.height * 0.02,
      left: Platform.isAndroid ? size.width * 0.04: size.width * 0.03,
      child: Platform.isAndroid ?
      IconButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TabletUserMenualScreen(orientation: orientation,))),
        icon: Icon(Icons.help_outline, color: Colors.black, size: size.height * 0.06),
      ) :
      CupertinoButton(
        onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => TabletUserMenualScreen(orientation: orientation))),
        child: Icon(Icons.help_outline, color: Colors.black, size: size.height * 0.06),
      ),
    );
  }


//==============================================================================

//==============================================================================

  ///구매 악보 장수 UI
  Widget _displayScorePrice(BuildContext context, Orientation orientation, Size size){
    String strPrice =
    widget.httpCommunicate!.nViewJeonKanjoo == 0 ?
    widget.httpCommunicate!.strScorePrice!.split(',').first :
    widget.httpCommunicate!.strScorePrice!.split(',').last;

    ///SJW Modify 2022.06.28 Start...1 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitScoreTotalPageNum(context, size)
        : _landscapeTotalPageNum(context, size);
    // return Positioned(
    //   ///SJW Modify 2022.04.19 Start...1   좌표 수정
    //   // top: orientation == Orientation.portrait ?
    //   //     Platform.isAndroid ?
    //   //         size.height * 0.75 : size.height * 0.75
    //   //     : Platform.isAndroid ?
    //   //         size.height * 0.65 : size.height * 0.65,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           size.height * 0.80 : size.height * 0.80
    //       : Platform.isAndroid ?
    //           size.height * 0.70 : size.height * 0.70,
    //   ///SJW Modify 2022.04.19 End...1
    //
    //   left: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           size.width * 0.05 : size.width * 0.05
    //       : Platform.isAndroid ?
    //           size.width * 0.05 : size.width * 0.05,
    //
    //   child: Text(
    //     '총 악보 장수 : ${context.watch<ScoreImageProvider>().scoreImageList.length}장',
    //     style: TextStyle(
    //     style: TextStyle(
    //       fontWeight: FontWeight.bold,
    //       color: Colors.red,
    //       fontSize: Platform.isAndroid ? 18 : 24,
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.28 End...1
  }

  ///세로 모드 악보 장수
  Widget _portraitScoreTotalPageNum(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.8,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: Text(
        '총 악보 장수 : ${widget.httpCommunicate!.nFileDataType != 1 ? context.read<PDFProvider>().scorePageData.length : context.read<PDFProvider>().nTiffTotalNum}장',
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Colors.red,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ///가로 모드 악보 장수
  Widget _landscapeTotalPageNum(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.7 : size.height * 0.7,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: Text(
        '총 악보 장수 : ${widget.httpCommunicate!.nFileDataType != 1 ? context.read<PDFProvider>().scorePageData.length : context.read<PDFProvider>().nTiffTotalNum}장',
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            color: Colors.red,
            fontSize: size.height * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================
  ///Title 텍스트
  Widget _appTitle(Orientation orientation, Size size){
    ///SJW Modify 2022.06.28 Start...2 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitAppTitle(size)
        : _landscapeAppTitle(size);
    // return Positioned(
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           size.height * 0.03 : size.height * 0.03
    //       :Platform.isAndroid ?
    //           size.height * 0.03 : size.height * 0.03,
    //
    //   left: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           size.width * 0.05 : size.width * 0.05
    //       :Platform.isAndroid ?
    //           size.width * 0.05 : size.width * 0.05,
    //
    //   child: httpCommunicate!.bIsPreViewScore == true ?
    //       Text('편집하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: Platform.isAndroid ? 30 : 36))
    //       : Text('인쇄하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: Platform.isAndroid ? 30 : 36))
    // );
    ///SJW Modify 2022.06.28 End...2
  }

  ///세로모드 Title
  Widget _portraitAppTitle(Size size) {

    return Positioned(
        top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
        left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        child: widget.httpCommunicate!.bIsPreViewScore == true
            ? Text('미리보기', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.04, fontWeight: FontWeight.bold)))
        // ? Text(String.fromCharCode(test), style: TextStyle(fontFamily: 'ElfScore', fontSize: size.width * 0.04),)
            : Text("인쇄", style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.width * 0.04, fontWeight: FontWeight.bold)))
    );
  }

  ///가로모드 Title
  Widget _landscapeAppTitle(Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: widget.httpCommunicate!.bIsPreViewScore == true
          ? Text('미리보기', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.04, fontWeight: FontWeight.bold)))
          : Text('인쇄', style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black, fontSize: size.height * 0.04, fontWeight: FontWeight.bold))),
    );
  }

//==============================================================================

//==============================================================================


  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    Uint8List? uintData;

    uintData = context.watch<PDFProvider>().uinPdfData!;

    return Platform.isAndroid ?
    MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Scaffold(
          body: _displatTabletMainScreen(context, _size, uintData)
      ),
    ) :
    CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: CupertinoPageScaffold(
          child: _displatTabletMainScreen(context, _size, uintData)
      ),
    );
  }
}