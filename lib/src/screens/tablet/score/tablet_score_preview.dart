import 'dart:async';
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import '../../../models/http/http_communicate.dart';
import '../../../providers/score_image_provider.dart';

class TabletScorePreview extends StatefulWidget {

  TabletScorePreview({Key? key, this.orientation, this.httpCommunicate, this.uintData}) : super(key: key);

  final Orientation? orientation;
  HttpCommunicate? httpCommunicate;
  final Uint8List? uintData;

  @override
  _TabletScorePreviewState createState() => _TabletScorePreviewState();
}

class _TabletScorePreviewState extends State<TabletScorePreview> {
  //페이징 인덱스
  int nPageIndex = 1;

  int nTotalPageNum = 0;
  bool isReady = false;

  // final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  PdfControllerPinch? pdfController;
  int _actualPageNumber = 1, _allPagesCount = 0;

//==============================================================================

  ///악보 표시
  Widget _displayScorePreview(BuildContext context, Size size) {
    ///SJW Modify 2022.06.28 Start...1  ///세로 & 가로 모드 함수 따로 구현
    return widget.orientation == Orientation.portrait
        ? _portraitDisplayScorePreview(context, size)
        : _landscapeDisplayScorePreView(context, size);
    ///SJW Modify 2022.06.28 End...1
  }

  ///세로모드 악보 미리보기
  Widget _portraitDisplayScorePreview(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.08 : size.height * 0.08,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.9 : size.width * 0.9,
        height: Platform.isAndroid ? size.height * 0.75 : size.height * 0.7,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/score_side.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.88 : size.width * 0.88,
          height: Platform.isAndroid ? size.height * 0.73 : size.height * 0.64,
          child: PdfViewPinch(
            pageSnapping: false,
            padding: 0,
            scrollDirection: Axis.vertical,
            pageLoader: Center(child: CircularProgressIndicator()),
            controller: pdfController!,
            onDocumentLoaded: (document) {

              ///SJW Modify 2023.01.17 Start...
              ///페이징 따로 Widget으로 만듬
              setState(() {
                _allPagesCount = document.pagesCount;
              });
              // context.read<PDFProvider>().setPdfTotalpage(document.pagesCount);
              ///SJW Modify 2023.01.17 End...
            },
            onPageChanged: (page) {
              ///SJW Modify 2023.01.17 Start...
              setState(() {
                _actualPageNumber = page;
              });
              // context.read<PDFProvider>().setPdfCurPage(page);
              ///SJW Modify 2023.01.17 End...
            },
          ),
        ),
      ),
    );
  }

  Widget _testButton(){
    return Positioned(
      top: 10,
      left: 500,
      child: TextButton(
        onPressed: ()async{
          await pdfController!.goToPage(pageNumber: 2, padding: 0);
        },
        child: Text('testButton'),
      ),
    );
  }

  ///가로모드 악보 미리 보기
  Widget _landscapeDisplayScorePreView(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.1 : size.height * 0.1,
      left: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.9 : size.width * 0.9,
        height: Platform.isAndroid ? size.height * 0.6 : size.height * 0.6,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/score_side.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          width: Platform.isAndroid ? size.width * 0.88 : size.width * 0.8,
          height: Platform.isAndroid ? size.height * 0.58 : size.height * 0.55,
          child: PdfViewPinch(
            pageSnapping: false,
            padding: 0,
            scrollDirection: Axis.vertical,
            pageLoader: Center(child: CircularProgressIndicator()),
            controller: pdfController!,
            onDocumentLoaded: (document) {
              ///SJW Modify 2023.01.17 Start...
              setState(() {
                _allPagesCount = document.pagesCount;
              });
              // context.read<PDFProvider>().setTotalStffNum(document.pagesCount);
              ///SJW Modify 2023.01.17 End...
            },
            onPageChanged: (page) {
              ///SJW Modify 2023.01.17 Start...
              setState(() {
                _actualPageNumber = page;
              });
              // context.read<PDFProvider>().setPdfCurPage(page);
              ///SJW Modify 2023.01.17 End...
            },
          ),
        ),
      ),
    );
  }

//==============================================================================

