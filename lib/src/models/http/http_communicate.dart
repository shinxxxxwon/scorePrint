import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/commandments_type_provider.dart';
import '../../providers/dan_settings_provider.dart';
import '../../providers/display_code_provider.dart';
import '../../providers/display_lyrics_provider.dart';
import '../../providers/ensemble_code_provider.dart';
import '../../providers/keynote_assistant_provider.dart';
import '../../providers/lyrics_commandments_provider.dart';
import '../../providers/lyrics_type_provider.dart';
import '../../providers/octave_provider.dart';
import '../../providers/score_size_provider.dart';
import '../../providers/transposition_code_fixed_provider.dart';
import '../../providers/transposition_provider.dart';
import '../../resources/score/score_info_controller.dart';
import '../data/user_data.dart';

class HttpCommunicate {
  ///SJW Modify 2022.04.25 Start...1  convert의 base64매서드로 대체함
//   /*------ Base64 Encoding Table ------*/
//   static List<String> MimeBase64 = [
//     'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
//     'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
//     'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
//     'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
//     'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
//     'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
//     'w', 'x', 'y', 'z', '0', '1', '2', '3',
//     '4', '5', '6', '7', '8', '9', '+', '/'
//   ];
//
//
// /*------ Base64 Decoding Table ------*/
//   static List<int> DecodeMimeBase64 = [
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* 00-0F */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* 10-1F */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,62,-1,-1,-1,63,  /* 20-2F */
//     52,53,54,55,56,57,58,59,60,61,-1,-1,-1,-1,-1,-1,  /* 30-3F */
//     -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,  /* 40-4F */
//     15,16,17,18,19,20,21,22,23,24,25,-1,-1,-1,-1,-1,  /* 50-5F */
//     -1,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,  /* 60-6F */
//     41,42,43,44,45,46,47,48,49,50,51,-1,-1,-1,-1,-1,  /* 70-7F */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* 80-8F */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* 90-9F */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* A0-AF */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* B0-BF */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* C0-CF */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* D0-DF */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  /* E0-EF */
//     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1   /* F0-FF */
//   ];
  ///SJW Modify End...1
  static const String strWebSeedKey = "uzlAeE4Vw2aY!eW0";

  String? strMode;
  String? strPort;
  String? strIpAddress;
  String? strSSID;
  String? strDUID;
  String? strASID;
  String? strBuyTransPosList;
  String? strMainKey;
  String? strManKey;
  String? strWomanKey;
  String? strMainTempo;
  String? strUserId;
  String? strTag;
  String? strMemberId;
  String? strScorePrice;
  String? strscPrintScoreTransPos;
  String? strscPrintScoreTransPos2;
  String? strscPrintScoreTransPos3;

  int? nSongNo;
  int? nCountryMode;
  int? nScoreType;
  int? nFileDataType;
  int? nViewJeonKanjoo;
  int? nSubType;
  int? nDispNumber;
  int? nScoreSize;

  bool? bIsPreViewScore;

  ///악보 크기 (아직 적용 안됨)
  // int? nScoreSize;

  //static const platform = const MethodChannel('samples.flutter.dev/kisaecb');

