import 'package:flutter/widgets.dart';

class EnsembleCodeProvider extends ChangeNotifier{

  bool bIsEnsembleCode = false;


  int _nEnsembleCode = 0;
  int get nEnsembleCode => _nEnsembleCode;

  void init(){
    bIsEnsembleCode = false;
    _nEnsembleCode = 0;

    notifyListeners();
  }

  void setEnsembleCode(int nValue){
    _nEnsembleCode = nValue;
  }

  ///합주코드 변경
  Future<void> changeEnsembleCode(int nButtonIndex) async {
    _nEnsembleCode = nButtonIndex;
    notifyListeners();
  }
}