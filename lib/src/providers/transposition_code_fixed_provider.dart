import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TranspositionCodeFixedProvider extends ChangeNotifier{

  bool bIsTranspositionCodeFixed = false;

  bool _bTranspositionCodeFixedValue = false;
  bool get bTranspositionCodeFixedValue => _bTranspositionCodeFixedValue;

  void init(){
    bIsTranspositionCodeFixed = false;
    _bTranspositionCodeFixedValue = false;

    notifyListeners();
  }

  void setTranspositionCodeFixedValue(int nValue){
    _bTranspositionCodeFixedValue = nValue == 0 ? false : true;
    notifyListeners();
  }

  ///이조시 코드 고정 값 변경
  Future<void> changeTranspositionCodeFixedValue(/*bool bState*/) async {
    _bTranspositionCodeFixedValue = !_bTranspositionCodeFixedValue;
    notifyListeners();
  }
}