  ///생성자
  ///param = Url mapping data
  ///nState = 구매 / 인쇄 Flag (1이면 구매, 0이면 인쇄)
  HttpCommunicate(Map<String, dynamic> param, int nState) {
    // print("param : $param");

    switch (nState) {
      //인쇄
      case 0:
        // print('case 인쇄!!');

        strMode = param['mode'];
        strPort = param['Port'];
        strIpAddress =  param['IpAddress'];
        strSSID = param['SSID'];
        strDUID = param['DUID'];
        strASID = param['ASID'];
        strBuyTransPosList = "";
        // strMainKey = param['strMainKey'] ?? "null";
        strMainKey = urlDecode(param['strMainKey']!);
        // strMainKey = convert.utf8.decode(param['strMainKey']);
        strManKey = urlDecode(param['strMankey']!);
        strWomanKey = urlDecode(param['strWomankey']!);
        strUserId = urlDecode(param['strUserId']!);
        strTag = param['Tag'];
        strMemberId = param['strMemberId'];
        strScorePrice = "0";
        strMainTempo = param['strMainTempo'];
        //print('strScorePrice : $strScorePrice');
        strscPrintScoreTransPos = param['scPrintScoreTransPos'];
        //print('strscPrintScoreTransPos : $strscPrintScoreTransPos');
        strscPrintScoreTransPos2 = param['scPrintScoreTransPos2'];
        //print('strscPrintScoreTransPos2 : $strscPrintScoreTransPos2');
        strscPrintScoreTransPos3 = param['scPrintScoreTransPos3'];
        //print('strscPrintScoreTransPos3 : $strscPrintScoreTransPos3');

        nSongNo = int.parse(param['SongNo']!);
        //print('nSongNo : $nSongNo');
        nCountryMode = int.parse(param['NCountryMode']!);
        //print('nCountryMode : $nCountryMode');
        nScoreType = int.parse(param['nScoreType']!);
        //print('nScoreType : $nScoreType');
        nFileDataType = int.parse(param['nFileDataType']!);
        //print('nFileDataType : $nFileDataType');
        // nScoreType = int.parse(param['nScoreType']);
        //print('nScoreType : $nScoreType');
        nViewJeonKanjoo = int.parse(param['nViewJeonKanjoo']!);
        //print('nViewJeonKanjoo : $nViewJeonKanjoo');
        nSubType = param['nSubType'] == "" ? 0 : int.parse(param['nSubType']!);
        //print('nSubType : $nSubType');
        nDispNumber = int.parse(param['DispNumber']!);
        //print('nDispNumber : $nDispNumber');

        bIsPreViewScore = param['blsPreViewScore'] == "0" ? false : true;
        // print('bIsPreViewScore : $bIsPreViewScore');

        ///악보 사이즈 (아직 적용 안된 사항)
        // nScoreSize = param['ScoreSize'] != null ? int.parse(param['ScoreSize']) : 0;
        break;

      //구매
      case 1:
        // print('case 구매!!');
        // print('param ::: $param');
        strMode = param['mode'];
        strPort = param['Port'];
        // print('strPort : ${convert.base64Decode(urlDecode(param['Port']))}');
        strIpAddress = param['IpAddress'];
        strSSID = convert.utf8.decode(convert.base64.decode(urlDecode(param['SSID']!)));
        // print('SSID home : ${convert.utf8.decode(convert.base64.decode(urlDecode(param['SSID'])))}');
        strDUID =param['DUID'];
        // print('DUID home : ${urlDecode(param['DUID'])}');
        strASID = "";
        strBuyTransPosList = urlDecode(param['strBuyTransPosList']!);
        // strBuyTransPosList = (param['strBuyTransPosList']);
        strMainKey = urlDecode(param['strMainKey']!);
        strManKey = urlDecode(param['strMankey']!);
        strWomanKey = urlDecode(param['strWomankey']!);
        strUserId = urlDecode(param['strUserId']!);
        // strManKey = (param['strMankey']);
        // strWomanKey = (param['strWomankey']);
        // strUserId = (param['strUserId']);
        strTag = "";
        strMemberId = "";
        strScorePrice = param['nScorePrice'];
        strMainTempo = param['strMainTempo'];
        strscPrintScoreTransPos = "";
        strscPrintScoreTransPos2 = "";
        strscPrintScoreTransPos3 = "";

        nSongNo = int.parse(param['SongNo']!);
        nCountryMode = int.parse(param['NCountryMode']!);
        nScoreType = int.parse(param['nScoreType']!);
        nFileDataType = int.parse(param['nFileDataType']!);
        nScoreType = int.parse(param['nScoreType']!);
        nViewJeonKanjoo = int.parse(param['nViewJeonKanjoo']!);
        nSubType = param['nSubType'] == "" ? -22 : int.parse(param['nSubType']!);
        nDispNumber = int.parse(param['DispNumber']!);

        bIsPreViewScore = param['blsPreViewScore'] == "0" ? false : true;

        ///악보 사이즈 (아직 적용 안된 사항)
        // nScoreSize = param['ScoreSize'] ? int.parse(param['ScoreSize']) : 0;
        break;
      default:
        print('Error nState Value!!');
    }
  }

//==============================================================================
  String getUserSetting(BuildContext context) {
    String strUserSetting = "";

    if (context.read<DanSettingsProvider>().nDan == 1) {
      // strUserSetting += "&KeyTrans1=${-1 * (context.read<TranspositionProvider>().nOneTranspositionValue - 11)}";
      strUserSetting += "&KeyTrans1=0";
      strUserSetting += "&Octave1=${-1 * (context.read<OctaveProvider>().nOneOctaveValue - 1)}";
      strUserSetting += "&KeyTrans2=-1";
      strUserSetting += "&Octave2=-1";
      strUserSetting += "&KeyTrans3=-1";
      strUserSetting += "&Octave3=-1";
    } else if (context.read<DanSettingsProvider>().nDan == 2) {
      strUserSetting +=
          "&KeyTrans1=${-1 * (context.read<TranspositionProvider>().nOneTranspositionValue - 11)}";
      strUserSetting +=
          "&Octave1=${-1 * (context.read<OctaveProvider>().nOneOctaveValue - 1)}";
      strUserSetting +=
          "&KeyTrans2=${-1 * (context.read<TranspositionProvider>().nTwoTranspositionValue - 11)}";
      strUserSetting +=
          "&Octave2=${-1 * (context.read<OctaveProvider>().nTwoOctaveValue - 1)}";
      strUserSetting += "&KeyTrans3=-1";
      strUserSetting += "&Octave3=-1";
    } else {
      strUserSetting +=
          "&KeyTrans1=${-1 * (context.read<TranspositionProvider>().nOneTranspositionValue - 11)}";
      strUserSetting +=
          "&Octave1=${-1 * (context.read<OctaveProvider>().nOneOctaveValue - 1)}";
      strUserSetting +=
          "&KeyTrans2=${-1 * (context.read<TranspositionProvider>().nTwoTranspositionValue - 11)}";
      strUserSetting +=
          "&Octave2=${-1 * (context.read<OctaveProvider>().nTwoOctaveValue - 1)}";
      strUserSetting +=
          "&KeyTrans3=${-1 * (context.read<TranspositionProvider>().nThreeTranspositionValue - 11)}";
      strUserSetting +=
          "&Octave3=${-1 * (context.read<OctaveProvider>().nThreeOctaveValue - 1)}";
    }

    strUserSetting += "&KeyTrans4=0";
    strUserSetting += "&Octave4=0";

    if (context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant)
      strUserSetting +=
          "&ChordHelp=${context.read<KeynoteAssistantProvider>().bKeynoteAssistantValue ? 1 : 0}";
    else
      strUserSetting += "&ChordHelp=-1";

    if (context
        .read<TranspositionCodeFixedProvider>()
        .bIsTranspositionCodeFixed)
      strUserSetting +=
          "&ChordFix=${context.read<TranspositionCodeFixedProvider>().bTranspositionCodeFixedValue ? 1 : 0}";
    else
      strUserSetting += "&ChordFix=-1";

    if (context.read<DisplayCodeProvider>().bIsDisplayCode)
      strUserSetting +=
          "&ChordSize=${context.read<DisplayCodeProvider>().nDisplayCodeValue}";
    else
      strUserSetting += "&ChordSize=-1";

    if (context.read<DisplayLyricsProvider>().bIsDisplayLyrics)
      strUserSetting +=
          "&LyricsSize=${context.read<DisplayLyricsProvider>().nDisplayLyricsValue}";
    else
      strUserSetting += "&LyricsSize=-1";

    if (context.read<LyricsTypeProvider>().bIsLyricsType)
      strUserSetting +=
          "&LyricsType=${context.read<LyricsTypeProvider>().nLyricsTypeValue}";
    else
      strUserSetting += "&LyricsType=-1";

    if (context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments)
      strUserSetting +=
          "&LyricsToneName=${context.read<LyricsCommandmentsProvider>().nLyricsCommandmentsValue}";
    else
      strUserSetting += "&LyricsToneName=-1";

    if (context.read<CommandmentsTypeProvider>().bIsCommandmentsType)
      strUserSetting +=
          "&ToneNameType=${context.read<CommandmentsTypeProvider>().nCommandmentsTypeValue}";
    else
      strUserSetting += "&ToneNameType=-1";

    if (context.read<EnsembleCodeProvider>().bIsEnsembleCode)
      strUserSetting +=
          "&SetHapJooChord=${context.read<EnsembleCodeProvider>().nEnsembleCode}";
    else
      strUserSetting += "&SetHapJooChord=-1";

    ///악보 사이즈 (아직 적용 안돰)
    strUserSetting += "&ScoreSize=${context.read<ScoreSizeProvider>().nScoreSizeValue + 2}";

    String strRes = "UserSetting=" + urlEncode(strUserSetting);

    print("UserSetting : $strRes");
    return strRes;
  }

//==============================================================================

//==============================================================================
  String urlEncode(String strUserSetting) {
    String strRes = "";

    // print("U : ${strUserSetting.codeUnitAt(0)}");

    for (int nIndex = 0; nIndex < strUserSetting.length; nIndex++) {
      int nTemp = strUserSetting.codeUnitAt(nIndex);
      if ((nTemp > 47 && nTemp < 57) ||
          (nTemp > 64 && nTemp < 91) ||
          (nTemp > 96 && nTemp < 123) ||
          strUserSetting[nIndex] == '-' ||
          strUserSetting[nIndex] == '.' ||
          strUserSetting[nIndex] == '_') {
        strRes += strUserSetting[nIndex];
      } else {
        strRes += "%${nTemp.toRadixString(16).toUpperCase()}";
      }
    }

    return strRes;
  }

//==============================================================================

//==============================================================================
  String convertAcsii(String strData){
    String strTemp="";
    int nAscii = 0;
    for (int nLength = 0; nLength < strData.length; nLength++) {
      if (strData[nLength] == '%') {
        nLength++;
        nAscii = int.parse(strData[nLength] + strData[nLength+1], radix: 16);
        strTemp += String.fromCharCode(nAscii);
        nLength++;
      }
      else{
        strTemp += strData[nLength];
      }
    }
    return strTemp;
  }

