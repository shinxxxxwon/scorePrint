import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/custom_font_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/score_data_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/transposition_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_ensemble.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:elfscoreprint_mobile/src/resources/score/score_info_controller.dart';
import 'package:elfscoreprint_mobile/src/screens/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:image/image.dart' as imgLib;

class BridgeNative{
  final platform = MethodChannel("native.flutter.kisatest");
  bool bTiffConvertRes = false;

  PreventCapture() async{
    await platform.invokeMethod("preventCapture");
  }

  OpenChrome() async {
    await platform.invokeMethod("OpenChrome");
    Platform.isAndroid
        ? SystemChannels.platform.invokeMethod('SystemNavigator.pop')
        : exit(0);
  }

  GetSongInfoMaxLength(BuildContext context) async {
    context.read<PDFProvider>().setSongInfoMaxLength(await platform.invokeMethod('GetSongInfoMaxLength'));
    print('songInfOMaxLength : ${context.read<PDFProvider>().nSongInfoMaxLength}');
  }

  ///색소폰 2중주, 3중주 ALTO, TENOR 키값 오차 데이터 받기
  GetSaxPhoneInfo() async {
    await platform.invokeMethod('GetSaxPhoneInfo');
  }

  InitSongInfoMaxLength() async{
    await platform.invokeMethod('InitSongInfoMaxLength');
  }

  downloadFiles(bool bP02Copy, int nP02Size, Map<String, String> data) async {
    ///P0 파일 Download 폴더에 복사
    if (nP02Size != 0 && nP02Size > 0) {
      if (bP02Copy) {
        Map<String, String> map = data;
        print('downloadFiles maap : $map');
        String strDownloadFilepath = await platform.invokeMethod('Save_P02_File_Storage', map);
        return strDownloadFilepath;
      }
    }
  }

  compressorFile(String file, Map<String, String> ftpFilePath) async{
    int nSize = 0;
    //print('compressorFile(file) : ${file}');
    //print('compressorFile(map) : ${ftpFilePath}');

    ///C01과 C02, C03별 Compress나눔 이유는 변환되는 파일이 다름(tiff, P02, P03)
    if(file.contains(".C01")){
      ///지금은 페이지 수를 받을수 없지만 추후에 받으면 반복문으로 이미지 저장후 불러내야함(현재 마지막 페이지만 파일로 떨어짐)
       nSize = await platform.invokeMethod('Compress_C02', ftpFilePath);
      // print('Compress_C02 result : $nSize');
    }
    else{//C02 or C03
      nSize = await platform.invokeMethod('Compress_C02', ftpFilePath);
      // print('Compress_C02 result : $nSize');
    }
    // print('compressorFile done');

    // print('compress end');
    return nSize;
  }

