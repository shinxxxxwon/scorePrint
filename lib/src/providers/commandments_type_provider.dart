import 'package:flutter/widgets.dart';

class CommandmentsTypeProvider extends ChangeNotifier{

  bool bIsCommandmentsType = false;

  int _nCommandmentsTypeValue = 0;
  int get nCommandmentsTypeValue => _nCommandmentsTypeValue;


  void init(){
    bIsCommandmentsType = false;
    _nCommandmentsTypeValue = 0;

    notifyListeners();
  }

  void setCommandmentsTypeValue(int nValue){
    _nCommandmentsTypeValue = nValue;
  }

  ///계명종류 설정 값 변경
  Future<void> changeCommandmentsTypeValue(int nButtonIndex) async {
    _nCommandmentsTypeValue = nButtonIndex;
    notifyListeners();
  }
}