  String urlDecode(/*HttpCommunicate? httpCommunicate*/ String strData) {

    strData = convertAcsii(strData);

    int nNum;
    int nRetval;

    String strResult = "";

    ///SJW Modify 2022.04.27 Start...1  SSID Docode에서 문자열을 Decode로 변경
    for (int nLength = 0; nLength < strData.length; nLength++) {
      if (strData[nLength] == '%') {
        nNum = 0;
        nRetval = 0;

        print(':.codeUnitAt(0) : ${':'.codeUnitAt(0)}');
        for (int i = 0; i < 2; i++) {
          nLength++;

          if (strData.codeUnitAt(nLength) < ':'.codeUnitAt(0)) {
            nNum = strData.codeUnitAt(nLength) - 48;
          } else if (strData.codeUnitAt(nLength) > '@'.codeUnitAt(0) &&
              strData.codeUnitAt(nLength) < '['.codeUnitAt(0)) {
            nNum = (strData.codeUnitAt(nLength) - 'A'.codeUnitAt(0)) + 10;
          } else {
            nNum = (strData.codeUnitAt(nLength) - 'a'.codeUnitAt(0) + 10);
          }

          if (16 * (1 - nLength) != 0) {
            nNum = nNum * 16;
          }
          nRetval += nNum;
        }
        strResult += nRetval.toRadixString(16);
      } else {
        strResult += strData[nLength];
      }
    }

    ///SJW Modify 2022.04.27 End...1
    return strResult;
  }

//==============================================================================

