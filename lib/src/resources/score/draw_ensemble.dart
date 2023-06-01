import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';

import 'package:elfscoreprint_mobile/src/providers/custom_font_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';


class DrawEnsemble {
  DrawEnsemble(this.imageList, this.sendPort, this.strUserId, this.strDispNumber, this.bIsPreview, this.nLength, this.cutPaperImage, this.watermakingImage, this.underElfImage, this.normalFont, this.mediumFont);

  final List<File> imageList;
  final SendPort sendPort;
  final String strUserId;
  final String strDispNumber;
  final bool bIsPreview;
  final int nLength;
  final Uint8List cutPaperImage;
  final Uint8List watermakingImage;
  final Uint8List underElfImage;
  final pdfWidget.Font normalFont;
  final pdfWidget.Font mediumFont;
}

void drawEnsembleScore(DrawEnsemble drawEnsemble) async {

  DrawScore drawScore = DrawScore();
  pdfWidget.Document scorePdf = pdfWidget.Document();


  final cutpaperImage = pdfWidget.MemoryImage(drawEnsemble.cutPaperImage);
  final watermarkingImage = pdfWidget.MemoryImage(drawEnsemble.watermakingImage);
  final underElfimage = pdfWidget.MemoryImage(drawEnsemble.underElfImage);

  final normalFont = drawEnsemble.normalFont;
  final mediumFont = drawEnsemble.mediumFont;

  for(int nCurPage=0; nCurPage<drawEnsemble.nLength; nCurPage++){
    File imageFile = File(drawEnsemble.imageList[nCurPage].path);
    final image = pdfWidget.MemoryImage(imageFile.readAsBytesSync());

    if(drawEnsemble.bIsPreview == true){
      scorePdf.addPage(
        pdfWidget.Page(
          pageFormat: PdfPageFormat.a4, ///2480 * 3508
          build: (pdfWidget.Context pContext){
            return pdfWidget.Stack(
              children: [

                pdfWidget.Column(
                  children: [

                    pdfWidget.AspectRatio(
                      aspectRatio: 80/42,
                      child: pdfWidget.Container(
                        decoration: pdfWidget.BoxDecoration(
                          image: pdfWidget.DecorationImage(
                            fit: pdfWidget.BoxFit.fitWidth,
                            alignment: pdfWidget.Alignment.topCenter,
                            image: image,
                          ),
                        ),
                      ),
                    ),

                    pdfWidget.Container(
                      width: 2480,
                      child: pdfWidget.Image(cutpaperImage),
                    ),
                  ],
                ),

                pdfWidget.Positioned(
                  top: 90,
                  left: 2100,
                  child: pdfWidget.Container(
                    width: 300,
                    height: 100,
                    color: PdfColor.fromInt(0xFFFFFFFF),
                  ),
                ),

                pdfWidget.Positioned(
                  top: 90,
                  left: 2100,
                  child: pdfWidget.Container(
                    width: 300,
                    height: 100,
                    alignment: pdfWidget.Alignment.centerRight,
                    child: pdfWidget.Text(
                      drawEnsemble.strDispNumber,
                      style: pdfWidget.TextStyle(
                        font: mediumFont,
                        fontSize: 56,
                      ),
                    ),
                  ),
                ),

              ],
            );
          },
        ),
      );
    }
    else{
      scorePdf.addPage(
        pdfWidget.Page(
            pageFormat: PdfPageFormat.a4, ///2480 * 3508
            build: (pdfWidget.Context pContext){
              return pdfWidget.Stack(
                children: [

                  drawScore.drawWatermarking(drawEnsemble.strUserId, watermarkingImage, 1.0, mediumFont),

                  pdfWidget.Container(
                    width: 2480,
                    height: 3508,
                    child: pdfWidget.Image(image, fit: pdfWidget.BoxFit.fill),
                  ),


                  pdfWidget.Positioned(
                    top: 100,
                    left: 2190,
                    child: pdfWidget.Container(
                      width: 201,
                      height: 90,
                      color: PdfColor.fromInt(0xFFFFFFFF),
                    ),
                  ),

                  pdfWidget.Positioned(
                    top: 100,
                    left: 2190,
                    child: pdfWidget.Container(
                      width: 201,
                      height: 100,
                      alignment: pdfWidget.Alignment.centerRight,
                      child: pdfWidget.Text(
                        drawEnsemble.strDispNumber,
                        style: pdfWidget.TextStyle(
                          font: mediumFont,
                          fontSize: 48,
                        ),
                      ),
                    ),
                  ),

                  // drawScore.drawWatermarking(context, watermarkingImage, httpCommunicate),

                  pdfWidget.Positioned(
                    top: 3424,
                    left: 24,
                    child: pdfWidget.Container(
                      width: 2432,
                      height: 83,
                      alignment: pdfWidget.Alignment.topCenter,
                      child: pdfWidget.Text(
                        '${nCurPage + 1} / ${drawEnsemble.nLength}',
                        style: pdfWidget.TextStyle(
                          font: normalFont,
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),

                  pdfWidget.Positioned(
                    top: 3424,
                    left: 24,
                    child: pdfWidget.Container(
                      width: 2432,
                      height: 83,
                      alignment: pdfWidget.Alignment.topLeft,
                      child: pdfWidget.Text(
                        drawEnsemble.strUserId,
                        style: pdfWidget.TextStyle(
                            font: normalFont,
                            fontSize: 36,
                            color: PdfColor.fromInt(0xFF000000)
                        ),
                      ),
                    ),
                  ),

                  pdfWidget.Positioned(
                    top: 3424,
                    left: 24,
                    child: pdfWidget.Container(
                      width: 2432,
                      height: 83,
                      alignment: pdfWidget.Alignment.topRight,
                      child: pdfWidget.Image(underElfimage, width: 190, height: 72),
                    ),
                  ),


                ],
              );
            }
        ),
      );
    }
  }

  drawEnsemble.sendPort.send(await scorePdf.save());
}


