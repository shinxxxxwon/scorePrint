import 'package:elfscoreprint_mobile/src/screens/tablet/dialogs/tablet_ensemble_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../../models/http/http_communicate.dart';
import '../../phone/dialogs/phone_settings_dialog.dart';

class TabletSettingsButton extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  HttpCommunicate? httpCommunicate;

  TabletSettingsButton(
      {this.orientation, this.bIsTablet, this.httpCommunicate});

//==============================================================================

  ///설정 버튼
  Widget _SettingsButton(BuildContext context, Size size) {
    return orientation == Orientation.portrait
        ? _portraitSettingsButton(context, size)
        : _landscapeSettingsButton(context, size);
  }

  ///세로 모드 설정 버튼
  Widget _portraitSettingsButton(BuildContext context, Size size) {
    return Positioned(
      ///SJW Modify 2023.05.22 Start...
      ///뷰어로 바뀌면서 좌표 변경
      top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
      right: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      // top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      // left: Platform.isAndroid ? size.width * 0.35 : size.width * 0.35,

      ///SJW Modify 2023.05.22 End...

      child: GestureDetector(
        onTap: () {
          if (httpCommunicate!.nFileDataType == 1) {
            Platform.isAndroid
                ? showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => TabletEnsembleDialog())
                : showCupertinoDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => TabletEnsembleDialog()
                    // builder: (BuildContext context) => TabletPurchasedDialog(),
                    );
          } else {
            Platform.isAndroid
                ? showMaterialModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    duration: Duration(milliseconds: 300),
                    enableDrag: false,
                    builder: (_) => PhoneSettingsDialog(
                        httpCommunicate: httpCommunicate!,
                        orientation: orientation!,
                        bIsTablet: bIsTablet!))
                : showCupertinoModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    duration: Duration(milliseconds: 300),
                    enableDrag: false,
                    builder: (_) => PhoneSettingsDialog(
                        httpCommunicate: httpCommunicate!,
                        orientation: orientation!,
                        bIsTablet: bIsTablet!));
          }
        },
        ///SJW Modify 2023.05.22 Start...
        ///뷰어로 바뀌면서 아이콘 버튼으로 변경
        // child: Container(
        //   width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
        //   height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/settings_button.png'),
        //     ),
        //   ),
        // ),
        child: Icon(Icons.settings, size: size.width * 0.06, color: Colors.black,),
        ///SJW Modify 2023.05.22 End...
      ),
    );
  }

  ///가로 모드 설정 버튼
  Widget _landscapeSettingsButton(BuildContext context, Size size) {
    return Positioned(
      ///SJW Modify 2023.05.22 Start...
      ///뷰어로 바뀌면서 좌표 변경
      top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.03,
      right: Platform.isAndroid ? size.width * 0.05: size.width * 0.05,
      // top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      ///SJW Modify 2023.02.09 Start...
      ///버튼 width 줄인 만큼 좌표이동
      // left: Platform.isAndroid ? size.width * 0.375 : size.width * 0.35,
      ///SJW Modify 2023.02.09 End...
      ///SJW Modift 2023.05.22 End...
      child: GestureDetector(
        onTap: () => httpCommunicate!.nFileDataType == 1
            ? Platform.isAndroid
                ? showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => TabletEnsembleDialog())
                : showCupertinoDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => TabletEnsembleDialog()
                    // builder: (BuildContext context) => TabletPurchasedDialog(),
                    )
            : SideSheet.right(
                context: context,
                barrierDismissible: true,
                body: PhoneSettingsDialog(
                    httpCommunicate: httpCommunicate!,
                    orientation: orientation!,
                    bIsTablet: bIsTablet!)),
        ///SJW Modify 2023.05.22 Start...
        ///뷰어로 바뀌면서 아이콘 버튼으로 변경
        // child: Container(
        //   ///SJW Modify 2023.02.09 Start...
        //   ///버튼 width가 넓어 줄임
        //   width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.3,
        //   ///SJW Modify 2023.02.09 End...
        //   height: Platform.isAndroid ? size.width * 0.07 : size.width * 0.07,
        //   alignment: Alignment.center,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/settings_button.png'),
        //     ),
        //   ),
        // ),
        child: Icon(Icons.settings, size: size.height * 0.06, color: Colors.black,),
        ///SJW Modify 2023.05.22 End...
      ),
    );
  }

