//
// Created by dhkwon on 2022-08-04.
//

#include <stdio.h>
#include <string.h>
//#include <jni.h>
#include "main.h"
#include "ScorePrint/ElfScorePrint.h"
#include "InterfaceForModule.h"


//전역 함수 선언
bool bIsSetData = false;
//extern bool bIsSetData

//extern define
MainControll* g_pMainControll = NULL;

///SJW Modify 2023.03.08 Start...
///main만 가져와서 다른 파일 없어서 오류 주석
ElfScorePrint *g_pElfScorePrint;
///SJW Modify 2023.03.08 End...


char*           g_pFtpPath;// = NULL;
char           g_pP0Path[255];// = null;
    //const char* szFtpPath = env->GetStringUTFChars(strFtpPath, nullptr); //jstring -> const char* 변환
    //const char* szP0Path = env->GetStringUTFChars(strP0Path, nullptr); //jstring -> const char* 변환

///SJW Modify 2023.03.08 Start...
///main만 가져와서 다른 파일 없어서 오류 주석
extern structElfScorePrintSetupInfo g_struElfScorePrintSetupInfo;
extern structScorePrintOptionInfo   g_struScorePrintOptionInfo;
///SJW Modify 2023.03.08 End...

//kkondae Modify 2023.02.27 Start...
extern bool g_bConvertCodePage;
//extern KEY_INFO_LIST g_KeyList;


//메뉴
int MainControll::GetMenuStringHeight(int nStaffNum, char *pMenuString, int nKind, int nLineSize, int nEdge, int nCountry)
{
///SJW Modify 2023.03.08 Start...
///JNI 코드 주석 OBJC GetMenuStringHeight 테스트 코드
//    #ifdef USE_JBYTE_ARRAY
//        jbyteArray bytedddr = g_env->NewByteArray(strlen(pMenuString));
//        g_env->SetByteArrayRegion(bytedddr, 0, strlen(pMenuString), (const jbyte*)pMenuString);
//        return g_env->CallStaticIntMethod(g_jclass,  g_methodID[0], nStaffNum, bytedddr, nKind, nLineSize, nEdge, nCountry);
//    #else
//    jstring str = g_env->NewStringUTF(pMenuString);
//    return g_env->CallStaticIntMethod(g_jclass,  g_methodID[0], nStaffNum, str, nKind, nLineSize, nEdge, nCountry);
//    #endif
    int nMenuStringHeight = ObjcGetMenuStringHeight(pMenuString, nKind, nLineSize, nEdge, nCountry);
    return nMenuStringHeight;
///SJW Modify 2023.03.08 End...
}

int MainControll::GetMenuStringWidth(int nStaffNum, char *pMenuString, int nMaxWidth, int nKind, int nLineSize, int nEdge, int nCountry)
{
///SJW Modify 2023.03.08 Start...
///JNI 코드 주석 OBJC GetMenuStringWidth 테스트 코드
//#ifdef USE_JBYTE_ARRAY
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(pMenuString));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pMenuString), (const jbyte*)pMenuString);
//    return g_env->CallStaticIntMethod(g_jclass,  g_methodID[1], nStaffNum, bytedddr, nMaxWidth, nKind, nLineSize, nEdge, nCountry);
//#else
//    jstring str = g_env->NewStringUTF(pMenuString);
//    g_env->CallStaticIntMethod(g_jclass,  g_methodID[1], nStaffNum, str, nMaxWidth, nKind, nLineSize, nEdge, nCountry);
//    return g_pMainControll->m_nReturnData1;
//#endif
    int nMenuStringWidth = ObjcGetMenuStringWidth(pMenuString, nMaxWidth, nKind, nLineSize, nEdge, nCountry);
    return nMenuStringWidth;
///SJW Modify 2023.03.08 End...
}

