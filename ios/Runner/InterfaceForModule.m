//
//  InterfaceForModule.m
//  Runner
//
//  Created by 신정원 on 2023/03/03.
//

#import <Foundation/Foundation.h>
#import "ObjcDef.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <Flutter/Flutter.h>
#import "AppDelegate.h"

//Font Size 리스트
int arrFontSize[25] = {
    12, 14, 16, 18, 20,
    24, 28, 32, 36, 40,
    48, 56, 64, 72, 80,
    96, 112,128,144,160,
    192,224,256,288,320
};


//Font Style
//0: normal , 1:bold , 2:italic
NSInteger nFontStyle = 0;
//실제 폰트 사이즈
int nEmSize = 0;

NSInteger g_nScoreType = 0;
NSInteger g_nCountryMode = 0;
NSInteger g_nLyricsType = 0;

NSInteger nLeftSpcae = 0;
UIFont* font;

bool g_bMenuStringEncodingFlag;


FlutterMethodChannel *flutterChannel;

@interface InterfaceForModule : NSObject

-(void)     SetChannel;

-(void)     SetFontStyle:(int)nEmSize;
-(void)     GetKindItem:(int)nKind lineSize:(int)nLineSize;
-(NSInteger)DrawEachItemFontWidth:(NSString*)strText edgePixel:(NSInteger)nEdgePixel;
-(NSInteger)DrawEachItemFontHeight:(NSString*)strText edgePixel:(NSInteger)nEdge;

-(NSInteger)GetMenuStringWidth:(NSString*)pMenuString maxWidth:(NSInteger)nMaxWidth kind:(NSInteger)nKind
                      lineSize:(NSInteger)nLindSize edge:(NSInteger)nEdge country:(NSInteger)nCountry;
-(NSInteger)GetMenuStringHeight:(NSString*)pMenuString kind:(NSInteger)nKind lineSize:(NSInteger)nLineSize
                           edge:(NSInteger)nEdge country:(NSInteger)nCountry;

-(NSInteger)GetLeftSpaceLetter:(NSString*)strText edgePixel:(NSInteger)nEdgePixcel;
-(NSInteger)GetMenuStringWidthGasa:(NSString*)pMenuString drawHight:(NSInteger)nDrawHight leftSpace:(NSInteger)nLeftSpace;
-(NSInteger)GetMenuStringHeightGasa:(NSString*)pMenuString drawHight:(NSInteger)nDrawHight;

-(NSInteger)GetActFontHeight:(NSString*)strText font:(NSInteger)nFont fontStyle:(NSInteger)nFontStyle size:(NSInteger)nSize x:(NSInteger)nX y:(NSInteger)nY alignment:(NSInteger)nAlignment;
-(NSInteger)GetActFontWidth:(NSString*)strText font:(NSInteger)nFont fontStyle:(NSInteger)nFontStyle size:(NSInteger)nSize x:(NSInteger)nX y:(NSInteger)nY alignment:(NSInteger)nAlignment;
-(void)     SetActFontStyle:(NSInteger)nFont fontStyle:(NSInteger)nFontStyle;

@end

@implementation InterfaceForModule

-(void)SetChannel
{

    AppDelegate* delegate = [[AppDelegate alloc] init];
    flutterChannel = [delegate GetChannel];
    [delegate release];
    
    return;
}

//void SetFontStyle(NSIntegwr nEmSize)
-(void)SetFontStyle:(int)nEmSize
{
    nFontStyle = 0;
    if(g_nScoreType == SCORE_TYPE_INSTRUCTOR) //강사용
    {
        if(g_nCountryMode == LANGUAGE_CHINESE || g_nCountryMode == LANGUAGE_JAPANESE)
        {
            nFontStyle = 0;
            font = [UIFont fontWithName:@"SourceHanSans-Medium" size:nEmSize];
        }
        else
        {
            //SJW 이 폰트 파일만 nil 리턴 함
            font = [UIFont fontWithName:@"SourceHanSans-Medium" size:nEmSize];
            nFontStyle = 1;
        }
    }
    else
    {
        font = [UIFont fontWithName:@"SourceHanSans-Normal" size:nEmSize];
    }
    return;
}

//void GetKindItem(NSInteger nKind, NSInteger nLineSize)
-(void)GetKindItem:(int)nKind lineSize:(int)nLineSize
{
    switch(nKind)
    {
        case 0: //메뉴
            nFontStyle = 0;
            if(nLineSize < 25)
            {
                nEmSize = arrFontSize[nLineSize];
            }
            else
            {
                nEmSize = arrFontSize[2];
            }
            [self SetFontStyle:nEmSize];
            break;
            
        case 1: // 큰 가사
            nFontStyle = 1;
            switch(nLineSize)
            {
                case 0: //일반
                    nEmSize = arrFontSize[10];  break;
                case 1: //타이틀
                    nEmSize = arrFontSize[11];  break;
                case 2:
                    nEmSize = arrFontSize[12];  break;
                case 3: //일반 듀얼 서브
                    nEmSize = arrFontSize[6];   break;
                case 4: //작은 듀얼 메인
                    nEmSize = arrFontSize[5];   break;
                case 5: //작은 일반
                    nEmSize = arrFontSize[7];   break;
                case 6: //작은 듀얼 서브
                    nEmSize = arrFontSize[4];   break;
                case 7:
                    nEmSize = arrFontSize[13];  break;
                case 8: //제목, 가사
                    nEmSize = arrFontSize[7];   break;
                case 9:
                    nEmSize = arrFontSize[3];   break;
                case 10:
                    nEmSize = arrFontSize[4];   break;
                case 11:
                    nEmSize = arrFontSize[5];   break;
                case 12:
                    nEmSize = arrFontSize[6];   break;
                case 13:
                    nEmSize = arrFontSize[7];   break;
                default:
                    nEmSize = arrFontSize[11];  break;
            }
            [self SetFontStyle:nEmSize];
            break;
        default:
            nFontStyle = 0;
            nEmSize = arrFontSize[1];
            [self SetFontStyle:nEmSize];
            break;
            
    }
}

