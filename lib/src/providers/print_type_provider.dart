import 'package:flutter/widgets.dart';

class PrintTypeProvider extends ChangeNotifier{

  bool bIsPrintType = false;

  int _nPrintTypeValue = 0;
  int get nPrintTypeValue => _nPrintTypeValue;

  bool bPrintResult = false;

  void init(){
    bIsPrintType = false;
    _nPrintTypeValue = 0;
    bool bPrintResult = false;

    notifyListeners();
  }

  setPrintResult(bool bRes){
    bPrintResult = bRes;
  }

  ///출력선택 설정 변경 ( 0 = 전체, 1 = 1보만, 2 = 2보만, 3 = 3보만 )
  Future<void> changePrintTypeValue(int nButtonIndex) async {
    _nPrintTypeValue = nButtonIndex;
    notifyListeners();
  }

}