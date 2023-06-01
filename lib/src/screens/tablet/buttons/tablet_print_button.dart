
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/models/data/draw_score_data.dart';
import 'package:elfscoreprint_mobile/src/providers/custom_font_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as imagePkg;

import 'package:provider/provider.dart';
import '../../../models/http/http_communicate.dart';
import '../../../providers/score_image_provider.dart';

class TabletPrintButton extends StatefulWidget {
  final Orientation? orientation;
  final HttpCommunicate? httpCommunicate;

  TabletPrintButton({this.orientation, this.httpCommunicate});

  @override
  _TabletPrintButtonState createState() => _TabletPrintButtonState();
}

class _TabletPrintButtonState extends State<TabletPrintButton> {

  ///인쇄 버튼 UI
  Widget _printButton(BuildContext context, Size size){
    return widget.orientation == Orientation.portrait
        ? _portraitPrintButton(context, size)
        : _landscapePrintButton(context, size);
  }

  ///세로 모드 인쇄 버튼
  Widget _portraitPrintButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
        height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: (){
            _generatedPdf(PdfPageFormat.a4, context, size, widget.httpCommunicate!);
            widget.httpCommunicate!.printPost(context, widget.httpCommunicate!);
          },
          child: Container(
            width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
            height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/buttons/print_button.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 인쇄 버튼
  Widget _landscapePrintButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      left: Platform.isAndroid ? size.width * 0.02 : size.width * 0.03,
      child: Container(
        width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
        height: Platform.isAndroid ? size.width * 0.07 : size.width * 0.07,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: (){
            _generatedPdf(PdfPageFormat.a4, context, size, widget.httpCommunicate!);
            widget.httpCommunicate!.printPost(context, widget.httpCommunicate!);
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
                image: AssetImage('assets/images/buttons/print_button.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
//==============================================================================
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    // pdf.addPage(pdfWidget.Page(pageFormat: PdfPageFormat.a4, build: (pdfWidget.Context pContext){return pdfWidget.SizedBox();}));
    // onListener();
    super.initState();
  }

  // _nativeCall()async{
  //   await platform.invokeMethod('drawFont');
  // }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;
    // _nativeCall();

    ///SJW Modify 2022.06.29 Start...1 ///세로 & 가로 모드 함수로 따로 구현
    return _printButton(context, _size);
    // return Positioned(
    //   ///SJW Modify 2022.04.19 Start...1 좌표 수정
    //   // top: orientation == Orientation.portrait ?
    //   //     Platform.isAndroid ?
    //   //         _size.height * 0.85 : _size.height * 0.85
    //   //     : Platform.isAndroid ?
    //   //         _size.height * 0.80 : _size.height * 0.80,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.height * 0.90 : _size.height * 0.90
    //       :Platform.isAndroid ?
    //           _size.height * 0.85 : _size.height * 0.85,
    //   ///SJW Modify 2022.04.19 End...1
    //
    //   left: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.width * 0.03 : _size.width * 0.03
    //       : Platform.isAndroid ?
    //           _size.width * 0.02 : _size.width * 0.03,
    //
    //   child: Container(
    //     width: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //             _size.width * 0.3 : _size.width * 0.3
    //         : Platform.isAndroid ?
    //             _size.width * 0.3 : _size.width * 0.3,
    //
    //     height: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //             _size.height * 0.07 : _size.height * 0.07
    //         : Platform.isAndroid ?
    //             _size.height * 0.13 : _size.height * 0.13,
    //
    //     decoration: BoxDecoration(
    //       color: Colors.blue,
    //       borderRadius: BorderRadius.circular(16.0)
    //     ),
    //     alignment: Alignment.center,
    //     child: TextButton(
    //       onPressed: (){
    //         _generatedPdf(PdfPageFormat.a4, context);
    //         httpCommunicate!.printPost(context, httpCommunicate!);
    //         print("done");
    //       },
    //       child: Text(
    //         '인쇄',
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           color: Colors.white,
    //           fontSize: Platform.isAndroid ? 18 : 24,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...1
  }


  ///PDF 생성 및 Wi-Fi 다이렉트 프린팅
  ///IOS , AOS 기본 인쇄 서비스 이용
  _generatedPdf(PdfPageFormat format, BuildContext context, Size size, HttpCommunicate httpCommunicate) async {
    // final pdf = pdfWidget.Document(version: PdfVersion.pdf_1_5, compress: true);
    // final image = await imageFromAssetBundle('assets/images/ELF_CI.png');

    //DrawScore drawScore = DrawScore();

    //context.read<CustomFontProvider>().setFontSize();
    // int letter = await context.read<CustomFontProvider>().getMenuStringWidthGasa(context, httpCommunicate, '자', 48);
    // print("Letter : $letter");
    // print('1/1 maxHeight : ${context.read<CustomFontProvider>().fontWidth.toInt()}');

   // List<PolyBezierData> polyBezierDataList = context.read<PDFProvider>().scorePolyBezierData;
   // List<LineData> lineDataList = context.read<PDFProvider>().scoreLineData;
   // List<FontData> fontDataList = context.read<PDFProvider>().scoreFontData;
   //print('lineData List : $lineDataList');
    // pdf.addPage(
    //     pdfWidget.Page(
    //         margin: pdfWidget.EdgeInsets.zero,
    //         pageFormat: format,
    //         build: (pdfWidget.Context pContext){
    //           return pdfWidget.Stack(
    //             children: [

                   // pdfWidget.Center(
                   //    child: pdfWidget.SizedBox(
                   //      width: 500,
                   //      height: 300,
                   //      child: pdfWidget.Watermark(
                   //        fit: pdfWidget.BoxFit.contain,
                   //        child: pdfWidget.Image(image, dpi: 96),
                   //      ),
                   //    ),
                   //  ),

                 //drawScore.drawWatermarking(image),

                  //가로선 테스트
                  //drawScore.drawLine(lineDataList[0].nX1!, lineDataList[0].nY1!, lineDataList[0].nX2!, lineDataList[0].nY2!, lineDataList[0].nThickness!, lineDataList[0].bIsDotLine!, lineDataList[0].crColor!),
                  //drawScore.drawLine(lineDataList[1].nX1!, lineDataList[1].nY1!, lineDataList[1].nX2!, lineDataList[1].nY2!, lineDataList[1].nThickness!, lineDataList[1].bIsDotLine!, lineDataList[1].crColor!),

                  //곡선 테스트
                  //drawScore.drawPolyBezier(polyBezierDataList[0].nStartX!, polyBezierDataList[0].nStartY!, polyBezierDataList[0].nEndX!, polyBezierDataList[0].nEndY!, polyBezierDataList[0].nUpDown!, polyBezierDataList[0].crColor!),
                  //drawScore.drawPolyBezier(polyBezierDataList[1].nStartX!, polyBezierDataList[1].nStartY!, polyBezierDataList[1].nEndX!, polyBezierDataList[1].nEndY!, polyBezierDataList[1].nUpDown!, polyBezierDataList[1].crColor!),

                  //폰트 테스트
                  // for(int i=0; i<fontDataList.length; i++)
                  //   drawScore.drawFontScoreItem(context, fontDataList[i].nFontNo!, fontDataList[i].nPosX!, fontDataList[i].nPosY!, fontDataList[i].nEmSize!, fontDataList[i].bIsSetMinMaxPosY),
    //             ],
    //           );
    //         },
    //     ),
    // );

    // bool bRes = await Printing.layoutPdf(onLayout: (format) async => pdf.save());


    DrawScore drawScore = DrawScore();
    await drawScore.makePDF(context.read<PDFProvider>().uinPdfData!);

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/score.pdf');
    await Printing.layoutPdf(onLayout: (_) => file.readAsBytesSync(), );
  }

}

