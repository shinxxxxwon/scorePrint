
import 'package:flutter/widgets.dart';


class ScoreDataProvider extends ChangeNotifier{

  Map<String, dynamic> urlData = Map<String, dynamic>();

  String strP0Path = "";

  setUrlData(Map<String, dynamic> data){
    urlData = data;
    notifyListeners();
  }
}