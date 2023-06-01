import 'package:flutter/widgets.dart';

class DisplayCodeProvider extends ChangeNotifier{

  bool bIsDisplayCode = false;

  int nActDisplayCode = 1;

  int _nDisplayCodeValue = 1;
  int get nDisplayCodeValue => _nDisplayCodeValue;

  void init(int nScoreType){
    bIsDisplayCode = false;
    nActDisplayCode = 1;
    if(nScoreType == 16 || nScoreType == 17) {
      _nDisplayCodeValue = 0;
    }
    else{
      _nDisplayCodeValue = 1;
    }

    notifyListeners();
  }

  void setDisplayCodeValue(int nValue){
    _nDisplayCodeValue = nValue;
    }

  Future<void> changeActDisplayCodeValue(int nStat) async{
    _nDisplayCodeValue = nStat;
    nActDisplayCode = nStat;
    notifyListeners();
  }

  ///코드 표시 설정 값 변경
  Future<void> changeDisplayCodeValue(int nButtonIndex) async{
    switch(nButtonIndex){
      case 0: ///안함
        _nDisplayCodeValue = 0;
        break;
      case 1: ///소
        _nDisplayCodeValue = 1;
        break;
      case 2: ///중
        _nDisplayCodeValue = 2;
        break;
      case 3: ///대
        _nDisplayCodeValue = 3;
        break;
    }
    notifyListeners();
  }

}