///SJW Modify 2023.03.08 Start...
///BOOL -> bool로 변경, JNI코드 주석 후 OBJC DrawMenuString 테스트 코드
int MainControll::DrawMenuString(int nStaffNum, char *pMenuString, int nRleft, int nRtop, int nRight, int nBottom, COLORREF crColor, int nKind, int nLineSize, int nLineAlign, int nAlignment, BOOL isAnti, int nCountry, BOOL bIsNoScale)
{
//#ifdef USE_JBYTE_ARRAY
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(pMenuString));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pMenuString), (const jbyte*)pMenuString);
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[2], nStaffNum, bytedddr, nRleft, nRtop, nRight, nBottom, crColor, nKind, nLineSize, nLineAlign, nAlignment, isAnti, nCountry, bIsNoScale, g_bConvertCodePage);
//#else
//     jstring str = g_env->NewStringUTF(pMenuString);
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[2], nStaffNum, str, nRleft, nRtop, nRight, nBottom, crColor, nKind, nLineSize, nLineAlign, nAlignment, isAnti, nCountry, bIsNoScale);
//     #endif
    int res = ObjcDrawMenuString(nStaffNum, pMenuString, nRleft, nRtop, nRight, nBottom, crColor, nKind, nLineSize, nLineAlign, nAlignment, isAnti, nCountry, bIsNoScale, g_bConvertCodePage);
     return res;
}
///SJW Modify 2023.03.08 End...

///SJW Modify 2023.03.08 Start...
///BOOL -> bool 변경, JNI 코드 주석후 return 0
int MainControll::DrawMenuString2(int nStaffNum, char *pMenuString, int nDrawPosX, int nDrawPosY, COLORREF crColor, int nKind, int nLineSize, int nEdge, COLORREF crEdgeColor, BOOL isAnti /* = TRUE */, int nCountry)
{
//#ifdef USE_JBYTE_ARRAY
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(pMenuString));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pMenuString), (const jbyte*)pMenuString);
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[19], nStaffNum, bytedddr, nDrawPosX, nDrawPosY, crColor, nKind, nLineSize, nEdge, crEdgeColor, isAnti, nCountry);
//#else
//     jstring str = g_env->NewStringUTF(pMenuString);
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[19], nStaffNum, str, nDrawPosX, nDrawPosY, crColor, nKind, nLineSize, nEdge, crEdgeColor, isAnti, nCountry);
//    #endif
     return 0;//;IIIIIIIZI
}
///SJW Modify 2023.03.08 End...


//가사
///SJW Modify 2023.03.08 Start...
///JNI 코드 주석, OBJC GetMenuStringHeightGasa 테스트 코드
int MainControll::GetMenuStringHeightGasa(int nStaffNum, char *pMenuString, int nDrawHight)
{
//#ifdef USE_JBYTE_ARRAY
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(pMenuString));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pMenuString), (const jbyte*)pMenuString);
//    return g_env->CallStaticIntMethod(g_jclass,  g_methodID[3], nStaffNum, bytedddr, nDrawHight);
//#else
//    jstring str = g_env->NewStringUTF(pMenuString);
//   // g_env->CallStaticIntMethod(g_jclass,  g_methodID[3], nStaffNum, str, nDrawHight);
//    return g_env->CallStaticIntMethod(g_jclass,  g_methodID[3], nStaffNum, str, nDrawHight);
//#endif
    int nMenuStringHeight = ObjcGetMenuStringHeightGasa(pMenuString, nDrawHight);
    return nMenuStringHeight;
}

///SJW Modify 2023.03.08 Start...
///JNI 코드 주석, OBJC GetmenuStringWidthGasa 테스트 코드
int MainControll::GetMenuStringWidthGasa(int nStaffNum, char *pMenuString, int nDrawHight, int &nLeftSpace)
{
//#ifdef USE_JBYTE_ARRAY
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(pMenuString));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pMenuString), (const jbyte*)pMenuString);
//    int nResult = g_env->CallStaticIntMethod(g_jclass,  g_methodID[4], nStaffNum, bytedddr, nDrawHight, nLeftSpace);
//    nLeftSpace = g_env->CallStaticIntMethod(g_jclass,  g_methodID[18]);
//    return nResult;
//#else
//
//    jstring str = g_env->NewStringUTF(pMenuString);
//    int nResult = g_env->CallStaticIntMethod(g_jclass,  g_methodID[4], nStaffNum, str, nDrawHight, nLeftSpace);
//    nLeftSpace = g_env->CallStaticIntMethod(g_jclass,  g_methodID[18]);
//    return nResult;
//#endif
    int nMenuStringWidth = ObjcGetMenuStringWidthGasa(pMenuString, nDrawHight, nLeftSpace);
    return nMenuStringWidth;
}
///SJW Modify 2023.03.08 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawMenuStringGasa  테스트 코드
int MainControll::DrawMenuStringGasa(int nStaffNum, char *pMenuString, int nDrawPosX, int nDrawPosY, COLORREF crColor, COLORREF crEdgeColor, int nDrawHight, BOOL isAnti)
{
//#ifdef USE_JBYTE_ARRAY
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(pMenuString));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pMenuString), (const jbyte*)pMenuString);
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[5], nStaffNum, bytedddr, nDrawPosX, nDrawPosY, crColor, crEdgeColor, nDrawHight, isAnti);
//#else
//     jstring str = g_env->NewStringUTF(pMenuString);
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[5], nStaffNum, str, nDrawPosX, nDrawPosY, crColor, crEdgeColor, nDrawHight, isAnti);
//    #endif
    int res = ObjcDrawMenuStringGasa(nStaffNum, pMenuString, nDrawPosX, nDrawPosY, crColor, crEdgeColor, nDrawHight, isAnti);
    return res;
}
///SJW Modify 2023.03.09 End...