//NSInteger DrawEachItemFontWidth(NSString* strText, NSInteger nEdgePixel)
-(NSInteger)DrawEachItemFontWidth:(NSString*)strText edgePixel:(NSInteger)nEdgePixel
{
    NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize textSize = [strText sizeWithAttributes: userAttributes];
//    NSLog(@"%@ each width : %f\n", strText, floor(textSize.width));
    
//    CTFontRef myFont = CTFontCreateWithName( (CFStringRef)font.fontName, nEmSize, NULL);
//    float nWidth = CTFontGet
    return (NSInteger)(floor(textSize.width));

}

//NSInteger DrawEachItemFontHeight(NSString* strText, NSInteger nEdge)
-(NSInteger)DrawEachItemFontHeight:(NSString *)strText edgePixel:(NSInteger)nEdge
{
//    NSDictionary *userAttributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
//    const CGSize textSize = [strText sizeWithAttributes: userAttributes];
    
    CTFontRef myFont = CTFontCreateWithName( (CFStringRef)font.fontName, nEmSize, NULL);
    float nHeight = CTFontGetDescent(myFont) + CTFontGetAscent(myFont) - CTFontGetUnderlinePosition(myFont);
//    float nHeight = -1 * CTFontGetUnderlinePosition(myFont);
    CFRelease(myFont);
    return (NSInteger)nHeight;
    
}

//NSInteger GetMenuStringWidth(NSString* pMenuString, NSInteger nMaxWidth, NSInteger nKind)
-(NSInteger)GetMenuStringWidth:(NSString*)pMenuString maxWidth:(NSInteger)nMaxWidth kind:(NSInteger)nKind
                      lineSize:(NSInteger)nLindSize edge:(NSInteger)nEdge country:(NSInteger)nCountry
{
    NSString* strMenuString = pMenuString;

//    NSLog(@"GetMenuString Width : %@\n", strMenuString);
    
    NSInteger nTotalWidth=0, nDotPos, nDotPosPre, nTotalWidthPre;
    
    [self GetKindItem:(int)nKind lineSize:(int)nLindSize];
    
    NSInteger nThreePoint = 3 * [self DrawEachItemFontWidth:@"." edgePixel:nEdge];
    NSInteger nPadding = (NSInteger)((nThreePoint * 2) / 3);
    
    
    nDotPosPre = 0;
    nDotPos = 0;
    nTotalWidth = 0;
    nTotalWidthPre = 0;
    
//    for(int i=0; i<pMenuString.length; i++)
//    {
//        char ch = [strMenuString characterAtIndex:i];
//        if(ch >= 0x10)
//        {
//            if(nTotalWidth < (nMaxWidth - nThreePoint - nPadding))
//            {
//                nDotPosPre = nDotPos;
//                nTotalWidthPre = nTotalWidth;
//            }
//            if(ch == 0x20 || ch == 0x2C || ch == 0x2E)
//            {
//                ch = 0x20;
//                nTotalWidth += 9;
//                if(nScoreType == SCORE_TYPE_INSTRUCTOR)
//                {
//                    nTotalWidth += 3;
//                }
//            }
//            nDotPos += 1;
////            NSString *str = [NSString stringWithFormat:@"%c", [strMenuString characterAtIndex:i]];
////            NSRange range;
////            range.location = i;
////            range.length = 1;
////            NSString *str = [strMenuString substringWithRange:range];
//            NSString* temp = [strMenuString substringToIndex:i];
//            NSString* str = [temp substringFromIndex:[temp length] - 1];
//
//            nTotalWidth += [self DrawEachItemFontWidth:str edgePixel:nEdge];
//
//            if(nTotalWidth > nMaxWidth)
//            {
//                nDotPos = nDotPosPre;
//                nTotalWidth = nTotalWidth;
//
//                char temp = [pMenuString characterAtIndex:nDotPos - 1];
//                while((temp == 0x20) || (temp == 0x2C) || (temp == 0x2E) || (temp == 0x0A) || (temp == 0x0D))
//                {
//                    ch = 0x20;
//                    nDotPos -= 1;
//                    NSString *str = [NSString stringWithFormat:@"%c", ch];
//                    nTotalWidth -= [self DrawEachItemFontWidth:str edgePixel:nEdge];
//                    nTotalWidth -= 5;
//                }
//                NSString* strReplace = @"";
//
//                strReplace = [NSString stringWithFormat:@"%c", 0x2E];
//
//                strMenuString = [strMenuString stringByReplacingCharactersInRange:NSMakeRange(nDotPos + 0, 1) withString:strReplace];
//                strMenuString = [strMenuString stringByReplacingCharactersInRange:NSMakeRange(nDotPos + 1, 1) withString:strReplace];
//                strMenuString = [strMenuString stringByReplacingCharactersInRange:NSMakeRange(nDotPos + 2, 1) withString:strReplace];
//
//                strReplace = [NSString stringWithFormat:@"%c", '\0'];
//                strMenuString = [strMenuString stringByReplacingCharactersInRange:NSMakeRange(nDotPos + 2, 1) withString:strReplace];
//
//                nTotalWidth += nThreePoint;
//                break;
//            }
//        }
//    }

    nTotalWidth += [self DrawEachItemFontWidth:strMenuString edgePixel:nEdge];
//    NSLog(@"GetMenuString : %@ , %d\n", pMenuString, nTotalWidth);
    
    return nTotalWidth;
}

