import 'dart:io';
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:provider/provider.dart';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TabletPdfPageIndex extends StatelessWidget {
  const TabletPdfPageIndex({Key? key, this.httpCommunicate, this.orientation}) : super(key: key);

  final HttpCommunicate? httpCommunicate;
  final Orientation? orientation;

  ///세로 모드 페이징
  Widget _portraitDisplayScorePaging(BuildContext context, Size size) {
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.83 : size.height * 0.78,
      child: httpCommunicate!.bIsPreViewScore == false
          ? Container(
        width: Platform.isAndroid ? size.width : size.width,
        height:
        Platform.isAndroid ? size.height * 0.05 : size.height * 0.05,
        alignment: Alignment.center,
        child: Text(
          // '[$nPageIndex / ${context.read<PDFProvider>().scorePageData.length}]',
          '[${context.watch<PDFProvider>().pdfCurPage} / ${context.watch<PDFProvider>().pdfTotalPage}]',
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
      child: httpCommunicate!.bIsPreViewScore == false
          ? Container(
        width: Platform.isAndroid ? size.width : size.width,
        height:
        Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
        alignment: Alignment.center,
        child: Text(
          // '[$nPageIndex / ${context.read<PDFProvider>().scorePageData.length}]',
          '[${context.watch<PDFProvider>().pdfCurPage} / ${context.watch<PDFProvider>().pdfTotalPage}]',
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


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return orientation! == Orientation.portrait ?
        _portraitDisplayScorePaging(context, size) :
        _landscapeDisplayScorePaging(context, size);
  }
}