//4개 함수는 폰트로드해서 찍기만 하면 됨
///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawFontScoreItem 테스트 코드
int MainControll:: DrawFontScoreItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, COLORREF crColor, BOOL bIsSetMinMaxPosY)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[6], nStaffNum, nFontNo, nDrawPosX, nDrawPosY, crColor, bIsSetMinMaxPosY);
//    printf("crColor : %d\n", crColor);
    int res = ObjcDrawFontScoreItem(nStaffNum, nFontNo, nDrawPosX, nDrawPosY, crColor, bIsSetMinMaxPosY);
     return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawFOntScoreSymbolItem 테스트 코드
int MainControll::DrawFontScoreSymbolItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, COLORREF crColor)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[7], nStaffNum, nFontNo, nDrawPosX, nDrawPosY, crColor);
    int res = ObjcDrawFontScoreSymbolItem(nStaffNum, nFontNo, nDrawPosX, nDrawPosY, crColor);
    return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawChordEntry 테스트 코드
int MainControll::DrawChordEntry(int nStaffNum, char *pChord, int nDrawPosX, int nDrawPosY, COLORREF crColor)
{
//#ifdef USE_JBYTE_ARRAY
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(pChord));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pChord), (const jbyte*)pChord);
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[8], nStaffNum, bytedddr, nDrawPosX, nDrawPosY, crColor);
//#else
//     jstring str = g_env->NewStringUTF(pChord);
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[8], nStaffNum, str, nDrawPosX, nDrawPosY, crColor);
//#endif
    int res = ObjcDrawChordEntry(nStaffNum, pChord, nDrawPosX, nDrawPosY, crColor);
     return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 코드 주석, OBJC DrawToneNameEntry 테스트 코드
int MainControll::DrawToneNameEntry(int nStaffNum, int nCountryMode, int nFontNo, int nDrawPosX, int nDrawPosY, COLORREF crColor)
//int MainControll::DrawToneNameEntry(int nStaffNum, int nCountryMode, char *pStrLyrics, int nDrawPosX, int nDrawPosY, COLORREF crColor)
{
/*
#ifdef USE_JBYTE_ARRAY
    jbyteArray bytedddr = g_env->NewByteArray(strlen(pStrLyrics));
    g_env->SetByteArrayRegion(bytedddr, 0, strlen(pStrLyrics), (const jbyte*)pStrLyrics);
    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[9], nStaffNum, nCountryMode, bytedddr, nDrawPosX, nDrawPosY, crColor);
#else
     jstring str = g_env->NewStringUTF(pStrLyrics);
     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[9], nStaffNum, nCountryMode, str, nDrawPosX, nDrawPosY, crColor);
#endif
*/
    //LogStrInt("DrawToneNameEntry", nFontNo);
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[9], nStaffNum, nCountryMode, nFontNo, nDrawPosX, nDrawPosY, crColor);
    int res = ObjcDrawToneNameEntry(nStaffNum, nCountryMode, nFontNo, nDrawPosX, nDrawPosY, crColor);
    return res;
}
///SJW Modify 2023.03.09 End...