//NSInteger GetMenuStringHeight(NSString* pMenuString, NSInteger nKind, NSInteger nLineSize, NSInteger nEdge, NSInteger nCountry)
-(NSInteger)GetMenuStringHeight:(NSString *)pMenuString kind:(NSInteger)nKind lineSize:(NSInteger)nLineSize edge:(NSInteger)nEdge country:(NSInteger)nCountry
{
    g_nCountryMode = nCountry;
    
    NSInteger nMaxHeight = 0;
    NSInteger nHeight = 0;
    
    NSString* strMenuString = pMenuString;
    
//    if(nCountry == LANGUAGE_KOR)
//    {
//        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
//        const char * eucKRString = [pMenuString cStringUsingEncoding:encoding];
//        strMenuString = [NSString stringWithUTF8String:eucKRString];
//    }
//    else if(nCountry == LANGUAGE_CHINESE)
//    {
//        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
//        const char * eucJPString = [pMenuString cStringUsingEncoding:encoding];
//        strMenuString = [NSString stringWithUTF8String:eucJPString];
//    }
//    else if(nCountry == LANGUAGE_JAPANESE)
//    {
//        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95);
//        const char * eucCHString = [pMenuString cStringUsingEncoding:encoding];
//        strMenuString = [NSString stringWithUTF8String:eucCHString];
//    }
//    else if(nCountry == LANGUAGE_ENG)
//    {
//        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//        const char * eucENGString = [pMenuString cStringUsingEncoding:encoding];
//        strMenuString = [NSString stringWithUTF8String:eucENGString];
//    }
//
    
    [self GetKindItem:(int)nKind lineSize:(int)nLineSize];
    
    for(int i=0; i<strMenuString.length; i++)
    {
        char ch = [strMenuString characterAtIndex:i];
        if(ch >= 0x10)
        {
            if(ch == 0x20 || ch == 0x2C || ch == 0x2E)
            {
                ch = 0x20;
            }
            NSString* str = [NSString stringWithFormat:@"%c", ch];
            nHeight = [self DrawEachItemFontHeight:str edgePixel:0];
//            NSLog(@"Height : %ld\n", nHeight);
            if(nHeight > nMaxHeight)
            {
                nMaxHeight = nHeight;
            }
        }
    }
//    NSLog(@"LineSize : %ld nMaxHeight : %ld pMenuString :%@ emSize : %d", nLineSize, nMaxHeight, strMenuString, nEmSize);
    return nMaxHeight;
}

//NSInteger GetLeftSpaceLetter(NSString* pMenuString, NSInteger nEdgePixel)
-(NSInteger)GetLeftSpaceLetter:(NSString *)strText edgePixel:(NSInteger)nEdgePixcel
{
    //안드로이드에서도 0이 return되어서 C모듈에서도 0으로 계산하기 때문에 return 0으로 작성함
    return 0;
}

//NSInteger GetMenuStringWidthGasa(NSString* pMenuString, int nDrawHight, int nLeftSpace)
- (NSInteger)GetMenuStringWidthGasa:(NSString *)pMenuString drawHight:(NSInteger)nDrawHight leftSpace:(NSInteger)nLeftSpace
{
    NSInteger nTotalWidth=0, nDotPos, nDotPosPre, nTotalWidthPre;
    NSInteger m_logPixelsY=96;
    
    if(m_logPixelsY > 96)
    {
        float fReSize = (float)nDrawHight * ((float)m_logPixelsY / 96);
        nDrawHight = (NSInteger)fReSize;
    }
    
    float fRealMenuFontSize = 0;
    
    if(g_nScoreType == SCORE_TYPE_INSTRUCTOR)
    {
        fRealMenuFontSize = 70;
    }
    else
    {
        fRealMenuFontSize = (float)(nDrawHight * 72 / m_logPixelsY);
    }
    
    nEmSize = (int)fRealMenuFontSize;
    [self SetFontStyle:nEmSize];
    
    nTotalWidthPre = 0;
    nDotPosPre = 0;
    nDotPos = 0;
    nTotalWidth = 0;
    
//    for(int i=0; i<[pMenuString length]; i++)
//    {
//        char ch = [pMenuString characterAtIndex:i];
//
//        if(ch == 0x20 || ch == 0x2C || ch == 0x2E)
//        {
//            continue;
//        }
//
//        NSString* str = [NSString stringWithFormat:@"%c", ch];
//        nTotalWidth += [self DrawEachItemFontWidth:str edgePixel:0];
//        nDotPos += 1;
//    }
//    NSLog(@"GetMenuString width Gasa : %@\n", pMenuString);
    nTotalWidth += [self DrawEachItemFontWidth:pMenuString edgePixel:0];
    nLeftSpace = [self GetLeftSpaceLetter:pMenuString edgePixel:0];
    
    return nTotalWidth;
}

