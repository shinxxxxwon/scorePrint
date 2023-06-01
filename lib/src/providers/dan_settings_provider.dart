import 'package:flutter/widgets.dart';

class DanSettingsProvider extends ChangeNotifier{

  int nDan = 0;
  int nSettingsCount = 0;

  String strSource = "";

  bool bFtpDownload = true;

  void init()
  {
    nDan = 0;
    nSettingsCount = 0;
    strSource = "";
    bFtpDownload = true;

    notifyListeners();
  }

}