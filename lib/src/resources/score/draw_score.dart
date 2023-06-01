import 'dart:convert' as convert;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/models/data/draw_score_data.dart';
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/custom_font_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/score_size_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:pdf/pdf.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as imgLib;


class DrawScore {

  showCacheDirList() async {
    List<FileSystemEntity> _dirFiles;
    final dir = await getTemporaryDirectory()..createSync(recursive: true);
    String dirPath = dir.path + '/';
    final myDir = Directory(dirPath);
    _dirFiles = myDir.listSync(recursive: true, followLinks: false);
    print('_dirFiles11 : $_dirFiles');
  }

  getTiffFiles(HttpCommunicate httpCommunicate) async {
    List<FileSystemEntity> _dirFiles;
    final dir = await getTemporaryDirectory()..createSync(recursive: true);
    String dirPath = dir.path + '/';
    final myDir = Directory(dirPath);
    _dirFiles = myDir.listSync();
    // _dirFiles = await compute(getTiffList,1);

    List<String> tiffFiles = [];
    for(int i=0; i<_dirFiles.length; i++){
      ///인쇄
      //  if(!(httpCommunicate.bIsPreViewScore!)) {
         if (_dirFiles[i].path.contains('.tiff')) {
           tiffFiles.add(_dirFiles[i].path);
         // }
       // }
       ///미리보기
       // else{
       //   if(_dirFiles[i].path.contains('001.tiff')){
       //     tiffFiles.add(_dirFiles[i].path);
       //   }
       }
    }

    if(tiffFiles.isNotEmpty){
      tiffFiles.sort();
    }

    return tiffFiles;
  }


  Future<void> changeOption(BuildContext context, HttpCommunicate httpCommunicate) async {

    // Size size = MediaQuery.of(context).size;

    if(context.read<PDFProvider>().bMakingScore){
      context.read<PDFProvider>().bWillChange = true;
    }
    else{
      DrawScore drawScore = DrawScore();
      context.read<PDFProvider>().bMakingScore = true;

      // await Future.delayed(const Duration(milliseconds: 300));

      await drawScore.reDrawSocre(context, httpCommunicate);

      context.read<PDFProvider>().nRealChagneCount++;
      context.read<PDFProvider>().bMakingScore = false;

      // print('reDrawCach : ');
      // await showCacheDirList();

      // await Future.delayed(const Duration(milliseconds: 300));

    }
  }

  Future<void> reDrawSocre(BuildContext context, HttpCommunicate httpCommunicate) async {
    context.read<PDFProvider>().deletePdfFile();
    context.read<PDFProvider>().setDataInit();

    PaintingBinding.instance!.imageCache!.clear();

    ///PDF 삭제
    BridgeNative bridgeNative = BridgeNative();
    await bridgeNative.callDrawFromModule(context, httpCommunicate, false, false);

    context.read<PDFProvider>().increaKeyCount();

  }