//NSInteger GetMenuStringHeightGasa(NSString* pMenuString, NSInteger nDrawHight);
-(NSInteger)GetMenuStringHeightGasa:(NSString *)pMenuString drawHight:(NSInteger)nDrawHight
{
    int nMaxHeight = 0, nHeight = 0;
    int m_logPixelY = 96;
    
    if(m_logPixelY > 96)
    {
        float fReSize = (float)nDrawHight * ((float)m_logPixelY / 96);
        nDrawHight = (int)fReSize;
    }
    
    float fRealMenuFontSize = 0;
    if(g_nScoreType == SCORE_TYPE_INSTRUCTOR)
    {
        fRealMenuFontSize = 70;
    }
    else
    {
        fRealMenuFontSize = (float)(nDrawHight * 72 / m_logPixelY);
    }
    
    nEmSize = (int)fRealMenuFontSize;
    [self SetFontStyle:nEmSize];
    
    for(int i=0; i<[pMenuString length]; i++)
    {
        char ch = [pMenuString characterAtIndex:i];
        if(ch > 0x10)
        {
            if(ch == 0x20 || ch == 0x2C || ch == 0x2E)
            {
                ch = 0x20;
            }
            NSString* str = [NSString stringWithFormat:@"%c", ch];
            nHeight = [self DrawEachItemFontHeight:str edgePixel:0];
            
            if(nMaxHeight < nHeight)
            {
                nMaxHeight = nHeight;
            }
        }
    }
    
    return nMaxHeight;
}

///void SetActFontStyle(NSInteger nFon, NSInteger nFontStyle)
-(void)     SetActFontStyle:(NSInteger)nFont fontStyle:(NSInteger)nFontStyle
{

    switch (nFont) {
        case 0:
            font = [UIFont fontWithName:@"maestro" size:nEmSize];
            break;
        case 1:
            font = [UIFont fontWithName:@"Times New Roman" size:nEmSize];
            break;
        case 2:
            font = [UIFont fontWithName:@"malgun" size:nEmSize];
            break;
        default:
            font = [UIFont fontWithName:@"SourceHanSans-Medium" size:nEmSize];
            break;
    }
}

///NSInteger GetActFontHeight(NSString* strText, NSInteger nFont, NSInteger nFontStyle, NSInteger nSize, NSInteger nX, NSInteger nY, NSInteger nAlignment)
-(NSInteger)GetActFontHeight:(NSString*)strText font:(NSInteger)nFont fontStyle:(NSInteger)nFontStyle size:(NSInteger)nSize x:(NSInteger)nX y:(NSInteger)nY alignment:(NSInteger)nAlignment
{
    NSInteger nMaxHeight = 0, nHeight = 0;
    nEmSize = nSize;
    
    [self SetActFontStyle:nFont fontStyle:nFontStyle];
    for(int i=0; i<[strText length]; i++)
    {
        char ch=[strText characterAtIndex:i];
        NSString* str = [NSString stringWithFormat:@"%c", ch];
        nHeight = [self DrawEachItemFontWidth:str edgePixel:0];
        
        if(nMaxHeight < nHeight)
        {
            nMaxHeight = nHeight;
        }
    }
    return nMaxHeight;
}

///NSInteger GetActFintWidth(NSString* strText, NSInteger nFont, NSInteger nFontStyle NSInteger nSize, NSInteger nX, NSInteger nY, NSInteger nAlignment)
-(NSInteger)GetActFontWidth:(NSString*)strText font:(NSInteger)nFont fontStyle:(NSInteger)nFontStyle size:(NSInteger)nSize x:(NSInteger)nX y:(NSInteger)nY alignment:(NSInteger)nAlignment
{
    NSInteger nTotalWidth = 0;
    nEmSize = nSize;
    
    [self SetActFontStyle:nFont fontStyle:nFontStyle];
    
    for(int i=0; i<[strText length]; i++)
    {
        char ch = [strText characterAtIndex:i];
        NSString* str = [NSString stringWithFormat:@"%c", ch];
        nTotalWidth += [self DrawEachItemFontWidth:str edgePixel:0];
    }
    return nTotalWidth;
}

