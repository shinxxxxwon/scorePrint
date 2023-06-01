import 'dart:io';

import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PhonePdfPageIndex extends StatelessWidget {
  const PhonePdfPageIndex({Key? key, this.httpCommunicate, this.orientation}) : super(key: key);

  final HttpCommunicate? httpCommunicate;
  final Orientation? orientation;

  ///세로모드 페이지 index
  Widget _portraitDisplayPageIndex(BuildContext context, Size size) {
    return Positioned(
        top: Platform.isAndroid ? size.height * 0.80 : size.height * 0.78,
        left: 0,
        child: Container(
          width: size.width,
          height: size.height * 0.1,
          alignment: Alignment.center,
          child: httpCommunicate!.bIsPreViewScore == false
              ? Container(
            width: Platform.isAndroid ? size.width : size.width,
            height: Platform.isAndroid
                ? size.height * 0.1
                : size.height * 0.1,
            alignment: Alignment.center,
            child: Text(
              '[${context.read<PDFProvider>().pdfCurPage} / ${context.read<PDFProvider>().pdfTotalPage}]',
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

  ///가로모드 페이지 index
  Widget _landscapeDisplayPageIndex(BuildContext context, Size size) {
    return Positioned(
        top: Platform.isAndroid ? size.height * 0.7 : size.height * 0.7,
        left: 0,
        child: Container(
          width: size.width,
          height: size.height * 0.1,
          alignment: Alignment.center,
          child: httpCommunicate!.bIsPreViewScore == false
              ? Container(
            width: Platform.isAndroid ? size.width : size.width,
            height: Platform.isAndroid
                ? size.height * 0.1
                : size.height * 0.1,
            alignment: Alignment.center,
            child: Text(
              // '[$nPageIndex / ${context.read<PDFProvider>().scorePageData.length}]',
              '[${context.watch<PDFProvider>().pdfCurPage} / ${context.watch<PDFProvider>().pdfTotalPage}]',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: size.height * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : SizedBox(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return orientation == Orientation.portrait
        ? _portraitDisplayPageIndex(context, size)
        : _landscapeDisplayPageIndex(context, size);
  }
}
