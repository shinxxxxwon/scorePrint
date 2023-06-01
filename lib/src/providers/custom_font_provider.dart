
import 'dart:math';
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/models/data/draw_score_data.dart';
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/display_code_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/display_lyrics_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/score_size_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:provider/provider.dart';
import '../resources/arabic.dart' as arabic;

class CustomFontProvider extends ChangeNotifier {

  ///ElfScore.ttf
  pdfWidget.Font? _elfScore;

  pdfWidget.Font get ELF_SCORE => _elfScore!;

  ///ElfChord.ttf
  pdfWidget.Font? _elfChord;

  pdfWidget.Font get ELF_CHORD => _elfChord!;

  ///ElfSymbol.ttf
  pdfWidget.Font? _elfSymbol;

  pdfWidget.Font get ELF_SYMBOL => _elfSymbol!;

  ///ElfToneName.ttf
  pdfWidget.Font? _elfToneName;

  pdfWidget.Font get ELF_TONENAME => _elfToneName!;

  ///KBIZ_HanmaumMyeongjoB.ttf
  pdfWidget.Font? _kbiz_HanmaumB;

  pdfWidget.Font get KBIZ_HANMAUM_MYEONGJO_B => _kbiz_HanmaumB!;

  ///KBIZ한마음명조 B.ttf
  pdfWidget.Font? _kbiz_HanmaumB_kor;

  pdfWidget.Font get KBIZ_HANMAUM_MYEONGJO_B_kor => _kbiz_HanmaumB_kor!;

  ///maestro.ttf
  pdfWidget.Font? _maestro;

  pdfWidget.Font get MAESTRO => _maestro!;

  ///malgun.ttf
  pdfWidget.Font? _malgun;

  pdfWidget.Font get MALGUN => _malgun!;

  ///NanumMyeongjoExtaBold.ttf
  pdfWidget.Font? _nanumBold;

  pdfWidget.Font get NANUM_MYEONGJO_B => _nanumBold!;

  ///SourceHanSans-Medium.ttf
  pdfWidget.Font? _sourceHanSans_Medium;

  pdfWidget.Font get SOURCE_HANSANS_MEDIUM => _sourceHanSans_Medium!;

  ///SourceHanSans-Normal.ttf
  pdfWidget.Font? _sourceHanSans_Normal;

  pdfWidget.Font get SOURCE_HANSANS_NORMAL => _sourceHanSans_Normal!;

  ///SourceHanSansKR-Bold.ttf.ttf
  pdfWidget.Font? _sourceHanSansKR_Bold;

  pdfWidget.Font get SOURCE_HANSAN_KR_BOLD => _sourceHanSansKR_Bold!;

  ///Times New Roman.ttf
  pdfWidget.Font? _times_New_Roman;

  pdfWidget.Font get TIME_NEW_ROMAN => _times_New_Roman!;

  pdfWidget.Font? _fontFamily;

  pdfWidget.Font get fontFamily => _fontFamily!;

  ///폰트 사이즈?
  double _emSize = 0;

  double get emSize => _emSize;

  ///매트릭스 넓이
  double _fontWidth = 0;

  double get fontWidth => _fontWidth;

  ///매트릭스 높이s
  double _fontHeight = 0;

  double get fontHeight => _fontHeight;

  ///폰트 스타일(굵기)
  pdfWidget.FontWeight? _fontStyle;

  pdfWidget.FontWeight get fontStyle => _fontStyle!;

  ///Menu & 가사 사이즈
  List<double> _nFontSize = [];

  List<double> get nFontSize => _nFontSize;

  ///GasaFontSize
  ///Gasa의 2중주, 3중주의 특정 가사 크기
  List<double> _nGasaSize = [];

  List<double> get nGasaSize => _nGasaSize;

  ///Score Font 사이즈
  List<double> _nScoreFontSize = [];

  List<double> get nScoreFontSize => _nScoreFontSize;

  List<double> _nFontLineSize = [];

  List<double> get nFontLineSize => _nFontLineSize;

  List<double> _nFontSizePosX = [];

  List<double> get nFontSizePosX => _nFontSizePosX;

  ByteData? _sourceHanSansMediumData;
  PdfTtfFont? _pdfTtfFont;

  int logPixelsY = 96;

  ///노래, 작곡, 작사 : 9
  ///곡번호 : 강사 15, 일반 13
  ///페이지 번호 : 8
  ///타이틀 : 강사 15, 일반 14
  // int nLineSize = 24; ///추후에 코드에서 상황에 맞게 설정해줘야 함 아직 구현 안함q

  ///악보 정보 저장 리스트들