//==============================================================================

  @override
  Widget build(BuildContext context) {
    //디바이스 크기[넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022.06.29 Start...1  ///세로 & 가로 모드 함수로 따로 구현
    return _SettingsButton(context, _size);
    // return Positioned(
    //   ///SJW Modify 2022.04.19 Start...1 좌표 수정
    //   // top: orientation == Orientation.portrait ?
    //   //     Platform.isAndroid ?
    //   //         _size.height * 0.85 : _size.height * 0.85
    //   //     : Platform.isAndroid ?
    //   //         _size.height * 0.80 : _size.height * 0.80,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.height * 0.90 : _size.height * 0.90
    //       :Platform.isAndroid ?
    //           _size.height * 0.85 : _size.height * 0.85,
    //   ///SJW Modify 2022.04.19 End...1
    //
    //   left: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.width * 0.35 : _size.width * 0.35
    //       : Platform.isAndroid ?
    //           _size.width * 0.35 : _size.width * 0.35,
    //
    //     ///SJW Modify 2022.04.29 Start...1  GUI 적용
    //     // child: TextButton(
    //     //   onPressed: () async {
    //     //     if(orientation == Orientation.portrait){
    //     //       Platform.isAndroid ?
    //     //           showMaterialModalBottomSheet(
    //     //             context: context,
    //     //             isDismissible: true,
    //     //             duration: Duration(milliseconds: 300),
    //     //             enableDrag: false,
    //     //             builder: (context) => PhoneSettingsDialog(orientation: orientation!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!)
    //     //           ) :
    //     //           showCupertinoModalBottomSheet(
    //     //             context: context,
    //     //             isDismissible: true,
    //     //             duration: Duration(milliseconds: 300),
    //     //             enableDrag: false,
    //     //             builder: (context) => PhoneSettingsDialog(orientation: orientation!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!)
    //     //           );
    //     //     }
    //     //     else{
    //     //       SideSheet.right(
    //     //         context: context,
    //     //         barrierDismissible: true,
    //     //         body: PhoneSettingsDialog(orientation: orientation!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!)
    //     //       );
    //     //     }
    //     //   },
    //     //   child: Text(
    //     //     '설정',
    //     //     style: TextStyle(
    //     //       fontWeight: FontWeight.bold,
    //     //       color: Colors.white,
    //     //       fontSize: Platform.isAndroid ? 18 : 24,
    //     //     ),
    //     //   ),
    //     // ),
    //     child: GestureDetector(
    //       onTap: () async {
    //         if(orientation == Orientation.portrait){
    //           Platform.isAndroid ?
    //           showMaterialModalBottomSheet(
    //               context: context,
    //               isDismissible: true,
    //               duration: Duration(milliseconds: 300),
    //               enableDrag: false,
    //               builder: (context) => PhoneSettingsDialog(orientation: orientation!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!)
    //           ) :
    //           showCupertinoModalBottomSheet(
    //               context: context,
    //               isDismissible: true,
    //               duration: Duration(milliseconds: 300),
    //               enableDrag: false,
    //               builder: (context) => PhoneSettingsDialog(orientation: orientation!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!)
    //           );
    //         }
    //         else{
    //           SideSheet.right(
    //               context: context,
    //               barrierDismissible: true,
    //               body: PhoneSettingsDialog(orientation: orientation!, httpCommunicate: httpCommunicate!, bIsTablet: bIsTablet!)
    //           );
    //         }
    //       },
    //       child:Container(
    //         width: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.3
    //             : Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.3,
    //
    //         height: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //         _size.height * 0.07 : _size.height * 0.07
    //             : Platform.isAndroid ?
    //         _size.height * 0.13 : _size.height * 0.13,
    //
    //         alignment: Alignment.center,
    //
    //         decoration: BoxDecoration(
    //           //color: Colors.blue,
    //           borderRadius: BorderRadius.circular(16.0),
    //           image: DecorationImage(image: AssetImage('assets/images/buttons/settings_button.png'), fit: BoxFit.fill),
    //         ),
    //     ),
    //     ///SJW Modify 2022.04.29 End...1
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...1
  }
}