///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawLine 테스트 코드
//라인 관련 함수
int MainControll::DrawLine(int nStaffNum, int nX1, int nY1, int nX2, int nY2, COLORREF crColor, int nThickness, BOOL bIsDotLine)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[10], nStaffNum, nX1, nY1, nX2, nY2, crColor, nThickness, bIsDotLine);
    
    int res = ObjcDrawLine(nStaffNum, nX1, nY1, nX2, nY2, crColor, nThickness, bIsDotLine);
    return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawHorizonLine 테스트 코드
int MainControll::DrawHorizonLine(int nStaffNum, int nPosY, int nStartX, int nEndX, COLORREF crColor, int nThickness, BOOL bIsDotLine)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[11], nStaffNum, nPosY, nStartX, nEndX, crColor, nThickness, bIsDotLine);
    int res = ObjcDrawHorizonLine(nStaffNum, nPosY, nStartX, nEndX, crColor, nThickness, bIsDotLine);
    return res;
}
///SJW Modify 2023.03.09 End...


///SJW Modify 2023.03.09 Start...
///JNI 코드 주석, OBJC DrawVerticalLine 테스트 코드
int MainControll::DrawVerticalLine(int nStaffNum, int nPosX, int nStartY, int nEndY, COLORREF crColor, int nThickness, BOOL bIsDotLine)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[12], nStaffNum, nPosX, nStartY, nEndY, crColor, nThickness, bIsDotLine);
    
    int res = ObjcDrawVerticalLine(nStaffNum, nPosX, nStartY, nEndY, crColor, nThickness, bIsSetData);
    return res;
}
///SJW Modify 2023.03.09 End...


//곡선 그리기
///SJW Modify 2022.11.23 Start...
///flutter에서 곡선을 그리는데 점 3개가 필요하므로 StartXY와 EndXY 좌표를 보내주고 UpDown flag를 던저주도록 수정함
///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawPolyBezier 테스트 코드
int MainControll::DrawPolyBezier(int nStaffNum, int nStartX, int nStartY, int nEndX, int nEndY, int nUpDown, COLORREF crColor)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[13], nStaffNum, nStartX, nStartY, nEndX, nEndY, nUpDown, crColor);
    int res = ObjcDrawPolyBezier(nStaffNum, nStartX, nStartY, nEndX, nEndY, nUpDown, crColor);
    return res;
}
///SJW Modify 2023.03.09 End...
///SJW Modify 2022.11.23 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawDiagonaLine 테스트 코드
int MainControll::DrawDiagonalLine(int nStaffNum, int nStartX, int nEndX, int nStartY, int nEndY, COLORREF crColor, int nThickness, BOOL bIsDotLine)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[25], nStaffNum, nStartX, nEndX, nStartY, nEndY, crColor, nThickness, bIsDotLine);
    int res = ObjcDrawDiagonalLine(nStaffNum, nStartX, nEndX, nStartY, nEndY, crColor, nThickness, bIsDotLine);
    return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC DrawActFont 테스트 코드
int MainControll::DrawActFont(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment ,int nLang )
{
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(string));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(string), (const jbyte*)string);
//
//
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[22], nStaffNum, bytedddr, nFont, nFontStyle, nSize, x, y, nAlignment, nLang);
    
    int res = ObjcDrawActFont(nStaffNum, string, nFont, nFontStyle, nSize, x, y, nAlignment, nLang);
    return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC GetActFontheight  테스트 코드