//C call OBJC InterFace
int ObjcGetMenuStringWidth(const char* pMenuString, int nMaxWidth, int nKind, int nLineSize, int nEdge, int nCountry)
{
    InterfaceForModule* interface = [[InterfaceForModule alloc]init];
    NSString* strMenuString = @"";
    if(g_nCountryMode == LANGUAGE_KOR)
    {
        if(g_bMenuStringEncodingFlag)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else if(g_nCountryMode == LANGUAGE_CHINESE)
    {
        if(g_bMenuStringEncodingFlag)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else if(g_nCountryMode == LANGUAGE_JAPANESE)
    {
        if(g_bMenuStringEncodingFlag)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        
    }
    else if(g_nCountryMode == LANGUAGE_ENG)
    {
        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
    }
    
//    strMenuString = [[strMenuString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];

    int nMenuStringWidth = [interface GetMenuStringWidth:strMenuString maxWidth:nMaxWidth kind:nKind lineSize:nLineSize edge:nEdge country:nCountry];
    
    [interface release];
    return nMenuStringWidth;
}

int ObjcGetMenuStringHeight(const char* pMenuString, int nKind, int nLineSize, int nEdge, int nCountry)
{
//    NSLog(@"pMenuString : %s", pMenuString);
    InterfaceForModule* interface = [[InterfaceForModule alloc]init];
    NSString* strMenuString = @"";
    if(g_nCountryMode == LANGUAGE_KOR)
    {
        if(g_bMenuStringEncodingFlag)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else if(g_nCountryMode == LANGUAGE_CHINESE)
    {
        if(g_bMenuStringEncodingFlag)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else if(g_nCountryMode == LANGUAGE_JAPANESE)
    {
        if(g_bMenuStringEncodingFlag)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        
    }
    else if(g_nCountryMode == LANGUAGE_ENG)
    {
        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
    }
    
//    strMenuString = [[strMenuString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
     
//    NSLog(@"strMenuString : %@", strMenuString);
    int nMenuStringHeight = [interface GetMenuStringHeight:strMenuString kind:nKind lineSize:nLineSize edge:nEdge country:nCountry];
    
    [interface release];
    return nMenuStringHeight;
}

int ObjcGetMenuStringWidthGasa(const char* pMenuString, int nDrawHight, int nLeftSpace)
{
    InterfaceForModule* interface = [[InterfaceForModule alloc]init];
    
    NSString* strMenuString = @"";
    if(g_nLyricsType == LANGUAGE_ORIGINAL)
    {
        if(g_nCountryMode == LANGUAGE_KOR)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_CHINESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_JAPANESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_ENG)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else
    {
//        if(g_nCountryMode == LANGUAGE_JAPANESE)
//        {
//            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISO_2022_KR);
//            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//        }
//        else
//        {
        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//        }
    }
    
    int nMenuStringWidth = [interface GetMenuStringWidthGasa:strMenuString drawHight:nDrawHight leftSpace:nLeftSpcae];
    
    [interface release];
    return nMenuStringWidth;
}

int ObjcGetMenuStringHeightGasa(const char* pMenuString, int nDrawHight)
{
    InterfaceForModule* interface = [[InterfaceForModule alloc]init];
    
    NSString* strMenuString = @"";
    if(g_nLyricsType == LANGUAGE_ORIGINAL)
    {
        if(g_nCountryMode == LANGUAGE_KOR)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_CHINESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_JAPANESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_ENG)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else
    {
        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
//        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISO_2022_KR);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
    }
    
    int nMenuStringHeight = [interface GetMenuStringHeightGasa:strMenuString drawHight:nDrawHight];
    
    [interface release];
    return nMenuStringHeight;
}


int ObjcDrawMenuString(int nStaffNum, char *pMenuString, int nRleft, int nRtop, int nRight, int nBottom, int crColor, int nKind, int nLineSize, int nLineAlign, int nAlignment, bool isAnti, int nCountry, bool bIsNoScale, bool bMenuStringEncodingFlag)
{
    NSString* strMenuString = @"";
    if(g_nCountryMode == LANGUAGE_KOR)
    {
        if(g_bMenuStringEncodingFlag)
        {
//            if(strstr(pMenuString, "남 ") || strstr(pMenuString, "여 "))
//            {
//                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
//            else
//            {
                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else if(g_nCountryMode == LANGUAGE_CHINESE)
    {
        if(g_bMenuStringEncodingFlag)
        {
//            if(strstr(pMenuString, "남 ") || strstr(pMenuString, "여 "))
//            {
//                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
//            else
//            {
                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else if(g_nCountryMode == LANGUAGE_JAPANESE)
    {
        if(g_bMenuStringEncodingFlag)
        {
//            if(strstr(pMenuString, "남 ") || strstr(pMenuString, "여 "))
//            {
//                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
//            else
//            {
                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        
    }
    else if(g_nCountryMode == LANGUAGE_ENG)
    {
        if(g_bMenuStringEncodingFlag)
        {
//            if(strstr(pMenuString, "남 ") || strstr(pMenuString, "여 "))
//            {
//                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
//                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
//            else
//            {
                NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
                strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
//            }
        }
        else
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    
    
    NSDictionary<NSString*, NSObject*> * data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"MenuString":strMenuString,
        @"Left":[NSNumber numberWithInt:nRleft],
        @"Top":[NSNumber numberWithInt:nRtop],
        @"Right":[NSNumber numberWithInt:nRight],
        @"Bottom":[NSNumber numberWithInt:nBottom],
        @"Color":[NSNumber numberWithInt:crColor],
        @"Kind":[NSNumber numberWithInt:nKind],
        @"LineSize":[NSNumber numberWithInt:nLineSize],
        @"LineAlign":[NSNumber numberWithInt:nLineAlign],
        @"Alignment":[NSNumber numberWithInt:nAlignment],
        @"Anti":[NSNumber numberWithBool:isAnti],
        @"Country":[NSNumber numberWithInt:nCountry],
        @"NoScale":[NSNumber numberWithBool:bIsNoScale],
        @"Flag":[NSNumber numberWithBool:false]
    };
    
//    NSLog(@"nStaffNum : %d, pMenuString : %s, nRleft : %d, nRtop : %d, nRight : %d, nBottom : %d, crColor : %d, nKind : %d, nLineSize : %d, nLineAlign : %d, nAlignment : %d, isAnti : %d, nCountry : %d, bIsNoScale : %d\n", nStaffNum, pMenuString, nRleft, nRtop, nRight, nBottom, crColor, nKind, nLineSize, nLineAlign, nAlignment, isAnti, nCountry, bIsNoScale);
    
//    NSLog(@"ObjcDrawMenuString data : %@", data);
    [flutterChannel invokeMethod:@"DrawMenuString" arguments:data];
//    NSLog(@"pass DrawMenuString\n");
    
//    [data release];

    return 1;
}

int ObjcDrawMenuStringGasa(int nStaffNum, char *pMenuString, int nDrawPosX, int nDrawPosY, int crColor, int crEdgeColor, int nDrawHight, bool isAnti)
{
    NSString* strMenuString = @"";
    if(g_nLyricsType == LANGUAGE_ORIGINAL)
    {
        if(g_nCountryMode == LANGUAGE_KOR)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_CHINESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_JAPANESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_ENG)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
        }
    }
    else
    {
        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
        strMenuString = [NSString stringWithCString:pMenuString encoding:encoding];
    }
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"MenuString":strMenuString,
        @"DrawPosX":[NSNumber numberWithInt:nDrawPosX],
        @"DrawPosY":[NSNumber numberWithInt:nDrawPosY],
        @"Color":[NSNumber numberWithInt:crColor],
        @"EdgeColor":[NSNumber numberWithInt:crEdgeColor],
        @"DrawHight":[NSNumber numberWithInt:nDrawHight],
        @"Anti":[NSNumber numberWithBool:isAnti]
    };
    
//    NSLog(@"ObjcDrawMenuStringGasa data : %@", data);
    [flutterChannel invokeMethod:@"DrawMenuStringGasa" arguments:data];
    return 1;
}

int ObjcDrawFontScoreItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, int crColor, bool bIsSetMinMaxPosY)
{
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"FontNo":[NSNumber numberWithInt:nFontNo],
        @"DrawPosX":[NSNumber numberWithInt:nDrawPosX],
        @"DrawPosY":[NSNumber numberWithInt:nDrawPosY],
        @"Color":[NSNumber numberWithInt:crColor],
        @"SetMinMaxPosY":[NSNumber numberWithBool:bIsSetMinMaxPosY]
    };
    
//    NSLog(@"FontNo : %d, Color: %d\n", nFontNo, crColor);
//    NSLog(@"ObjcDrawFontScoreItem data : %@", data);
    [flutterChannel invokeMethod:@"DrawFontScoreItem" arguments:data];
    return 1;
}

int ObjcDrawFontScoreSymbolItem(int nStaffNum, int nFontNo, int nDrawPosX, int nDrawPosY, int crColor)
{
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"FontNo":[NSNumber numberWithInt:nFontNo],
        @"DrawPosX":[NSNumber numberWithInt:nDrawPosX],
        @"DrawPosY":[NSNumber numberWithInt:nDrawPosY],
        @"Color":[NSNumber numberWithInt:crColor]
    };
    
//    NSLog(@"ObjcDrawFontScoreSymbolItem data : %@", data);
    [flutterChannel invokeMethod:@"DrawFontScoreSymbolItem" arguments:data];
    return 1;
}

int ObjcDrawChordEntry(int nStaffNum, char *pChord, int nDrawPosX, int nDrawPosY, int crColor)
{
    NSData* chord = [NSData dataWithBytes:pChord length:strlen(pChord)];
    
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"Chord":[FlutterStandardTypedData typedDataWithBytes:chord],
        @"DrawPosX":[NSNumber numberWithInt:nDrawPosX],
        @"DrawPosY":[NSNumber numberWithInt:nDrawPosY],
        @"Color":[NSNumber numberWithInt:crColor]
    };
    
//    NSLog(@"ObjcDrawChordEntry data : %@", data);
    [flutterChannel invokeMethod:@"DrawChordEntry" arguments:data];
    return 1;
}

int ObjcDrawToneNameEntry(int nStaffNum, int nCountryMode, int nFontNo, int nDrawPosX, int nDrawPosY, int crColor)
{
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"Lyrics":[NSNumber numberWithInt:nFontNo],
        @"CountryMode":[NSNumber numberWithInt:nCountryMode],
        @"DrawPosX":[NSNumber numberWithInt:nDrawPosX],
        @"DrawPosY":[NSNumber numberWithInt:nDrawPosY],
        @"Color":[NSNumber numberWithInt:crColor]
    };
    
//    NSLog(@"ObjcDrawToneNameEntry data : %@", data);
    [flutterChannel invokeMethod:@"DrawToneNameEntry" arguments:data];
    return 1;
}

int ObjcDrawLine(int nStaffNum, int nX1, int nY1, int nX2, int nY2, int crColor, int nThickness, bool bIsDotLine)
{
    
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"X1":[NSNumber numberWithInt:nX1],
        @"Y1":[NSNumber numberWithInt:nY1],
        @"X2":[NSNumber numberWithInt:nX2],
        @"Y2":[NSNumber numberWithInt:nY2],
        @"Color":[NSNumber numberWithInt:crColor],
        @"Thickness":[NSNumber numberWithInt:nThickness],
        @"DotLine":[NSNumber numberWithBool:bIsDotLine]
    };
    
//    NSLog(@"ObjcDrawLine data : %@", data);
    [flutterChannel invokeMethod:@"DrawLine" arguments:data];
    return 1;
}

