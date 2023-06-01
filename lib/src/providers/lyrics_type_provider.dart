import 'package:flutter/widgets.dart';

class LyricsTypeProvider extends ChangeNotifier{

  bool bIsLyricsType = false;

  int _nLyricsTypeValue = 0;
  int get nLyricsTypeValue => _nLyricsTypeValue;

  void init(){
    bIsLyricsType = false;
    _nLyricsTypeValue = 0;

    notifyListeners();
  }

  void setLyricsTypeValue(int nValue){
    _nLyricsTypeValue = nValue;
  }

  ///가사종류 설정 값 변경 ( 0 = 원어, 1 = 독음 )
  Future<void> changeLyricsTypeValue(int nButtonIndex) async {
    switch(nButtonIndex){
      case 0:
        _nLyricsTypeValue = 0;
        break;
      case 1:
        _nLyricsTypeValue = 1;
        break;
    }
    notifyListeners();
  }
}