int MainControll::GetActFontheight(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment)
{
//     jbyteArray bytedddr = g_env->NewByteArray(strlen(string));
//     g_env->SetByteArrayRegion(bytedddr, 0, strlen(string), (const jbyte*)string);
//
//     int nResult = g_env->CallStaticIntMethod(g_jclass,  g_methodID[23], nStaffNum, bytedddr, nFont, nFontStyle, nSize, x, y, nAlignment);
    
    int res = ObjcGetActFontheight(nStaffNum, string, nFont, nFontStyle, nSize, x, y, nAlignment);
    return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC GetActFontwidth 테스트 코드
int MainControll::GetActFontwidth(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment)
{
     //int nResult = g_env->CallStaticIntMethod(g_jclass,  g_methodID[24], nStaffNum, string, nFont, nFontStyle, nSize, x, y, nAlignment);
//     jbyteArray bytedddr = g_env->NewByteArray(strlen(string));
//     g_env->SetByteArrayRegion(bytedddr, 0, strlen(string), (const jbyte*)string);

//    return g_env->CallStaticIntMethod(g_jclass,  g_methodID[24], bytedddr, nFont, nFontStyle, nSize, x, y, nAlignment);
    int res = ObjcGetActFontwidth(nStaffNum, string, nFont, nFontStyle, nSize, x, y, nAlignment);
    return res;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC SetTransMinMax 테스트 코드
int MainControll::SetTransMinMax(int nMinKey, int nMaxKey)
{
//     g_env->CallStaticVoidMethod(g_jclass,  g_methodID[26], nMinKey, nMaxKey);
    int res = ObjcSetTransMinMax(nMinKey, nMaxKey);
    return res;
}

bool MainControll::SetScoreData()
{
    bIsSetData = true;
    return bIsSetData;
}

bool MainControll::DrawScoreStart(int nType, const char* pP0Path)
{
    memset(g_pP0Path, 0x00, 255);
    memcpy(g_pP0Path, pP0Path, strlen(pP0Path) + 1);
    
    ObjcSetChannel();
    
    printf("Cpp DrawStart\n");
     if(g_pP0Path != NULL)
     {
         printf("g_pP0Path not null\n");
         g_pElfScorePrint = new ElfScorePrint();
         if(g_pElfScorePrint == NULL)
         {
             printf("g_pElfScorePrint is null");
//            g_pMainControll->LogStr("g_pElfScorePrint Fail\n");
            return false;
        }

        switch(nType)
        {
                printf("nType : %d\n", nType);
            case FILE_DATA_TYPE_C02 :
//                g_pMainControll->LogStr("LoadsC02 Start");
                printf("Load C02 Start\n");
                g_pElfScorePrint->LoadC02File(g_pP0Path);
            break;
            case FILE_DATA_TYPE_C01	:
            break;
            case FILE_DATA_TYPE_ACT	:
//                g_pMainControll->LogStr("Load FILE_DATA_TYPE_ACT Start");
                printf("Load Act start\n");
                g_pElfScorePrint->LoadActFile(g_pP0Path, true);
            break;
            case FILE_DATA_TYPE_C03	:
                printf("Load C03 Start\n");
//                g_pMainControll->LogStr("LoadsC03 Start");
                g_pElfScorePrint->LoadC03File(g_pP0Path);
            break;
        default:
        break;
        }
    }
    
    printf("Cpp Draw End\n");
    return true;
}


///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC SetStaffPostion 테스트 코드
void MainControll::SetStaffPosition(int nStaffNum, int nX, int nY, int nHeight, int nWidth)
{
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[14], nStaffNum, nX, nY, nHeight, nWidth);
    ObjcSetStaffPosition(nStaffNum, nX, nY, nHeight, nWidth);
    return;
}

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC EndPage 테스트 코드
void MainControll::EndPage(int nPageNum, int TotalStaffSu)
{
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[15], nPageNum, TotalStaffSu);
    ObjcEndPage(nPageNum, TotalStaffSu);
    return;
}
///SJW Modify 2023.03.09 End...

///SJW Modify 2023.03.10 Start...
///악보 데이터 저장 함수 구현 생성
int MainControll::GetScoreData(int nTrans1, int nOctave1, int nTrans2, int nOctave2, int nTrans3, int nOctave3, BOOL bChordHeler, BOOL bChordFixed, int nDisplayChord, int nDisplayLyrics, int nLyricsType, int nLyricsCommandments, int nCommandmentsType, int nHapjooChord, int nPrintType, int nScoreSize)
{
    g_struElfScorePrintSetupInfo.nScoreTransPosition[0] = nTrans1;
    g_struElfScorePrintSetupInfo.nScoreTransPosition[1] = nTrans2;
    g_struElfScorePrintSetupInfo.nScoreTransPosition[2] = nTrans3;
    
    g_struElfScorePrintSetupInfo.nScoreOctavePosition[0] = nOctave1;
    g_struElfScorePrintSetupInfo.nScoreOctavePosition[1] = nOctave2;
    g_struElfScorePrintSetupInfo.nScoreOctavePosition[2] = nOctave3;
    
    g_struElfScorePrintSetupInfo.nScoreHapjooViewFlag = nHapjooChord;
    g_struElfScorePrintSetupInfo.nScoreChordViewFlag = nDisplayChord;
    
    g_struElfScorePrintSetupInfo.bIsFixChord = bChordFixed;
    g_struElfScorePrintSetupInfo.bIsStaffKeySignatureNote = bChordHeler;
    
    g_struElfScorePrintSetupInfo.nScoreLyricsViewFlag = nDisplayLyrics; //가사 크기
    g_struElfScorePrintSetupInfo.nScoreLyricsKindFlag = nLyricsType;    //가사 종류
    g_struElfScorePrintSetupInfo.nLyricsTonename = nLyricsCommandments;
    g_struElfScorePrintSetupInfo.nKindTonename = nCommandmentsType;
    
    g_struElfScorePrintSetupInfo.shScoreSize = (short)nScoreSize;
    
    g_struElfScorePrintSetupInfo.nSelectPrintStaff = nPrintType;
    
//    printf("nTrans1 : %d, nTrans2 : %d\n", nTrans1, nTrans2);
    
    ///SJW Modify 2023.03.20 Start...
    ///Objc Interface 에서 필요한 데이터 전송
    ObjcGetLyricsType(nLyricsType);
    ///SJW Modify 2023.03.23 End...
    
    return 1;
}
///SJW Modify 2023.03.10 End...

