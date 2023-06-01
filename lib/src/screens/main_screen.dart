
import 'dart:io';
import 'dart:ui';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:provider/provider.dart';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/http/http_communicate.dart';
import 'phone/phone_main_screen.dart';
import 'tablet/tablet_main_screen.dart';

import 'package:device_info_plus/device_info_plus.dart';

class MainScreen extends StatefulWidget {
  HttpCommunicate? httpCommunicate;

  MainScreen({this.httpCommunicate});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  _preventCapture() async {
    BridgeNative bridgeNative = BridgeNative();
    await bridgeNative.PreventCapture();
  }

  Widget _displayMainScreen(BuildContext context, Size size){
    ///시스템 바 숨김

    // _preventCapture();
    // if(context.read<PDFProvider>().bMakingScore == false) {
    //   setState(() {


        // if (context.read<PDFProvider>().bMakingScore == false && context.read<PDFProvider>().bWillChange == true) {
        //   context.read<PDFProvider>().bWillChange = false;
        //   context.read<PDFProvider>().bMakingScore = true;
        //
        //   DrawScore drawScore = DrawScore();
        //   drawScore.reDrawSocre(context, widget.httpCommunicate!);
        //
        //   context.read<PDFProvider>().nRealChagneCount++;
        //   context.read<PDFProvider>().bMakingScore = false;
        // }

      // });
    // }

    // Size _size = MediaQuery.of(context).size;

    Orientation _orientation = MediaQuery.of(context).orientation;

    if(_orientation == Orientation.portrait){
      if(size.width > 600){
        return TabletMainScreen(httpCommunicate: widget.httpCommunicate!);
      }
      else{
        return PhoneMainScreen(httpCommunicate: widget.httpCommunicate!);
      }
    }
    else{
      if(size.height > 600){
        return TabletMainScreen(httpCommunicate: widget.httpCommunicate!);
      }
      else{
        return PhoneMainScreen(httpCommunicate: widget.httpCommunicate!);
      }
    }

    // return OrientationBuilder(
    //   builder: (context, orientation) {
    //     print('main screen orientation : $orientation');
    //     if(orientation == Orientation.portrait && size.width > 600)
    //       return TabletMainScreen(orientation: orientation, httpCommunicate: widget.httpCommunicate!);
    //     else if(orientation == Orientation.landscape && size.height > 600)
    //       return TabletMainScreen(orientation: orientation, httpCommunicate: widget.httpCommunicate!);
    //     else
    //       return PhoneMainScreen(orientation: orientation, httpCommunicate: widget.httpCommunicate!);
    //   },
    // );
  }

  void _getDeviceInfo()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print("${androidInfo.version.release}");
    if(int.parse(androidInfo.version.release ?? "12") < 9){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
      return;
    }
    else{
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if(Platform.isAndroid) {
      _getDeviceInfo();
    }
    else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
    }

    // SystemChrome.setPreferredOrientations([]);
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return _displayMainScreen(context, _size);
  }
}

