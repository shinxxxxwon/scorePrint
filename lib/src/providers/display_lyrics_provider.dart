import 'package:flutter/widgets.dart';

class DisplayLyricsProvider extends ChangeNotifier{

  bool bIsDisplayLyrics = false;

  int nActDisplayLyrics = 1;

  int _nDisplayLyricsValue = 1;
  int get nDisplayLyricsValue => _nDisplayLyricsValue;

  void init(){
    bIsDisplayLyrics = false;
    nActDisplayLyrics = 1;
    _nDisplayLyricsValue = 1;

    notifyListeners();
  }

  void setDisplayLyricsValue(int nValue){
    _nDisplayLyricsValue = nValue;
    // print("nValue : $nValue");
    // print("_nDisplayLyricsValue : $_nDisplayLyricsValue");
  }

  changeActDisplayLyricsValue(int nStat){
    nActDisplayLyrics = nStat;
    _nDisplayLyricsValue = nStat;
    notifyListeners();
  }

  ///가사표시 설정 값 변경
 changeDisplayLyricsValue(int nButtonIndex){
    switch(nButtonIndex){
      case 0: ///안함
        _nDisplayLyricsValue = 0;
        break;
      case 1: ///소
        _nDisplayLyricsValue = 1;
        break;
      case 2: ///중
        _nDisplayLyricsValue = 2;
        break;
      case 3: ///대
        _nDisplayLyricsValue = 3;
        break;
    }
    notifyListeners();
  }
}