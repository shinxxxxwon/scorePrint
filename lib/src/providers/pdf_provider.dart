
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/models/data/draw_score_data.dart';
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/custom_font_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/api/remove_bg.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';


class PDFProvider extends ChangeNotifier{



  List<File> scorePngList = [];
  int nTiffTotalNum = 0;

  EditData? editData;

  int nTotalPageNum = 0;

  int nFTPCount = 0;

  String? _strPdfPath;
  String? get strPdfPath => _strPdfPath!;

  Uint8List? _uintPdfData;
  Uint8List? get uinPdfData => _uintPdfData!;

  int nKeyValue = 0;

  pdfWidget.Document _pdf = pdfWidget.Document(version: PdfVersion.pdf_1_5, compress: true);
  // pdfWidget.Document get pdf => _pdf;

  bool bFtpRes = false;

  Orientation orientation = Orientation.portrait;

  ///Title, Menue 데이터 저장 List
  List<MenuData> _scoreMenuData = [];
  List<MenuData> get scoreMenuData => _scoreMenuData;

  ///가사 데이터 저장 List
  List<GasaData> _scoreGasaData = [];
  List<GasaData> get scoreGasaDate => _scoreGasaData;

  ///font, chord, symbol, ToneName 데이터 저장 List
  List<FontData> _scoreFontData = [];
  List<FontData> get scoreFontData => _scoreFontData;

  List<ChordData> _scoreChordData = [];
  List<ChordData> get scoreChordData => _scoreChordData;

  ///Act font 데이터 저장 List
  List<ACTData> _scoreActData = [];
  List<ACTData> get scoreActData => _scoreActData;

  ///가로, 세로 Line 데이터 저장 List
  List<LineData> _scoreLineData = [];
  List<LineData> get scoreLineData => _scoreLineData;

  ///곡선 데이터 List
  List<PolyBezierData> _scorePolyBezierData = [];
  List<PolyBezierData> get scorePolyBezierData => _scorePolyBezierData;

  ///전체 악보 데이터를 저장하는 PageData class List
  ///PageData class 생성자로 Data add 하면됨
  ///_scorePageData!.add(PageData(_scoreTextData!, _scoreFontData!, _scoreLineData!, _scorePolyBezierData!));
  List<PageData> _scorePageData = [];
  List<PageData> get scorePageData => _scorePageData;

  ///페이지 StaffNum에 대한 X,Y 좌표, 넓이, 높이 데이터
  List<StaffNumPosition> _scoreStaffNumPositionList = [];
  List<StaffNumPosition> get scoreStaffNumPositionList => _scoreStaffNumPositionList;

  // PageData? _pageData;
  // PageData get pageData => _pageData!;

  ///전체 페이지 StaffNum에 대한 X,Y 좌표, 넓이, 높이 데이터
  List<List<StaffNumPosition>> _scoreStaffNumPositionDoubleList = [];
  List<List<StaffNumPosition>> get scoreStaffNumPositionDoubleList => _scoreStaffNumPositionDoubleList;

  ///Page Num
  int _nPageNum = 0;
  int get nPageNum => _nPageNum;

  int _nTotalStaffSu = 3;
  int get nTotalStaffSu => _nTotalStaffSu;

  int BASE_MEASURE_WIDTH = 200; ///최소 마디 넓이 원래는 300인데 테스트 200중
  int BASE_LINE_SIZE = 24;

  String strUserID = "";

  int nSongInfoMaxLength = 0;

  bool bMakingScore = false;  ///악보를 그리는 중
  bool bWillChange = false;   ///악보를 그리는 중 설정 값 변경

  int nRealChagneCount = 0;
  int nButtonClickCount = 0;

  int pdfCurPage = 1;
  int pdfTotalPage = 1;

  void setPdfCurPage(int page){
    pdfCurPage = page;
    notifyListeners();
  }

  void setPdfTotalpage(int page){
    pdfTotalPage = page;
    notifyListeners();
  }

  setTotalPageNum(int nPage){
    nTotalPageNum = nPage;
    notifyListeners();
  }

  addScorePngList(File img){
    scorePngList.add(img);
    notifyListeners();
  }

  setSongInfoMaxLength(int nLen){
    nSongInfoMaxLength = nLen;
    notifyListeners();
  }

