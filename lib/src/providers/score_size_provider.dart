import 'package:flutter/widgets.dart';

class ScoreSizeProvider extends ChangeNotifier{

  bool bIsScoreSize = true;

  int _nScoreSizeValue = 0;
  int get nScoreSizeValue => _nScoreSizeValue;

  void init(){
    bIsScoreSize = true;
    _nScoreSizeValue = 0;

    notifyListeners();
  }

  ///증가 ( -2 ~ +6 )
  Future<void> incrementScoreSize() async {
    if(_nScoreSizeValue < 6){
      _nScoreSizeValue++;
    }
    notifyListeners();
  }

  ///감소 ( -2 ~ +6 )
  Future<void> decrementScoreSize() async {
    if(_nScoreSizeValue > -2){
      _nScoreSizeValue--;
    }
    notifyListeners();
  }

  void setScoreSize(int nValue){
    _nScoreSizeValue = nValue - 2;
    // print("_nScoreSizeValue : $_nScoreSizeValue");
    notifyListeners();
  }

}