  int GetRealUserID(BuildContext context, String strUserID){
    String op = "0x";
    String strTemp = "";
    String strRes = "";

    // print('받은 데이터 : $strUserID');

    if(strUserID.isEmpty){
      return 0;
    }

    for(int i=0; i<strUserID.length; i++){
      if(strUserID[i] != '%'){
        strTemp += strUserID[i];
      }
      else{
        i++;
        if(strUserID[i] != 'u'){
          strTemp = "";
          strTemp += strUserID[i];
          strTemp += strUserID[i+1];
          i += 2;
        }
        else{
          i++;
          strTemp = "";
          strTemp += op;
          strTemp += strUserID[i];
          strTemp += strUserID[i+1];
          strTemp += strUserID[i+2];;
          strTemp += strUserID[i+3];
          i += 4;
        }
        strRes += String.fromCharCode(int.parse(strTemp));
        // print('strUser Test : $strRes');
        i--;
      }
    }
    context.read<PDFProvider>().SetUserID(strRes);
    // print(context.read<PDFProvider>().strUserID);
    // print('rtes : ${String.fromCharCode(int.parse(context.read<PDFProvider>().strUserID))}');
    return strRes.length;
  }

//==============================================================================
  void purchase(BuildContext context, HttpCommunicate? httpCommunicate) {
    bool bAccessed = false;

    String strData = "";

    if (!bAccessed) {
      bAccessed = true;

      if (httpCommunicate != null) {
        strData += getUserSetting(context);

        strData += "&SongNo=${httpCommunicate.nSongNo!}";
        strData += "&nScoreType=${httpCommunicate.nScoreType!}";
        strData += "&nSubType=${httpCommunicate.nScoreType!}";
        strData += "&nViewJeonKanjoo=${httpCommunicate.nViewJeonKanjoo}";

        int nDanCount=0;
        String strTemp = "";
       do{

           strTemp = "KeySignature";
           if(nDanCount>0)
             strTemp += "${nDanCount+1}";
           strData += "&$strTemp=${context.read<TranspositionProvider>().setMeterKey(nDanCount+1)}";

           strTemp = "Chord";
           if(nDanCount>0)
             strTemp += "${nDanCount+1}";
           if(nDanCount == 0) {strData += "&$strTemp=${context.read<TranspositionProvider>().pKeyChordTransPos1[context.read<TranspositionProvider>().nOneTranspositionValue + 11].strKeyChord}";}
           else if(nDanCount == 1) {strData += "&$strTemp=${context.read<TranspositionProvider>().pKeyChordTransPos2[context.read<TranspositionProvider>().nTwoTranspositionValue + 11].strKeyChord}";}
           else if(nDanCount == 2) {strData += "&$strTemp=${context.read<TranspositionProvider>().pKeyChordTransPos3[context.read<TranspositionProvider>().nThreeTranspositionValue + 11].strKeyChord}";}

           strTemp = "scPrintScoreTransPos";
           if(nDanCount>0)
             strTemp += "${nDanCount+1}";

           if(nDanCount == 0) {strTemp += "=${(context.read<TranspositionProvider>().nOneTranspositionValue)}";}
           else if(nDanCount == 1){strTemp += "=${(context.read<TranspositionProvider>().nTwoTranspositionValue)}";}
           else if(nDanCount == 2){strTemp += "=${(context.read<TranspositionProvider>().nThreeTranspositionValue)}";}
           strData += "&$strTemp";



           nDanCount++;
         }while(nDanCount < context.read<DanSettingsProvider>().nDan);

        strTemp = "ScoreSize";
        strTemp = "&$strTemp = ${context.read<ScoreSizeProvider>().nScoreSizeValue + 2}";
        strData += "&$strTemp";
      }
    }

    ///SJW Modify 2022.07.19 Start... ///SSID -> urlDecode + Base64Decode하도록 변경
    // String strDUIDTemp =
    //     httpCommunicate!.strDUID!.replaceAllMapped("%3D", (match) => "=");
    // String strSSIDTemp =
    //     httpCommunicate.strSSID!.replaceAllMapped("%3D", (match) => "=");

    String strDUID = httpCommunicate!.strDUID!;
    String strSSID = httpCommunicate.strSSID!;

    // String strPHPSSID =
    //     const convert.Utf8Decoder().convert(convert.base64Decode(strSSID));
    String strPHPSSID = strSSID;
    ///SJW Modify 2022.07.19 End...

    Uri uri = Uri.parse(
        'https://m.elf.co.kr/akbo/ScoreBridge.php?duid=$strDUID&mode=purchase');
    print("PHPSSID : $strPHPSSID");
    print("DUID : $strDUID");

    print("POST DATA : $strData");
    purchasePost(uri, strData, strPHPSSID).then((value) => exit(0));
  }

//==============================================================================
  
//==============================================================================
  Future<dynamic> purchasePost(Uri uri, String data, String strPHPSSID) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept-Language': 'ko-KR',
      'Accept-Encoding': 'deflate',
      'Cookie': 'PHPSESSID=$strPHPSSID'
    };

    http.Response response = await http.post(uri, headers: headers, body: data);

    // print("uri : $uri");
    // print("header : $headers");
    // print("data : $data");

    print("result : ${response.body}");

    if (response.statusCode == 200)
      print("SUCCESS Code : ${response.statusCode}");
    else
      print("FAILED Code : ${response.statusCode}");

  }