int ObjcDrawHorizonLine(int nStaffNum, int nPosY, int nStartX, int nEndX, int crColor, int nThickness, bool bIsDotLine)
{
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"PosY":[NSNumber numberWithInt:nPosY],
        @"StartX":[NSNumber numberWithInt:nStartX],
        @"EndX":[NSNumber numberWithInt:nEndX],
        @"Color":[NSNumber numberWithInt:crColor],
        @"Thickness":[NSNumber numberWithInt:nThickness],
        @"DotLine":[NSNumber numberWithBool:bIsDotLine]
    };
    
//    NSLog(@"ObjcDrawHorizonLine data : %@", data);
    [flutterChannel invokeMethod:@"DrawHorizonLine" arguments:data];
    return 1;
}

int ObjcDrawVerticalLine(int nStaffNum, int nPosX, int nStartY, int nEndY, int crColor, int nThickness, bool bIsDotLine)
{
    NSDictionary<NSString*, NSObject*> *data = @{
      @"StaffNum":[NSNumber numberWithInt:nStaffNum],
      @"PosX":[NSNumber numberWithInt:nPosX],
      @"StartY":[NSNumber numberWithInt:nStartY],
      @"EndY":[NSNumber numberWithInt:nEndY],
      @"Color":[NSNumber numberWithInt:crColor],
      @"Thickness":[NSNumber numberWithInt:nThickness],
      @"DotLine":[NSNumber numberWithBool:bIsDotLine],
    };
    
//    NSLog(@"ObjcDrawVerticalLine data : %@", data);
    [flutterChannel invokeMethod:@"DrawVerticalLine" arguments:data];
    return 1;
}

