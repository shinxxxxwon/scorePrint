
import 'package:elfscoreprint_mobile/src/resources/score/score_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/http/http_communicate.dart';
import '../resources/score/score_tables.dart';
import 'dan_settings_provider.dart';

class TranspositionProvider extends ChangeNotifier {

  bool bIsTransposition = false;

  int _nOneTranspositionValue = 0;

  int get nOneTranspositionValue => _nOneTranspositionValue;

  int _nTwoTranspositionValue = 0;

  int get nTwoTranspositionValue => _nTwoTranspositionValue;

  int _nThreeTranspositionValue = 0;

  int get nThreeTranspositionValue => _nThreeTranspositionValue;

  int _nActMinKey = -11;
  int get nActMinKey => _nActMinKey;

  int _nActMaxKey = 11;
  int get nActMaxKey => _nActMaxKey;

  List<KeyChordTransPos> pKeyChordTransPos1 = [];
  List<KeyChordTransPos> pKeyChordTransPos2 = [];
  List<KeyChordTransPos> pKeyChordTransPos3 = [];

  List<KeyChordTransPos> realKeyChordTransPost1 = [];
  List<KeyChordTransPos> realKeyChordTransPost2 = [];
  List<KeyChordTransPos> realKeyChordTransPost3 = [];

  bool bOneIsDrum = false;
  bool bTwoIsDrum = false;
  bool bThreeIsDrum = false;

  bool bIsFirst = true;

  int nTrioTrans1 = 0;
  int nTrioTrans2 = 0;
  int nTrioTrans3 = 0;

  void init(){
    bIsTransposition = false;

    _nOneTranspositionValue = 0;
    _nTwoTranspositionValue = 0;
    _nThreeTranspositionValue = 0;

    _nActMinKey = -11;
    _nActMaxKey = 11;

    pKeyChordTransPos1.clear();
    pKeyChordTransPos2.clear();
    pKeyChordTransPos3.clear();

    realKeyChordTransPost1.clear();
    realKeyChordTransPost2.clear();
    realKeyChordTransPost3.clear();

    bOneIsDrum = false;
    bTwoIsDrum = false;
    bThreeIsDrum = false;

    nTrioTrans1 = 0;
    nTrioTrans2 = 0;
    nTrioTrans3 = 0;

    notifyListeners();
  }

  void setActMinMaxKey(int nMinKey, int nMaxKey){
    _nActMinKey = nMinKey;
    _nActMaxKey = nMaxKey;

    notifyListeners();
  }

  void setTransPosString(BuildContext context, HttpCommunicate httpCommunicate){
    ScoreInfoController scoreInfoController = ScoreInfoController();
    if(scoreInfoController.isApplayTrioSong(httpCommunicate)){
      for(int nStaffNo=0; nStaffNo<context.read<DanSettingsProvider>().nDan; nStaffNo++){

          int nPos = 0;
          int nTranControlValue = 0;

          nPos = 11;
          if(nStaffNo == 0){
            nTranControlValue = context.read<TranspositionProvider>().nTrioTrans1;
            // print('nTrioTrans1 : ${context.read<TranspositionProvider>().nTrioTrans1}');
          }
          else if(nStaffNo == 1){
            nTranControlValue = context.read<TranspositionProvider>().nTrioTrans2;
            // print('nTrioTrans2 : ${context.read<TranspositionProvider>().nTrioTrans2}');
          }
          else if(nStaffNo == 2){
            nTranControlValue = context.read<TranspositionProvider>().nTrioTrans3;
            // print('nTrioTrans3 : ${context.read<TranspositionProvider>().nTrioTrans3}');
          }

          GetTransPosString(context, httpCommunicate, nStaffNo, nPos, nTranControlValue);
        }
    }
    notifyListeners();
  }