//==============================================================================
  
  Future<dynamic> printPost(BuildContext context, HttpCommunicate httpCommunicate) async{
    Uri uri = Uri.parse("https://www.elf.co.kr/shop/akbo/userAkboList/UserByAkbo_PrintUpdate_T.asp");

    ///SJW Modify 2022.07.19 Start... ///ASID & SSID -> urlDecode + Boase64Decode
    String strASID = const convert.Utf8Decoder().convert(convert.base64Decode(urlDecode(httpCommunicate.strASID!)));
    String strSSID = const convert.Utf8Decoder().convert(convert.base64Decode(urlDecode(httpCommunicate.strSSID!)));
    // String strASID = const convert.Utf8Decoder().convert(convert.base64Decode(httpCommunicate.strASID!));
    // String strSSID = const convert.Utf8Decoder().convert(convert.base64Decode(httpCommunicate.strSSID!));
    ///SJW Modify 2022.07.19 End...

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept-Language': 'ko-KR',
      'Accept-Encoding': 'deflate',
      'Cookie': 'PHPSESSID=$strSSID; $strASID'
    };

    int nSongNo = httpCommunicate.nSongNo!;
    int nScoreType = httpCommunicate.nScoreType!;
    int nJeonKanjoo = httpCommunicate.nViewJeonKanjoo!;

    String strData = "SongNo=$nSongNo&nScoreType=$nScoreType&nViewJeonKanjoo=$nJeonKanjoo";

    for(int nCount=0; nCount<context.read<DanSettingsProvider>().nDan; nCount++){
      switch(nCount){
        case 0:
          strData += "&scPrintScoreTransPos=${httpCommunicate.strscPrintScoreTransPos!}";
          break;
        case 1:
          strData += "&scPrintScoreTransPos2=${httpCommunicate.strscPrintScoreTransPos2!}";
          break;
        case 2:
          strData += "&scPrintScoreTransPos3=${httpCommunicate.strscPrintScoreTransPos3!}";
          break;
      }
    }
    strData += "&MemberId=${httpCommunicate.strMemberId}";

    strData += "&${getUserSetting(context)}";

    print("strPostData : $strData");

    http.Response response = await http.post(uri, headers: headers, body: strData);

    print("header : $headers");
    print("data : $strData");

    //print("request : ${response.body}");

    if (response.statusCode == 200) {
      print("SUCCESS Code : ${response.statusCode}");

    }
    else {
      print("FAILED Code : ${response.statusCode}");
      print("error : ${response.reasonPhrase}");
    }

  }

//==============================================================================
//==============================================================================
//   ///URL 받아야 테스트 할수 있음
//   getHttp() async {
//     Uri url = Uri.https('elf.mobile.score.mall', '/home');
//
//     http.Response response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonResponse =
//           convert.jsonDecode(response.body) as Map<String, dynamic>;
//
//       print(jsonResponse);
//     }
//   }
//==============================================================================
  Future<String> postUriUserSetting(BuildContext context, HttpCommunicate httpCommunicate) async{
    Uri uri = Uri.parse("https://www.elf.co.kr/shop/akbo/userAkboList/UserByAkbo_ReceiveSetting.asp");

    ///SJW Modify 2022.07.19 Start... ///ASID -> urlDecode + Base64Decode
    String strASID = const convert.Utf8Decoder().convert(convert.base64Decode(urlDecode(httpCommunicate.strASID!)));
    // String strASID = const convert.Utf8Decoder().convert(convert.base64Decode(httpCommunicate.strASID!));
    ///SJW Modify 2022.07.19 End...

    String strBody = "";

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept-Language': 'ko-KR',
      'Accept-Encoding': 'deflate',
      'Cookie': 'PHPSESSID=${httpCommunicate.strSSID}; $strASID'
    };

    // print("Cookie Log Text : PHPSESSID=${httpCommunicate.strSSID};  $strASID");

    strBody += "SongNo=${httpCommunicate.nSongNo}";
    strBody += "&nScoreType=${httpCommunicate.nScoreType}";
    strBody += "&nViewJeonKanjoo=${httpCommunicate.nViewJeonKanjoo}";

    for(int nStaff=0; nStaff<context.read<DanSettingsProvider>().nDan; nStaff++){
      switch(nStaff){
        case 0 :
          strBody += "&scPrintScoreTransPos=${httpCommunicate.strscPrintScoreTransPos}";
          // print("strBody1 : $strBody");
          break;
        case 1 :
          int value = int.parse(httpCommunicate.strscPrintScoreTransPos2!) + 11;
          // int plus = int.parse(httpCommunicate.strscPrintScoreTransPos2!) + 11;
          strBody += "&scPrintScoreTransPos2=${httpCommunicate.strscPrintScoreTransPos2!}";
          // strBody += "&scPrintScoreTransPos2=${5}";
          // print("strBody2 : $strBody");
          break;
        case 2 :
          strBody += "&scPrintScoreTransPos3=${httpCommunicate.strscPrintScoreTransPos3!}";
          // print("strBody3 : $strBody");
          break;
      }
    }

    strBody += "&MemberId=${httpCommunicate.strMemberId}";
    // print('strBodyBody : $strBody');

    http.Response response = await http.post(uri, headers: headers, body: strBody);

    // if (response.statusCode == 200)
    //   print("SUCCESS Code : ${response.statusCode}");
    // else {
    //   // print("FAILED Code : ${response.statusCode}");
    //   // print("error : ${response.reasonPhrase}");
    // }

    String strServerData = response.body;
    // print('strServerData213 : $strServerData');

    return strServerData;
  }
