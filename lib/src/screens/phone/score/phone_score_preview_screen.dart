import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'dart:io';

import 'package:provider/provider.dart';

import '../../../models/http/http_communicate.dart';
import '../../../providers/score_image_provider.dart';

class PhoneScorePreviewScreen extends StatefulWidget {
  PhoneScorePreviewScreen(
      {Key? key, this.orientation, this.httpCommunicate, this.uintData})
      : super(key: key);

  // : assert(orientation != null || httpCommunicate != null),
  //   super(key: key);

  final Orientation? orientation;
  HttpCommunicate? httpCommunicate;
  final Uint8List? uintData;

  @override
  _PhoneScorePreviewScreenState createState() {
    return _PhoneScorePreviewScreenState();
  }
}

class _PhoneScorePreviewScreenState extends State<PhoneScorePreviewScreen> {
  int nPageIndex = 1;
  int nDefaultPage = 0;

  // int nTotalPageNum = 0;
  bool isReady = false;

  int _actualPageNumber = 1, _allPagesCount = 0;

  PdfControllerPinch? pdfController;

//==============================================================================
  ///악보 미리보기
  Widget _displayScorePreview(BuildContext context, Size size) {
    return widget.orientation! == Orientation.portrait
        ? _portraitDisplayScorePreview(context, size)
        : _landscapeDisplayScorePreview(context, size);
  }

  ///세로 모드 악보 미리보기
  Widget _portraitDisplayScorePreview(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.11 : size.height * 0.1,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.9 : size.width * 0.9,
        height: Platform.isAndroid ? size.height * 0.645 : size.height * 0.7,
        alignment: Alignment.center,
        constraints: BoxConstraints(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/score_side.png'),
          ),
        ),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.88 : size.width * 0.88,
          height: Platform.isAndroid ? size.height * 0.62 : size.height * 0.68,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          child: PdfViewPinch(
            pageSnapping: false,
            padding: 0,
            scrollDirection: Axis.vertical,
            pageLoader: Center(child: CircularProgressIndicator()),
            controller: pdfController!,
            onDocumentLoaded: (document) {
              setState(() {
                _allPagesCount = document.pagesCount;
              });
              // context.read<PDFProvider>().setPdfTotalpage(document.pagesCount);
            },
            onPageChanged: (page) {
              setState(() {
                _actualPageNumber = page;
              });
              // context.read<PDFProvider>().setPdfCurPage(page);
            },
          ),
        ),
      ),
    );
  }

  ///가로 모드 악보 미리모기
  Widget _landscapeDisplayScorePreview(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.13 : size.height * 0.13,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.9 : size.width * 0.9,
        height: Platform.isAndroid ? size.height * 0.6 : size.height * 0.6,
        alignment: Alignment.center,
        constraints: BoxConstraints(),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/score_side.png'),
          ),
        ),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.88 : size.width * 0.8,
          height: Platform.isAndroid ? size.height * 0.58 : size.height * 0.5,
          alignment: Alignment.center,
          child: PdfViewPinch(
            pageSnapping: false,
            scrollDirection: Axis.vertical,
            padding: 0,
            pageLoader: Center(child: CircularProgressIndicator()),
            controller: pdfController!,
            onDocumentLoaded: (document) {
              setState(() {
                _allPagesCount = document.pagesCount;
              });
              // context.read<PDFProvider>().setPdfTotalpage(document.pagesCount);
            },
            onPageChanged: (page) {
              setState(() {
                _actualPageNumber = page;
              });
              // context.read<PDFProvider>().setPdfCurPage(page);
            },
          ),
        ),
      ),
    );
  }

