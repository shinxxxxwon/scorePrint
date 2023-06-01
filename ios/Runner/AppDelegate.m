#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "KISA_SEED_ECB.h"
#import "sha256.h"
#import <AdSupport/AdSupport.h>
#import "ServerData.h"
#import "SettingsData.h"
#include "CppTest.hpp"
#include "CompressLz4/CompressorLz4.h"
#include "main.h"
#include "ObjcDef.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/stitching.hpp>

#import <UIKit/UIKit.h>


MainControll* g_pMainController = nullptr;
//Objc* g_pObjcController = nil;

int nSongInfoMaxLength = 0;
FlutterMethodChannel *pChannel = nil;


@interface UIWindow (Secure)

- (void)makeSecure;

@end

@implementation UIWindow (Secure)

- (void)makeSecure {
    UITextField *field = [[UITextField alloc] init];
    field.secureTextEntry = YES;

    field.backgroundColor = [UIColor whiteColor];
    field.textColor = [UIColor blackColor];
    field.textAlignment = NSTextAlignmentCenter;
    field.text = @"Prevent Capture";
    field.userInteractionEnabled = NO;

    [self addSubview:field];
    [field.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [field.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.layer.superlayer addSublayer:field.layer];
    [field.layer.sublayers.firstObject addSublayer:self.layer];
}

@end

@implementation AppDelegate

- (void)handleScreenshotNotification:(NSNotification *)notification {
    // 캡처 시 알림창 표시
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"알림"
                                                                             message:@"스크린 캡처를 지원하지 않습니다."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"확인"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alertController addAction:dismissAction];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

  FlutterViewController *controller = (FlutterViewController*) self.window.rootViewController;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleScreenshotNotification:)
                                                     name:UIApplicationUserDidTakeScreenshotNotification
                                                   object:nil];
    //캡처 방지
    [self.window makeSecure];
    
    FlutterMethodChannel *CHANNEL = [FlutterMethodChannel
             methodChannelWithName:@"native.flutter.kisatest" binaryMessenger:controller.binaryMessenger];

    pChannel = CHANNEL;
    NSLog(@"Channel : %p\n",CHANNEL);
    
  [CHANNEL setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result)
  {

      if([@"preventCapture" isEqual:call.method]){
        UIView *blockerView = [[UIView alloc] initWithFrame:controller.view.bounds];
        blockerView.backgroundColor = [UIColor clearColor];
        [controller.view addSubview:blockerView];
        [controller.view bringSubviewToFront:blockerView];
        result(nil);
      }
      
      //악보 그리기 시작 함수
      if([@"DrawStart" isEqualToString:call.method])
      {
          NSLog(@"objc draw Start");
          
          NSNumber* nSongNo = call.arguments[@"SongNo"];
          NSNumber* nFileDataType = call.arguments[@"FileDataType"];
          NSString* strP0Path = call.arguments[@"P0Path"];
          
          NSDictionary<NSString*, NSObject*> *data = @{
              @"string" : @"IOS_CHANNEL_TEST",
              @"int" : [NSNumber numberWithInt:101],
              @"bool" : [NSNumber numberWithBool:false]
          };
          [CHANNEL invokeMethod:@"IOS_CHANNEL_TEST" arguments:data];
          
          int nSongNoInteger = [nSongNo intValue];
          int nFileDataTypeInteger = [nFileDataType intValue];
          const char* strP0PathChar = [strP0Path UTF8String];
          
          NSLog(@"Draw Start nSognNo %d\n", nSongNoInteger);
          NSLog(@"Draw Start nFileDataType %d\n", nFileDataTypeInteger);
          NSLog(@"Draw Start P0Path %s\n", strP0PathChar);
          
          bool res = g_pMainController->DrawScoreStart(nFileDataTypeInteger, strP0PathChar);
          
//          [nSongNo release];
//          [nFileDataType release];
//          [strP0Path release];
          
//          [pChannel release];
          if(g_pMainController !=  nullptr)
          {
              NSLog(@"release g_pMainController\n");
              delete g_pMainController;
              g_pMainController = nullptr;
          }
          
          NSLog(@"objc draw End");
//          result([NSNumber numberWithInt:res]);
          result([NSNumber numberWithInt:1]);
      }
      
      if([@"ReDrawScore" isEqualToString:call.method])
      {
          NSLog(@"reDraw\n");
          int res = g_pMainController->ReDraw();
          result([NSNumber numberWithInt:res]);
      }
      
      if([@"GetEnsembleImage" isEqualToString:call.method])
      {
          NSString* strPath = call.arguments[@"Path"];
          NSString* strTiff = call.arguments[@"Tiff"];
          NSString* strName = call.arguments[@"Name"];
          
          NSString* tiffName = [strName stringByAppendingString:@".tiff"];
          
          NSString* readFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:tiffName];
          UIImage* image = [[UIImage alloc] initWithContentsOfFile:readFilePath];
          NSLog(@"image:%@", image);
          cv::String tiffPath = [readFilePath cStringUsingEncoding:NSUTF8StringEncoding];

          //Read Tiff
          cv::Mat tiffImage;
          UIImageToMat(image, tiffImage, true);
          
          //Change Background Alpha
          cv::Mat input_bgra;
          cv::cvtColor(tiffImage, input_bgra, cv::COLOR_BGR2BGRA);
          for (int y = 0; y < input_bgra.rows; ++y)
              for (int x = 0; x < input_bgra.cols; ++x)
              {
                  cv::Vec4b & pixel = input_bgra.at<cv::Vec4b>(y, x);
                  // if pixel is white
                  if (pixel[0] == 255 && pixel[1] == 255 && pixel[2] == 255)
                  {
                      // set alpha to zero:
                      pixel[3] = 0;
                  }
              }
          
        
          NSString* pngName = [strName stringByAppendingString:@".png"];
          NSString* saveFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:pngName];
          //Write PNG
          cv::String writepath_str = [saveFilePath cStringUsingEncoding:NSUTF8StringEncoding];
          bool res = cv::imwrite(writepath_str, input_bgra);
          NSLog(@"cm write:%d", res);
          