//==============================================================================

  //Tag 및 서버 시간 체크
  Future<bool> secureTest(BuildContext context, HttpCommunicate httpCommunicate, MethodChannel platform) async {
    ///SJW Modify 2022-05-13 Start...1
    ///키값과 Decrypt를 모두 각각 비동기로 처리하니까 꼬임
    ///네이티브에서 한번에 처리하도록 변경함

    // print("secure Test Run");
    String strData = "";
    String strParam = "";
    String strTarget = "";

    if (httpCommunicate.bIsPreViewScore == false) {
      // print('starting secureTest1');

      //print("seedDecrypt Run : ${httpCommunicate.urlDecode(httpCommunicate.strTag!)}");
      // print("seedDecrypt Run : ${convert.Utf8Decoder().convert(convert.base64Decode(httpCommunicate.strTag!))}");
      // print("Tag : ${httpCommunicate.strTag}");
      strData = await seedDecrypt(platform, httpCommunicate.urlDecode(httpCommunicate.strTag!));
      // print("buffff : $strData");
      // strData = await seedDecrypt(platform, httpCommunicate.urlDecode("5396E4BFEF41280B2A449EB162A0B6401340FBABC4A74753418E49DF2B8150EC11E4F088FED4D91F7A1BB3FA5AF13E9A"));
    ///SJW Modify 2022-05-13 End...1
      String strDate = "";
      String strSource = "";

      strDate = strData.substring(0, 24);
      strSource = strData.substring(24, strData.length);

      String strTime = await getServerTime();
      // print("serverTime : $strTime");

      if(strTime.isEmpty) {return false;}

      strTime = await seedDecrypt(platform, strTime);
      // print("serverTime Seed : $strTime");
      if(strTime.length < 24) {return false;}

      strTime = strTime.substring(0, 24);

      Uint8List dateBuf = Uint8List(12);
      Uint8List timeBuf = Uint8List(12);
      int nBufCount = 0;

      String strDateTemp = "";
      String strTimeTemp = "";

      for(int nIndex=0; nIndex<24; nIndex+=2){
        dateBuf[nBufCount] = int.parse(strDate[nIndex + 0] + strDate[nIndex + 1], radix: 16) & 0xFF;
        ///int -> ASCII 코드 문자열로 변환
        strDateTemp += String.fromCharCode(dateBuf[nBufCount]);

        timeBuf[nBufCount] = int.parse(strTime[nIndex + 0] + strTime[nIndex + 1], radix: 16) & 0xFF;
        ///int -> ASCII 코드 문자열로 변환
        strTimeTemp += String.fromCharCode(timeBuf[nBufCount]);
        nBufCount++;
      }

      strDate = strDateTemp;
      strTime = strTimeTemp;

       // print("strDate : $strDate");
       // print("strTime : $strTime");

      int nDifferenceTime = serverTimeDiff(strTime, strDate);
      // print("dTime : $nDifferenceTime");

      if(nDifferenceTime >= (60 * 60 * 12)){return false;}

      if(strSource.length < 64){return false;}

      strSource = strSource.substring(0, 64);
      // print("strSource : $strSource");

      strParam += httpCommunicate.nSongNo!.toString();
      strParam += httpCommunicate.nCountryMode!.toString();
      strParam += httpCommunicate.nScoreType!.toString();
      strParam += httpCommunicate.nFileDataType!.toString();
      strParam += httpCommunicate.nViewJeonKanjoo!.toString();
      strParam += httpCommunicate.strscPrintScoreTransPos!;
      strParam += httpCommunicate.strscPrintScoreTransPos2!;
      strParam += httpCommunicate.strscPrintScoreTransPos3!;
      strParam += httpCommunicate.strMainKey!;
      strParam += httpCommunicate.strManKey!;
      strParam += httpCommunicate.strWomanKey!;
      strParam += httpCommunicate.strMainTempo!;
      strParam += httpCommunicate.strUserId!;
      strParam += httpCommunicate.strMemberId!;

      // print("strParam : $strParam");

      Uint8List buff = Uint8List(32);
      Map<String, dynamic> shaData = {
        "param" : Uint8List.fromList(strParam.codeUnits),
        "paramLen" : Uint8List.fromList(strParam.codeUnits).length,
        "buff" : buff,
        "buffLen" : buff.length
      };
      // print("shaData : ${Uint8List.fromList(strParam.codeUnits)}");

      buff = await platform.invokeMethod('SHA256_Encrypt', shaData);
      // print("SHA256 Buff : $buff");


      for(int nIndex=0; nIndex<32; nIndex++){
        if(buff[nIndex].toRadixString(16).length < 2) {
          strTarget += "0${buff[nIndex].toRadixString(16).toUpperCase()}";
        }
        else{
          strTarget += buff[nIndex].toRadixString(16).toUpperCase();
        }
      }

      ///SJW Modify 2023.02.08 Start...
      ///테스트 코드
      // print("strSource : $strSource");
      // print("strTarget : $strTarget");
      //
      // if(strSource.compareTo(strTarget) != 0){
      //   return false;
      // }
      ///SJW Modify 2023.02.08 End...

      String strServerData = await postUriUserSetting(context, httpCommunicate);

      // print("response Data : $strServerData");
      List<String> strServerTemp = strServerData.split("&");
      // print("strServerData Temp : $strServerTemp");
      List<String> strServerTemp2 = [];
      Map<String, String> mapServerData = Map();
      for(int nIndex=1; nIndex<strServerTemp.length; nIndex++){
        strServerTemp2.clear();
        strServerTemp2 = strServerTemp[nIndex].split("=");
        mapServerData[strServerTemp2[0]] = strServerTemp2[1];
      }

      // print("mapServerData : $mapServerData");

      UserData userData = setUserData(mapServerData, httpCommunicate.strscPrintScoreTransPos!);

      // print("1 : ${userData.nKeyTrans1}");
      // print("2 : ${userData.nKeyTrans2}");
      // print("3 : ${userData.nKeyTrans3}");


      //피아노 멜로디 + 오른손 + 왼손
      if(httpCommunicate.nScoreType! == 50){
        userData.nKeyTrans3 = userData.nKeyTrans2;
        userData.nOctave3 = userData.nOctave2;
      }
      //피아노 왼손 + 오른손
      else if(httpCommunicate.nScoreType! == 52){
        userData.nKeyTrans2 = userData.nKeyTrans1;
        userData.nOctave2 = userData.nOctave1;
      }

      ScoreInfoController scoreInfoController = ScoreInfoController();
      scoreInfoController.setScoreSettingOption(context, userData, httpCommunicate);


      return true;
    }
    return false;
  }

