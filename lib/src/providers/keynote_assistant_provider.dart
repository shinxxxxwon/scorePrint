
import 'package:flutter/widgets.dart';

class KeynoteAssistantProvider extends ChangeNotifier{

  bool bIsKeynoteAssistant = false;

  bool _bKeynoteAssistantValue = false;
  bool get bKeynoteAssistantValue => _bKeynoteAssistantValue;

  void init(){
    bIsKeynoteAssistant = false;
    _bKeynoteAssistantValue = false;

    notifyListeners();
  }

  void setKeynoteAssistantValue(int nValue){
    // print('nValue22 : $nValue');
    _bKeynoteAssistantValue = nValue == 0 ? false : true;
    notifyListeners();
  }

  ///조표 인식 도우미 값 변경
  Future<void> changeKeynoteAssistantValue(/*bool bState*/) async {
    _bKeynoteAssistantValue = !_bKeynoteAssistantValue;
    notifyListeners();
  }

}