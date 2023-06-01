//
// Created by dhkwon on 2022-08-08.
//

#ifndef ELFSCOREPRINT_MOBILE_20220720_MAIN_H
#define ELFSCOREPRINT_MOBILE_20220720_MAIN_H

#include "ScorePrint/DefConst.h"
#define USE_JBYTE_ARRAY

/*
#include "CompressLz4/CompressorLz4.h"
#include "ScorePrint/ReadPrintScoreFile.h"
#include "ScorePrint/FontFile.h"
#include "ScorePrint/DrawScore.h"
*/

#ifdef __cplusplus
extern "C" {
#endif

int CppGetScoreData(int nTrans1, int nOctave1, int nTrans2, int nOctave2, int nTrans3, int nOctave3, BOOL bChordHeler, BOOL bChordFixed, int nDisplayChord, int nDisplayLyrics, int nLyricsType, int nLyricsCommandments, int nCommandmentsType, int nHapjooChord, int nPrintType, int nScoreSize);

#ifdef __cplusplus
}

//SJW Modify 2022.11.22 Start...
//JAVA에 unsigned int가 없고 long은 8바이트이기 때문에 int로 변경
//테스트 해본 결과 색상 데이터 문제 없음
typedef int COLORREF;
///SJW Modify 2022-11.22 End...

enum {
	JNI_METHODID_GetMenuStringHeight,
	JNI_METHODID_GetMenuStringWidth,
	JNI_METHODID_DrawMenuString,
	//JNI_METHODID_DrawMenuString2,
	JNI_METHODID_GetMenuStringHeightGasa,
	JNI_METHODID_GetMenuStringWidthGasa,
	JNI_METHODID_DrawMenuStringGasa,
	JNI_METHODID_DrawFontScoreItem,
	JNI_METHODID_DrawFontScoreSymbolItem,
	JNI_METHODID_DrawChordEntry,
	JNI_METHODID_DrawToneNameEntry,
	JNI_METHODID_DrawLine,
	JNI_METHODID_DrawHorizonLine,
	JNI_METHODID_DrawVerticalLine,
	JNI_METHODID_DrawPolyBezier,
	JNI_METHODID_SetStaffPosition,
	JNI_METHODID_EndPage,
	JNI_METHODID_LogString,
	JNI_METHODID_LogInt,
};

//void SetMethodid(JNIEnv* env);

class MainControll
{
/*
    FontFile			    m_FontFile;
    DrawScore               *m_pDrawScore;
    ReadPrintScoreFile		m_ReadPrintScoreFile;
    int                     m_nOpenSongNo;
*/
    //kkondae Modify 2022.11.22 Start... wnd사이즈 필요없음
    /*
    CRect					m_rectScoreWndPos;
    CSize                   m_sizeScoreWnd;
    */
    void                    InitMeberVariables();
public:
    
    int m_nReturnData1;
    int m_nReturnData2;

    int m_nLeftSpace;

    int SetFileData();
    bool SetScoreData();
    int DrawStart();

    bool DrawScoreStart(int nType, const char* pP0Path);
    bool LoadC02File();

    //메뉴
    int GetMenuStringHeight(int nStaffNum, char *pMenuString, int nKind, int nLineSize, int nEdge, int nCountry = 0);
    int GetMenuStringWidth(int nStaffNum, char *pMenuString, int nMaxWidth, int nKind, int nLineSize, int nEdge, int nCountry = 0);
    int DrawMenuString(int nStaffNum, char *pMenuString, int nRleft, int nRtop, int nRight, int nBottom, COLORREF crColor, int nKind, int nLineSize, int nLineAlign = 0, int nAlignment = 0, BOOL isAnti = TRUE, int nCountry = 0, BOOL bIsNoScale = FALSE);
    int DrawMenuString2(int nStaffNum, char *pMenuString, int nDrawPosX, int nDrawPosY, COLORREF crColor, int nKind, int nLineSize, int nEdge, COLORREF crEdgeColor, BOOL isAnti /* = TRUE */, int nCountry);
    //가사
	int GetMenuStringHeightGasa(int nStaffNum, char *pMenuString, int nDrawHight);//(wchar_t *pMenuString, int nDrawHight);
	int GetMenuStringWidthGasa(int nStaffNum, char *pMenuString, int nDrawHight, int &nLeftSpace);//(wchar_t *pMenuString, int nDrawHight, int &nLeftSpace);
	int DrawMenuStringGasa(int nStaffNum, char *pMenuString, int nDrawPosX, int nDrawPosY, COLORREF crColor, COLORREF crEdgeColor, int nDrawHight, BOOL isAnti = TRUE);//(CDC *pDC, wchar_t *pMenuString, int nDrawPosX, int nDrawPosY, COLORREF crColor, COLORREF