//==============================================================================
  UserData setUserData(Map<String, String> data, String strKeyTrans1){
    UserData userData = UserData();

    // print("MAP : $data");
    // userData.nKeyTrans1 = int.parse(data['KeyTrans1']!);
    userData.nKeyTrans1 = int.parse(strKeyTrans1);
    userData.nOctave1 = int.parse(data['Octave1']!);
    userData.nKeyTrans2 = int.parse(data['KeyTrans2']!);
    userData.nOctave2 = int.parse(data['Octave2']!);
    userData.nKeyTrans3 = int.parse(data['KeyTrans3']!);
    userData.nOctave3 = int.parse(data['Octave3']!);
    userData.nKeyTrans4 = int.parse(data['KeyTrans4']!);
    userData.nOctave4 = int.parse(data['Octave4']!);
    userData.nChordHelp = int.parse(data['ChordHelp']!) != -1 ? int.parse(data['ChordHelp']!) : 0;
    userData.nChordFix = int.parse(data['ChordFix']!) != -1 ? int.parse(data['ChordFix']!) : 0;
    userData.nChordSize = int.parse(data['ChordSize']!) != -1 ? int.parse(data['ChordSize']!) : 1;
    userData.nLyricsSize = int.parse(data['LyricsSize']!) != -1 ? int.parse(data['LyricsSize']!) : 1;
    userData.nLyricsType = int.parse(data['LyricsType']!) != -1 ? int.parse(data['LyricsType']!) : 0;
    userData.nLyricsToneName = int.parse(data['LyricsToneName']!) != -1 ? int.parse(data['LyricsToneName']!) : 0;
    userData.nToneNameType = int.parse(data['ToneNameType']!) != -1 ? int.parse(data['ToneNameType']!) : 0;
    userData.nSetHapJooChord = int.parse(data['SetHapJooChord']!) != -1 ? int.parse(data['SetHapJooChord']!) : 0;
    userData.nScoreSize = data['ScoreSize'] == null ? 2 : int.parse(data['ScoreSize']!);

    print("setUserData : ${userData.nLyricsSize}");

    return userData;
  }
//==============================================================================
  seedDecrypt(MethodChannel platform, String strData) async {
    int nLen = 0;
    int nCnt = 0;
    int nDummy = 0;
    String strTemp = "";
    // String strNum = "";
    int nNumCount = 0;
    //strSource = httpCommunicate.urlDecode(httpCommunicate.strTag!);
    //strData = httpCommunicate.urlDecode("5396E4BFEF41280B2A449EB162A0B6401340FBABC4A74753418E49DF2B8150EC11E4F088FED4D91F7A1BB3FA5AF13E9A");

    // print("strS : $strData");

    ////////////////////////////////////////////////
    //source
    nLen = strData.length;
    // print("nLen : $nLen");
    if ((nLen == 0) || (nLen % 2) != 0) {
      return;
    }
    strTemp = strData;
    ////////////////////////////////////////////////

    ////////////////////////////////////////////////
    //target
    nCnt = (nLen / 2).toInt();
    nDummy = nCnt % 16;
    if (nDummy != 0) {
      nCnt += nDummy;
    }
    ////////////////////////////////////////////////

    ////////////////////////////////////////////////
    //copy
    ///SJW Modify 2022-05-09 Start...1
    ///Tag문자열을 16진수로 읽고 10진수로 변경 byte[]로 매개변수를 넘겨주어야 하므로 Unit8List로 변환함
    Uint8List byteBuffer = Uint8List((nLen / 2).toInt());

    for (int nCount = 0; nCount < nLen; nCount += 2) {
      // if(bFirst == true)
      //{
      //   strNum += strTemp[nCount + 0];
      //   strNum += strTemp[nCount + 1];
      //   //bFirst = false;
      //   print('strNum : $strNum');
      // }
      // else
      // {
      //  strNum.replaceRange(0, 1, strTemp[nCount + 0]);
      //  strNum.replaceRange(1, 2, strTemp[nCount + 1]);
      //  print('strNum2.. : $strNum');
      // }q

      //strBuffer += ((strTemp.codeUnitAt(nCount + 0) * 10).toRadixString(16) + (strTemp.codeUnitAt(nCount+1).toRadixString(16)));
      // strBuffer = strTemp[nCount + 0] + strTemp[nCount + 1];
      //print('strBuffer : $strBuffer');
      //print("byteBuffer : $byteBuffer");int nLen = 0;
      //     int nCnt = 0;
      //     int nDummy = 0;
      //     String strTemp = "";
      //     String strBuffer = "";
      //     String strNum = "";
      //     int nNumCount = 0;
      //strBuffer = "";
      //nNumCount++;

      byteBuffer[nNumCount++] =
          int.parse(strTemp[nCount + 0] + strTemp[nCount + 1], radix: 16);
    }
    // print('seedDecrypt for end');
    //
    // print("first byteBuffer : $byteBuffer len : ${byteBuffer.length}");
    ///SJW Modify 2022-05-09 End...1

    ////////////////////////////////////////////////
    strData = "";
    strTemp = "";

    //Decryption
    nLen = (nCnt / 16).toInt();

    List<int> temp = strWebSeedKey.codeUnits;
    Uint8List byte = Uint8List.fromList(temp);

    // print("key byte : $byte nLen : ${nCnt / 16}");
    ///SJW Modify 2022-06-17 Start...1
    ///IOS 네이티브 테스트
    var IOSdata = <String, dynamic>{
      "data": byte,
      "dataLen" : byte.length,
      "value": byteBuffer,
      "valueLen": byteBuffer.length,
      "cnt": nCnt,
    };
    var AOSdata = <String, Uint8List>{
      "data": byte,
      "value": byteBuffer,
    };

    ///SJW Modify 2022-06-17 End...1
    Uint8List? byteRes;

    // kisaSeedKeySchedKey(platform);
    //
    //byteRes = await kisaSeedDecrypt(platform, byteBuffer);

    // print('SeedDecrypt Start!!');
    //String str = await platform.invokeMethod('SeedDecrypt', data);

    // print("STR FLUTTER DATA : $strData");
    byteRes = await platform.invokeMethod('SeedDecrypt', Platform.isAndroid ? AOSdata : IOSdata);
    // print("good!!");
    // print('SeedDecrypt Res : $byteRes');

    // print("Length CNT : $nCnt");
    for(int nIndex=0; nIndex<nCnt; nIndex++)
    {
      //if(byteBuffer[nIndex] < 0x0A) {
      if(byteRes![nIndex].toRadixString(16).length == 1){
        strData += "0${byteRes[nIndex].toRadixString(16).toUpperCase()}";
      }else{
        strData += byteRes[nIndex].toRadixString(16).toUpperCase();
      }
    }

    // print("pause");
    // print("strData : $strData");
    ///SJW Modify 2022-05-13 End...1
    return strData;
  }
