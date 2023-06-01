
import 'package:flutter/widgets.dart';

class OctaveProvider extends ChangeNotifier{

  bool bIsOctave = false;

  int _nOneOctaveValue = 0;
  int get nOneOctaveValue => _nOneOctaveValue;

  int _nTwoOctaveValue = 0;
  int get nTwoOctaveValue => _nTwoOctaveValue;

  int _nThreeOctaveValue = 0;
  int get nThreeOctaveValue => _nThreeOctaveValue;

  void init(){
    bIsOctave = false;
    _nOneOctaveValue = 0;
    _nTwoOctaveValue = 0;
    _nThreeOctaveValue = 0;

    notifyListeners();
  }


  void setOctave(int nDan, int nOctaveStat){
    switch(nDan){
      case 1:
        _nOneOctaveValue = nOctaveStat;
        break;
      case 2:
        _nTwoOctaveValue = nOctaveStat;
        break;
      case 3:
        _nThreeOctaveValue = nOctaveStat;
        break;
    }
  }

  ///옥타브 증가
  Future<void> incrementOctave(int nDanIndex) async{
    switch(nDanIndex){
      case 1:
        if(_nOneOctaveValue < 1)
          _nOneOctaveValue++;
        break;
      case 2:
        if(_nTwoOctaveValue < 1)
          _nTwoOctaveValue++;
        break;
      case 3:
        if(_nThreeOctaveValue < 1)
          _nThreeOctaveValue++;
        break;
    }
    notifyListeners();
  }

  ///옥타브 감소
  Future<void> decreamentOctave(int nDanIndex) async {
    switch(nDanIndex){
      case 1:
        if(_nOneOctaveValue > -1)
          _nOneOctaveValue--;
        break;
      case 2:
        if(_nTwoOctaveValue > -1)
          _nTwoOctaveValue--;
        break;
      case 3:
        if(_nThreeOctaveValue > -1)
          _nThreeOctaveValue--;
        break;
    }
    notifyListeners();
  }
}