    //4개 함수는 폰트로드해서 찍기만 하면 됨
	int DrawFontScoreItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, COLORREF crColor, BOOL bIsSetMinMaxPosY); //&m_ElfScoreFont
	int DrawFontScoreSymbolItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, COLORREF crColor);//m_ElfSymbolFont
	int DrawChordEntry(int nStaffNum, char *pChord, int nDrawPosX, int nDrawPosY, COLORREF crColor);//&m_ElfChordFont[g_struElfScorePrintSetupInfo.nScoreChordViewFlag]
	//int DrawToneNameEntry(int nStaffNum, int nCountryMode, char *pStrLyrics, int nDrawPosX, int nDrawPosY, COLORREF crColor);//&m_ElfToneNameFont[g_struElfScorePrintSetupInfo.nScoreLyricsViewFlag]
	int DrawToneNameEntry(int nStaffNum, int nCountryMode, int nFontNo, int nDrawPosX, int nDrawPosY, COLORREF crColor);//&m_ElfToneNameFont[g_struElfScorePrintSetupInfo.nScoreLyricsViewFlag]

    //라인 관련 함수
	int DrawLine(int nStaffNum, int nX1, int nY1, int nX2, int nY2, COLORREF crColor, int nThickness, BOOL bIsDotLine);
    int DrawHorizonLine(int nStaffNum, int nPosY, int nStartX, int nEndX, COLORREF crColor, int nThickness, BOOL bIsDotLine);
    int DrawVerticalLine(int nStaffNum, int nPosX, int nStartY, int nEndY, COLORREF crColor, int nThickness, BOOL bIsDotLine);
    //곡선 그리기
    int DrawPolyBezier(int nStaffNum, int nStartX, int nStartY, int nEndX, int nEndY, int nUpDown, COLORREF crColor);
    //int DrawPolyBezier2Point(int nStaffNum, int nStartX, int nStartY, int nEndX, int nEndY, int nUpDown, COLORREF crColor);


    //
    int DrawDiagonalLine(int nStaffNum, int nStartX, int nEndX, int nStartY, int nEndY, COLORREF crColor, int nThickness, BOOL bIsDotLine);
   // int DrawActFont(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment);
    int DrawActFont(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment, int nLang);
    int GetActFontheight(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment);
    int GetActFontwidth(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment);
    int SetTransMinMax(int nMinKey, int nMaxKey);
    //
    void LogInt(int nNum);
    void LogStr(char* strTemp);
    void LogStrInt(char* strTemp, int a, int b= 0, int c= 0, int d= 0, int e = 0);

    void SetStaffPosition(int nStaffNum, int nX, int nY, int nHeight, int nWidth);
    void EndPage(int nPageNum, int TotalStaffSu);
    int  GetLeftSpace();

    void GetSaxPhoneInfo(int a, int b, int c);
    
    ///SJW Modify 2023.03.10 Start...
    ///악보 설정 데이터 받는 함수 생성
    int GetScoreData(int nTrans1, int nOctave1, int nTrans2, int nOctave2, int nTrans3, int nOctave3, BOOL bChordHeler, BOOL bChordFixed, int nDisplayChord, int nDisplayLyrics, int nLyricsType, int nLyricsCommandments, int nCommandmentsType, int nHapjooChord, int nPrintType, int nScoreSize);
    ///SJW Modfy 2023.03.10 End...
    
    ///SJW Modify 2023.03.10 Start...
    ///웹 서버 데이터 받는 함수
    int GetWebServerData(const char* strMainKey, const char* strManKey, const char* strWomanKey, const char* strUserId, const char* strTag, const char* strMemberId, int nMainTempo, const char* scPrintScoreTransPos, const char* scPrintScoreTransPos2, const char* scPrintScoreTransPos3, int nSongNo, int nCountryMode, int nScoreType, int nFileDataType, int nViewJeonKanjoo, int nSubType, int nDispNumber, BOOL bIsPreViewScore);
    ///SJW Modify 2023.03.10 End...
    
    ///SJW Modify 2023.03.20 Start...
    ///ReDraw 함수 생성
    int ReDraw();
    ///SJW Modify 2023.03.20 End...
    
    int GetFileData(const char* szFtpPath, const char* szP0Path);
};

#endif //ELFSCOREPRINT_MOBILE_20220720_MAIN_H

#endif //__cplusplus