  ///PDF 그리는 함수
  ///Flutter -> JAVA -> 이후 반복 :: ( C -> JAVA(method) -> Flutter -> C)(callback)
  Future<void> callDrawFromModule(BuildContext context, HttpCommunicate httpCommunicate, bool bFirst, bool bFirstLoad) async {
    ScoreInfoController scoreInfoController = ScoreInfoController();
    pdfWidget.Document? scorePdf;

    DrawScore drawScore = DrawScore();

    PaintingBinding.instance!.imageCache!.clear();

   if(httpCommunicate.nFileDataType != 1){
     await scoreInfoController.postDataToModule(context, httpCommunicate); ///서버 & 설정 데이터 POST



     Map<String, dynamic> data = {
       'SongNo':httpCommunicate.nSongNo!,
       'FileDataType':httpCommunicate.nFileDataType!,
       'P0Path':context.read<ScoreDataProvider>().strP0Path
     };

     if(bFirst){
       debugPrint('drawStart');
       int res = await platform.invokeMethod('DrawStart', data); ///C++ 에서 악보 데이터 계산 시작
     }
     else{
       debugPrint('reDrawStart');
       int res = await platform.invokeMethod('ReDrawScore'); ///C++ 에서 악보 다시 그리기
     }

     ///SJW Modify 2023.01.04 start
     /// 테스트로 인한 주석 그리는 부분
    // scorePdf = await context.read<PDFProvider>().addPDFTest(context, httpCommunicate, false);
    //  print('add pdf');
     print('draw 1');
     scorePdf = await context.read<PDFProvider>().addScorePDF(context, httpCommunicate, false);
     // print('add pdf done');
     if(httpCommunicate.bIsPreViewScore == false) {
       // await context.read<PDFProvider>().editPDF(scorePdf, context, httpCommunicate);
     }

     // print('score save');
     // Uint8List uintData = await scorePdf.save();
     // print('score save done');
     //
     // print("uintData length : ${uintData.length}");
     //
     // context.read<PDFProvider>().setPdfData(uintData);
     ///SJW Modify 2023.01.04 end...

     print('draw 2');
     Uint8List uintData = await scorePdf.save();

     print('draw 3');
     context.read<PDFProvider>().setPdfData(uintData);

     print('draw 4');
     context.read<PDFProvider>().nKeyValue++;

     print('draw 5');
     context.read<PDFProvider>().setDataInit();
   }
   else{
     final dir = await getTemporaryDirectory();

     List<String> tiffPath = await drawScore.getTiffFiles(httpCommunicate);
     context.read<PDFProvider>().nTiffTotalNum = tiffPath.length;

     // print('tiffPath : $tiffPath');
     if(tiffPath.length > 0){
       // await drawScore.convertTiffToPng(context, httpCommunicate, tiffPath);

       ///SJW Modify 2023.04.04 Start...
       ///앙상블 악보 OpenCV로 변경
       int nLoop = 0;
       if(httpCommunicate.bIsPreViewScore!){
         //미리보기
         nLoop = 1;
       }
       else{
         nLoop = tiffPath.length;
       }
      for(int i=0; i<nLoop; i++){

        Map<String, String> data = {
          'Path' : dir.path,
          'Tiff' : tiffPath[i],
          'Name' : httpCommunicate.nDispNumber.toString() + '_' + i.toString()
        };

        print('png Path : ${data['Name']!}.png');
        await platform.invokeMethod("GetEnsembleImage", data);
        // await waitingForConvertTiff();
        if(Platform.isAndroid) {
          await Future.delayed(const Duration(milliseconds: 1000));
        }
        context.read<PDFProvider>().addScorePngList(File(data['Path']! + '/' + data['Name']! + '.png'));
        print('done getEnsembleimage');
        drawScore.showCacheDirList();
      }
      ///SJW Modify 2023.04.04 End...-

       ///SJW Modify 2023.02.06 Start...
       ///Tiff 스레드처리
       int n = await getEnsembleSocre(context, httpCommunicate);
       ///SJW Modify 2023.02.06 End...
     }
     else{//연결 해제
       //Error
       print('Tiff Count 0');
     }
   }


    if(bFirstLoad) {
      if (scoreInfoController.isApplayTrioSong(httpCommunicate)) {
        scoreInfoController.setKeyChordTransPosList(context, httpCommunicate, context.read<TranspositionProvider>().pKeyChordTransPos1[11 + context.read<TranspositionProvider>().nTrioTrans1].strKeyChord!, 0);
        scoreInfoController.setKeyChordTransPosList(context, httpCommunicate, context.read<TranspositionProvider>().pKeyChordTransPos2[11 + context.read<TranspositionProvider>().nTrioTrans2].strKeyChord!, 1);
        scoreInfoController.setKeyChordTransPosList(context, httpCommunicate, context.read<TranspositionProvider>().pKeyChordTransPos3[11 + context.read<TranspositionProvider>().nTrioTrans3].strKeyChord!, 2);
      }
    }
  }


