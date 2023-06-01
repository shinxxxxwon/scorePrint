import 'package:flutter/widgets.dart';

class ScoreImageProvider extends ChangeNotifier{

  Uri? tempUriData;

  List<String> _scoreImageList = [];
  List<String> get scoreImageList => _scoreImageList;

  void setUriData(Uri uri){
    tempUriData = uri;
    notifyListeners();
  }

  void getScoreImage(List<String> imageList){
    _scoreImageList.clear();
    _scoreImageList = imageList;
    notifyListeners();
  }

  Map<String, String> scoreInfo = Map<String, String>();

 url2Map(String strUrl){

    Map<String, String> map = Map<String, String>();

    List<String> list = strUrl.split("?");
    list = list[1].split("&");
    // print("list : $list");
    List<String> tempList = [];
    for(int nCount=0; nCount<list.length; nCount++){
      tempList.clear();
      tempList = list[nCount].split("=");
      map[tempList[0]] = tempList[1];

    }
    // print('map : $map');
    scoreInfo = map;
    // print('ScoreInfo Map : $scoreInfo');
    notifyListeners();
  }

}