  SetEditData(int nStaffNum, int nPosX, int nPosY, int nEmSize, int nWidth, int nHeight){
    editData = EditData(nStaffNum, nPosX, nPosY, nEmSize, nWidth, nHeight);
    notifyListeners();
  }
  
  SetUserID(String id){
    strUserID = id;
    notifyListeners();
  }

  deletePdfFile()async {
    final dir = await getTemporaryDirectory();
    // File printScoreFile = File('${dir.path}/score.pdf');
    // if(await printScoreFile.exists()) {
    //   print('remove Score pdf file');
    //   printScoreFile.deleteSync();
    // }

    List<FileSystemEntity> _dirFiles;

    String dirPath = dir.path + '/';
    final myDir = Directory(dirPath);
    _dirFiles = myDir.listSync(recursive: true, followLinks: false);

    for (int i = 0; i < _dirFiles.length; i++) {
      // if(_dirFiles[i].path.contains('cache/pdf_renderer_cache')){
      if(_dirFiles[i].path.contains('.pdf')){
        File(_dirFiles[i].path).deleteSync();
      }
      if(_dirFiles[i].path.contains('pdf_renderer_cache')){
        Directory(_dirFiles[i].path).deleteSync();
      }
    }

    _dirFiles.clear();
  }

  void setPdfPath(String path){
    _strPdfPath = path;
    notifyListeners();
  }

  void setPdfData(Uint8List data) {
    _uintPdfData = data;
    notifyListeners();
  }

  int keyCount = 0;

  void increaKeyCount() {
    keyCount++;
    notifyListeners();
  }

  void setDataInit() {
    _scoreMenuData.clear();
    _scoreGasaData.clear();
    _scoreFontData.clear();
    _scoreLineData.clear();
    _scorePolyBezierData.clear();
    _scoreActData.clear();
    _scorePageData.clear();
    _scoreChordData.clear();
    _scoreStaffNumPositionList.clear();
    _scoreStaffNumPositionDoubleList.clear();
    notifyListeners();
  }

  void setTotalStffNum(int totalStaffSu){
    _nTotalStaffSu = totalStaffSu;
    // _pageData!.nTotalStaffNum = totalStaffSu;
    notifyListeners();
  }

  void setPageNum(int pageNum){
    _nPageNum = pageNum;
    notifyListeners();
  }

  void addTextData(MenuData data) {
    _scoreMenuData.add(data);
    // _pageData!.menuDataList!.add(data);
    notifyListeners();
  }

  void addActData(ACTData data){
    _scoreActData.add(data);
    // print('_scoreActData Length : ${_scoreActData.length}');
    notifyListeners();
  }

  void addGasaData(GasaData data){
    _scoreGasaData.add(data);
    // _pageData!.gasaDataList!.add(data);
    notifyListeners();
  }

  void addFontData(FontData data){
    _scoreFontData.add(data);
    // _pageData!.fontDataList!.add(data);
    notifyListeners();
  }

  void addChordData(ChordData data){
    _scoreChordData.add(data);
    notifyListeners();
  }

  void addLineData(LineData data){
    _scoreLineData.add(data);
    // _pageData!.lineDataList!.add(data);
    notifyListeners();
  }

  void addPolyBezierData(PolyBezierData data){
    _scorePolyBezierData.add(data);
    // _pageData!.polyBezierDataList!.add(data);
    notifyListeners();
  }



  void addStaffNumPositionData(int nStaffNum, int nPosX, int nPosY, int nHeight, int nWidth){
    StaffNumPosition data = StaffNumPosition();
    data.nX = nPosX;
    data.nY = nPosY;
    data.nWidth = nWidth;
    data.nHeight = nHeight;

    _scoreStaffNumPositionList.add(data);
    // print('print start');
    // for(int i=0; i<_scoreStaffNumPositionList.length; i++){
    //   print('scoreStaff : ${_scoreStaffNumPositionList[i].nY}');
    // }
    notifyListeners();
  }

  int prevTotalStaffSu = 0;
  ///페이지 End Flag 받았을때 호출해야함
  void addScorePageData(){
    _scorePageData.add(PageData(_nTotalStaffSu, _scoreMenuData, _scoreGasaData, _scoreFontData, _scoreChordData, _scoreLineData, _scorePolyBezierData, _scoreStaffNumPositionList, _scoreActData));

    // for(int i=0; i<_scoreChordData.length; i++){
    //   print("$i. staffnum: ${_scorePageData[0].chordDataList![i].nStaffNum}");
    // }

    _nTotalStaffSu = 0;
    _scoreStaffNumPositionList.clear();
    _scoreMenuData.clear();
    _scoreGasaData.clear();
    _scoreFontData.clear();
    _scoreLineData.clear();
    _scorePolyBezierData.clear();
    _scoreActData.clear();
    _scoreChordData.clear();
    // print("_nTotalStaffSu : $_nTotalStaffSu");
    notifyListeners();
  }