  void GetTransPosString(BuildContext context, HttpCommunicate httpCommunicate, int nStaffNo, int nPos, int nTemp){
    bool bIsMinor = false;

    if(nPos + nTemp < 0){
      nTemp += 12;
    }
    if(nPos + nTemp > 22){
      nTemp -= 12;
    }

    if(nStaffNo == 0){
      bIsMinor = (pKeyChordTransPos1[11].strKeyChord![pKeyChordTransPos1[11].strKeyChord!.length - 1] == 'm');
      if(bIsMinor){
        if(pKeyChordTransPos1[nPos + nTemp].nTransPos! - nTemp == 0){
          realKeyChordTransPost1[nPos + nTemp].nTransPos = 0;
          realKeyChordTransPost1[nPos + nTemp].strKeyChord = pKeyChordTransPos1[nPos + nTemp].strKeyChord;
        }
        else{
          realKeyChordTransPost1[nPos + nTemp].nTransPos = pKeyChordTransPos1[nPos + nTemp].nTransPos! - nTemp;
          realKeyChordTransPost1[nPos + nTemp].strKeyChord = pKeyChordTransPos1[nPos + nTemp].strKeyChord;
        }
      }
      else{
        if(pKeyChordTransPos1[nPos + nTemp].nTransPos! - nTemp == 0){
          realKeyChordTransPost1[nPos + nTemp].nTransPos = 0;
          realKeyChordTransPost1[nPos + nTemp].strKeyChord = pKeyChordTransPos1[nPos + nTemp].strKeyChord;
        }
        else{
          realKeyChordTransPost1[nPos + nTemp].nTransPos = pKeyChordTransPos1[nPos + nTemp].nTransPos! - nTemp;
          realKeyChordTransPost1[nPos + nTemp].strKeyChord = pKeyChordTransPos1[nPos + nTemp].strKeyChord;
        }
      }
      if(pKeyChordTransPos1[nPos + nTemp].nMeterKey! > 0){
        realKeyChordTransPost1[nPos + nTemp].nMeterKey = pKeyChordTransPos1[nPos + nTemp].nMeterKey!;
      }
      else if(pKeyChordTransPos1[nPos + nTemp].nMeterKey! < 0){
        realKeyChordTransPost1[nPos + nTemp].nMeterKey = pKeyChordTransPos1[nPos + nTemp].nMeterKey!;
      }
      else{
        realKeyChordTransPost1[nPos + nTemp].nMeterKey = 0;
      }
    }
    else if(nStaffNo == 1){
      // print('nStaff == 1 : $nTrioTrans2}');
      bIsMinor = (pKeyChordTransPos2[11].strKeyChord![pKeyChordTransPos2[11].strKeyChord!.length - 1] == 'm');
      if(bIsMinor){
        if(pKeyChordTransPos2[nPos + nTemp].nTransPos! - nTemp == 0){
          realKeyChordTransPost2[nPos + nTemp].nTransPos = 0;
          realKeyChordTransPost2[nPos + nTemp].strKeyChord = pKeyChordTransPos2[nPos + nTemp].strKeyChord;
        }
        else{
          realKeyChordTransPost2[nPos + nTemp].nTransPos = pKeyChordTransPos2[nPos + nTemp].nTransPos! - nTemp;
          realKeyChordTransPost2[nPos + nTemp].strKeyChord = pKeyChordTransPos2[nPos + nTemp].strKeyChord;
        }
      }
      else{
        if(pKeyChordTransPos2[nPos + nTemp].nTransPos! - nTemp == 0){
          realKeyChordTransPost2[nPos + nTemp].nTransPos = 0;
          realKeyChordTransPost2[nPos + nTemp].strKeyChord = pKeyChordTransPos2[nPos + nTemp].strKeyChord;
        }
        else{
          realKeyChordTransPost2[nPos + nTemp].nTransPos = pKeyChordTransPos2[nPos + nTemp].nTransPos! - nTemp;
          realKeyChordTransPost2[nPos + nTemp].strKeyChord = pKeyChordTransPos2[nPos + nTemp].strKeyChord;
        }
      }
      if(pKeyChordTransPos2[nPos + nTemp].nMeterKey! > 0){
        realKeyChordTransPost2[nPos + nTemp].nMeterKey = pKeyChordTransPos2[nPos + nTemp].nMeterKey!;
      }
      else if(pKeyChordTransPos2[nPos + nTemp].nMeterKey! < 0){
        realKeyChordTransPost2[nPos + nTemp].nMeterKey = pKeyChordTransPos2[nPos + nTemp].nMeterKey!;
      }
      else{
        realKeyChordTransPost2[nPos + nTemp].nMeterKey = 0;
      }
    }
    else if(nStaffNo == 2){
      bIsMinor = (pKeyChordTransPos3[11].strKeyChord![pKeyChordTransPos3[11].strKeyChord!.length - 1] == 'm');
      if(bIsMinor){
        if(pKeyChordTransPos3[nPos + nTemp].nTransPos! - nTemp == 0){
          realKeyChordTransPost3[nPos + nTemp].nTransPos = 0;
          realKeyChordTransPost3[nPos + nTemp].strKeyChord = pKeyChordTransPos3[nPos + nTemp].strKeyChord;
        }
        else{
          realKeyChordTransPost3[nPos + nTemp].nTransPos = pKeyChordTransPos3[nPos + nTemp].nTransPos! - nTemp;
          realKeyChordTransPost3[nPos + nTemp].strKeyChord = pKeyChordTransPos3[nPos + nTemp].strKeyChord;
        }
      }
      else{
        if(pKeyChordTransPos3[nPos + nTemp].nTransPos! - nTemp == 0){
          realKeyChordTransPost3[nPos + nTemp].nTransPos = 0;
          realKeyChordTransPost3[nPos + nTemp].strKeyChord = pKeyChordTransPos3[nPos + nTemp].strKeyChord;
        }
        else{
          realKeyChordTransPost3[nPos + nTemp].nTransPos = pKeyChordTransPos3[nPos + nTemp].nTransPos! - nTemp;
          realKeyChordTransPost3[nPos + nTemp].strKeyChord = pKeyChordTransPos3[nPos + nTemp].strKeyChord;
        }
      }
      if(pKeyChordTransPos3[nPos + nTemp].nMeterKey! > 0){
        realKeyChordTransPost3[nPos + nTemp].nMeterKey = pKeyChordTransPos3[nPos + nTemp].nMeterKey!;
      }
      else if(pKeyChordTransPos3[nPos + nTemp].nMeterKey! < 0){
        realKeyChordTransPost3[nPos + nTemp].nMeterKey = pKeyChordTransPos3[nPos + nTemp].nMeterKey!;
      }
      else{
        realKeyChordTransPost3[nPos + nTemp].nMeterKey = 0;
      }
    }

    // if(httpCommunicate.nFileDataType != 2 && httpCommunicate.nFileDataType != 1){///!ACT && !C01
    //   if(pKeyChordTransPos[nPos + nTemp].nMeterKey == 6 && )
    // }
    //notifyListeners();
  }

