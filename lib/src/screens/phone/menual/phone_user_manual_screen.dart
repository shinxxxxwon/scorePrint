import 'phone_user_menual_print_02.dart';
import 'phone_user_menual_prev_page.dart';
import 'phone_user_menumal_save_page.dart';
import 'phone_user_menual_print.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneUserMenualScreen extends StatefulWidget {

  PhoneUserMenualScreen();

  @override
  _PhoneUserMenualScreenState createState() => _PhoneUserMenualScreenState();
}

class _PhoneUserMenualScreenState extends State<PhoneUserMenualScreen> {

  int _nCurrentPage = 2;
  bool bIsPreview = true;
  bool bIsPrint = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _nCurrentPage = 2;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PhoneUserMenualScreen oldWidget) {
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
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Platform.isAndroid
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            home: Scaffold(
              body: _displayMenualScreen(context, _size),
            ),
          )
        : CupertinoApp(
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(brightness: Brightness.light),
            home: CupertinoPageScaffold(
              child: _displayMenualScreen(context, _size),
            ),
          );
  }

//==============================================================================

  ///UI
  Widget _displayMenualScreen(BuildContext context, Size size) {
    return Stack(
      children: <Widget>[
        //뒤로 가기 버튼
        _popScreen(context, size),

        //Title
        // _displayTitle(size),

        //도움말
        _displayMenual(size),

        //현재 페이지
        // _displayCurrentPage(size),

        //이전 페이지 버튼
        // _previewPageButton(size),

        //다음 페이지 버튼
        // _printPageButton(size),

      ],
    );
  }

//==============================================================================

//==============================================================================

  ///뒤로가기 버튼
  Widget _popScreen(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: Platform.isAndroid ?
      IconButton(
        onPressed: () => Navigator.pop(context),
        // constraints: BoxConstraints(),
        icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
            size: size.width * 0.08),
      ) :
      CupertinoButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back_ios_outlined,
          color: Colors.black,
          size: size.width * 0.08,
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///Title
  Widget _displayTitle(Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.04 : size.height * 0.04,
      left: Platform.isAndroid ? size.width * 0.17 : size.width * 0.17,
      child: Text(
        '도움말',
        style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///도움말
  Widget _displayMenual(Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.1 : size.height * 0.1,
      left: Platform.isAndroid ? size.width * 0.025 : size.width * 0.05,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.95 : size.width * 0.9,
        height: Platform.isAndroid ? size.height * 0.8 : size.height * 0.8,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/score_side.png'),
          ),
        ),
        child: _displayMenualPage(),
      ),
    );
  }

  ///display Menual Page
  Widget _displayMenualPage(){
    switch(_nCurrentPage){
      case 1:
        setState(() {
          bIsPreview = true;
          bIsPrint = false;
        });
        return PhoneUserMenualPrevPage();
      case 2:
        setState(() {
          bIsPreview = false;
          bIsPrint = true;
        });
        return PhoneUserMenualPrint();
      default:
        return Container();
    }
  }

//==============================================================================

//==============================================================================

  ///현재 페이지 표시
  Widget _displayCurrentPage(Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.83,
      child: Container(
        width: Platform.isAndroid ? size.width : size.width,
        height: Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        alignment: Alignment.center,
        child: Text(
          '[$_nCurrentPage / 2]',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: size.width * 0.05,
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
      top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      left: Platform.isAndroid ? size.width * 0.025 : size.width * 0.025,
      child: GestureDetector(
        onTap: () => _decrementPageNum(),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.45 : size.width * 0.45,
          height: Platform.isAndroid ? size.height * 0.07: size.height * 0.06,
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
      top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      left: Platform.isAndroid ? size.width * 0.525 : size.width * 0.5,
      child: GestureDetector(
        onTap: () => _incrementPageNum(),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.45 : size.width * 0.45,
          height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.06,
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
  void _incrementPageNum(){
    setState(() {
      if(_nCurrentPage < 2){
        _nCurrentPage++;
      }
    });
  }

  ///페이지 감소
  void _decrementPageNum(){
    setState(() {
      if(_nCurrentPage > 1){
        _nCurrentPage--;
      }
    });
  }

//==============================================================================

}