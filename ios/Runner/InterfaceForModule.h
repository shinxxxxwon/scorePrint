//
//  InterfaceForModule.h
//  Runner
//
//  Created by 신정원 on 2023/03/03.
//

#ifndef InterfaceForModule_h
#define InterfaceForModule_h

///Font Metrics 데이터 모듈에 전송하는 함수들
int ObjcGetMenuStringWidth(const char* pMenuString, int nMaxWidth, int nKind, int nLineSize, int nEdge, int nCountry);
int ObjcGetMenuStringHeight(const char* pMenuString, int nKind, int nLineSize, int nEdge, int nCountry);
int ObjcGetMenuStringWidthGasa(const char* pMenuString, int nDrawHight, int nLeftSpace);
int ObjcGetMenuStringHeightGasa(const char* pMenuString, int nDrawHight);
///ACT Font Metrics
int ObjcGetActFontheight(int nStaffNum, const char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment);
int ObjcGetActFontwidth(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment);

///그리는 데이터 flutter로 전달하는 함수들
///메뉴 데이터
int ObjcDrawMenuString(int nStaffNum, char *pMenuString, int nRleft, int nRtop, int nRight, int nBottom, int crColor, int nKind, int nLineSize, int nLineAlign, int nAlignment, bool isAnti, int nCountry, bool bIsNoScale, bool bMenuStringEncodingFlag);
///가사 데이터
int ObjcDrawMenuStringGasa(int nStaffNcum, char *pMenuString, int nDrawPosX, int nDrawPosY, int crColor, int crEdgeColor, int nDrawHight, bool isAnti);
///폰트 데이터
int ObjcDrawFontScoreItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, int crColor, bool bIsSetMinMaxPosY);
///심볼 데이터
int ObjcDrawFontScoreSymbolItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, int crColor);
///코드 데이터
int ObjcDrawChordEntry(int nStaffNum, char *pChord, int nDrawPosX, int nDrawPosY, int crColor);
///계명 데이터
int ObjcDrawToneNameEntry(int nStaffNum, int nCountryMode, int nFontNo, int nDrawPosX, int nDrawPosY, int crColor);
///라인 데이터
int ObjcDrawLine(int nStaffNum, int nX1, int nY1, int nX2, int nY2, int crColor, int nThickness, bool bIsDotLine);
///수평 라인 데이터
int ObjcDrawHorizonLine(int nStaffNum, int nPosY, int nStartX, int nEndX, int crColor, int nThickness, bool bIsDotLine);
///수직 라인 데이터
int ObjcDrawVerticalLine(int nStaffNum, int nPosX, int nStartY, int nEndY, int crColor, int nThickness, bool bIsDotLine);
///곡선 데이터
int ObjcDrawPolyBezier(int nStaffNum, int nStartX, int nStartY, int nEndX, int nEndY, int nUpDown, int crColor);
///대각선 데이터
int ObjcDrawDiagonalLine(int nStaffNum, int nStartX, int nEndX, int nStartY, int nEndY, int crColor, int nThickness, bool bIsDotLine);
///ACT 폰트 데이터
int ObjcDrawActFont(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment ,int nLang);

int ObjcSetTransMinMax(int nMinKey, int nMaxKey);
void ObjcSetStaffPosition(int nStaffNum, int nX, int nY, int nHeight, int nWidth);
void ObjcEndPage(int nPageNum, int TotalStaffSu);
int  ObjcGetLeftSpace();
void ObjcGetSaxPhoneInfo(int nTrans1, int nTrans2, int nTrans3);

void ObjcGetCountryMode(int nCountryMode);
void ObjcGetScoreType(int nScoreType);
void ObjcGetLyricsType(int nLyricsType);

void ObjcSetChannel();
void ObjcGetMenuStringEncodingFlag(bool bMenuStringEncodingFlag);
#endif /* InterfaceForModule_h */
