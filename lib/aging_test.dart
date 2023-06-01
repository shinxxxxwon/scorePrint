
import 'dart:io';
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:provider/provider.dart';

class AgingTest extends StatefulWidget {
  const AgingTest({Key? key, this.agingData, this.httpCommunicate}) : super(key: key);

  final HttpCommunicate? httpCommunicate;
  final List<String>? agingData;

  @override
  State<AgingTest> createState() => _AgingTestState();
}

class _AgingTestState extends State<AgingTest> {

  final platform = MethodChannel("native.flutter.kisatest");
  Uint8List? uintData;
  int C02 = 0;
  int C03 = 3;

  Future<bool> Compress(int index, File agingFile) async{


    if(agingFile.existsSync()) {
      print("Aging Fiel exists : ${agingFile.path}");

      List<String> temp = agingFile.path.split("/");
      String strFileName = temp.last.toString().split(".")[0];
      final dir = await getTemporaryDirectory();


      Map<String, String> map = {
        'ftpFilePath': agingFile.path,
        'p0FilePath': '${dir.path}/$strFileName.P03'
      };


      BridgeNative bridgeNative = BridgeNative();

      int nSize = await bridgeNative.compressorFile(agingFile.path, map);
      print('aging compressor res = $nSize');
      return true;
    }
    return false;
  }

  DrawPdf(BuildContext context, int nSongNo) async{
    pdfWidget.Document? scorePdf;

    int res = await platform.invokeMethod('DrawStart');
    scorePdf = await context.read<PDFProvider>().addScorePDF(context, widget.httpCommunicate!, false);
    Uint8List temp = await scorePdf.save();
    uintData = temp;
    print('pdf Data size : ${uintData!.lengthInBytes}');

    File pdfFile = File('/storage/emulated/0/Documents/C03/pdf/${nSongNo.toString()}.pdf')..createSync(recursive: true);
    await pdfFile.writeAsBytes(uintData!);
  }

  Aging(BuildContext context) async {
    int nStartNum = 0;
    int nEndNum = widget.agingData!.length;

    DrawScore drawScore = DrawScore();
    for(int i=1; i<2; i++) {
      int nResult = (i ~/ 100) * 100;
      File agingFile = File('/storage/emulated/0/Documents/C03/$nResult/$i.C03');

      // Directory cacheDir = await getTemporaryDirectory()..createSync(recursive: true);
      // File cacheFile = File("$cacheDir/$i.C03");

      // bool bCopy = await CopyDocumentFile(agingFile, cacheDir.path, cacheFile.path);
      if(agingFile.existsSync()){
        bool bCopy = await CopyDocumentFile(agingFile, i.toString());
        if (bCopy) {
          bool bres = await Compress(i, agingFile);
          if (bres) {
            int nSongNo = i;
            await DrawPdf(context, nSongNo);
            // drawScore.showCacheDirList();
            await Future.delayed(const Duration(seconds: 1));
            await deleteCacheDir();
            // drawScore.showCacheDirList();
          }
        }
      }

    }
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    cacheDir.deleteSync(recursive: true);
    // print('delete cacheDir');
  }

  // Future<bool> CopyDocumentFile(File documentFile, String cachePath, String cacheFile) async {
  Future<bool> CopyDocumentFile(File documentFile, String strSonNo) async {

    print("copy");
    final Directory cacheDir = await getTemporaryDirectory()..createSync(recursive: true);

    // File copyFile = await documentFile.copy("$cacheDir/$strSonNo.C03");
    final File copyFile = File('${cacheDir.path}/${strSonNo.toString()}.C03');
    await copyFile.writeAsBytes(documentFile.readAsBytesSync());

    if(copyFile.existsSync()){
      print('documentFile Size : ${documentFile.lengthSync()}');
      print('C03File Size : ${copyFile.lengthSync()}');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Aging(context);

    return ScoreView(scoreData: uintData!);
  }
}

class ScoreView extends StatefulWidget {
  const ScoreView({Key? key, this.scoreData}) : super(key: key);

  final Uint8List? scoreData;

  @override
  State<ScoreView> createState() => _ScoreViewState();
}
///Pdf View
class _ScoreViewState extends State<ScoreView> {
  PdfControllerPinch? pdfController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfController = PdfControllerPinch(document: PdfDocument.openData(widget.scoreData!));
  }

  @override
  void didUpdateWidget(covariant ScoreView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.scoreData != widget.scoreData){
      pdfController!.loadDocument(PdfDocument.openData(widget.scoreData!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdfViewPinch(
      scrollDirection: Axis.vertical,
      padding: 0,
      pageLoader: Center(child: CircularProgressIndicator()),
      controller: pdfController!,
    );
  }
}