  Future<pdfWidget.Document> addScorePDF(BuildContext context, HttpCommunicate httpCommunicate, bool bIsTiff)async{

    DrawScore drawScore = DrawScore();

    pdfWidget.Document scorePdf = pdfWidget.Document(version: PdfVersion.pdf_1_5, compress: true);

    final cutpaperImage = await imageFromAssetBundle('assets/images/CutPaper.png');
    final watermarkingImage = await imageFromAssetBundle('assets/images/ELF_CI.png');
    final underElfimage = await imageFromAssetBundle('assets/images/ELF_CI2.png');

      int nTotalPageLen = httpCommunicate.bIsPreViewScore == true ? 1 : context.read<PDFProvider>().scorePageData.length;

      String strUserId = strUserID;
      ///총 페이지 길이만큼 반복
      for(int nCurPage=0; nCurPage<nTotalPageLen; nCurPage++)
      {
        ///pdf 생성(추가)
        scorePdf.addPage(
          pdfWidget.Page(
              // margin: pdfWidget.EdgeInsets.zero,
              pageFormat: PdfPageFormat.a4, ///2480 * 3508
              build: (pdfWidget.Context pContext){
                return pdfWidget.Stack(
                  children: [


                    ///draw watermarking
                    if(httpCommunicate.bIsPreViewScore == false)
                      drawScore.drawWatermarking(context.read<PDFProvider>().strUserID, watermarkingImage, 1.0, context.read<CustomFontProvider>().SOURCE_HANSANS_MEDIUM)
                    else
                      drawScore.drawCutPaper(context, cutpaperImage, httpCommunicate, nCurPage),

                    ///draw Menu
                    for(int nMenuIndex=0; nMenuIndex<_scorePageData[nCurPage].menuDataList!.length; nMenuIndex++)
                      drawScore.drawMenuString(context, httpCommunicate, underElfimage, nCurPage, nMenuIndex),

                    ///draw Gasa
                    for(int nGasaIndex=0; nGasaIndex<_scorePageData[nCurPage].gasaDataList!.length; nGasaIndex++)
                      drawScore.drawGasaString(context, httpCommunicate, nCurPage, nGasaIndex),

                    ///draw Font
                    for(int nFontIndex=0; nFontIndex<_scorePageData[nCurPage].fontDataList!.length; nFontIndex++)
                      drawScore.drawFont(context, httpCommunicate, nCurPage, nFontIndex),

                    for(int nChordIndex=0; nChordIndex<=_scorePageData[nCurPage].chordDataList!.length - 1; nChordIndex++)
                      drawScore.drawChord(context, httpCommunicate, nCurPage, nChordIndex/*, nChIndex*/),

                    ///draw act font act가 아니라면 List길이가 0이기 때문에 pass함
                    for(int nActFontIndex=0; nActFontIndex<_scorePageData[nCurPage].actDataList!.length; nActFontIndex++)
                      drawScore.drawAct(context, httpCommunicate, underElfimage, nCurPage, nActFontIndex),
                    // if(httpCommunicate.bIsPreViewScore == false && httpCommunicate.nFileDataType == 2)
                    // if(httpCommunicate.bIsPreViewScore == false)
                        drawScore.drawScoreBottom(context, underElfimage, httpCommunicate, nCurPage, 0),

                    ///Draw Line
                    for(int nLineIndex=0; nLineIndex<_scorePageData[nCurPage].lineDataList!.length; nLineIndex++)
                      drawScore.drawLine(context, httpCommunicate, nCurPage, nLineIndex),


                    ///draw PolyVezierLine
                    for(int nPloyBezierIndex=0; nPloyBezierIndex<_scorePageData[nCurPage].polyBezierDataList!.length; nPloyBezierIndex++)
                      drawScore.drawPolyBezier(context, httpCommunicate, nCurPage, nPloyBezierIndex),



                  ],
                );
              }
          ),
        );
      }


    return scorePdf;
  }


}