  setElfScoreTTF() async {
    final data = await rootBundle.load('assets/fonts/ElfScore.ttf');
    _elfScore = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setElfChordTTF() async {
    final data = await rootBundle.load('assets/fonts/ElfChord.ttf');
    _elfChord = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setElfSymbolTTF() async {
    final data = await rootBundle.load('assets/fonts/ElfSymbol.ttf');
    _elfSymbol = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setElfToneNameTTF() async {
    final data = await rootBundle.load('assets/fonts/ElfToneName.ttf');
    _elfToneName = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setKBIZHanmaumMyeonjoBTTF() async {
    final data = await rootBundle.load(
        'assets/fonts/KBIZ_HanmaumMyeongjoB.ttf');
    _kbiz_HanmaumB = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setKBIZHanmaumMyeonJoBTTF_kor() async {
    final data = await rootBundle.load('assets/fonts/KBIZ한마음명조 B.ttf');
    _kbiz_HanmaumB_kor = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setMaestroTTF() async {
    final data = await rootBundle.load('assets/fonts/maestro.ttf');
    _maestro = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setMalgunTTF() async {
    final data = await rootBundle.load('assets/fonts/malgun.ttf');
    _malgun = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setNanumMyeongjoBTTF() async {
    final data = await rootBundle.load(
        'assets/fonts/NanumMyeongjoExtraBold.ttf');
    _nanumBold = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setSourceHanSansMediumTTF() async {
    final data = await rootBundle.load('assets/fonts/SourceHanSans-Medium.ttf');
    _sourceHanSans_Medium = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setSourceHanSansNormalTTF() async {
    final data = await rootBundle.load('assets/fonts/SourceHanSans-Normal.ttf');
    _sourceHanSans_Normal = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setSourceHanSansKRBoldTTF() async {
    final data = await rootBundle.load('assets/fonts/SourceHanSansKR-Bold.ttf');
    print('font data : $data');
    _sourceHanSansKR_Bold = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  getSourceHanSansMediumTTF2() async {
    final data = await rootBundle.load('assets/fonts/SourceHanSans-Medium.ttf');
    pdfWidget.Font sourceHanSans_Medium = pdfWidget.Font.ttf(data);
    return sourceHanSans_Medium;
  }

  getSourceHanSansNormalTTF2() async {
    final data = await rootBundle.load('assets/fonts/SourceHanSans-Normal.ttf');
    pdfWidget.Font sourceHanSans_Normal = pdfWidget.Font.ttf(data);
    return sourceHanSans_Normal;
  }

  setTimesNewRomanTTF() async {
    final data = await rootBundle.load('assets/fonts/Times New Roman.ttf');
    _times_New_Roman = pdfWidget.Font.ttf(data);
    notifyListeners();
  }

  setFontByteData(BuildContext context) async {
    _sourceHanSansMediumData =
    await rootBundle.load('assets/fonts/SourceHanSans-Medium.ttf');
    // _pdfTtfFont = PdfTtfFont(context.read<PDFProvider>().pdf.document, _sourceHanSansMediumData!);
    notifyListeners();
  }

  ///Gasa의 2중주, 3중주의 특정 가사 크기
  void setGasaSize(){
    _nGasaSize.add(20); /// -2
    _nGasaSize.add(24); /// -1
    _nGasaSize.add(28); /// 기본
    _nGasaSize.add(32); /// +1
    _nGasaSize.add(36); /// +2
    _nGasaSize.add(40); /// +3
    _nGasaSize.add(44); /// +4
    _nGasaSize.add(48); /// +5
    _nGasaSize.add(52); /// +6
  }

  ///FontSize 초기화 메서드 main의 LoadFont에서 호출함
  void setFontSize() {
    _nFontSize.add(12);
    _nFontSize.add(14);
    _nFontSize.add(16);
    _nFontSize.add(18);
    _nFontSize.add(20);

    _nFontSize.add(24);
    _nFontSize.add(28);
    _nFontSize.add(32);
    _nFontSize.add(36);
    _nFontSize.add(40);

    _nFontSize.add(48);
    _nFontSize.add(56);
    _nFontSize.add(64);
    _nFontSize.add(72);
    _nFontSize.add(80);

    _nFontSize.add(96);
    _nFontSize.add(112);
    _nFontSize.add(128);
    _nFontSize.add(144);
    _nFontSize.add(160);

    _nFontSize.add(192);
    _nFontSize.add(224);
    _nFontSize.add(256);
    _nFontSize.add(288);
    _nFontSize.add(320);

    notifyListeners();
  }

  void setScoreFontSize() {
    _nScoreFontSize.add(48);

    ///FontSize -2
    _nScoreFontSize.add(60);

    ///FontSize -1
    _nScoreFontSize.add(70);

    ///FontSize 기본
    _nScoreFontSize.add(82);

    ///FontSize +1
    _nScoreFontSize.add(92);

    ///FontSize +2
    _nScoreFontSize.add(102);

    ///FontSize +3
    _nScoreFontSize.add(118);

    ///FontSize +4
    _nScoreFontSize.add(131);

    ///FontSize +5
    _nScoreFontSize.add(142);

    ///FontSize +6
  }

  void setFontLineSize() {
    _nFontLineSize.add(17);
    _nFontLineSize.add(20);
    _nFontLineSize.add(24);
    _nFontLineSize.add(28);
    _nFontLineSize.add(32);
    _nFontLineSize.add(35);
    _nFontLineSize.add(39);
    _nFontLineSize.add(43);
    _nFontLineSize.add(46);

    notifyListeners();
  }

  void setFontSizePosX() {
    _nFontSizePosX.add(-1);
    _nFontSizePosX.add(-0);
    _nFontSizePosX.add(-0);
    _nFontSizePosX.add(-0);
    _nFontSizePosX.add(-0);
    _nFontSizePosX.add(-0);
    _nFontSizePosX.add(-0);
    _nFontSizePosX.add(-0);
    _nFontSizePosX.add(-0);
  }


  ///FontFamily, FontSize, FontWeight 설정
  void getKindItem(HttpCommunicate httpCommunicate, int nKind, int nLineSize) {
    _emSize = 0;
    switch (nKind) {
      case 0:

      ///메뉴
        _fontStyle = pdfWidget.FontWeight.normal;

        if (nLineSize < _nFontSize.length) {
          _emSize = _nFontSize[nLineSize];
        } else {
          _emSize = _nFontSize[2];
        }

        setFontFamilyStyle(httpCommunicate);
        break;

      case 1:

      ///큰가사
        _fontStyle = pdfWidget.FontWeight.bold;
        switch (nLineSize) {
          case 0:
            _emSize = _nFontSize[11];
            break;

        ///일반
          case 1:
            _emSize = _nFontSize[11];
            break;

        ///타이틀
          case 2:
            _emSize = _nFontSize[12];
            break;
          case 3:
            _emSize = _nFontSize[6];
            break;

        ///일반 듀얼 서브
          case 4:
            _emSize = _nFontSize[5];
            break;

        ///작은 듀얼 메인
          case 5:
            _emSize = _nFontSize[7];
            break;

        ///작은 일반
          case 6:
            _emSize = _nFontSize[4];
            break;

        ///작은 듀얼 서브
          case 7:
            _emSize = _nFontSize[13];
            break;
          case 8:
            _emSize = _nFontSize[7];
            break;

        ///제목, 가사
          case 9:
            _emSize = _nFontSize[3];
            break;
          case 10:
            _emSize = _nFontSize[4];
            break;
          case 11:
            _emSize = _nFontSize[5];
            break;
          case 12:
            _emSize = _nFontSize[6];
            break;
          case 13:
            _emSize = _nFontSize[7];
            break;

          default:
            _emSize = _nFontSize[11];
            break;
        }
        setFontFamilyStyle(httpCommunicate);
        break;

      default:
        _fontStyle = pdfWidget.FontWeight.normal;
        _emSize = _nFontSize[1];
        setFontFamilyStyle(httpCommunicate);
        break;
    }
    //print('_emSize : $_emSize');
    notifyListeners();
  }

  ///FontFamily, fontWeight 설정
  void setFontFamilyStyle(HttpCommunicate httpCommunicate) {
    if (httpCommunicate.nScoreType == 1) {
      ///강사용
      if ((httpCommunicate.nCountryMode == 1) || (httpCommunicate.nCountryMode == 2)///COUNTRY_MODE_CHINA ///COUNTRY_MODE_JAPAN
      ) {
        _fontStyle = pdfWidget.FontWeight.normal;
        _fontFamily = _sourceHanSans_Normal;
      }
      else {
        _fontStyle = pdfWidget.FontWeight.bold;
        _fontFamily = _kbiz_HanmaumB_kor;
        // _fontFamily = _nanumBold;
      }
    }
    else {
      _fontStyle = pdfWidget.FontWeight.bold;
      _fontFamily = _sourceHanSans_Medium;
      // _fontFamily = _sourceHanSansKR_Bold;
      // _fontFamily = _kbiz_HanmaumB_kor;
    }
    notifyListeners();
  }

  PdfFontMetrics glyphMetrics(TtfParser font, int charCode) {
    final g = font.charToGlyphIndexMap[charCode];

    if (g == null) {
      return PdfFontMetrics.zero;
    }

    if (arabic.isArabicDiacriticValue(charCode)) {
      final metric = font.glyphInfoMap[g] ?? PdfFontMetrics.zero;
      return metric.copyWith(advanceWidth: 0);
    }

    return font.glyphInfoMap[g] ?? PdfFontMetrics.zero;
  }

  ///get Font Height
  Future<double> drawEachItemFontHeight(BuildContext context,
      String strText) async {
    ;
    final size = PdfPoint(_emSize, _emSize);
    final metricsUnscaled = _pdfTtfFont!.glyphMetrics(strText.codeUnitAt(0));
    final fontSizeW = size.x / metricsUnscaled.maxWidth;
    final fontSizeH = size.y / metricsUnscaled.maxHeight;
    final fontSize = min(fontSizeW, fontSizeH);
    final metrics = metricsUnscaled * fontSize;

    return metrics.maxHeight;
  }

  ///get Font Width
  Future<double> drawEachItemFontWidth(BuildContext context,
      String strText) async {
    final size = PdfPoint(_emSize, _emSize);
    final metricsUnscaled = _pdfTtfFont!.glyphMetrics(strText.codeUnitAt(0));
    final fontSizeW = size.x / metricsUnscaled.maxWidth;
    final fontSizeH = size.y / metricsUnscaled.maxHeight;
    final fontSize = min(fontSizeW, fontSizeH);
    final metrics = metricsUnscaled * fontSize;

    return metrics.maxWidth;
  }

  ///메뉴 maxHeight
  Future<void> getMenuStringHeight(BuildContext context,
      HttpCommunicate httpCommunicate, String strText, int nKind, int nLineSize,
      int nEdge, int nCountry) async {
    getKindItem(httpCommunicate, nKind, nLineSize);

    _fontHeight = 0;

    ///maxHeight
    String strLetter = '';
    double nHeight = 0;

    for (int nIndex = 0; nIndex < strText.length; nIndex++) {
      strLetter = strText[nIndex];

      if (strLetter.codeUnits[0] == 0x20 || strLetter.codeUnits[0] == 0x2C ||
          strLetter.codeUnits[0] == 0x2E ||
          strLetter.codeUnits[0] == 0x0A || strLetter.codeUnits[0] == 0x0D) {
        strLetter = String.fromCharCode(0x20);
        continue;
      }

      nHeight = await drawEachItemFontHeight(context, strLetter);

      if (_fontHeight < nHeight) {
        _fontHeight = nHeight;
      }
    }
    notifyListeners();
  }

  ///메뉴 maxWidth
  Future<void> getMenuStringWidth(BuildContext context,
      HttpCommunicate httpCommunicate, int nMaxWidth, String strText, int nKind,
      int nLineSize) async {
    int dotPos, dotPosPre, totalWidthPre;
    String strLetter = '';

    getKindItem(httpCommunicate, nKind, nLineSize);

    double threePoint = 3.0 * await drawEachItemFontWidth(context, '.');
    double padding = (threePoint * 2.0) / 3.0;

    dotPos = 0;
    dotPosPre = 0;
    _fontWidth = 0;

    ///Total Width
    totalWidthPre = 0;

    for (int nIndex = 0; nIndex < strText.length; nIndex++) {
      strLetter = strText[nIndex];
      print('strLetter : $strLetter');
      if (_fontWidth < (nMaxWidth - threePoint - padding)) {
        dotPosPre = dotPos;
        totalWidthPre = _fontWidth.toInt();
      }

      if (strLetter.codeUnits[0] == 0x20 || strLetter.codeUnits[0] == 0x2C ||
          strLetter.codeUnits[0] == 0x2E ||
          strLetter.codeUnits[0] == 0x0A || strLetter.codeUnits[0] == 0x0D) {
        strLetter = String.fromCharCode(0x20);
        _fontWidth += 9;

        if (httpCommunicate.nScoreType == 1) {
          ///강사용 이라면
          _fontWidth += 3;
        }
        continue;
      }

      dotPos += 1;
      _fontWidth += await drawEachItemFontWidth(context, strLetter);

      if (_fontWidth > nMaxWidth) {
        dotPos = dotPosPre;
        _fontWidth = totalWidthPre.toDouble();

        while ((strText[dotPos - 1].codeUnits[0] == 0x20) ||
            (strText[dotPos - 1].codeUnits[0] == 0x2C) ||
            (strText[dotPos - 1].codeUnits[0] == 0x2E) ||
            (strText[dotPos - 1].codeUnits[0] == 0x0A) ||
            (strText[dotPos - 1].codeUnits[0] == 0x0D)) {
          strLetter = String.fromCharCode(0x20);

          dotPos -= 1;
          _fontWidth -= await drawEachItemFontWidth(context, strText);
          _fontWidth -= 5;
        }

        strText.replaceRange(dotPos + 0, dotPos + 1, String.fromCharCode(0x2E));
        strText.replaceRange(dotPos + 1, dotPos + 2, String.fromCharCode(0x2E));
        strText.replaceRange(dotPos + 2, dotPos + 3, String.fromCharCode(0x2E));
        // strText.replaceRange(dotPos + 3, dotPos + 4, ); //null?
        _fontWidth += threePoint;
        break;
      }
    }
    notifyListeners();
  }

  // Future<int> getMenuStringWidthGasa(BuildContext context, HttpCommunicate httpCommunicate, String strText, int nDrawHight) async {
  //   String strLetter;
  //   int nDotPos, nDotPosPre, nTotalWidthPre;
  //
  //   _fontStyle = pdfWidget.FontWeight.normal;
  //
  //   if(logPixelsY > 96){
  //     double fReSize = nDrawHight.toDouble() * (logPixelsY / 96.0);
  //     nDotPos = fReSize.toInt();
  //   }
  //
  //   _emSize = ((nDrawHight * 72) / logPixelsY);
  //   print('eemSize: $_emSize');
  //   setFontFamilyStyle(httpCommunicate);
  //
  //   nTotalWidthPre = 0;
  //   nDotPosPre = 0;
  //   nDotPos = 0;
  //   _fontWidth = 0;
  //
  //   for(int nIndex=0; nIndex<strText.length; nIndex++){
  //     strLetter = strText[nIndex];
  //
  //     if(strLetter.codeUnitAt(0) == 0x20 || strLetter.codeUnitAt(0) == 0x2E || strLetter.codeUnitAt(0) == 0x0A || strLetter.codeUnitAt(0) == 0x0D){
  //       continue;
  //     }
  //
  //     String str = strLetter;
  //
  //     _fontWidth += await drawEachItemFontWidth(context, str);
  //     nDotPos += 1;
  //   }
  //
  //   double nLeftSpace = await getLeftSpaceLetter(context, strText, 0, emSize);
  //
  //   notifyListeners();
  //
  //   return nLeftSpace.toInt();
  // }

  Future<void> getMenuStringHeightGasa(BuildContext context,
      HttpCommunicate httpCommunicate, String strText, int nDrawHight) async {
    String strLetter;
    double nHeight;
    _fontHeight = 0;

    _fontStyle = pdfWidget.FontWeight.normal;

    if (logPixelsY > 96) {
      double fResize = nDrawHight + (logPixelsY / 96.0);
      nDrawHight = fResize.toInt();
    }
    _emSize = ((nDrawHight * 72) / logPixelsY);
    setFontFamilyStyle(httpCommunicate);

    for (int nIndex = 0; nIndex < strText.length; nIndex++) {
      strLetter = strText[nIndex];

      if (strLetter.codeUnitAt(0) == 0x20 || strLetter.codeUnitAt(0) == 0x2C ||
          strLetter.codeUnitAt(0) == 0x2E ||
          strLetter.codeUnitAt(0) == 0x0A || strLetter.codeUnitAt(0) == 0x0D) {
        strLetter = String.fromCharCode(0x20);
      }

      nHeight = await drawEachItemFontHeight(context, strLetter);

      if (_fontHeight < nHeight) {
        _fontHeight = nHeight;
      }
    }

    notifyListeners();
  }

  // Future<double> getLeftSpaceLetter(BuildContext context, String strText, int nEdgePixcel, double emSize) async{
  //   int nWidthMin = 0xFFFF;
  //
  //   final data = await rootBundle.load('assets/fonts/SourceHanSans-Medium.ttf');
  //   final fontData = data.buffer;
  //   final font = PdfTtfFont(context.read<PDFProvider>().pdf.document, fontData.asByteData());
  //   final size = PdfPoint(_emSize,_emSize);
  //   final metricsUnscaled = font.glyphMetrics(strText.codeUnitAt(0));
  //   final fontSizeW = size.x / metricsUnscaled.maxWidth;
  //   final fontSizeH = size.y / metricsUnscaled.maxHeight;
  //   final fontSize = min(fontSizeW, fontSizeH);
  //   final metrics = metricsUnscaled * fontSize;
  //
  //   return metrics.advanceWidth - metrics.width;
  // }

  void drawMenuString(BuildContext context, HttpCommunicate httpCommunicate,
      int nStaffNum, String strMenuString, int nLeft, int nTop, int nRight,
      int nBottom, double crColor, int nKind, int nLineSize, int nLineAlign,
      int nAlignment, bool isAnti, int nCountry, bool bIsNoScale, bool bFlag) {

    getKindItem(httpCommunicate, nKind, nLineSize);

    MenuData menuData = MenuData();
    menuData.textAlign = pdfWidget.TextAlign.left;
    menuData.align = pdfWidget.Alignment.centerLeft;

    int nWidth = nRight - nLeft;
    int nHeight = nBottom - nTop;

    if (nHeight > _emSize) {
      switch (nLineAlign) {
        case 1:

        ///StringAlignmentCenter
          menuData.textAlign = pdfWidget.TextAlign.center;
          break;
        case 2:

        ///StringAlignmentFar
          menuData.textAlign = pdfWidget.TextAlign.right;
          break;
        case 0:

        ///StringAlignmentNear
          menuData.textAlign = pdfWidget.TextAlign.left;
          break;
      }

      switch (nAlignment) {
        case 1:

        ///AlignmentCenter
          menuData.align = pdfWidget.Alignment.topCenter;
          break;
        case 2:

        ///AlignmentFar
          menuData.align = pdfWidget.Alignment.topRight;
          break;
        case 0:

        ///AlignmentNear
          menuData.align = pdfWidget.Alignment.topLeft;
          break;
      }
    }

    menuData.nStaffNum = nStaffNum;
    menuData.strText = strMenuString;
    menuData.nWidth = nWidth;
    menuData.nHeight = nBottom;
    menuData.nPosX = nLeft;
    menuData.nPosY = nTop;
    menuData.nLineSize = nLineSize;
    menuData.nKind = nKind;
    menuData.nEmSize = _emSize.toInt();
    menuData.fontStyle = _fontStyle;
    menuData.fontFamily = _fontFamily;
    menuData.bFlag = bFlag;

    if (strMenuString == '1/1') {
      context.read<PDFProvider>().SetEditData(
          menuData.nStaffNum!, menuData.nPosX!, menuData.nPosY!,
          menuData.nEmSize!, menuData.nWidth!, menuData.nHeight!);
    }

    context.read<PDFProvider>().addTextData(menuData);
    notifyListeners();
  }

  void drawMenuString2(BuildContext context, HttpCommunicate httpCommunicate,
      int nStaffNum, String strMenuString, int nDrawPosX, int nDrawPosY,
      double crColor, int nKind, int nLineSize, bool isAnti, int nCountry) {
    getKindItem(httpCommunicate, nKind, nLineSize);

    MenuData menuData = MenuData();
    menuData.textAlign = pdfWidget.TextAlign.left;
    menuData.align = pdfWidget.Alignment.centerLeft;
    menuData.nStaffNum = nStaffNum;
    menuData.strText = strMenuString;
    menuData.nWidth = 0;
    menuData.nHeight = 0;
    menuData.nPosX = nDrawPosX;
    menuData.nPosY = nDrawPosY;
    menuData.nLineSize = nLineSize;
    menuData.nKind = nKind;
    menuData.nEmSize = _emSize.toInt();
    menuData.fontStyle = _fontStyle;
    menuData.fontFamily = _sourceHanSans_Medium;

    context.read<PDFProvider>().addTextData(menuData);
    notifyListeners();
  }

  void drawMenuStringGasa(BuildContext context, HttpCommunicate httpCommunicate,
      int nStaffNum, String strMenuString, int nDrawPosX, int nDrawPosY,
      int crColor, int crEdgeColor, int nDrawHight, bool isAnti) {
    if (logPixelsY >= 96) {
      double fReSize = nDrawHight * (logPixelsY / 96.0);
      nDrawHight = fReSize.toInt();
    }
    double fEmSize = nDrawHight * 72 / logPixelsY;
    setFontFamilyStyle(httpCommunicate);

    GasaData gasaData = GasaData();

    List<int> emSize = [0, 35, 40, 50];
    // List<int> emSize2 = [0, 45, 51, 61];
    int emSizeGasa = 70;
    ///안함, 소, 중, 대

    gasaData.nStaffNum = nStaffNum;
    gasaData.strMenuString = strMenuString;
    gasaData.nDrawPosX = nDrawPosX;
    gasaData.nDrawPosY = nDrawPosY;
    gasaData.crColor = crColor;
    gasaData.crEdgeColor = crEdgeColor;
    gasaData.nDrawHight = nDrawHight;
    gasaData.isAnti = isAnti;
    gasaData.nEmSize = httpCommunicate.nScoreType != 1 ? emSize[context.read<DisplayLyricsProvider>().nDisplayLyricsValue] : emSizeGasa;
    gasaData.fontStyle = _fontStyle;
    gasaData.fontFamily = _fontFamily;

    context.read<PDFProvider>().addGasaData(gasaData);
    notifyListeners();
  }

  void drawActFontByte(BuildContext context, int nStaffNum, Uint8List nFontData, int nDrawPosX, int nDrawPosY, int nFontSelect, int nFontStyle, int nSize, int nAlignment){
    ACTData actData = ACTData();

    actData.nStaffNum = nStaffNum;
    actData.nFontData = 0xF000 + nFontData[0];
    actData.strFontData = "";
    actData.nDrawPosX = nDrawPosX;
    actData.nDrawPosY = nDrawPosY;
    actData.nFontSelect = nFontSelect;
    actData.nFontStyle = nFontStyle;
    actData.nSize = nSize;
    actData.nAlignment = nAlignment;

    context.read<PDFProvider>().addActData(actData);
    notifyListeners();
  }

  void drawActFontString(BuildContext context, int nStaffNum, String strFontData, int nDrawPosX, int nDrawPosY, int nFontSelect, int nFontStyle, int nSize, int nAlignment){
    ACTData actData = ACTData();

    actData.nStaffNum = nStaffNum;
    actData.strFontData = strFontData;
    actData.nFontData = -1;
    actData.nDrawPosX = nDrawPosX;
    actData.nDrawPosY = nDrawPosY;
    actData.nFontSelect = nFontSelect;
    actData.nFontStyle = nFontStyle;
    actData.nSize = nSize;
    actData.nAlignment = nAlignment;

    context.read<PDFProvider>().addActData(actData);
    notifyListeners();
  }

  void drawFontItem(BuildContext context, HttpCommunicate httpCommunicate,
      int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, int crColor,
      bool bIsSetMinMaxPosY) {
    FontData fontData = FontData();

    fontData.nFontKind = 0;
    fontData.nStaffNum = nStaffNum;
    fontData.nFontNo = 0xF020 + nFontNo;
    fontData.nPosX = nDrawPosX;
    fontData.nPosY = nDrawPosY;
    fontData.crColor = crColor;
    fontData.bIsSetMinMaxPosY = bIsSetMinMaxPosY;
    fontData.fontStyle = pdfWidget.FontWeight.normal;
    fontData.fontFamily = _elfScore;
    fontData.nEmSize = _nScoreFontSize[2 + context.read<ScoreSizeProvider>().nScoreSizeValue].toInt();

    context.read<PDFProvider>().addFontData(fontData);
    notifyListeners();
  }

  void drawFontScoreSymbolItem(BuildContext context, int nStaffNum, int nFontNo,
      int nDrawPosX, int nDrawPosY, int crColor) {
    FontData symbolData = FontData();

    symbolData.nFontKind = 1;
    symbolData.nStaffNum = nStaffNum;
    symbolData.nFontNo = 0xF000 + nFontNo; //왜 1을 더해줘야하는지 모르겠음
    symbolData.nPosX = nDrawPosX;
    symbolData.nPosY = nDrawPosY;
    symbolData.crColor = crColor;
    symbolData.fontStyle = pdfWidget.FontWeight.normal;
    symbolData.fontFamily = _elfSymbol;
    ///SJW Modify 2023.02.24 Start...
    ///Symbol 사이즈 기본으로 고정
    // symbolData.nEmSize = _nScoreFontSize[2 + context.read<ScoreSizeProvider>().nScoreSizeValue].toInt();
    symbolData.nEmSize = _nScoreFontSize[2].toInt();
    ///SJW Modify 2023.02.24 End...

    context.read<PDFProvider>().addFontData(symbolData);
    notifyListeners();
  }

  void drawChordEntry(BuildContext context, HttpCommunicate httpCommunicate, int nStaffNum, /*String strChord*/ Uint8List nFontList,
      int nDrawPosX, int nDrawPosY, int crColor) {
    ChordData chordData = ChordData();

    List<int> emSize = [0, 32, 38, 48];
    List<int> interval = [0, 22, 30, 42];

    chordData.nStaffNum = nStaffNum;
    ///SJW Modify 2023.02.23 Start...
    ///byte[]로 데이터를 받도록 변경
    chordData.nFontList = nFontList;
    ///SJW Modify 2023.02.23 End...
    chordData.nPosX = nDrawPosX;
    chordData.nPosY = nDrawPosY;
    chordData.crColor = crColor;
    chordData.fontStyle = pdfWidget.FontWeight.normal;
    // chordData.fontFamily = _elfChord;
    chordData.fontFamily = _elfChord;
    chordData.nEmSize = emSize[context.read<DisplayCodeProvider>().nDisplayCodeValue];
    chordData.nInterval = interval[context.read<DisplayCodeProvider>().nDisplayCodeValue];

   for(int i=0; i<chordData.nFontList!.length; i++){
     chordData.nFontList![i] += 0xF002; //왜 2를 더 더해줘야하는지 모르겠음
   }   

    context.read<PDFProvider>().addChordData(chordData);
    notifyListeners();
  }

  void drawToneNameEntry(BuildContext context, int nStaffNum, int nCountryMode,
      int nLyrics, int nDrawPosX, int nDrawPosY, int crColor) {
    FontData toneName = FontData();

    List<int> emSize = [0, 37, 39, 41]; //계명

    toneName.nFontKind = 3;
    toneName.nStaffNum = nStaffNum;
    toneName.nCountryMode = nCountryMode;
    toneName.nFontNo = 0xF000 + nLyrics;
    // toneName.nFontNo = 0xF000 + 0x43;
    toneName.nPosX = nDrawPosX;
    toneName.nPosY = nDrawPosY;
    toneName.crColor = crColor;
    toneName.fontStyle = pdfWidget.FontWeight.normal;
    // toneName.fontFamily = _elfToneName;
    toneName.fontFamily = _elfToneName;
    toneName.nEmSize = emSize[context.read<DisplayLyricsProvider>().nDisplayLyricsValue];

    context.read<PDFProvider>().addFontData(toneName);
    notifyListeners();
  }

  void drawLine(BuildContext context, int nStaffNum, int nX1, int nY1, int nX2,
      int nY2, int crColor, int nThickness, bool bIsDotLine) {
    LineData lineData = LineData();

    lineData.nStaffNum = nStaffNum;
    lineData.nX1 = nX1;
    lineData.nY1 = nY1;
    lineData.nX2 = nX2;
    lineData.nY2 = nY2;
    lineData.crColor = crColor;
    lineData.nThickness = nThickness;
    lineData.bIsDotLine = bIsDotLine;

    context.read<PDFProvider>().addLineData(lineData);
    notifyListeners();
  }

  void drawDiagonalLine(BuildContext context, int nStaffNum, int nStartX, int nStartY, int nEndX, int nEndY, int crColor, int nThickness, bool bIsDotLine){
    LineData lineData = LineData();

    lineData.nStaffNum = nStaffNum;
    lineData.nX1 = nStartX;
    lineData.nY1 = nStartY;
    lineData.nX2 = nEndX;
    lineData.nY2 = nEndY;
    lineData.crColor = crColor;
    lineData.nThickness = nThickness;
    lineData.bIsDotLine = bIsDotLine;

    context.read<PDFProvider>().addLineData(lineData);
  }

  void drawHorizonLine(BuildContext context, int nStaffNum, int nPosY, int nStartX, int nEndX, int crColor, int nThickness, bool bIsDotLine) {
    LineData lineData = LineData();

    lineData.nStaffNum = nStaffNum;
    lineData.nX1 = nStartX;
    lineData.nY1 = nPosY;
    lineData.nX2 = nEndX;
    lineData.nY2 = nPosY;
    lineData.crColor = crColor;
    lineData.nThickness = nThickness;
    lineData.bIsDotLine = bIsDotLine;

    context.read<PDFProvider>().addLineData(lineData);
  }

  void drawVerticalLine(BuildContext context, int nStaffNum, int nPosX,
      int nStartY, int nEndY, int crColor, int nThickness, bool bIsDotLine) {
    LineData lineData = LineData();

    lineData.nStaffNum = nStaffNum;
    lineData.nX1 = nPosX;
    lineData.nY1 = nStartY;
    lineData.nX2 = nPosX;
    lineData.nY2 = nEndY;
    lineData.crColor = crColor;
    lineData.nThickness = nThickness;
    lineData.bIsDotLine = bIsDotLine;

    context.read<PDFProvider>().addLineData(lineData);
  }

  void drawPolyBezier(BuildContext context, int nStaffNum, int nStartX,
      int nStartY, int nEndX, int nEndY, int nUpDown, int crColor) {
    PolyBezierData polyBezierData = PolyBezierData();

    polyBezierData.nStaffNum = nStaffNum;
    polyBezierData.nStartX = nStartX;
    polyBezierData.nStartY = nStartY;
    polyBezierData.nEndX = nEndX;
    polyBezierData.nEndY = nEndY;
    polyBezierData.nUpDown = nUpDown;

    ///0, 1 = Up, 2 = Down
    polyBezierData.crColor = crColor;


    context.read<PDFProvider>().addPolyBezierData(polyBezierData);
  }
}