//==============================================================================

  int serverTimeDiff(String strTime, String strDate){
    String strVal = "";
    int nYear = 0;
    int nMonth = 0;
    int nDay = 0;
    int nHour = 0;
    int nMinute = 0;

    strVal = strTime.substring(0, 4);   nYear = int.parse(strVal) - 1900;
    strVal = strTime.substring(4, 6);   nMonth = int.parse(strVal) - 1;
    strVal = strTime.substring(6, 8);   nDay = int.parse(strVal);
    strVal = strTime.substring(8, 10);  nHour = int.parse(strVal);
    strVal = strTime.substring(10, 12); nMinute = int.parse(strVal);

    DateTime dateTimeStart = DateTime(nYear, nMonth, nDay, nHour, nDay);

    strVal = strDate.substring(0, 4);   nYear = int.parse(strVal) - 1900;
    strVal = strDate.substring(4, 6);   nMonth = int.parse(strVal) - 1;
    strVal = strDate.substring(6, 8);   nDay = int.parse(strVal);
    strVal = strDate.substring(8, 10);  nHour = int.parse(strVal);
    strVal = strDate.substring(10, 12); nMinute = int.parse(strVal);

    DateTime dateTimeEnd = DateTime(nYear, nMonth, nDay, nHour, nMinute);

    int nDifferenceTime = dateTimeStart.difference(dateTimeEnd).inSeconds;

    return nDifferenceTime;
  }

//==============================================================================
  Future<void> kisaSeedKeySchedKey(
      MethodChannel platform /*, Int32List pbUserKey*/) async {
    List<int> temp = strWebSeedKey.codeUnits;
    Uint8List byte = Uint8List.fromList(temp);

    var data = <String, Uint8List>{"key": byte};

    try {
      Int32List nResult = await platform.invokeMethod('key_schedule', data /*pdwRoundKey*/);

      //Uint32List nResult = await platform.invokeMethod('key_schedule', data/*pdwRoundKey*/);
      //int nResult =  await platform.invokeMethod('key_schedule', data/*pdwRoundKey*/);

      print('res $nResult');

      if (nResult != 0){ return; }
      print("kisaSeedKeySchedKey Done!");
    } on PlatformException catch (e) {
      print('kisaSeedKeySchedKey Failed! : ${e.toString()}');
    }
    print("kisaSeedKeySchedKey Done!");
  }

//==============================================================================

//==============================================================================
//   Future<Uint8List> kisaSeedDecrypt(MethodChannel platform, Uint8List byteBuffer) async {
//
//     print("byteBuffer : $byteBuffer");
//     Uint8List? b;
//
//     var data = <String, Uint8List>{"key": byteBuffer,};
//
//     try {
//       //byteBuffer = await platform.invokeMethod('decrypt', data);
//       b = await platform.invokeMethod('decrypt', data);
//       print("b : $b");
//     } on PlatformException catch (e) {
//       print("kisaSeedDecrypt Failed! : ${e.toString()}");
//     }
//
//     print("kisaSeedDecrypt Done!");
//     return b!;
//   }
//==============================================================================

//==============================================================================
  Future<String> getServerTime() async
  {
    String strURL = "";
    String strHost = "www.elf.co.kr";
    String strUri = "/shop/akbo/ScoreDate.asp";

    strURL= "https://$strHost$strUri";

    Uri uri = Uri.parse(strURL);


    Map<String, String> headers = {
      'Accept-Language': 'ko-KR',
      'Accept-Encoding': 'deflate',
    };

    http.Response response = await http.get(uri, headers: headers);

    final int nStatus = response.statusCode;
    if(nStatus < 200 || nStatus > 400){return "Server Time Error";}

    // print("body Data : ${response.body}");

    return response.body;
  }
//==============================================================================
}
