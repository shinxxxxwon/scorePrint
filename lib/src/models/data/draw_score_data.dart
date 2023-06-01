
import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pdfWidget;

/// SCORE & SYMBOL : FontHeight(192) FontSize( 31,  25) : Line Space 24
///  TONENAME FontHeight(119) MAX_FontSize( 40,  44) : Line Space 22
///  TONENAME FontHeight(128) MAX_FontSize( 43,  46) : Line Space 23
///  TONENAME FontHeight(134) MAX_FontSize( 45,  48) : Line Space 24
/// nChordFontHeight = 32;    코드 소
/// nChordFontHeight = 38;    코드 중
///	nChordFontHeight = 48;    코드 대
/// MAX_LYRICS_TTF_HEIGHT[0] = 48;  가사 소 
/// MAX_LYRICS_TTF_HEIGHT[1] = 54;  가사 중
/// MAX_LYRICS_TTF_HEIGHT[2] = 60;  가사 대
/// SCORE & SYMBOL : FontHeight(192) FontSize( 31,  25) : Line Space 24

///Title, Menu, Gasa data table
class MenuData{
  int? nStaffNum;
  String? strText;  ///문자열
  int? nPosX;       ///X 좌표
  int? nPosY;       ///Y 좌표
  int? nWidth;      ///DC 넓이
  int? nHeight;     ///DC 높이
  pdfWidget.Alignment ? align;      ///DC 정렬 방법
  pdfWidget.TextAlign? textAlign;  ///텍스트 정렬 방법
  int? nLineSize;   ///EmSize 리스트 인덱스 번호
  int? nKind;       ///font, style 구분 값
  int? nEmSize;     ///그리는 실제 사이즈
  pdfWidget.FontWeight? fontStyle;
  pdfWidget.Font? fontFamily;
  bool? bFlag = false;

}

class GasaData{
  int? nStaffNum;
  String? strMenuString;  ///문자열
  int? nDrawPosX;         ///X 좌표
  int? nDrawPosY;         ///Y 좌표
  int? crColor;           ///색상
  int? crEdgeColor;       ///Edge Color
  int? nDrawHight;
  bool? isAnti;
  int? nEmSize = 48;           ///그리는 실제 사이즈
  pdfWidget.FontWeight? fontStyle;
  pdfWidget.Font? fontFamily;
}

///font, symbol, chord, ToneName data Table
class FontData{
  int? nFontKind;
  int? nStaffNum;
  int? nFontNo = 0; ///Font 값
  int? nPosX;   ///x 좌표
  int? nPosY;   ///y 좌표
  int? nEmSize = 70; ///그리는 실제 사이즈
  pdfWidget.FontWeight? fontStyle;
  pdfWidget.Font? fontFamily;
  bool bIsSetMinMaxPosY = false;
  int crColor = 0xFF000000;
  int nCountryMode = 0;
}

class ChordData{
  int? nStaffNum;
  Uint8List? nFontList; ///Font 값
  int? nPosX;   ///x 좌표
  int? nPosY;   ///y 좌표
  int? nEmSize = 70; ///그리는 실제 사이즈
  pdfWidget.FontWeight? fontStyle;
  pdfWidget.Font? fontFamily;
  bool bIsSetMinMaxPosY = false;
  int crColor = 0xFF000000;
  int nCountryMode = 0;
  int nInterval = 0;
}

///가로, 세로 Line data table
class LineData{
  int?  nStaffNum;
  int?  nX1;        ///첫번째 X좌표
  int?  nY1;        ///첫반째 Y좌표
  int?  nX2;        ///두번째 X좌표
  int?  nY2;        ///두번째 Y좌표
  int?  nThickness; ///Line 두께
  int?  crColor = 0xFF000000;    ///색상
  bool? bIsDotLine; ///점선과 실선 구분 Flag
}

///곡선 data table (중간 점은 (startX - startY) / 2.0 )
class PolyBezierData{
  int? nStaffNum;
  int? nStartX;     ///시작 X좌표
  int? nStartY;     ///시작 Y좌표
  int? nEndX;       ///끝 X좌표
  int? nEndY;       ///끝 Y좌표
  int? nUpDown;
  int? crColor = 0xFF000000;
}

class ACTData{
  int? nStaffNum;
  int? nFontData = -1;
  String? strFontData = "";
  int? nDrawPosX;
  int? nDrawPosY;
  int? nFontSelect;
  int? nFontStyle;
  int? nSize;
  int? nAlignment;
}

class StaffNumPosition{
  int? nX;
  int? nY;
  int? nWidth;
  int? nHeight;
}

class PageData{

  ///Initialize
  PageData(int totlaStaffSu, List<MenuData> menuData, List<GasaData> gasaData, List<FontData> fontData, List<ChordData> chordData, List<LineData> lineData, List<PolyBezierData> polyBezierData, List<StaffNumPosition> staffNumPositionData, List<ACTData> actData)
  {
    nTotalStaffNum = totlaStaffSu;
    menuDataList = [...menuData];
    gasaDataList = [...gasaData];
    fontDataList = [...fontData];
    chordDataList = [...chordData];
    lineDataList = [...lineData];
    polyBezierDataList = [...polyBezierData];
    staffNumPositionDataList = [...staffNumPositionData];
    actDataList = [...actData];
  }


  int?                  nTotalStaffNum;     ///한 페이지의 총 Staff 개수
  List<MenuData>?       menuDataList;       ///한 페이지의 메뉴, 타이틀 데이터를 저장한 List
  List<GasaData>?       gasaDataList;       ///한 페이지의 가사 데이터를 저장한 List
  List<FontData>?       fontDataList;       ///한 페이지의 font,ToneName, Symbol 데이터를 저장한 List
  List<ChordData>?      chordDataList;      ///한 페이지의 chord 데이터를 저장한 List
  List<LineData>?       lineDataList;       ///한 페이지의 가로, 세로 Line 데이터를 저장한 List
  List<PolyBezierData>? polyBezierDataList; ///한 페이지의 곡선 데이터를 저장한 List
  List<StaffNumPosition>? staffNumPositionDataList;

  List<ACTData>? actDataList;
}

class EditData{
  EditData(int staffNum, int posX, int posY, int emSize, int width, int height){
    nStaffNum = staffNum;
    nPosX = posX;
    nPosY = posY;
    nEmSize = emSize;
    nWidth = width;
    nHeight = height;
  }

  int? nStaffNum;
  int? nPosX;
  int? nPosY;
  int? nEmSize;
  int? nWidth;
  int? nHeight;
}