///SJW Modify 2023.03.10 Start...
///웹 서버 데이터 받는 함수 구현부
int MainControll::GetWebServerData(const char* strMainKey, const char* strManKey, const char* strWomanKey, const char* strUserId, const char* strTag, const char* strMemberId, int nMainTempo, const char* scPrintScoreTransPos, const char* scPrintScoreTransPos2, const char* scPrintScoreTransPos3, int nSongNo, int nCountryMode, int nScoreType, int nFileDataType, int nViewJeonKanjoo, int nSubType, int nDispNumber, BOOL bIsPreViewScore)
{
    g_struScorePrintOptionInfo.nSongNo = nSongNo;
    g_struScorePrintOptionInfo.nRepresentSongNo = nDispNumber;
    g_struScorePrintOptionInfo.nCountryMode = nCountryMode;
    
    g_struScorePrintOptionInfo.nMainScoreType = nScoreType;
    
    g_struScorePrintOptionInfo.bIsPreViewScore = bIsPreViewScore;
    g_struScorePrintOptionInfo.nFileDataType = nFileDataType;
    g_struScorePrintOptionInfo.nViewJeonKanjoo = nViewJeonKanjoo;
    g_struElfScorePrintSetupInfo.bIsViewJeonKanjoo = g_struScorePrintOptionInfo.nViewJeonKanjoo;
    g_struScorePrintOptionInfo.nSubScoreType = nSubType;
    
    g_struScorePrintOptionInfo.nMainTempo = nMainTempo;
    
    const char* scTransPos = scPrintScoreTransPos;
    memcpy(&(g_struScorePrintOptionInfo.scPrintScoreTransPos[0]), scTransPos, strlen(scTransPos));
    
    const char* scTransPos2 = scPrintScoreTransPos2;
    memcpy(&(g_struScorePrintOptionInfo.scPrintScoreTransPos[1]), scTransPos2, strlen(scTransPos2));
    
    const char* scTransPos3 = scPrintScoreTransPos3;
    memcpy(&(g_struScorePrintOptionInfo.scPrintScoreTransPos[2]), scTransPos3, strlen(scTransPos3));
    
    const char* scMainKey = strMainKey;
    memcpy(g_struScorePrintOptionInfo.strMainKey, scMainKey, strlen(scMainKey));
    
    const char* scManKey = strManKey;
    memcpy(g_struScorePrintOptionInfo.strManKey, scManKey, strlen(scManKey));
    
    const char* scWomanKey = strWomanKey;
    memcpy(g_struScorePrintOptionInfo.strWomanKey, scWomanKey, strlen(scWomanKey));
    
    ///SJW Modify 2023.03.20 Start...
    ///Objc Interface에서 필요한 데이터 전달
    ObjcGetCountryMode(nCountryMode);
    ObjcGetScoreType(nScoreType);
    ///SJW Modify 2023.03.20 End...
    
    return 1;
}
///SJW Modify 2023.03.10 End...

void MainControll::LogInt(int nNum)
{
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[17], nNum);
    return;
}

void MainControll::LogStr(char* strTemp)
{

//    jbyteArray bytedddr = g_env->NewByteArray(strlen(strTemp));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(strTemp), (const jbyte*)strTemp);
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[16], bytedddr);
    printf("%s\n", strTemp);

    return;
}