int ObjcDrawPolyBezier(int nStaffNum, int nStartX, int nStartY, int nEndX, int nEndY, int nUpDown, int crColor)
{
    NSDictionary<NSString*, NSObject*> *data = @{
      @"StaffNum":[NSNumber numberWithInt:nStaffNum],
      @"StartX":[NSNumber numberWithInt:nStartX],
      @"StartY":[NSNumber numberWithInt:nStartY],
      @"EndX":[NSNumber numberWithInt:nEndX],
      @"EndY":[NSNumber numberWithInt:nEndY],
      @"UpDown":[NSNumber numberWithInt:nUpDown],
      @"Color":[NSNumber numberWithInt:crColor]
    };
    
//    NSLog(@"ObjcDrawPolyBezier data : %@", data);
    [flutterChannel invokeMethod:@"DrawPolyBezier" arguments:data];
    return 1;
}

int ObjcDrawDiagonalLine(int nStaffNum, int nStartX, int nEndX, int nStartY, int nEndY, int crColor, int nThickness, bool bIsDotLine)
{
    NSDictionary<NSString*, NSObject*> *data = @{
      @"StaffNum":[NSNumber numberWithInt:nStaffNum],
      @"StartX":[NSNumber numberWithInt:nStartX],
      @"EndX":[NSNumber numberWithInt:nEndX],
      @"StartY":[NSNumber numberWithInt:nStartY],
      @"EndY":[NSNumber numberWithInt:nEndY],
      @"Color":[NSNumber numberWithInt:crColor],
      @"Thickness":[NSNumber numberWithInt:nThickness],
      @"DotLine":[NSNumber numberWithBool:bIsDotLine]
    };
    
//    NSLog(@"ObjcDrawDiagonalLine data : %@", data);
    [flutterChannel invokeMethod:@"DrawDiagonalLine" arguments:data];
    return 1;
}

int ObjcDrawActFont(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment ,int nLang)
{
//    NSLog(@"objc Draw Act font\n");
    
    NSString* strFont = nil;
    NSData* byteData = nil;
    ///원어, 독음 분기
    if(nFont != 0)
    {
        if(g_nCountryMode == LANGUAGE_KOR)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            strFont = [NSString stringWithCString:string encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_CHINESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_CN);
            strFont = [NSString stringWithCString:string encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_JAPANESE)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingShiftJIS);
            strFont = [NSString stringWithCString:string encoding:encoding];
        }
        else if(g_nCountryMode == LANGUAGE_ENG)
        {
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            strFont = [NSString stringWithCString:string encoding:encoding];
        }