  Future<imgLib.Image> colorTransparent(imgLib.Image src, int red, int green, int blue) async {
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

  getEnsembleSocre(BuildContext context, HttpCommunicate httpCommunicate) async {
    final completer = Completer<void>();
    final receivePort = ReceivePort();

    String strUserId = context.read<PDFProvider>().strUserID;
    String strDispNumber = httpCommunicate.nDispNumber.toString();
    bool bIsPreview = httpCommunicate.bIsPreViewScore!;
    int nLength = context.read<PDFProvider>().scorePngList.length;
    List<File> imageList = context.read<PDFProvider>().scorePngList;

    final cutpaperImage = (await rootBundle.load('assets/images/CutPaper.png')).buffer.asUint8List();
    final watermarkingImage = (await rootBundle.load('assets/images/ELF_CI.png')).buffer.asUint8List();
    final underElfimage = (await rootBundle.load('assets/images/ELF_CI2.png')).buffer.asUint8List();

    pdfWidget.Font normalFont = context.read<CustomFontProvider>().SOURCE_HANSANS_NORMAL;
    pdfWidget.Font mediumFont = context.read<CustomFontProvider>().SOURCE_HANSANS_MEDIUM;


    receivePort.listen((dynamic data) async {
      if(data is Uint8List){
        context.read<PDFProvider>().setPdfData(data);
      }
      completer.complete();
    });

    final isolate = await Isolate.spawn<DrawEnsemble>(
        drawEnsembleScore,
        DrawEnsemble(imageList, receivePort.sendPort, strUserId, strDispNumber, bIsPreview, nLength, cutpaperImage, watermarkingImage, underElfimage, normalFont, mediumFont)
    );

    // print('await pdf to be generated');
    await completer.future;
    receivePort.close();

    return 1;
  }

  ///Flutter -> JAVA URL Data 전달
  Future<void> GetWebServerData(Map<String, dynamic> urlData) async {
    // print('getWebserverData : $urlData');
    await platform.invokeMethod('GetWebServerData', urlData);
  }

  ///Flutter -> JAVA userSettings data 전달
  Future<void> GetScoreData(Map<String ,dynamic> settingsData) async {
    await platform.invokeMethod('GetScoreData', settingsData);
  }

  ///JAVA에서 악보 데이터를 줄때 이 함수를 호출 함
  int getScoreDataFromModule(BuildContext context, HttpCommunicate httpCommunicate) {
    platform.setMethodCallHandler((call) async {

      ///get 색소폰 3중주 이조 데이터
      if(call.method == 'GetSaxPhoneInfo'){
        int nTrans1 = call.arguments['Trans1'];
        int nTrans2 = call.arguments['Trans2'];
        int nTrans3 = call.arguments['Trans3'];
        context.read<TranspositionProvider>().nTrioTrans1 = nTrans1;
        context.read<TranspositionProvider>().nTrioTrans2 = nTrans2;
        context.read<TranspositionProvider>().nTrioTrans3 = nTrans3;
      }

      ///JAVA에서 Length 데이터 요청
      if(call.method == "getFontData"){
        //Pass Length Data 매개변수로 보냄
        int res = await platform.invokeMethod('passFontData', 10);
        print('getLength result : $res');

        return 1;
      }
      ///font Heigth pass to JAVA -> C
      ///native에서 처리하는걸로 바꿈
      if(call.method == "GetMenuStringHeight"){
        int nStaffNum = call.arguments['StaffNum'];
        String strMenuString = call.arguments['MenuString'];
        int nKind = call.arguments['Kind'];
        int nLineSize = call.arguments['LineSize'];
        int nEdge = call.arguments['Edge'];
        int nCountry = call.arguments['Country'] ?? 0;

        // print('GetMenuStringHeight Flutter ${call.arguments}');

        ///get MenuString height method
        await context.read<CustomFontProvider>().getMenuStringHeight(context, httpCommunicate, strMenuString, nKind, nLineSize, nEdge, nCountry);

        // print('context.read<CustomFontProvider>().fontHeight.toInt() : ${context.read<CustomFontProvider>().fontHeight.toInt()}');
        ///Flutter -> JAVA로 Menu 높이 데이터 전달
        int res = await platform.invokeMethod('GetMenuStringHeight', context.read<CustomFontProvider>().fontHeight.toInt());
        //print('GetMenuStringHeight res = $res');

        return 1;
      }
      ///font Width pass to JAVA -> C
      ///native에서 처리하는걸로 바꿈
      if(call.method == "GetMenuStringWidth"){
        int nStaffNum = call.arguments['StaffNum'];
        String strMenuString = call.arguments['MenuString'];
        int nMaxWidth = call.arguments['MaxWidth'];
        int nKind = call.arguments['Kind'];
        int nLineSize = call.arguments['LineSize'];
        int nEdge = call.arguments['Edge'];
        int nCountry = call.arguments['Country'] ?? 0;

        ///get MenuString width method
        await context.read<CustomFontProvider>().getMenuStringWidth(context, httpCommunicate, nMaxWidth, strMenuString, nKind, nLineSize);

        ///Fluter -> JAVA로 Menu totalWidth 전달
        int res = await platform.invokeMethod('GetMenuStringWidth', context.read<CustomFontProvider>().fontWidth.toInt());
        print('GetMenuStringWidth res = $res');

        return 1;
      }
      ///가사 font 높이 데이터 전달
      if(call.method == 'GetMenuStringHeightGasa'){
        int nStaffNum = call.arguments['StaffNum'];
        String strMenuString = call.arguments['MenuString'];
        int nDrawHight = call.arguments['DrawHight'];

        ///get MenuStringGasa height method
        context.read<CustomFontProvider>().getMenuStringHeightGasa(context, httpCommunicate, strMenuString, nDrawHight);

        ///Flutter -> JAVA로 가사 높이 전달
        int res = await platform.invokeMethod('GetMenuStringHeightGasa', context.read<CustomFontProvider>().fontHeight.toInt());

        print('GetMenuStringHeightGasa res = $res');

        return 1;
      }
      ///가사 font width 데이터 전달
      if(call.method == 'GetMenuStringWidthGasa'){
        int nStaffNum = call.arguments['StaffNum'];
        String strMenuString = call.arguments['MenuString'];
        int nDrawHight = call.arguments['DrawHight'];

        ///get MenuStringGasa height method
        context.read<CustomFontProvider>().getMenuStringHeightGasa(context, httpCommunicate, strMenuString, nDrawHight);

        ///Flutter -> JAVA 가사 넓이 전달
        int res = await platform.invokeMethod('GetMenuStringWidthGasa', context.read<CustomFontProvider>().fontWidth.toInt());

        // print('GetMenuStringWidthGasa res = $res');

        return 1;
      }

      if(call.method == 'tiffConvertDone'){
        bTiffConvertRes = call.arguments['Result'];
        print('tiffConvertDone : $bTiffConvertRes');
        return 1;
      }

      ///메뉴 그리는데 필요한 정보 저장
      if(call.method == 'DrawMenuString'){

        int nStaffNum = call.arguments['StaffNum'];
        String strMenuString = call.arguments['MenuString'];
        int nLeft = call.arguments['Left'];
        int nTop = call.arguments['Top'];
        int nRight = call.arguments['Right'];
        int nBottom = call.arguments['Bottom'];
        int nColor = call.arguments['Color'] ?? 0xFF000000;
        int nKind = call.arguments['Kind'];
        int nLineSize = call.arguments['LineSize'];
        int nLineAlign = call.arguments['LineAlign'] ?? 1;
        int nAlignment = call.arguments['Alignment'] ?? 1;
        bool isAnti = call.arguments['Anti'] ?? true;
        int nCountry = call.arguments['Country'] ?? 0;
        bool bIsNoScale = call.arguments['Scale'] ?? false;
        bool bFlag = call.arguments['Flag'] ?? false;

        // print('flutter draw menu String =  posX : $nLeft, posY : $nTop, str : $strMenuString');
        
        ///메뉴 데이터 저장하는 함수 호출
        context.read<CustomFontProvider>().drawMenuString(context, httpCommunicate, nStaffNum, strMenuString, nLeft, nTop, nRight, nBottom, nColor.toDouble(), nKind, nLineSize, nLineAlign, nAlignment, isAnti, nCountry, bIsNoScale, bFlag);

        return 1;
      }

      if(call.method == "DrawMenuStringGasa2"){
        int nStaffNum = call.arguments['StaffNum'];
        String strMenuString = call.arguments['MenuString'];
        int nDrawPosX = call.arguments['DrawPosX'];
        int nDrawPosY = call.arguments['DrawPosY'];
        int crColor = call.arguments['Color'];
        int nKind = call.arguments['Kind'];
        int nLineSize = call.arguments['LineSize'];
        int nEdge = call.arguments['Edge'];
        int crEdgeColor = call.arguments['EdgeColor'];
        //int nDrawHight = call.arguments['DrawHight'];
        bool isAnti = call.arguments['Anti'];
        int nCountry = call.arguments['Country'];

        // print('flutter draw Gasa2 String =  posX : $nDrawPosX, posY : $nDrawPosY, str : $strMenuString');

        context.read<CustomFontProvider>().drawMenuString2(context, httpCommunicate, nStaffNum, strMenuString, nDrawPosX, nDrawPosY, crColor.toDouble(), nKind, nLineSize, isAnti, nCountry);
      }

      ///가사 데이터 저장
      if(call.method == 'DrawMenuStringGasa'){
        int nStaffNum = call.arguments['StaffNum'];
        String strMenuString = call.arguments['MenuString'];
        int nDrawPosX = call.arguments['DrawPosX'];
        int nDrawPosY = call.arguments['DrawPosY'];
        int crColor = call.arguments['Color'];
        int crEdgeColor = call.arguments['EdgeColor'];
        int nDrawHight = call.arguments['DrawHight'];
        bool isAnti = call.arguments['Anti'] ?? true;

        // print('flutter draw Gasa String =  posX : $nDrawPosX, posY : $nDrawPosY, str : $strMenuString');
        // print('gasa : $strMenuString');

        ///가사 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawMenuStringGasa(context, httpCommunicate, nStaffNum, strMenuString, nDrawPosX, nDrawPosY, crColor, crEdgeColor, nDrawHight, isAnti);
        return 1;
      }

      ///Score Font data 저장
      if(call.method == 'DrawFontScoreItem'){
        int nStaffNum = call.arguments['StaffNum'];
        int nFontNo = call.arguments['FontNo'];
        int nDrawPosX = call.arguments['DrawPosX'];
        int nDrawPosY = call.arguments['DrawPosY'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;
        bool bIsSetMinMaxPosY = call.arguments['SetMinMaxPosY'];

        // print('flutter font data : ${nFontNo + 0x20}');

        ///Scor Font 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawFontItem(context, httpCommunicate, nStaffNum, nFontNo, nDrawPosX, nDrawPosY, crColor, bIsSetMinMaxPosY);
        return 1;
      }

      if(call.method == 'DrawActFont'){
        Uint8List fontData;
        String strFontdata = "";

        int nStaffNum = call.arguments['StaffNum'];
        int nDrawPosX = call.arguments['DrawPosX'];
        int nDrawPosY = call.arguments['DrawPosY'];
        int nFontSelect = call.arguments['nFontSelect'];
        int nFontStyle = call.arguments['nFontStyle'];
        int nSize = call.arguments['Size'];
        int nAlignment = call.arguments['Alignment'];

        if(nFontSelect != 0){
          strFontdata = call.arguments['FontData'];
          // print('act Data1 : ${'posX : $nDrawPosX , posY : $nDrawPosY , data: $strFontdata , select : $nFontSelect'}');
          context.read<CustomFontProvider>().drawActFontString(context, nStaffNum, strFontdata, nDrawPosX, nDrawPosY, nFontSelect, nFontStyle, nSize, nAlignment);
        }
        else{
          fontData = call.arguments['FontData'];
          // print('act Data2 : ${'posX : $nDrawPosX , posY : $nDrawPosY , data: $fontData , select : $nFontSelect'}');
          context.read<CustomFontProvider>().drawActFontByte(context, nStaffNum, fontData, nDrawPosX, nDrawPosY, nFontSelect, nFontStyle, nSize, nAlignment);
        }



        return 1;
      }

      ///Symbol Item 데이터 저장 함수 호출
      if(call.method == 'DrawFontScoreSymbolItem'){
        int nStaffNum = call.arguments['StaffNum'];
        int nFontNo = call.arguments['FontNo'];
        int nDrawPosX = call.arguments['DrawPosX'];
        int nDrawPosY = call.arguments['DrawPosY'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;

        // print('flutter symbol data : $nFontNo');

        ///Symbol 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawFontScoreSymbolItem(context, nStaffNum, nFontNo, nDrawPosX, nDrawPosY, crColor);
        return 1;

      }

      ///Chord Entry 데이터 저장
      if(call.method == 'DrawChordEntry'){
        int nStaffNum = call.arguments['StaffNum'];
        ///SJW Modify 2023.02.23 Start...
        ///byte[]로 받도록 변경
        Uint8List nFontist = call.arguments['Chord'];
        ///SJW Modify 2023.02.23 End...
        int nDrawPosX = call.arguments['DrawPosX'];
        int nDrawPosY = call.arguments['DrawPosY'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;

        nDrawPosY += context.read<PDFProvider>().BASE_LINE_SIZE ~/ 3;

        // print("chord Data : $nFontist");

        ///Chord 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawChordEntry(context, httpCommunicate, nStaffNum, /*strChord*/ nFontist, nDrawPosX, nDrawPosY, crColor);
        return 1;
      }

      ///ToneName 데이터 저장
      if(call.method == 'DrawToneNameEntry'){
        int nStaff = call.arguments['StaffNum'];
        int nCountryMode = call.arguments['CountryMode'];
        int nLyrics = call.arguments['Lyrics'];
        int nDrawPosX = call.arguments['DrawPosX'];
        int nDrawPosY = call.arguments['DrawPosY'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;

        // print('flutter Draw ToneName : ${call.arguments}');

        ///ToneName 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawToneNameEntry(context, nStaff, nCountryMode, nLyrics, nDrawPosX, nDrawPosY, crColor);
        return 1;
      }

      ///Line 데이터 저장
      if(call.method == 'DrawLine'){
        int nStaff = call.arguments['StaffNum'];
        int nX1 = call.arguments['X1'];
        int nY1 = call.arguments['Y1'];
        int nX2 = call.arguments['X2'];
        int nY2 = call.arguments['Y2'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;
        int nThickness = call.arguments['Thickness'];
        bool bIsDotLine = call.arguments['DotLine'] ?? false;

        ///Line 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawLine(context, nStaff, nX1, nY1, nX2, nY2, crColor, nThickness, bIsDotLine);
        return 1;
      }

      ///대각선 데이터 저장
      if(call.method == "DrawDiagonalLine"){
        int nStaffNum = call.arguments['StaffNum'];
        int nStartX = call.arguments['StartX'];
        int nStartY = call.arguments['StartY'];
        int nEndX = call.arguments['EndX'];
        int nEndY = call.arguments['EndY'];
        int crColor = call.arguments['Color'];
        int nThickness = call.arguments['Thickness'];
        bool bIsDotLine = call.arguments['DotLine'];

        context.read<CustomFontProvider>().drawDiagonalLine(context, nStaffNum, nStartX, nStartY, nEndX, nEndY, crColor, nThickness, bIsDotLine);
        return 1;
      }

      ///Horizon Line 데이터 저장
      if(call.method == "DrawHorizonLine"){
        int nStaffNum = call.arguments['StaffNum'];
        int nPosY = call.arguments['PosY'];
        int nStartX = call.arguments['StartX'];
        int nEndX = call.arguments['EndX'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;
        int nThickness = call.arguments['Thickness'];
        bool bIsDotLine = call.arguments['DotLine'] ?? false;

        // print('flutter horizon.Y : $nPosY');

        ///HorizonLine 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawHorizonLine(context, nStaffNum, nPosY, nStartX, nEndX, crColor, nThickness, bIsDotLine);
        return 1;
      }

      ///Vertical Line 데이터 저장
      if(call.method == "DrawVerticalLine"){
        int nStaffNum = call.arguments['StaffNum'];
        int nPosX = call.arguments['PosX'];
        int nStartY = call.arguments['StartY'];
        int nEndY = call. arguments['EndY'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;
        int nThickness = call.arguments['Thickness'];
        bool bIsDotLine = call.arguments['DotLine'] ?? false;

        //print('DrawVerticalLine Flutter : ${call.arguments}');

        ///Vertical Line 데이터 저장 함수 호출
         context.read<CustomFontProvider>().drawVerticalLine(context, nStaffNum, nPosX, nStartY, nEndY, crColor, nThickness, bIsDotLine);
        return 1;
      }

      ///곡선 데이터 저장
      if(call.method == "DrawPolyBezier"){
        int nStaffNum = call.arguments['StaffNum'];
        int nStartX = call.arguments['StartX'];
        int nStartY = call.arguments['StartY'];
        int nEndX = call.arguments['EndX'];
        int nEndY = call.arguments['EndY'];
        int nUpDown = call.arguments['UpDown'];
        int crColor = call.arguments['Color'] ?? 0xFF000000;

        ///곡선 데이터 저장 함수 호출
        context.read<CustomFontProvider>().drawPolyBezier(context, nStaffNum, nStartX, nStartY, nEndX, nEndY, nUpDown, crColor);
        return 1;
      }

      ///Staff번호에 따른 대표 좌표와 넓이 높이 데이터 저장
      if(call.method == "SetStaffPosition"){
        int nStaffNum = call.arguments['StaffNum'];
        int nPosX = call.arguments['PosX'];
        int nPosY = call.arguments['PosY'];
        int nHeight = call.arguments['Height'];
        int nWidth = call.arguments['Width'];

        // print('flutter setStaffPosition : ${call.arguments}');

        ///Staff번호에 따른 대표 좌표와 넓이 높이 데이터 저장 함수 호출
        context.read<PDFProvider>().addStaffNumPositionData(nStaffNum, nPosX, nPosY, nHeight, nWidth);
        return 1;
      }

      ///End Page Flag
      if(call.method == "EndPage"){
        int nPageNum = call.arguments['PageNum'];
        int nTotalStaffSu = call.arguments['TotalStaffSu'];


        ///set PageNum
        context.read<PDFProvider>().setPageNum(nPageNum);
        ///set TotalStaffSu
        context.read<PDFProvider>().setTotalStffNum(nTotalStaffSu);

        context.read<PDFProvider>().addScorePageData();

        // print('flutter End page');
        return 1;
      }

      ///ACT 경우 이조 값의 범위를 C로 부터 받는다.
      if(call.method == "SetTransMinMax"){
        int nMinKey = call.arguments['MinKey'];
        int nMaxKey = call.arguments['MaxKey'];

        context.read<TranspositionProvider>().setActMinMaxKey(nMinKey, nMaxKey);
      }


      ///색상 데이터 테스트
      // if(call.method == 'ColorTest'){
      //   // Map<String, dynamic> data  = call.arguments;
      //   print('nColor : ${call.arguments['Color']}');
      //   LineData lineData = LineData();
      //
      //   lineData.nX1 = 10;
      //   lineData.nY1 = 500;
      //   lineData.nX2 = 1000;
      //   lineData.nY2 = 500;
      //   lineData.nThickness = 2;
      //   lineData.bIsDotLine = false;
      //   lineData.crColor = call.arguments['Color'];
      //
      //   print('add LineData : ${call.arguments['Color']}');
      //   context.read<PDFProvider>().addLineData(lineData);
      //
      //   print('context line : ${context.read<PDFProvider>().scoreLineData}');
      // }
    });
    return 0;
  }

  errorDialog(BuildContext context){

    Size size = MediaQuery.of(context).size;

    return Platform.isAndroid ?
    AlertDialog(
      title: Column(
        children: <Widget>[
          // Platform.isAndroid ?
          Container(
            height: size.height * 0.02,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/error.png'),
              ),
            ),
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
      ),
      content: Container(
        width: size.width * 0.7,
        height: size.height * 0.1,
        alignment: Alignment.center,
        child: Text(
          '오류가 발생했습니다.\n담당자에게 문의해 주세요.',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: size.width > 600 ? size.width * 0.025 : size.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: <Widget>[Container(
        height: size.height * 0.06,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            Platform.isAndroid ? SystemNavigator.pop() : exit(0);
          },
          child: Image(
            image: AssetImage('assets/images/buttons/ok_button.png'),
          ),
        ),
      )],
    ) :
    CupertinoAlertDialog(
      title: Column(
        children: <Widget>[
          // Platform.isAndroid ?
          Container(
            height: size.height * 0.02,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/error.png'),
              ),
            ),
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
      ),
      content: Container(
        width: size.width * 0.7,
        height: size.height * 0.1,
        alignment: Alignment.center,
        child: Text(
          '오류가 발생했습니다.\n담당자에게 문의해 주세요.',
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: size.width > 600 ? size.width * 0.025 : size.width * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: <Widget>[Container(
        height: size.height * 0.06,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            Platform.isAndroid ? SystemNavigator.pop() : exit(0);
          },
          child: Image(
            image: AssetImage('assets/images/buttons/ok_button.png'),
          ),
        ),
      )],
    );
  }

}