  _showReDrawAlertTitle(Size size){
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.02,
          alignment: Alignment.center,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/error.png'),
          //   ),
          // ),
          child: Text('설정'),
        ),
        Container(
          height: size.height * 0.03,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/divider.png'),
            ),
          ),
        ),
      ],
    );
  }

  _showRedrawAlertContent(Size size, String txt){
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        txt,
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: size.width > 600 ? size.width * 0.025 : size.width * 0.035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  showReDrawAlertForWaiting(BuildContext context, Size size, String txt){
    return Platform.isAndroid
        ? AlertDialog(
              title: _showReDrawAlertTitle(size),
              content: _showRedrawAlertContent(size, txt),
              // content: CircularProgressIndicator(),
            )
        : CupertinoAlertDialog(
              title: _showReDrawAlertTitle(size),
              content: _showRedrawAlertContent(size, txt),
            );
  }

  _showReDrawAlertOkButton(BuildContext context, Size size){
    return Container(
      height: size.height * 0.06,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Image(
          image: AssetImage('assets/images/buttons/ok_button.png'),
        ),
      ),
    );
  }

  showReDrawAlert(BuildContext context, Size size, String txt){
    return Platform.isAndroid
        ? AlertDialog(
          title: _showReDrawAlertTitle(size),
          content: _showRedrawAlertContent(size, txt),
          actions: [_showReDrawAlertOkButton(context, size)],
          )
        : CupertinoAlertDialog(
          title: _showReDrawAlertTitle(size),
          content: _showRedrawAlertContent(size, txt),
          actions: [_showReDrawAlertOkButton(context, size)],
        );
  }

  ///악보 파일(pdf) 생성
  makePDF(Uint8List doc) async {
    // final dir = await getTemporaryDirectory()..createSync(recursive: true);
    final dir = await getTemporaryDirectory();
    String dirPath = dir.path + '/score.pdf';
    File pdf = File('$dirPath');
    await pdf.writeAsBytes(doc);
    print('make PDF done');
    // await showCacheDirList();
    return pdf.readAsBytesSync();
  }

  ///실제 선 그리기
  pdfWidget.Widget drawLine(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex){

    int nX1 = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nX1!;
    int nX2 = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nX2!;

    int nY1 = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY1!;
    int nY2 = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY2!;

    int crColor = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].crColor!;

    // print('X1 : $nX1 , X2 : $nX2');
    if(nX1 == nX2){
      if(nY1 < nY2)
        return drawVerticalLine(context, httpCommunicate, nCurPage, nDrawIndex);
      else
        return drawVerticalLine(context, httpCommunicate, nCurPage, nDrawIndex);
    }
    else if(nY1 == nY2){
      if(nX1 < nX2)
        return drawHorizonLine(context, httpCommunicate, nCurPage, nDrawIndex);
      else
        return drawHorizonLine(context, httpCommunicate, nCurPage, nDrawIndex);
    }
    else{
      // return pdfWidget.Positioned(
      //   top: nY1.toDouble(),
      //   left: nX1.toDouble(),
      //   child: pdfWidget.CustomPaint(
      //       painter: (PdfGraphics canvas, PdfPoint size){
      //         canvas
      //           ..moveTo(0, 0)
      //           ..setStrokeColor(PdfColor.fromInt(0xFF000000))
      //           ..lineTo((nX2 - nX1).toDouble(), 0)
      //           ..strokePath();
      //       }
      //   )
      // );
      return drawDiagonalLine(context, httpCommunicate, nCurPage, nDrawIndex);
    }
  }

  ///대각 선 그리기
  pdfWidget.Widget drawDiagonalLine(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex){
    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nStaffNum!;

    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...

      if(nStaffNum < nTotalStaffNum) {
        int nZeroPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX!;
        int nZeroPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY!;

        int nStartX = nZeroPosX + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nX1!;
        int nStartY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY1!;
        int nEndX = nZeroPosX + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nX2!;
        int nEndY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY2!;
        int nThickness = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nThickness!;
        int crColor = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].crColor!;

        bool bIsDotLine = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].bIsDotLine!;

        int operatorX = nStartX < nEndX ? 1 : -1;
        int operatorY = nStartY < nEndY ? 1 : -1;

        double nLineX = (nEndX - nStartX).toDouble();
        double nLineY = -(nEndY - nStartY).toDouble();

        /*
        int operatorX = nStartX < nEndX ? 1 : -1;
        int operatorY = nStartY < nEndY ? 1 : -1;

        double nLineX = operatorX * (nEndX - nStartX).toDouble();
        double nLineY = operatorY * (nEndY - nStartY).toDouble();
        */
        return pdfWidget.Positioned(
          top: nStartY.toDouble(),
          left: nStartX.toDouble(),
          child: pdfWidget.CustomPaint(
              painter: (PdfGraphics canvas, PdfPoint size) {
                canvas
                  ..moveTo(0, 0)
                  ..setStrokeColor(PdfColor.fromInt(0xFF000000))
                  ..setLineWidth(nThickness.toDouble())
                  ..lineTo(nLineX , nLineY)
                  ..strokePath();
              }
          ),
        );
      }
      else{
        return pdfWidget.Container();
    }
  }

  ///가로 선 그리기
  pdfWidget.Widget drawHorizonLine(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex) {

    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nStaffNum!;

    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...

      if(nStaffNum < nTotalStaffNum) {

        int nZeroPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX!;
        int nZeroPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY!;

        int nStartX = nZeroPosX + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nX1!;
        int nPosY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY1!;
        int nEndX = nZeroPosX + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nX2!;
        int nThickness = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nThickness!;
        int crColor = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].crColor!;

        bool bIsDotLine = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].bIsDotLine!;

        ///SJW Modify 2023.02.08 Start...
        ///수평선 로그
        // if(nStaffNum == 1 && nCurPage == 0){
        //   print('flutter Horizon Line Data : StaffNum : $nStaffNum , nStartX : $nStartX , nStartY : $nPosY , nEndX : $nEndX , nTickness : $nThickness');
        // }
        ///SJW Modify 2023.02.08 End...

        return pdfWidget.Positioned(
            left: nStartX.toDouble(),
            top: nPosY.toDouble() + 4,
            child: pdfWidget.CustomPaint(
                painter: (PdfGraphics canvas, PdfPoint size) {
                  if (bIsDotLine) {
                    int nStep = nThickness + 1;
                    for (int nX = nStartX; nX <= nEndX; nX += (2 * nStep)) {
                      canvas
                        ..moveTo(nX.toDouble(), 0)
                        ..setStrokeColor(PdfColor.fromInt(0xFF000000))
                        ..lineTo((nX + nStep).toDouble(), 0)
                        ..strokePath();
                    }
                  }
                  else {
                    if (nThickness > 1) {
                      canvas
                        ..moveTo(0, 0)
                        ..setStrokeColor(PdfColor.fromInt(0xFF000000))
                        ..setLineWidth(nThickness.toDouble())
                        ..lineTo((nEndX - nStartX).toDouble(), 0)
                        ..strokePath();
                    }
                    else {
                      canvas
                        ..moveTo(0, 0)
                        ..setStrokeColor(PdfColor.fromInt(0xFF000000))
                        ..lineTo((nEndX - nStartX).toDouble(), 0)
                        ..strokePath();
                    }
                  }
                }
            )
        );
      }
      else{
        return pdfWidget.Container();
      }

  }

  ///세로 선 그리기
  pdfWidget.Widget drawVerticalLine(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex) {

    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nStaffNum!;

    double nLinePosY = 3;
    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...

      if (nStaffNum < nTotalStaffNum) {
        int nZeroPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX!;
        int nZeroPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY!;
        int nPosX = nZeroPosX + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nX1!;
        // int nStartY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY1!;
        // int nEndY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY2!;
        bool bIsDotLine = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].bIsDotLine!;
        int nThickness = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nThickness!;
        int crColor = context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].crColor!;
        int nStartY = 0;
        int nEndY = 0;



        ///Y값이 음수면 아래, 양수면 위
        if(context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY1! > context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY2!)
        {
          nStartY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY1!;
          nEndY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY2!;
        }
        else
        {
          nStartY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY2!;
          nEndY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].lineDataList![nDrawIndex].nY1!;
        }


        ///SJW Modify 2023.02.08 Start...
        ///수직선 로그
        // if(nStaffNum == 1 && nCurPage == 0){
        //
        //   print('flutter Vertical LineData : StaffNum : $nStaffNum , nX : $nPosX , nY1 : $nStartY , nY2 : $nEndY , DotLine : $bIsDotLine , Thickness : $nThickness');
        // }
        ///SJW Modify 2023.02.08 End...

        return pdfWidget.Positioned(
            left: nPosX.toDouble(),
            top: nStartY.toDouble() + nLinePosY,
            child: pdfWidget.CustomPaint(
                painter: (PdfGraphics canvas, PdfPoint size) {
                  if (bIsDotLine) {
                    int nStep = nThickness + 1;
                    for (int nY = nStartY; nY <= nEndY; nY += nStep) {
                      canvas
                        ..moveTo(0, nY.toDouble())
                        ..setStrokeColor(PdfColor.fromInt(0xFF000000))
                        ..lineTo(0, ((nY + nStep).toDouble() * -1))
                        ..strokePath();
                    }
                  }
                  else {
                    if (nThickness > 1) {
                      // print('nThickness : $nThickness');
                      // canvas
                      //   ..moveTo(0, 0)
                      //   ..setFillColor(PdfColor.fromInt(0xFF000000))
                      //   ..drawRect(nPosX.toDouble(), nStartY.toDouble(),
                      //       nThickness.toDouble(), (nEndY - nStartY).toDouble())
                      //   ..fillPath();
                      canvas
                        ..moveTo(0, 0)
                        ..setStrokeColor(PdfColor.fromInt(0xFF000000))
                        ..setLineWidth(nThickness.toDouble())
                        ..lineTo(0, ((nEndY - nStartY).toDouble() * -1))
                        ..strokePath();
                    }
                    else {
                      canvas
                        ..moveTo(0, 0)
                        ..setStrokeColor(PdfColor.fromInt(0xFF000000))
                        ..lineTo(0, ((nEndY - nStartY).toDouble() * -1))
                        ..strokePath();
                    }
                  }
                }
            )
        );
      }
      else{
        return pdfWidget.Container();
      }
  }

  pdfWidget.Widget drawScoreBottom(BuildContext context, pdfWidget.ImageProvider image, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex){
    double top = 3424;
    // double top = 3024;
    double left = 24;
    double width = 2432;
    double height = 83;

    if(httpCommunicate.bIsPreViewScore == false){
      if(httpCommunicate.nFileDataType != 2){
        return pdfWidget.Stack(
          children: [

            pdfWidget.Positioned(
              top: top,
              left: left,
              child: pdfWidget.Container(
                width: width,
                height: height,
                color: PdfColor.fromInt(0xFFFFFFFF),
              ),
            ),

            pdfWidget.Positioned(
              top: top,
              left: left,
              child: pdfWidget.Container(
                width: width,
                height: height,
                alignment: pdfWidget.Alignment.topCenter,
                child: pdfWidget.Text(
                  '${nCurPage + 1} / ${context.read<PDFProvider>().scorePageData.length}',
                  style: pdfWidget.TextStyle(
                    font: context.read<CustomFontProvider>().SOURCE_HANSANS_NORMAL,
                    fontSize: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nEmSize!.toDouble(),
                  ),
                ),
              ),
            ),

            pdfWidget.Positioned(
              top: top,
              left: left,
              child: pdfWidget.Container(
                width: width,
                height: height,
                alignment: pdfWidget.Alignment.topLeft,
                child: pdfWidget.Text(
                  context.read<PDFProvider>().strUserID,
                  style: pdfWidget.TextStyle(
                      font: context.read<CustomFontProvider>().SOURCE_HANSANS_NORMAL,
                      fontSize: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nEmSize!.toDouble(),
                      color: const PdfColor.fromInt(0xFF000000)
                  ),
                ),
              ),
            ),

            pdfWidget.Positioned(
              top: top,
              left: left,
              child: pdfWidget.Container(
                width: width,
                height: height,
                alignment: pdfWidget.Alignment.topRight,
                child: pdfWidget.Image(image, width: 190, height: 72),
              ),
            ),

          ],
        );
      }
      else{
        return pdfWidget.Stack(
          children: [
            pdfWidget.Positioned(
              top: top,
              left: left,
              child: pdfWidget.Container(
                width: width,
                height: height,
                alignment: pdfWidget.Alignment.topCenter,
                child: pdfWidget.Text(
                  '${nCurPage + 1} / ${context.read<PDFProvider>().scorePageData.length}',
                  style: pdfWidget.TextStyle(
                    font: context.read<CustomFontProvider>().SOURCE_HANSANS_NORMAL,
                    fontSize: 36,
                  ),
                ),
              ),
            ),

            pdfWidget.Positioned(
              top: top,
              left: left,
              child: pdfWidget.Container(
                width: width,
                height: height,
                alignment: pdfWidget.Alignment.topLeft,
                child: pdfWidget.Text(
                  context.read<PDFProvider>().strUserID,
                  style: pdfWidget.TextStyle(
                      font: context.read<CustomFontProvider>().SOURCE_HANSANS_NORMAL,
                      fontSize: 36,
                      color: const PdfColor.fromInt(0xFF000000)
                  ),
                ),
              ),
            ),

            pdfWidget.Positioned(
              top: top,
              left: left,
              child: pdfWidget.Container(
                width: width,
                height: height,
                alignment: pdfWidget.Alignment.topRight,
                child: pdfWidget.Image(image, width: 190, height: 72),
              ),
            ),

          ],
        );
      }
    }
    else{
      return pdfWidget.Positioned(
        top: top,
        left: left,
        child: pdfWidget.Container(
          width: width,
          height: height,
          color: PdfColor.fromInt(0xFFFFFFFF),
        ),
      );
    }

  }

  ///메뉴 그리기
  pdfWidget.Widget drawMenuString(BuildContext context, HttpCommunicate httpCommunicate, pdfWidget.ImageProvider image, int nCurPage, int nDrawIndex) {


    bool bFlag = context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].bFlag!;
    // int nSongInfoMaxLength = context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nEmSize!;
    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nStaffNum!;

    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...

      if (nStaffNum < nTotalStaffNum) {
        ///SJW Modify 2023.02.08 Start...
        ///인쇄 모드라면 매 페이지 마다 그려야 하기 때문에 페이지 별로 실행되도록 빼서 실행
        // if(context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].strText!.contains('/') &&
        //     context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nPosY! > 3000){
        //
        //   if(httpCommunicate.bIsPreViewScore == false) {
        //     return drawScoreBottom(context, image, httpCommunicate, nCurPage, nDrawIndex);
        //   }
        //   return pdfWidget.Container();
        //
        // }
        // else{
        ///SJW Modify 2023.02.08 end...
          int nPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX! + context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nPosX!;
          int nPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY! + context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nPosY!;

          int nSongInfoMaxLength =
              context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nWidth! -
                  (context.read<PDFProvider>().nSongInfoMaxLength * (context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nEmSize!));

          return pdfWidget.Positioned(
            left: bFlag ? (nPosX + nSongInfoMaxLength).toDouble() : nPosX.toDouble(),
            top: nPosY.toDouble(),
            child: pdfWidget.Container(
              width: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nWidth!.toDouble(),
              height: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nHeight!.toDouble(),
              alignment: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].align!,
              // decoration: pdfWidget.BoxDecoration(
              //   border: pdfWidget.Border.all(),
              // ),
              // alignment: pdfWidget.Alignment.center,
              child: pdfWidget.Text(
                context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].strText!,
                // '희',
                textAlign: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].textAlign!,
                style: pdfWidget.TextStyle(
                  font: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].fontFamily!, //Font Family
                  // color: PdfColor.fromInt(context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].),
                  fontSize: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nEmSize!.toDouble(), //Font Size
                  fontWeight: pdfWidget.FontWeight.bold,
                ),
              ),
            ),
          );
        // }
      }
      else{
        return pdfWidget.Container();
      }
  }

  ///가사 그리기
  pdfWidget.Widget drawGasaString(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex) {

    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].nStaffNum ?? -1;

    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...

      if (nStaffNum < nTotalStaffNum) {

        int nPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX! +
            context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].nDrawPosX!;

        int nPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY! +
            context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].nDrawPosY!;

        // print('draw GASA[$nCurPage][$nDrawIndex]');
        return pdfWidget.Positioned(
          ///SJW Modify 2023.02.09 Start...
          ///오선지에 2중주 3중주 특정 문자가 너무 붙어서 좌표수정
          left: context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].nDrawHight != -1 ? nPosX.toDouble() :  nPosX.toDouble() + 10,
          top: context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].nDrawHight != -1 ? nPosY.toDouble() : nPosY.toDouble() + 5,
          ///SJW Modify 2023.02.09 End...
          child: pdfWidget.Container(
            // width: context.read<PDFProvider>().scorePageData[nCurPage].menuDataList![nDrawIndex].nWidth!.toDouble(),
            // height: rectHeight,
            alignment: pdfWidget.Alignment.centerRight,
            child: pdfWidget.Text(
              context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].strMenuString!,
              style: pdfWidget.TextStyle(
                font: context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].fontFamily!, //Font Family
                color: PdfColor.fromInt(context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].crColor!),
                fontSize: context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].nDrawHight != -1 ?
                  context.read<PDFProvider>().scorePageData[nCurPage].gasaDataList![nDrawIndex].nEmSize!.toDouble() :
                  context.read<CustomFontProvider>().nGasaSize[context.read<ScoreSizeProvider>().nScoreSizeValue + 2],
                fontWeight: pdfWidget.FontWeight.bold,
                  //Font Size
              ),
            ),
          ),
        );
      }
      else {
        // print('draw GASA2[$nCurPage][$nDrawIndex]');
        return pdfWidget.Container();
      }
  }

  ///SJW Modify 2022.11.29 Start...
  ///Score 그리기 합침
  pdfWidget.Widget drawFont(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex) {
     int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].nStaffNum!;

     int nTotalStaffNum = 0;

     if(httpCommunicate.bIsPreViewScore == true) {
       ///SJW Modify 2023.04.18 Start...
       ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
       if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
         nTotalStaffNum = 3;
       }
       else{
         nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
       }
     }
     else{
       nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
     }
     ///SJW Modify 2023.04.18 End...

      if (nStaffNum < nTotalStaffNum) {

        int nPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX! + context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].nPosX!;
        int nPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY! + context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].nPosY!;
        double fLineSize = context.read<CustomFontProvider>().nFontLineSize[context.read<ScoreSizeProvider>().nScoreSizeValue + 2];
        double fPosX = context.read<CustomFontProvider>().nFontSizePosX[context.read<ScoreSizeProvider>().nScoreSizeValue + 2];
        return pdfWidget.Positioned(
          left: nPosX.toDouble(),
          top:  nStaffNum == 0 ? nPosY.toDouble() + context.read<CustomFontProvider>().nFontLineSize[0] : nPosY.toDouble() + fLineSize,
          child: pdfWidget.Text(
              context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].nFontNo != -1
                  ? String.fromCharCode(context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].nFontNo!)
                  // : context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].strFont.toString(),
                  : String.fromCharCode(context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].nFontNo!),
              style: pdfWidget.TextStyle(
                font: context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].fontFamily!,
                fontSize: nStaffNum != 0 ? context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].nEmSize!.toDouble() : context.read<CustomFontProvider>().nScoreFontSize[1],
                color: PdfColor.fromInt(context.read<PDFProvider>().scorePageData[nCurPage].fontDataList![nDrawIndex].crColor),
                fontWeight: pdfWidget.FontWeight.normal,

              )
          ),
        );
      }
      else{
        return pdfWidget.Container();
      }
 }

 ///코드 그리기
  pdfWidget.Widget drawChord(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex/*, int nChordIndex*/) {
    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].nStaffNum!;

    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...

    if (nStaffNum < nTotalStaffNum) {

      int nPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX! + context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].nPosX!;
      int nPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY! + context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].nPosY!;

        return pdfWidget.Positioned(
          left: nPosX.toDouble(),
          top: nPosY.toDouble(),
          child: pdfWidget.Text(
              String.fromCharCodes(context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].nFontList!),
              // String.fromCharCode(context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].nFontList![0]),
              style: pdfWidget.TextStyle(
                font: context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].fontFamily!,
                fontSize: context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].nEmSize!.toDouble(),
                color: PdfColor.fromInt(context.read<PDFProvider>().scorePageData[nCurPage].chordDataList![nDrawIndex].crColor),
                fontWeight: pdfWidget.FontWeight.bold,
              )
          ),
        );

    }
    else {
      return pdfWidget.Container();
    }

  }

 _getActFontFamily(BuildContext context, int nCurPage, int nDrawIndex){
    switch(context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nFontSelect){
      case 0:
        return context.read<CustomFontProvider>().MAESTRO;
      case 2:
        return context.read<CustomFontProvider>().TIME_NEW_ROMAN;
      case 1:
        return context.read<CustomFontProvider>().MALGUN;
      default:
        if(context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nDrawPosY! < 270){
          return context.read<CustomFontProvider>().SOURCE_HANSANS_MEDIUM;
        }
        else {
          return context.read<CustomFontProvider>().SOURCE_HANSANS_NORMAL;
        }
    }
 }

 //ACT 그리기
  pdfWidget.Widget drawAct(BuildContext context, HttpCommunicate httpCommunicate, pdfWidget.ImageProvider image, int nCurPage, int nDrawIndex){
    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nStaffNum!;


    // print('act List length : ${context.read<PDFProvider>().scorePageData[nCurPage].actDataList!.length}');

    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...


      if(nStaffNum < nTotalStaffNum){
        int nPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX! + context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nDrawPosX!;
        int nPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY! + context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nDrawPosY!;
        double fLineSize = context.read<CustomFontProvider>().nFontLineSize[context.read<ScoreSizeProvider>().nScoreSizeValue + 2];

        // print('act data : ${'posX : $nPosX , poxY : $nPosY , data : ${context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nFontData != -1 ?
        // String.fromCharCode(context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nFontData!) :
        // context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].strFontData!}'}'

        return pdfWidget.Positioned(
          left: nPosX.toDouble(),
          top:  nPosY.toDouble() + context.read<CustomFontProvider>().nFontLineSize[0],
          child: pdfWidget.Text(
              context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nFontData != -1 ?
                String.fromCharCode(context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nFontData!) :
                context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].strFontData!,
              style: pdfWidget.TextStyle(
                font: _getActFontFamily(context, nCurPage, nDrawIndex),
                fontSize: context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nSize!.toDouble(),
                color: const PdfColor.fromInt(0xFF000000),
                fontWeight: context.read<PDFProvider>().scorePageData[nCurPage].actDataList![nDrawIndex].nFontStyle == 1 ? pdfWidget.FontWeight.bold : pdfWidget.FontWeight.normal,
              )
          ),
        );
      }
      else{
        return pdfWidget.Container();
      }

  }

  ///SJW Modify 2022.11.29 End...

  ///곡선 그리기
  pdfWidget.Widget drawPolyBezier(BuildContext context, HttpCommunicate httpCommunicate, int nCurPage, int nDrawIndex){

    int operator = context.read<PDFProvider>().scorePageData[nCurPage].polyBezierDataList![nDrawIndex].nUpDown == 2 ? 1 : -1;

    int nStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].polyBezierDataList![nDrawIndex].nStaffNum!;

    int nTotalStaffNum = 0;

    if(httpCommunicate.bIsPreViewScore == true) {
      ///SJW Modify 2023.04.18 Start...
      ///악보 크기로 인해 포지션 값이 2개만 넘어올 경우 예외처리
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nTotalStaffNum = 3;
      }
      else{
        nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length;
      }
    }
    else{
      nTotalStaffNum = context.read<PDFProvider>().scorePageData[nCurPage].nTotalStaffNum!;
    }
    ///SJW Modify 2023.04.18 End...

      if (nStaffNum < nTotalStaffNum) {
        int nZeroPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nX!;
        int nZeroPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![nStaffNum].nY!;

        int nStartX = nZeroPosX + context.read<PDFProvider>().scorePageData[nCurPage].polyBezierDataList![nDrawIndex].nStartX!;
        int nStartY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].polyBezierDataList![nDrawIndex].nStartY!;
        int nEndX = nZeroPosX + context.read<PDFProvider>().scorePageData[nCurPage].polyBezierDataList![nDrawIndex].nEndX!;
        int nEndY = nZeroPosY + context.read<PDFProvider>().scorePageData[nCurPage].polyBezierDataList![nDrawIndex].nEndY!;

        int crColor = context.read<PDFProvider>().scorePageData[nCurPage].polyBezierDataList![nDrawIndex].crColor!;
        int nBetween = nEndX - nStartX;

        ///중간 Y축 좌표
        int nMiddleY = 0;

        if(nStartY == nEndY){
          nMiddleY = nBetween > context.read<PDFProvider>().BASE_MEASURE_WIDTH
              ? operator * (context.read<PDFProvider>().BASE_LINE_SIZE * 2)
              : operator * (context.read<PDFProvider>().BASE_LINE_SIZE);
        }
        else{
          if(operator == 1){
            if(nStartY < nEndY){
              nMiddleY = context.read<PDFProvider>().BASE_LINE_SIZE * operator;
            }
            else{
              nMiddleY = ((nStartY - nEndY) + context.read<PDFProvider>().BASE_LINE_SIZE) * operator;
            }
          }
          else{
            if(nStartY < nEndY){
              nMiddleY = (nEndY - nStartY + context.read<PDFProvider>().BASE_LINE_SIZE) * operator;
            }
            else{
              nMiddleY = context.read<PDFProvider>().BASE_LINE_SIZE * operator;
            }
          }
        }

        double fWidth = 2;
        return pdfWidget.Positioned(
          top: nStartY.toDouble(),
          left: nStartX.toDouble(),
          // child: pdfWidget.Text('TEST', style: pdfWidget.TextStyle(fontSize: 40))
          child: pdfWidget.CustomPaint(
              painter: (PdfGraphics canvas, PdfPoint size){
                canvas
                  ..moveTo(0, 0)
                  ..setStrokeColor(PdfColor.fromInt(crColor))
                  ..setLineWidth(fWidth)
                  //kkondae Modify 2023.01.26 Start...
                  //..curveTo(0, 0, nBetween / 2, nMiddleY.toDouble(), nBetween.toDouble(), (nEndY - nStartY).toDouble() < 0 ? (nEndY - nStartY).toDouble() * -1 : (nEndY - nStartY).toDouble())
                  ..curveTo(0, 0, nBetween / 2, nMiddleY.toDouble(), nBetween.toDouble(),  (nEndY - nStartY).toDouble() * -1 )
                  ..strokePath();
              }),

        );
      }
      else{
        return pdfWidget.Container();
      }

  }

  ///워터 마킹 그리기
  pdfWidget.Widget drawWatermarking(String strUserId, pdfWidget.ImageProvider image, double opacity, pdfWidget.Font mediumFont){
    int nWidth = 2480 ~/ 3;
    int nHeight = (260 * nWidth) ~/ 689;


    // print('context.read<PDFProvider>().strUserID.toString() : ${context.read<PDFProvider>().strUserID.toString()}');
    return pdfWidget.Positioned(
      top: (3508/2) - nHeight,
      left: (2480/2) - (nWidth/2),
      child: pdfWidget.Column(
        children: [
          ///엘프 로고
          pdfWidget.Opacity(
            opacity: opacity, ///투명도
            child: pdfWidget.SizedBox(
              width: nWidth.toDouble(),
              height:  nHeight.toDouble(),
              child: pdfWidget.Watermark(
                child: pdfWidget.Image(image),
              ),
            ),
          ),

          ///UserName
          pdfWidget.Opacity(
            opacity: opacity,
            child: pdfWidget.Text(
              strUserId,
              style: pdfWidget.TextStyle(
                fontSize: 80,
                fontWeight: pdfWidget.FontWeight.normal,
                font: mediumFont,
                color: PdfColor.fromInt(0xFFD2D2D2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  drawCutPaper(BuildContext context, pdfWidget.ImageProvider image, HttpCommunicate httpCommunicate, int nCurPage) {

    if(httpCommunicate.nFileDataType != 2){

      ///SJW Modify 2023.04.18 Start...
      ///악보 사이즈로 인한 오류수정
      int nPosX = -1;
      int nPosY = -1;
      if(context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList!.length > 2) {
        nPosX = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![3].nX!;
        nPosY = context.read<PDFProvider>().scorePageData[nCurPage].staffNumPositionDataList![3].nY!;
      }
      ///SJW Modify 2023.04.18 End...

      print('nPosX : $nPosX');
      print('nPosY : $nPosY');

      return nPosY != -1 ? pdfWidget.Positioned(
        left: 0,
        top: nPosY.toDouble(),
        // left: 0,
        // top: 1000,
        child: pdfWidget.SizedBox(
          width: 2480,
          child: pdfWidget.Image(image),
        ),
      ) : pdfWidget.Container();
    }
    else{
      return pdfWidget.Positioned(
        left: 0,
        top: 1400,
        child: pdfWidget.SizedBox(
          width: 2480,
          child: pdfWidget.Image(image),
        ),
      );
    }
  }

  // convertTiffToPng(BuildContext context, HttpCommunicate httpCommunicate, List<String> tiffPath) async {
  //   final dir = await getTemporaryDirectory();
  //
  //   print('tiff Path : $tiffPath}');
  //   for(int i=0; i<tiffPath.length; i++){
  //     File tiffFile = File(tiffPath[i]);
  //     imgLib.Image? image = imgLib.decodeImage(tiffFile.readAsBytesSync());
  //     imgLib.Image copyImg = imgLib.copyResize(image!, width: 2480, height: 3508);
  //     imgLib.Image transImage = await colorTransparent(copyImg, 255, 255, 255);
  //     File pngImage = File('/${dir.path}/${httpCommunicate.nSongNo}_00${i+1}.png')..writeAsBytesSync(imgLib.encodePng(transImage));
  //     context.read<PDFProvider>().addScorePngList(pngImage);
  //   }
  //   print('pngPath : ${context.read<PDFProvider>().scorePngList}');
  // }
  //
  // Future<imgLib.Image> readTiff(String tiffFile) async {
  //   imgLib.Image? image = imgLib.decodeImage(File(tiffFile).readAsBytesSync());
  //   imgLib.Image transparentImage = await colorTransparent(image!, 255, 255, 255);
  //   return transparentImage;
  // }


  Future<imgLib.Image> readTiff(String tiffPath) async {
    imgLib.Image? image = imgLib.decodeImage(await File(tiffPath).readAsBytes());
    imgLib.Image transImage = await colorTransparent(image!, 255, 255, 255);

    return transImage;
  }

  Future<File> writePng(Map<String, dynamic> arg) async {
    String pngPath = arg['path'];
    imgLib.Image image = arg['image'];

    File pngImage = await File(pngPath).writeAsBytes(imgLib.encodePng(image));

    return pngImage;
  }

  convertTiffToPng(BuildContext context, HttpCommunicate httpCommunicate, List<String> tiffPath) async {
    final dir = await getTemporaryDirectory();

    // print('tiff Path : $tiffPath}');
    for(int i=0; i<tiffPath.length; i++){
      String strTiffPath = tiffPath[i];


      imgLib.Image transImage = await compute(readTiff, strTiffPath); ///tiff read byte (스레드)

      String pngPath = '/${dir.path}/${httpCommunicate.nSongNo}_00${i+1}.png';
      Map<String, dynamic> map = {
        "path" : pngPath,
        "image" : transImage
      };
      File pngImage = await compute(writePng, map); ///write png byte (스레드)

      context.read<PDFProvider>().addScorePngList(pngImage);
    }
    // print('pngPath : ${context.read<PDFProvider>().scorePngList}');
  }

  static Future<imgLib.Image> colorTransparent(imgLib.Image src, int red, int green, int blue) async {
    var pixels = src.getBytes();
    for (int i = 0, len = pixels.length; i < len; i += 4) {
      if(pixels[i] == red
          && pixels[i+1] == green
          && pixels[i+2] == blue
      ) {
        pixels[i + 3] = 0;
      }
    }

    return src;
  }

}

Future<List<FileSystemEntity>> getTiffList(int num) async {
  List<FileSystemEntity> _dirFiles = [];
  final dir = await getTemporaryDirectory()..createSync(recursive: true);
  String dirPath = dir.path + '/';
  final myDir = Directory(dirPath);
  _dirFiles = myDir.listSync();

  print("tiffFIles : $_dirFiles");

  return _dirFiles;
}