//        strFont = [NSString stringWithFormat:@"%s", string];
    }
    else
    {
        byteData = [NSData dataWithBytes:string length:strlen(string)];
    }
    
    NSDictionary<NSString*, NSObject*> *data = @{
      @"StaffNum":[NSNumber numberWithInt:nStaffNum],
      @"FontData": nFont !=0 ? strFont : [FlutterStandardTypedData typedDataWithBytes:byteData],
//      @"FontData":[FlutterStandardTypedData typedDataWithBytes:byteData],
      @"DrawPosX":[NSNumber numberWithInt:x],
      @"DrawPosY":[NSNumber numberWithInt:y],
      @"nFontSelect":[NSNumber numberWithInt:nFont],
      @"nFontStyle":[NSNumber numberWithInt:nFontStyle],
      @"Size":[NSNumber numberWithInt:nSize],
      @"Alignment":[NSNumber numberWithInt:nAlignment]
    };
    
//    NSLog(@"ObjcDrawActFont data : %@", data);
    [flutterChannel invokeMethod:@"DrawActFont" arguments:data];
    return 1;
}

int ObjcGetActFontheight(int nStaffNum, const char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment)
{
    InterfaceForModule* interface = [[InterfaceForModule alloc]init];
    
    NSString* strFont = [NSString stringWithUTF8String: string];
    int nActFontHeight = [interface GetActFontHeight:strFont font:nFont fontStyle:nFontStyle size:nSize x:x y:y alignment:nAlignment];
    
    [interface release];

    return nActFontHeight;
}

int ObjcGetActFontwidth(int nStaffNum, char* string, int nFont, int nFontStyle,int nSize, int x, int y, int nAlignment)
{
    InterfaceForModule* interface = [[InterfaceForModule alloc]init];
    
    NSString* strFont = [NSString stringWithUTF8String: string];
    int nActFontWidth = [interface GetActFontWidth:strFont font:nFont fontStyle:nFontStyle size:nSize x:x y:y alignment:nAlignment];
    
    [interface release];
    return nActFontWidth;
}

int ObjcSetTransMinMax(int nMinKey, int nMaxKey)
{
    NSDictionary<NSString*, NSObject*> *data = @{
        @"MinKey":[NSNumber numberWithInt:nMinKey],
        @"MaxKey":[NSNumber numberWithInt:nMaxKey]
    };
    
//    NSLog(@"ObjcSetTransMinMax data : %@", data);
    [flutterChannel invokeMethod:@"SetTransMinMax" arguments:data];
    return 1;
}

void ObjcSetStaffPosition(int nStaffNum, int nX, int nY, int nHeight, int nWidth)
{
    NSDictionary<NSString*, NSObject*> *data = @{
        @"StaffNum":[NSNumber numberWithInt:nStaffNum],
        @"PosX":[NSNumber numberWithInt:nX],
        @"PosY":[NSNumber numberWithInt:nY],
        @"Height":[NSNumber numberWithInt:nHeight],
        @"Width":[NSNumber numberWithInt:nWidth]
    };
    
//    NSLog(@"ObjcSetStaffPosition data : %@", data);
    [flutterChannel invokeMethod:@"SetStaffPosition" arguments:data];
    return;
}

void ObjcEndPage(int nPageNum, int TotalStaffSu)
{
    NSDictionary<NSString*, NSObject*> *data = @{
        @"PageNum":[NSNumber numberWithInt:nPageNum],
        @"TotalStaffSu":[NSNumber numberWithInt:TotalStaffSu]
    };
    
//    NSLog(@"ObjcEndPage data : %@", data);
    [flutterChannel invokeMethod:@"EndPage" arguments:data];
    return;
}

int  ObjcGetLeftSpace()
{
    return (int)nLeftSpcae;
}

void ObjcGetSaxPhoneInfo(int nTrans1, int nTrans2, int nTrans3)
{
    NSDictionary<NSString*, NSObject*> *data = @{
      @"Trans1":[NSNumber numberWithInt:nTrans1],
      @"Trans2":[NSNumber numberWithInt:nTrans2],
      @"Trans3":[NSNumber numberWithInt:nTrans3]
    };
    
//    NSLog(@"ObjcGetSaxPhoneInfo data : %@", data);
    [flutterChannel invokeMethod:@"GetSaxPhoneInfo" arguments:data];
    return;
}

void ObjcGetCountryMode(int nCountryMode)
{
    g_nCountryMode = nCountryMode;
    return;
}

void ObjcGetScoreType(int nScoreType)
{
    g_nScoreType = nScoreType;
    return;
}

void ObjcGetLyricsType(int nLyricsType)
{
    g_nLyricsType = nLyricsType;
    return;
}

void ObjcSetChannel()
{
    InterfaceForModule* interface = [[InterfaceForModule alloc] init];
    [interface SetChannel];
    [interface release];
    return;
}

void ObjcGetMenuStringEncodingFlag(bool bMenuStringEncodingFlag)
{
    g_bMenuStringEncodingFlag = bMenuStringEncodingFlag;
    return;
}
@end