//==============================================================================

  ///악보 페이징
  Widget _displayPageIndex(BuildContext context, Size size) {
    ///SJW Modify 2022.06.24 Start...1 ///세로 & 가로 모드 따로 함수로 구현
    return widget.orientation! == Orientation.portrait
        ? _portraitDisplayPageIndex(context, size)
        : _landscapeDisplayPageIndex(context, size);
    // return  Positioned(
    //     top: widget.orientation == Orientation.portrait
    //         ? size.height * 0.75
    //         : size.height * 0.68,
    //     left: 0,
    //     // child: Text('[${ score.nImagePageCount} / ${ score.scoreImageList.length}]',
    //     //   style: TextStyle(fontWeight: FontWeight.bold),),
    //     child: Container(
    //       width: size.width,
    //       height: size.height * 0.1,
    //       alignment: Alignment.center,
    //       child: widget.httpCommunicate!.bIsPreViewScore == false ?
    //       AnimatedSmoothIndicator(
    //         count: context.watch<ScoreImageProvider>().scoreImageList.length,
    //         axisDirection: Axis.horizontal,
    //         activeIndex: nPageIndex,
    //         effect: WormEffect(type: WormType.thin),
    //       ) : SizedBox(),
    //     )
    // );
    ///SJW Modify 2022.06.24 End...1
  }

  ///세로 모드 악보 페이징
  Widget _portraitDisplayPageIndex(BuildContext context, Size size) {
    return Positioned(
        top: Platform.isAndroid ? size.height * 0.78 : size.height * 0.78,
        left: 0,
        child: Container(
          width: size.width,
          height: size.height * 0.1,
          alignment: Alignment.center,
          child: widget.httpCommunicate!.bIsPreViewScore == false
              ? Container(
            width: Platform.isAndroid ? size.width : size.width,
            height: Platform.isAndroid
                ? size.height * 0.1
                : size.height * 0.1,
            alignment: Alignment.center,
            child: Text(
              // '[$nPageIndex / ${context.read<PDFProvider>().scorePageData.length}]',
              '[$_actualPageNumber / $_allPagesCount]',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : SizedBox(),
        ));
  }

  ///가로 모드 악보 페이징
  Widget _landscapeDisplayPageIndex(BuildContext context, Size size) {
    return Positioned(
        top: Platform.isAndroid ? size.height * 0.72 : size.height * 0.72,
        left: 0,
        child: Container(
          width: size.width,
          height: size.height * 0.1,
          alignment: Alignment.center,
          child: widget.httpCommunicate!.bIsPreViewScore == false
              ? Container(
            width: Platform.isAndroid ? size.width : size.width,
            height: Platform.isAndroid
                ? size.height * 0.1
                : size.height * 0.1,
            alignment: Alignment.center,
            child: Text(
              // '[$nPageIndex / ${context.read<PDFProvider>().scorePageData.length}]',
              '[$_actualPageNumber / $_allPagesCount]',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: size.height * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : SizedBox(),
        ));
  }

//==============================================================================

  // getPdfViewData(){
  //   print('getPdfViewData run');
  //   PdfControllerPinch? pdfController;
  //   pdfController = PdfControllerPinch(document: PdfDocument.openData(widget.uintData!));
  //   return pdfController;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init phone score  view');
    pdfController = PdfControllerPinch(document: PdfDocument.openData(widget.uintData!));
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  // @override
  // void didUpdateWidget(covariant PhoneScorePreviewScreen oldWidget) {
  //   // TODO: implement didUpdateWidget
  //
  //   ///pdf data가 변경후 같지 않다면 Update
  //   if (oldWidget.uintData != widget.uintData) {
  //     print('change option');
  //     pdfController!.loadDocument(PdfDocument.openData(widget.uintData!), initialPage: 1);
  //   }
  //   else if(oldWidget.orientation != widget.orientation){
  //     _actualPageNumber = 1;
  //     print('change orientation');
  //     context.read<PDFProvider>().nKeyValue++;
  //   }
  //
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose pdf view');
    pdfController!.dispose();
    super.dispose();
  }

  _portraitPrevButton(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.88 : size.height * 0.88,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.4 : size.width * 0.4,
        height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: GestureDetector(
          onTap: () {
            if(_actualPageNumber > 1) {
              setState(() {
                _actualPageNumber--;
                pdfController!.goToPage(pageNumber:_actualPageNumber);
              });
            }
          },
          child: Container(
            width: Platform.isAndroid ? size.width * 0.4 : size.width * 0.4,
            height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/buttons/prev_button.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _landscapePrevButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.05,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.27,
        height: Platform.isAndroid ? size.height * 0.15 : size.height * 0.13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: GestureDetector(
          onTap: () {
            if(_actualPageNumber > 1) {
              setState(() {
                _actualPageNumber--;
                pdfController!.goToPage(pageNumber:_actualPageNumber);
              });
            }
          },
          child: Container(
            width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.27,
            height: Platform.isAndroid ? size.height * 0.13 : size.height * 0.13,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/buttons/prev_button.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _portraitNextButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.88 : size.height * 0.88,
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          if(_actualPageNumber < _allPagesCount) {
            setState(() {
              _actualPageNumber++;
              pdfController!.goToPage(pageNumber:_actualPageNumber);
            });
          }
        },
        child:Container(
          width: Platform.isAndroid ? size.width * 0.4 : size.width * 0.4,
          ///SJW Modify 2023.05.18 End...
          height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/buttons/next_button.png'),
            ),
          ),
        ),
      ),
    );
  }

  _landscapeNextButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.08,
      child: GestureDetector(
        onTap: (){
          if(_actualPageNumber < _allPagesCount) {
            setState(() {
              _actualPageNumber++;
              pdfController!.goToPage(pageNumber:_actualPageNumber);
            });
          }
        },
        child:Container(
          width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.27,
          height: Platform.isAndroid ? size.height * 0.15 : size.height * 0.13,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/buttons/next_button.png'),
            ),
          ),
        ),
      ),
    );
  }

  ///빌드 함수
  @override
  Widget build(BuildContext context) {
    print('preview');
    context.read<PDFProvider>().nKeyValue++;

    // 디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        //악보 표시
        _displayScorePreview(context, _size),

        //페이징
        _displayPageIndex(context, _size),

        //이전 페이지 버튼
        widget.orientation == Orientation.portrait
            ? _portraitPrevButton(context, _size)
            : _landscapePrevButton(context, _size),

        //다음 페이지 버튼
        widget.orientation == Orientation.portrait
            ? _portraitNextButton(context, _size)
            : _landscapeNextButton(context, _size),

      ],
    );
  }
}