  void setTransposition(int nDan, int nTranspositionStat){
    // print("index : $nDan , TransState : $nTranspositionStat");

    switch(nDan){
      case 1:
        _nOneTranspositionValue = nTranspositionStat;
        break;
      case 2:
          _nTwoTranspositionValue = (nTranspositionStat * -1) + 11;
        break;
      case 3:
          _nThreeTranspositionValue = (nTranspositionStat * -1) + 11;
        break;
    }
  }

  ///pKeyChordTransPos 초기화
  void initKeyChordTransPos() {

    KeyChordTransPos keyCodePos = KeyChordTransPos(0, 0, "");
    keyCodePos.strKeyChord = "";
    keyCodePos.nMeterKey = 0;
    keyCodePos.nTransPos = 0;
    //초기화
    for (int nCount = 0; nCount < 24; nCount++) {
      pKeyChordTransPos1.add(keyCodePos);
      pKeyChordTransPos2.add(keyCodePos);
      pKeyChordTransPos3.add(keyCodePos);
      realKeyChordTransPost1.add(keyCodePos);
      realKeyChordTransPost2.add(keyCodePos);
      realKeyChordTransPost3.add(keyCodePos);
    }
  }

  ///이조 값 증가
  Future<void> incrementTranspositionValue(HttpCommunicate httpCommunicate, int nDanIndex) async {
    if(httpCommunicate.nFileDataType == 2){ ///ACT
      if (_nOneTranspositionValue < _nActMaxKey)
        _nOneTranspositionValue++;
    }
    else{
      switch (nDanIndex) {
        case 1:
          if (_nOneTranspositionValue < 11)
            _nOneTranspositionValue++;
          break;
        case 2:
          if (_nTwoTranspositionValue < 11)
            _nTwoTranspositionValue++;
          break;
        case 3:
          if (_nThreeTranspositionValue < 11)
            _nThreeTranspositionValue++;
          break;
      }
    }
    notifyListeners();
  }