//==============================================================================

  ///페이징 UI
  Widget _displayScorePaging(BuildContext context, Size size) {
    ///SJW Modify 2022.06.28 Start...2  ///세로 & 가로 모드 함수로 따로 구현
    return widget.orientation == Orientation.portrait
        ? _portraitDisplayScorePaging(context, size)
        : _landscapeDisplayScorePaging(context, size);
    // return Positioned(
    //   top: widget.orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           size.height * 0.75 : size.height * 0.75
    //       : Platform.isAndroid ?
    //           size.height * 0.65 : size.height * 0.65,
    //
    //   child: Container(
    //     width: size.width,
    //     height: size.height * 0.05,
    //     alignment: Alignment.center,
    //     child: Transform.scale(
    //       scale: 2.0,
    //       child: widget.httpCommunicate == false ?
    //           AnimatedSmoothIndicator(
    //             count: context.watch<ScoreImageProvider>().scoreImageList.length,
    //             axisDirection: Axis.horizontal,
    //             activeIndex: nPageIndex,
    //             effect: WormEffect(type: WormType.thin),
    //           ) : SizedBox(),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.28 End...2
  }

  ///세로 모드 페이징
  Widget _portraitDisplayScorePaging(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.83 : size.height * 0.78,
      child: widget.httpCommunicate!.bIsPreViewScore == false
          ? Container(
              width: Platform.isAndroid ? size.width : size.width,
              height:
                  Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
              alignment: Alignment.center,
              child: Text(
                // '[$nPageIndex / ${context.read<PDFProvider>().scorePageData.length}]',
                '[$_actualPageNumber / $_allPagesCount]',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }

  ///가로 모드 페이징
  Widget _landscapeDisplayScorePaging(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.70 : size.height * 0.70,
      child: widget.httpCommunicate!.bIsPreViewScore == false
          ? Container(
              width: Platform.isAndroid ? size.width : size.width,
              height:
                  Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
              alignment: Alignment.center,
              child: Text(
                // '[$nPageIndex / ${context.read<PDFProvider>().scorePageData.length}]',
                '[$_actualPageNumber / $_allPagesCount]',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: size.height * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }

//==============================================================================

  @override
  void initState() {
    // TODO: implement initState
    print('init tablet pfgView');
    super.initState();
    pdfController = PdfControllerPinch(document: PdfDocument.openData(widget.uintData!), initialPage: 1);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  // @override
  // void didUpdateWidget(covariant TabletScorePreview oldWidget) {
  //   // TODO: implement didUpdateWidget
  //
  //   ///pdf data가 변경후 같지 않다면 Update
  //
  //   if (oldWidget.uintData != widget.uintData) {
  //     pdfController!.loadDocument(PdfDocument.openData(widget.uintData!));
  //   }
  //   else if(oldWidget.orientation != widget.orientation){
  //     print('orientation tablet change');
  //     _actualPageNumber = 1;
  //     // pdfController!.loadDocument(PdfDocument.openData(widget.uintData!));
  //     context.read<PDFProvider>().nKeyValue++;
  //   }
  //
  //   // print('force reload');
  //
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose tablet pdf view');
    pdfController!.dispose();
    super.dispose();
  }

  _portraitPrevButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
        height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: (){
            if(_actualPageNumber > 1){
              setState(() {
                _actualPageNumber--;
                pdfController!.goToPage(pageNumber: _actualPageNumber);
              });
            }
          },
          child: Container(
            width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
            height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
            alignment: Alignment.center,
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
      left: Platform.isAndroid ? size.width * 0.02 : size.width * 0.03,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
        height: Platform.isAndroid ? size.width * 0.07 : size.width * 0.07,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: (){
            if(_actualPageNumber > 1){
              setState(() {
                _actualPageNumber--;
                pdfController!.goToPage(pageNumber: _actualPageNumber);
              });
            }
          },
          child:Container(
            ///SJW Modify 2023.02.09 Start...
            ///버튼 width가 넓어 줄임
            width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.3,
            height: Platform.isAndroid ? size.width * 0.07 : size.width * 0.07,
            ///SJW Modify 2023.02.09 End...
            alignment: Alignment.center,
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
      top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          if(_actualPageNumber < _allPagesCount){
            setState(() {
              _actualPageNumber++;
              pdfController!.goToPage(pageNumber: _actualPageNumber);
            });
          }
        },
        child: Container(
          width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
          height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
          alignment: Alignment.center,
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
      right: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          if(_actualPageNumber < _allPagesCount){
            setState(() {
              _actualPageNumber++;
              pdfController!.goToPage(pageNumber: _actualPageNumber);
            });
          }
        },
        child: Container(
          ///SJW Modify 2023.02.09 Start...
          ///버튼 width가 넓어 줄임
          width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.3,
          ///SJW Modify 2023.02.09 End...
          height: Platform.isAndroid ? size.width * 0.07 : size.width * 0.07,
          alignment: Alignment.center,
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

  @override
  Widget build(BuildContext context) {
    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    setState(() {
      if(context.read<PDFProvider>().orientation != widget.orientation){
        context.read<PDFProvider>().nKeyValue++;
      }
    });

    return Stack(
      children: <Widget>[
        // _testButton(),

        //악보 표시
        _displayScorePreview(context, _size),

        //악보 페이징 애니메이션
        _displayScorePaging(context, _size),

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
