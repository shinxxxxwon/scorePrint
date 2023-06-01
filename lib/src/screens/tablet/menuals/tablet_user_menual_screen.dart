import 'tablet_user_menual_prev_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tablet_user_menual_print_01_page.dart';
import 'tablet_user_menual_print_02_page.dart';
import 'tablet_user_menual_save_page.dart';

class TabletUserMenualScreen extends StatefulWidget {
  final Orientation? orientation;

  TabletUserMenualScreen({this.orientation});

  @override
  _TabletUserMenualScreenState createState() => _TabletUserMenualScreenState();
}

class _TabletUserMenualScreenState extends State<TabletUserMenualScreen> {

  ///현재 페이지 변수
  int _nCurrentPage = 2;
  bool bIsPreview = true;
  bool bIsPrint = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _nCurrentPage = 2;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TabletUserMenualScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[

            //뒤로 가기
            _popScreen(context, _size),

            //도움말
            _displayUserMenual(_size),

            //현재 페이지
            // _displayCurrentPage(_size),

            //이전 페이지 버튼
            // _previewPageButton(_size),

            //다음 페이지 버튼
            // _printPageButton(_size),

          ],
        ),
      ),
    );
  }

//==============================================================================

  ///뒤록 가기 버튼
  Widget _popScreen(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
      left: Platform.isAndroid ? size.width * 0.025 : size.width * 0.025,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.06 : size.width * 0.06,
        height: Platform.isAndroid ? size.height * 0.04 : size.height * 0.04,
        constraints: BoxConstraints(),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: size.width * 0.04),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///도움말
  Widget _displayUserMenual(Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.08 : size.height * 0.08,
      left: Platform.isAndroid ? size.width * 0.025 : size.width * 0.025,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.95 : size.width * 0.95,
        height: Platform.isAndroid ? size.height * 0.8 : size.height * 0.8,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/score_side.png'),
          ),
        ),
        child: _displayMenualPage(size),
      ),
    );
  }

  ///display Menual Page
  Widget _displayMenualPage(Size size){
    switch(_nCurrentPage){
      case 1:
        setState(() {
          bIsPreview = true;
          bIsPrint = false;
        });
        return TabletUserMenualPrevPage();
      // case 2:
      //   return TabletUserMenualSavePage();
      case 2:
        setState(() {
          bIsPreview = false;
          bIsPrint = true;
        });
        return TabletUserMenualPrint01Page();
      // case 4:
      //   return TabletUserMenualPrint02Page();
      default:
        return Container();
    }
  }

//==============================================================================

//==============================================================================

  ///현재 페이지
  Widget _displayCurrentPage(Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.8 : size.height * 0.8,
      child: Container(
        width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height * 0.04 : size.height * 0.04,
        alignment: Alignment.center,
        child: Text(
          '[$_nCurrentPage / 4]',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///이전 페이지 버튼
  Widget _previewPageButton(Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      left: Platform.isAndroid ? size.width * 0.025 : size.width * 0.025,
      child: GestureDetector(
        onTap: () => _decrementPage(),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.45 : size.width * 0.45,
          height: Platform.isAndroid ? size.height * 0.08: size.height * 0.08,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: bIsPreview == true ? AssetImage('assets/images/buttons/preview_button.png') : AssetImage('assets/images/buttons/un_user_preview_button.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  ///다음 페이지 버튼
  Widget _printPageButton(Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      left: Platform.isAndroid ? size.width * 0.525 : size.width * 0.525,
      child: GestureDetector(
        onTap: () => _incrementPage(),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.45 : size.width * 0.45,
          height: Platform.isAndroid ? size.height * 0.08 : size.height * 0.08,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: bIsPrint == true ? AssetImage('assets/images/buttons/print_button.png') : AssetImage('assets/images/buttons/un_use_print_button.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  ///페이지 증가
  void _incrementPage(){
    setState(() {
      if(_nCurrentPage < 2){
        _nCurrentPage++;
      }
    });
  }

  ///페이지 감소
  void _decrementPage(){
    setState(() {
      if(_nCurrentPage > 1){
        _nCurrentPage--;
      }
    });
  }

//==============================================================================

}