  ///이조 값 감수
  Future<void> decrementTranspositionValue(HttpCommunicate httpCommunicate, int nDanIndex) async{
    if(httpCommunicate.nFileDataType == 2){ ///ACT
      if (_nOneTranspositionValue > _nActMinKey);
        _nOneTranspositionValue--;
    }
    else{
      switch (nDanIndex) {
        case 1:
          if (_nOneTranspositionValue > -11)
            _nOneTranspositionValue--;
          break;
        case 2:
          if (_nTwoTranspositionValue > -11)
            _nTwoTranspositionValue--;
          break;
        case 3:
          if (_nThreeTranspositionValue > -11)
            _nThreeTranspositionValue--;
          break;
      }
    }
    notifyListeners();
  }

  //==============================================================================
  ///보류
  ///섹소폰 3중주 체크 함수
  bool _isApplayTrioSong(int nScoreType) {
    bool bIsApplyTrioSong = false;

    switch (nScoreType) {
      case 30 :
      case 31 :
      case 32 :
      case 35 :
      case 36 :
      case 37 :
        bIsApplyTrioSong = true;
        break;
    }

    return bIsApplyTrioSong;
  }

//==============================================================================

//==============================================================================
  bool purchasedScore(BuildContext context, HttpCommunicate httpCommunicate, List<int> nCurTranspos)
  {
    if(httpCommunicate.bIsPreViewScore! == true)
    {
      print("strBuyTransPosList : ${httpCommunicate.strBuyTransPosList!}");
      int nDan = context.read<DanSettingsProvider>().nDan;
      String strTemp = httpCommunicate.strBuyTransPosList!.replaceAllMapped("%2C", (match) => ",");
      List<String> buyTransposList = strTemp.split(",");

      bool bFlag1 = false;
      bool bFlag2 = false;
      bool bFlag3 = false;

      // print("strBuyTransPosList : ${httpCommunicate.strBuyTransPosList}");
      print("strTemp : $strTemp");
      print("buyTransposList : $buyTransposList");

      for(int nCount=0; nCount<buyTransposList.length; nCount++)
      {
        for(int nIndex=0; nIndex<nDan; nIndex++)
        {
          // print("nCurTranspos[0] : ${nCurTranspos[0]}");
          print("count = ${buyTransposList.length }");
          print("nDan L: $nDan");
          // print("buyTransposList[0].codeUnits : ${buyTransposList[nCount]}");


          switch(nDan)
          {
            case 1 :
              print("1 : ${nCurTranspos[0] + 65}");
              print("buy$nCount : ${buyTransposList[nCount].codeUnits}");
              if((nCurTranspos[0] + 65) == buyTransposList[nCount].codeUnits[nIndex])  return true;
              continue;
            case 2 :
              if((nCurTranspos[0] + 65) == buyTransposList[nCount].codeUnits[nIndex]) {bFlag1 = true; print("bFlag1 : $bFlag1");}
              if((nCurTranspos[1] + 65) == buyTransposList[nCount].codeUnits[nIndex]) {bFlag2 = true; print("bFlag2 : $bFlag2");}

              if(bFlag1 && bFlag2) {print("return true"); return true;}
              continue;
            case 3 :
              if((nCurTranspos[0] + 65) == buyTransposList[nCount].codeUnits[nIndex]) bFlag1 = true;
              if((nCurTranspos[1] + 65) == buyTransposList[nCount].codeUnits[nIndex]) bFlag2 = true;
              if((nCurTranspos[2] + 65) == buyTransposList[nCount].codeUnits[nIndex]) bFlag3 = true;

              if(bFlag1 && bFlag2 && bFlag3) return true;
              continue;
            default :
              print('nDan Error!!');
              break;
          }
        }
      }
    }
    print("retuen false");
    return false;
  }
//==============================================================================

//==============================================================================
  bool isPurchasedScore(BuildContext context, HttpCommunicate httpCommunicate)
  {

    List<int> nCurTranspos = [];

    nCurTranspos.clear();

   if(httpCommunicate.strBuyTransPosList!.isNotEmpty)
   {
     if(context.read<DanSettingsProvider>().nDan == 1)
     {
       nCurTranspos.add((_nOneTranspositionValue - 11) * -1);
       // nCurTranspos.add(_nOneTranspositionValue);
     }
     else if(context.read<DanSettingsProvider>().nDan == 2)
     {
       nCurTranspos.add((_nOneTranspositionValue - 11) * -1);
       print("nOneTrans : $_nOneTranspositionValue");
       nCurTranspos.add((_nTwoTranspositionValue - 11) * -1);
       print("nTwoTrans : $_nTwoTranspositionValue");
     }
     else
     {
       nCurTranspos.add((_nOneTranspositionValue - 11) * -1);
       nCurTranspos.add((_nTwoTranspositionValue - 11) * -1);
       nCurTranspos.add((_nThreeTranspositionValue - 11) * -1);
     }
     print('nCureTranspos : $nCurTranspos');
     return purchasedScore(context, httpCommunicate, nCurTranspos);
   }
   return false;
  }
//==============================================================================

