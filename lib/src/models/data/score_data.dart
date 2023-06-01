
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ScoreData extends ChangeNotifier{

  String? strScorePath;
  int? nScorePageNum;

  ScoreData();

  setData(ScoreData data){
    strScorePath = data.strScorePath;
    nScorePageNum = data.nScorePageNum;

    notifyListeners();
  }
}