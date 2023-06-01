
import 'package:elfscoreprint_mobile/src/models/data/draw_score_data.dart';
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/custom_font_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../providers/score_image_provider.dart';

class PhonePrintButton extends StatelessWidget {
  final Orientation? orientation;
  final HttpCommunicate? httpCommunicate;

  PhonePrintButton({this.orientation, this.httpCommunicate});

  ///AOS, IOS 기본 인쇄 서비스
  _generatedPdf(PdfPageFormat format, BuildContext context, Size size, HttpCommunicate httpCommunicate) async {

    DrawScore drawScore = DrawScore();
    await drawScore.makePDF(context.read<PDFProvider>().uinPdfData!);

    // // bool bRes = await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/score.pdf');

    ///Test Code
    // pdfWidget.Document scorePdf = pdfWidget.Document(version: PdfVersion.pdf_1_5, compress: true);
    // scorePdf.addPage(
    //     pdfWidget.Page(
    //       pageFormat: PdfPageFormat.a4, ///2480 * 3508
    //       build: (pdfWidget.Context pContext){
    //         return pdfWidget.Stack(
    //           children: [
    //             for(int i=0; i<10; i++)
    //               pdfWidget.Positioned(
    //                 top: 220.0 * i,
    //                 left: 100,
    //                 child: pdfWidget.Container(
    //                   alignment: pdfWidget.Alignment.center,
    //                   child: pdfWidget.Text(
    //                     'TEST Code!!',
    //                     style: pdfWidget.TextStyle(
    //                       color: PdfColor.fromInt(0xFF000000),
    //                       fontSize: 60,
    //                       font: context.read<CustomFontProvider>().SOURCE_HANSANS_MEDIUM,
    //                       fontWeight: pdfWidget.FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //           ]
    //         );
    //       }
    //     )
    // );
    //
    // File testFile = File('${output.path}/testFile.pdf');
    // testFile.writeAsBytesSync(await scorePdf.save());

    // print("testFile : ${File('${output.path}/testFile.pdf').readAsBytesSync()}");

    // await Printing.layoutPdf(onLayout: (_) => testFile.readAsBytesSync());
    ///
    await Printing.layoutPdf(onLayout: (_) => file.readAsBytesSync(), format: PdfPageFormat.a4);

  }

//==============================================================================

  ///세로모드 버튼 UI
  Widget _portraitPhonePrintButton(BuildContext context, Size size,){
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
            _generatedPdf(PdfPageFormat.a4, context, size, httpCommunicate!);
            httpCommunicate!.printPost(context, httpCommunicate!);
          },
          child: Container(
            ///SJW Modify 2023.05.18 Start..
            ///뷰어로 변경되면서 버튼 사이즈 변경
            // width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
            width: Platform.isAndroid ? size.width * 0.4 : size.width * 0.4,
            ///SJW Modify 2023.05.18 End...
            height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
            decoration: BoxDecoration(
              //color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                ///SJW Modify 2023.05.18 Start...
                ///뷰어로 변경되면서 버튼 이미지 변경
                // image: AssetImage('assets/images/buttons/print_button.png'),
                image: AssetImage('assets/images/buttons/prev_button.png'),
                ///SJW Modify 2023.05.18 End...
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///가로모드 버튼 UI
  Widget _landscapePhonePrintButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.05,
      child: Container(
        ///SJW Modify 2023.02.09 Start...
        ///가로 모드 버튼 UI의 width가 커서 줄임
        width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.27,
        ///SJW Modify 2023.02.09 End...
        height: Platform.isAndroid ? size.height * 0.13 : size.height * 0.13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: GestureDetector(
          onTap: () {
            _generatedPdf(PdfPageFormat.a4, context, size, httpCommunicate!);
            httpCommunicate!.printPost(context, httpCommunicate!);
          },
          child: Container(
            width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.27,
            height: Platform.isAndroid ? size.height * 0.13 : size.height * 0.13,
            decoration: BoxDecoration(
              //color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                ///SJW Modify 2023.05.18 Start...
                ///뷰어로 변경되면서 버튼 이미지 변경
                // image: AssetImage('assets/images/buttons/print_button.png'),
                image: AssetImage('assets/images/buttons/prev_button.png'),
                ///SJW Modify 2023.05.18 End...
              ),
            ),
          ),
        ),
      ),
    );
  }

//==============================================================================

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022.06.24 Start...1  ///세로 & 가로모드 따로 함수로 구현
    return orientation == Orientation.portrait
        ? _portraitPhonePrintButton(context, _size)
        : _landscapePhonePrintButton(context, _size);
    // return Positioned(
    //   ///SJW Modify 2022.04.21 Start...1  좌표수정
    //   // top: orientation == Orientation.portrait ?
    //   //     Platform.isAndroid ?
    //   //         _size.height * 0.85 : _size.height * 0.83
    //   //     : Platform.isAndroid ?
    //   //         _size.height * 0.80 : _size.height * 0.80,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.height * 0.90 : _size.height * 0.88
    //       :Platform.isAndroid ?
    //           _size.height * 0.85 : _size.height * 0.85,
    //   ///SJW Modify 2022.04.21 End...1
    //
    //   left: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.width * 0.03 : _size.width * 0.03
    //       : Platform.isAndroid ?
    //           _size.width * 0.03 : _size.width * 0.05,
    //
    //   child: Container(
    //     width: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //             _size.width * 0.3 : _size.width * 0.3
    //         : Platform.isAndroid ?
    //             _size.width * 0.3 : _size.width * 0.27,
    //
    //     height: orientation == Orientation.portrait ?
    //         _size.height * 0.07 : _size.height * 0.13,
    //     decoration: BoxDecoration(
    //       color: Colors.blue,
    //       borderRadius: BorderRadius.circular(16.0),
    //     ),
    //     child: TextButton(
    //       onPressed: () {
    //         print("print button onPress");
    //         _generatePdf(PdfPageFormat.a4, context);
    //         httpCommunicate!.printPost(context, httpCommunicate!);
    //         print("print button Done");
    //       },
    //       child: Text(
    //         '인쇄',
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           color: Colors.white
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    ///SJW Modify 2022.06.24 End...1
  }
}