  String setKeyChord(int nDanIndex)
  {
    if(nDanIndex == 1)
    {
      return pKeyChordTransPos1[_nOneTranspositionValue + 11].strKeyChord!;
    }
    else if(nDanIndex == 2)
    {
      return pKeyChordTransPos2[_nTwoTranspositionValue + 11].strKeyChord!;
    }
    else
    {
      return pKeyChordTransPos3[_nThreeTranspositionValue + 11].strKeyChord!;
    }
  }

//==============================================================================

//==============================================================================

  String setMeterKey(int nDanIndex)
  {
    if(nDanIndex == 1)
    {
      if(pKeyChordTransPos1[_nOneTranspositionValue + 11].nMeterKey! > 0)
      {
        return "#${pKeyChordTransPos1[_nOneTranspositionValue + 11].nMeterKey}";
      }
      else if(pKeyChordTransPos1[_nOneTranspositionValue + 11].nMeterKey! < 0)
      {
        return "b${(pKeyChordTransPos1[_nOneTranspositionValue + 11].nMeterKey!) * -1}";

      }
      else
      {
        return "0";
      }
    }
    else if(nDanIndex == 2)
    {
      if(pKeyChordTransPos2[_nTwoTranspositionValue + 11].nMeterKey! > 0)
      {
        return "#${pKeyChordTransPos2[_nTwoTranspositionValue + 11].nMeterKey}";
      }
      else if(pKeyChordTransPos2[_nTwoTranspositionValue + 11].nMeterKey! < 0)
      {
        return "b${(pKeyChordTransPos2[_nTwoTranspositionValue + 11].nMeterKey!) * -1}";
      }
      else
      {
        return "0";
      }
    }
    else
    {
      if(pKeyChordTransPos3[_nThreeTranspositionValue + 11].nMeterKey! > 0)
      {
        return "#${pKeyChordTransPos3[_nThreeTranspositionValue + 11].nMeterKey}";
      }
      else if(pKeyChordTransPos3[_nThreeTranspositionValue + 11].nMeterKey! < 0)
      {
        return "b${(pKeyChordTransPos3[_nThreeTranspositionValue + 11].nMeterKey!) * -1}";
      }
      else
      {
        return "0";
      }
    }
  }

//==============================================================================
}

class KeyChordTransPos{

  int?    nTransPos;
  int?    nMeterKey;
  String? strKeyChord;

  KeyChordTransPos(this.nTransPos, this.nMeterKey, this.strKeyChord);
}