void MainControll::LogStrInt(char* strTemp, int a, int b, int c, int d, int e)
{
//    jbyteArray bytedddr = g_env->NewByteArray(strlen(strTemp));
//    g_env->SetByteArrayRegion(bytedddr, 0, strlen(strTemp), (const jbyte*)strTemp);
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[20], bytedddr, a , b , c ,d, e);

    return;
}
///SJW Modify 2022.12.05 Start...
///JAVA의 GetLeftSpace call 하는 함수
///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC GetLeftSpace 테스트 코드
int MainControll::GetLeftSpace()
{
//    g_pMainControll->m_nLeftSpace = g_env->CallStaticIntMethod(g_jclass,  g_methodID[18]);
    ObjcGetLeftSpace();
    return 0;
}
///SJW Modify2023.03.09 End...

///SJW Modify 2023.03.09 Start...
///JNI 주석, OBJC GetSaxPhoneInfo 테스트 코드
void MainControll::GetSaxPhoneInfo(int a, int b, int c)
{
//    g_env->CallStaticVoidMethod(g_jclass,  g_methodID[21], a , b , c );
    ObjcGetSaxPhoneInfo(a, b, c);
    return ;
}
///SJW Modify 2023.03.09 End...
///SJW Modify 2022.12.05 End...

///SJW Modify 2023.03.02 Start...
///ReDraw 함수 구현
int MainControll::ReDraw()
{
    switch (g_struScorePrintOptionInfo.nFileDataType) {
        case FILE_DATA_TYPE_C02:
            g_pElfScorePrint->RedrawScore();
            break;
        case FILE_DATA_TYPE_C01:
            break;
        case FILE_DATA_TYPE_ACT:
            g_pElfScorePrint->LoadActFile(g_pP0Path, false);
            break;
        case FILE_DATA_TYPE_C03:
            if(true)
            {
                g_pElfScorePrint->ChangeCoordinationInfo(g_struElfScorePrintSetupInfo.nSelectPrintStaff);
            }
            g_pElfScorePrint->RedrawScore();
            break;
        default:
            break;
    }
    return 1;
}
///SJW Modify 2023.03.20 End...

/*
void MainControll::LogNullCheck(char* strTemp, void* pCheck)
{
    if(pCheck == NULL)
    {
        jstring str = g_env->NewStringUTF(strTemp);
        g_env->CallStaticVoidMethod(g_jclass,  g_methodID[16], str);
        jstring str = g_env->NewStringUTF(strTemp);
                g_env->CallStaticVoidMethod(g_jclass,  g_methodID[16], str);
    }
    return;
}*/


//Interface
int CppGetScoreData(int nTrans1, int nOctave1, int nTrans2, int nOctave2, int nTrans3, int nOctave3, BOOL bChordHeler, BOOL bChordFixed, int nDisplayChord, int nDisplayLyrics, int nLyricsType, int nLyricsCommandments, int nCommandmentsType, int nHapjooChord, int nPrintType, int nScoreSize)
{
    MainControll mainController;
    int res = mainController.GetScoreData(nTrans1, nOctave1, nTrans2, nOctave2, nTrans3, nOctave3, bChordHeler, bChordFixed, nDisplayChord, nDisplayLyrics, nLyricsType, nLyricsCommandments, nCommandmentsType, nHapjooChord, nPrintType, nScoreSize);
    return res;
}

///SJW Modify 2023.03.23 Start...
///Compress call
int MainControll::GetFileData(const char* szFtpPath, const char* szP0Path)
{
    CCompressorLz4 Compressor;
    strucCompFile filePack = {0,};
    int nFileCount = 0;
    if(Compressor.OpenLz4(&filePack, szFtpPath))
    {
        if(nFileCount = Compressor.Decompress_FileHandle(szP0Path))
        {
            FILE* fpP02 = fopen(szP0Path, "rb");
            if(fpP02 == NULL)
                return nFileCount;
            
            fseek(fpP02, 0, SEEK_END);
            int nSize = ftell(fpP02);
            
            return nSize;
        }
        else
        {
            return nFileCount + 1000;
        }
    }
    else
    {
        return 22;
    }
}
///SJW Modify 2023.03.23 End...