//          bool res = cv::imwrite(pngPath, tiffImage);
          result([NSNumber numberWithBool:res]);
      }
      
      if([@"GetWebServerData" isEqualToString:call.method])
      {
          NSString* nsMainKey = call.arguments[@"strMainKey"];
          NSString* nsManKey = call.arguments[@"strMankey"];
          NSString* nsWomanKey = call.arguments[@"strWomanKey"];
          NSString* nsUserId = call.arguments[@"strUserId"];
          NSString* nsTag = call.arguments[@"Tag"];
          NSString* nsMemberId = call.arguments[@"strMemberId"];
          NSString* nsPrintScoreTransPos = call.arguments[@"scPrintScoreTransPos"];
          NSString* nsPrintScoreTransPos2 = call.arguments[@"scPrintScoreTransPos2"];
          NSString* nsPrintScoreTransPos3 = call.arguments[@"scPrintScoreTransPos3"];
          NSString* nsMainTempo = call.arguments[@"strMainTempo"];
          
          NSNumber* nsSongNo = call.arguments[@"SongNo"];
          NSNumber* nsCountryMode = call.arguments[@"NCountryMode"];
          NSNumber* nsScoreType = call.arguments[@"nScoreType"];
          NSNumber* nsFileDataType = call.arguments[@"nFileDataType"];
          NSNumber* nsViewJeonKanjoo = call.arguments[@"nViewJeonKanjoo"];
          NSNumber* nsSubType = call.arguments[@"nSubType"];
          NSNumber* nsDispNumber = call.arguments[@"DispNumber"];
          
          NSNumber* nsIsPreViewScore = call.arguments[@"blsPreViewScore"];
          
          const char* strMainKey = [nsMainKey UTF8String];
          const char* strManKey = [nsManKey UTF8String];
          const char* strWomanKey = [nsWomanKey UTF8String];
          const char* strUserId = [nsUserId UTF8String];
          const char* strTag = [nsTag UTF8String];
          const char* strMemberId = [nsMemberId UTF8String];
          const char* strPrintScoreTransPos = [nsPrintScoreTransPos UTF8String];
          const char* strPrintScoreTransPos2 = [nsPrintScoreTransPos2 UTF8String];
          const char* strPrintScoreTransPos3 = [nsPrintScoreTransPos3 UTF8String];
          
          int nMainTempo = [nsMainTempo intValue];
          int nSongNo = [nsSongNo intValue];
          int nCountryMode = [nsCountryMode intValue];
          int nScoreType = [nsScoreType intValue];
          int nFileDataType = [nsFileDataType intValue];
          int nViewJeonKanjoo = [nsViewJeonKanjoo intValue];
          int nSubType = [nsSubType intValue];
          int nDispNumber = [nsDispNumber intValue];
          
          bool bIsPreViewScore = [nsIsPreViewScore boolValue];
          
          if(g_pMainController ==  nullptr)
          {
              NSLog(@"alloc g_pMainController in Web\n");
              g_pMainController = new MainControll();
          }
          
          g_pMainController->GetWebServerData(strMainKey, strManKey, strWomanKey, strUserId, strTag, strMemberId, nMainTempo, strPrintScoreTransPos, strPrintScoreTransPos2, strPrintScoreTransPos3, nSongNo, nCountryMode, nScoreType, nFileDataType, nViewJeonKanjoo, nSubType, nDispNumber, bIsPreViewScore);
                
          result([NSNumber numberWithInt:1]);
      }
      
      if([@"GetSongInfoMaxLength" isEqualToString:call.method])
      {
          result([NSNumber numberWithInt:nSongInfoMaxLength]);
      }
      
      if([@"InitSongInfoMaxLength" isEqualToString:call.method])
      {
          nSongInfoMaxLength = 0;
          result([NSNumber numberWithInt:1]);
      }
      
      
      if([@"GetScoreData" isEqualToString:call.method])
      {
          NSNumber* nsTrans1 = call.arguments[@"Trans1"];
          NSNumber* nsOctave1 = call.arguments[@"Octave1"];
          NSNumber* nsTrans2 = call.arguments[@"Trans2"];
          NSNumber* nsOctave2 = call.arguments[@"Octave2"];
          NSNumber* nsTrans3 = call.arguments[@"Trans3"];
          NSNumber* nsOctave3 = call.arguments[@"Octave3"];
          
          NSNumber* nsbChordHelper = call.arguments[@"ChordHelper"];
          NSNumber* nsbChordFixed = call.arguments[@"ChordFixed"];
          
          NSNumber* nsnDisplayChord = call.arguments[@"DisplayChord"];
          NSNumber* nsnDisplayLyrics = call.arguments[@"DisplayLyrics"];
          NSNumber* nsnLyricsType = call.arguments[@"LyricsType"];
          NSNumber* nsnLyricsCommandmentsType = call.arguments[@"LyricsCommandments"];
          NSNumber* nsnCommandmentsType = call.arguments[@"CommandmentsType"];
          NSNumber* nsnHapjooChord = call.arguments[@"HapjooChord"];
          NSNumber* nsnPrintType = call.arguments[@"PrintType"];
          NSNumber* nsnScoreSize = call.arguments[@"ScoreSize"];
          
          int nTrans1 = [nsTrans1 intValue];
          int nOctave1 = [nsOctave1 intValue];
          int nTrans2 = [nsTrans2 intValue];
          int nOctave2 = [nsOctave2 intValue];
          int nTrans3 = [nsTrans3 intValue];
          int nOctave3 = [nsOctave3 intValue];
          
          bool bChordHelper = [nsbChordHelper boolValue];
          bool bChordFixed = [nsbChordFixed boolValue];
          
          int nDisplayChord = [nsnDisplayChord intValue];
          int nDisplayLyrics = [nsnDisplayLyrics intValue];
          int nLyricsType = [nsnLyricsType intValue];
          int nLyricsCommandmentsType = [nsnLyricsCommandmentsType intValue];
          int nCommandmentsType = [nsnCommandmentsType intValue];
          int nHapjooChord = [nsnHapjooChord intValue];
          int nPrintType = [nsnPrintType intValue];
          int nScoreSize = [nsnScoreSize intValue];
        
//          NSLog(@"call GetScore Data\n");
          
          g_pMainController->GetScoreData(nTrans1, nOctave1, nTrans2, nOctave2, nTrans3, nOctave3, bChordHelper, bChordFixed, nDisplayChord, nDisplayLyrics, nLyricsType, nLyricsCommandmentsType, nCommandmentsType, nHapjooChord, nPrintType, nScoreSize);
          
          result([NSNumber numberWithInt:1]);
                                
      }
      
      //uri가 null일때 크롬 또느 사파리 브라우저로 이동시키는 메서드
      if([@"OpenChrome" isEqualToString:call.method])
      {
          NSString* url = @"https://m.elf.co.kr";
          NSURL *inputURL = [NSURL URLWithString:url];
          NSString *scheme = inputURL.scheme;

          // Replace the URL Scheme with the Chrome equivalent.
          NSString *chromeScheme = nil;
          if ([scheme isEqualToString:@"http"]) {
              chromeScheme = @"googlechrome";
          } else if ([scheme isEqualToString:@"https"]) {
              chromeScheme = @"googlechromes";
          }

          // Proceed only if a valid Google Chrome URI Scheme is available.
          if (chromeScheme) {
              NSString *absoluteString = [inputURL absoluteString];
              NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
              NSString *urlNoScheme =
              [absoluteString substringFromIndex:rangeForScheme.location];
              NSString *chromeURLString =
              [chromeScheme stringByAppendingString:urlNoScheme];
              NSURL *chromeURL = [NSURL URLWithString:chromeURLString];

              if ([[UIApplication sharedApplication] canOpenURL:chromeURL])
              {
                  // Open the URL with Chrome.
                  [[UIApplication sharedApplication] openURL:chromeURL];
              }
              else
              {
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://m.elf.co.kr"]];
              }
//              [absoluteString release];
//              [urlNoScheme release];
//              [chromeURL release];
//              [chromeURLString release];
              
          }
          
//          [url release];
//          [inputURL release];
//          [scheme release];
//          [chromeScheme release];
          result(0);
      }

      if([@"SeedDecrypt" isEqualToString:call.method])
      {
          //데이터 길이 Flutter -> OBJC
          NSNumber* argLen = call.arguments[@"dataLen"];
          NSNumber* argValueLen = call.arguments[@"valueLen"];
          NSNumber* cnt = call.arguments[@"cnt"];
          
          //데이터길이 자료형 변화 NSNumber* -> NSUInteger
          NSUInteger argInteger = [argLen integerValue];
          NSUInteger argValueInteger = [argValueLen integerValue];
          NSUInteger cntInteger = [cnt integerValue];
          NSUInteger len = (int)(cntInteger / 16);

          //Key값 & 데이터 get  Fultter -> OBJC
          FlutterStandardTypedData* arg = call.arguments[@"data"];
          FlutterStandardTypedData* argValue = call.arguments[@"value"];
          
          DWORD pdwRoundKey[32];

          //메모리 할당
          BYTE* key = (BYTE*)malloc(argInteger);
          BYTE* keyValue = (BYTE*)malloc(argValueInteger);
          
          //Copy
          memcpy(key, [arg.data bytes], argInteger);
          memcpy(keyValue, [argValue.data bytes], argValueInteger);

          SEED_KeySchedKey(pdwRoundKey, key);

          for(int i=0; i<len; i++)
          {
              SEED_Decrypt_ECB(&keyValue[16 * i], pdwRoundKey);
          }

          //데이터 자료형 변환 BYTE* -> NSData*
          NSData* res = [NSData dataWithBytes:keyValue length:argValueInteger];
          FlutterStandardTypedData* rest = [FlutterStandardTypedData typedDataWithBytes:res];

          //메모리 해제
          free(key);
          free(keyValue);

//          [argLen release];
//          [argValueLen release];
//          [cnt release];
          
          //데이터 return  OBJC -> Flutter
          result(rest);
          
//          [res release];
//          [rest release];
          
          
      }
      else if([@"SHA256_Encrypt" isEqualToString:call.method])
      {
          NSNumber* paramTempLen = call.arguments[@"paramLen"];
          NSNumber* buffTempLen = call.arguments[@"buffLen"];
          
          NSUInteger paramLen = [paramTempLen integerValue];
          NSUInteger buffLen = [buffTempLen integerValue];
          
          FlutterStandardTypedData* paramTemp = call.arguments[@"param"];
          FlutterStandardTypedData* buffTemp = call.arguments[@"buff"];
          
          BYTE* param = (BYTE*)malloc(paramLen);
          BYTE* buff = (BYTE*)malloc(buffLen);

          memcpy(param, [paramTemp.data bytes], paramLen);
          memcpy(buff, [buffTemp.data bytes], buffLen);

          KISA_SHA256_MD(param, paramLen, buff);

          NSData* res = [NSData dataWithBytes:buff length:buffLen];
          FlutterStandardTypedData* rest = [FlutterStandardTypedData typedDataWithBytes:res];
          
          free(param);
          free(buff);
    
//          [paramTempLen release];
//          [buffTempLen release];
          
          result(rest);
//          [res release];
//          [rest release];
      }
      if([@"Set_Server_Data" isEqualToString:call.method])
            {
                //OBJC MAP
//                NSDictionary* data = call.arguments;
                //함수 initData 호출
//                [serverData initData];
                //함수 setData 호출
//                [serverData setData:data];

                //==============================================================
                //C++ TEST
//                cpptest->SetName((char*)[[serverData strUserId] UTF8String]);
//                cpptest->SetAge([serverData nSongNo].intValue);
//                cpptest->SetHeight(10.12);

//                NSDictionary* res = @{
//                    @"Name" : [NSString stringWithUTF8String:cpptest->GetName()],
//                    @"Age" : [NSNumber numberWithInt:cpptest->GetAge()],
//                    @"Height" : [NSNumber numberWithDouble:cpptest->GetHeight()],
//                };
                //================f==============================================

      //          result([NSString stringWithUTF8String:cpptest->GetName()()]);
                result(0);
            }
            if([@"Set_Settings_Data" isEqualToString:call.method])
            {
                //OBJC MAP
//                NSDictionary* data = call.arguments;
                //함수 initData 호출
//                [settingsData initData];
                //함수 setData 호출
//                [settingsData setData:data];

//                result([settingsData nTrans1]);
                result(0);
            }
            if([@"Compress_C02" isEqualToString:call.method])
            {
//                pChannel = CHANNEL;
                NSString* strFtpFilePath = call.arguments[@"ftpFilePath"];
                NSString* strP0FilePath = call.arguments[@"p0FilePath"];
                
                char* szFtpFilePath = (char*)[strFtpFilePath UTF8String];
                char* szP0FilePath = (char*)[strP0FilePath UTF8String];
                
                NSLog(@"ftpFilePath : %s", szFtpFilePath);
                //NSLog(@"strP0FilePath : %s", szP0FilePath);
                
//                if(g_pObjcController == nil)
//                {
//                    g_pObjcController = [[Objc alloc]init];
//                }
                
                if(g_pMainController ==  nullptr)
                {
                    NSLog(@"alloc g_pMainController\n");
                    g_pMainController = new MainControll();
                }
                
//                CCompressorLz4 Compress;
//                int res = Compress.ConvertFile(szFtpFilePath, szP0FilePath);
                
                int res = g_pMainController->GetFileData(szFtpFilePath, szP0FilePath);
                
                result([NSNumber numberWithInt:res]);
            }
                
            if([@"Free_Cpp_Memory" isEqualToString:call.method])
            {
//                free(cpptest);

                result([NSNumber numberWithInt:1]);
            }
            if([@"dataSpeedTest" isEqualToString:call.method])
            {
//                CCompressorLz4 Compressor;
//                int res = Compressor.DataSpeedTest();
                int res = 0;
                result([NSNumber numberWithInt:res]);
            }
  }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(FlutterMethodChannel*)GetChannel
{
    return pChannel;
}

@end

