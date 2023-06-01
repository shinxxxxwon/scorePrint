import 'package:flutter/widgets.dart';

class LyricsCommandmentsProvider extends ChangeNotifier {

  bool bIsLyricsCommandments = false;

  int _nLyricsCommandmentsValue = 0;
  int get nLyricsCommandmentsValue => _nLyricsCommandmentsValue;

  void init(){
    bIsLyricsCommandments = false;
    _nLyricsCommandmentsValue = 0;

    notifyListeners();
  }

  void setLyricsCommandmentsValue(int nValue){
    _nLyricsCommandmentsValue = nValue;
  }

  ///가사/계명 설정 값 변경 ( 0 = 가사, 1 = 계명 )
  Future<void> changeLyricsCommandmentsValue(int nButtonIndex) async {
    _nLyricsCommandmentsValue = nButtonIndex;
    notifyListeners();
  }
}