
import 'package:elfscoreprint_mobile/src/screens/phone/dialogs/phone_ensemble_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:side_sheet/side_sheet.dart';

import '../../../models/http/http_communicate.dart';
import '../dialogs/phone_settings_dialog.dart';

class PhoneSettingsButton extends StatelessWidget {
  final Orientation? orientation;
  HttpCommunicate? httpCommunicate;

  PhoneSettingsButton({this.orientation, this.httpCommunicate});

//==============================================================================

  ///세로모드 버튼 UI
  Widget _portraitPhoneSettingsButton(BuildContext context, Size size){
    return Positioned(
      ///SJW Modify 2023.05.18 Start...
      ///뷰어로 바뀌어서 버튼 위치 변경
      // top: Platform.isAndroid ? size.height * 0.88 : size.height * 0.88,
      // left: Platform.isAndroid ? size.width * 0.35 : size.width * 0.35,
      top: Platform.isAndroid ? size.height * 0.04 : size.height * 0.035,
      right: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      ///SJW Modify 2023.05.18 End...
      child: GestureDetector(
        onTap: () {
          if (httpCommunicate!.nFileDataType == 1) {
            Platform.isAndroid
                ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PhoneEnsembleDialog()
            )
                : showCupertinoDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => PhoneEnsembleDialog()
            );
          }
          else {
            print('show Phone Setting');
            Platform.isAndroid ?
            showMaterialModalBottomSheet(
              context: context,
              isDismissible: true,
              duration: Duration(milliseconds: 300),
              // shape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(16.0),
              //     topRight: Radius.circular(16.0),
              //   ),
              // ),
              builder: (context) =>
                  PhoneSettingsDialog(orientation: orientation!,
                      bIsTablet: false,
                      httpCommunicate: httpCommunicate!),
            ) :
            showCupertinoModalBottomSheet(
              context: context,
              isDismissible: true,
              duration: Duration(milliseconds: 300),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              builder: (context) =>
                  PhoneSettingsDialog(orientation: orientation!,
                      bIsTablet: false,
                      httpCommunicate: httpCommunicate!),
            );
          }
        },
        // child: Container(
        //   width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
        //   height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
        //   decoration: BoxDecoration(
        //     //color: Colors.blue,
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/settings_button.png'),
        //     ),
        //   ),
        // ),
        child: Icon(Icons.settings, size: size.width * 0.08, color: Colors.black,),
        ///SJW Modify 2023.05.18 End...
      ),
    );
  }

  ///가로모드 버튼 UI
  Widget _landscapePhoneSettingsButton(BuildContext context, Size size){
    return Positioned(
      ///SJW Modify 2023.05.18 Start...
      ///뷰어로 바뀌면서 좌표 이동
      // top: Platform.isAndroid ? size.height * 0.85 : size.height *0.85,
      // ///SJW Modify 2023.02.09 Start...
      // ///버튼 줄인 만큼 좌표 이동
      // left: Platform.isAndroid ? size.width * 0.375 : size.width * 0.35,
      // /SJW Modify 2023.02.09 End...
      top: Platform.isAndroid ? size.height * 0.03 : size.height * 0.05,
      right: Platform.isAndroid ? size.width * 0.05 : size.width * 0.05,
      ///SJW Modify 2023.05.18 End...
      child: GestureDetector(
        onTap: () {
          if (httpCommunicate!.nFileDataType == 1) {
            Platform.isAndroid
                ? showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => PhoneEnsembleDialog()
            )
                : showCupertinoDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => PhoneEnsembleDialog()
            );
          }
          else {
            SideSheet.right(
              context: context,
              barrierDismissible: true,
              transitionDuration: Duration(milliseconds: 300),
              body: PhoneSettingsDialog(orientation: orientation!,
                  bIsTablet: false,
                  httpCommunicate: httpCommunicate!),
            );
          }
        },
        ///SJW Modify 2023.05.18 Start...
        ///뷰어로 바뀌면서 악보설정 버튼 아이콘으로 대체
        // child: Container(
        //   ///SJW Modify 2023.02.09 Start...
        //   ///버튼 width가 넓어 줄임
        //   width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.27,
        //   ///SJW Modify 2023.02.09 End...
        //   height: Platform.isAndroid ? size.height * 0.13 : size.height * 0.13,
        //   decoration: BoxDecoration(
        //     //color: Colors.blue,
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/buttons/settings_button.png'),
        //     ),
        //   ),
        // ),
        child: Icon(Icons.settings, size: size.height * 0.08, color: Colors.black,),
        ///SJW Modify 2023.05.18 End...
      ),
    );
  }

//==============================================================================

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022.06.24 Start...1  ///세로 & 가로모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitPhoneSettingsButton(context, _size)
        : _landscapePhoneSettingsButton(context, _size);
    // return Positioned(
    //   ///SJW Modify 2022.04.21 Start...1  좌표 수정
    //   // top: orientation == Orientation.portrait ?     //세로모드
    //   // Platform.isAndroid ?
    //   // _size.height * 0.85 : _size.height * 0.83
    //   //     : Platform.isAndroid ?                     //가로모드
    //   // _size.height * 0.80 : _size.height * 0.80,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //           _size.height * 0.90 : _size.height * 0.88
    //       :Platform.isAndroid ?
    //           _size.height * 0.85 : _size.height *0.85,
    //   ///SJW Modify 2022.04.21 End...1
    //
    //   left: orientation! == Orientation.portrait ?   //세로모드
    //   Platform.isAndroid ?
    //   _size.width * 0.35 : _size.width * 0.35
    //       : Platform.isAndroid ?                     //가로모드
    //   _size.width * 0.35 : _size.width * 0.35,
    //
    //     ///SJW Modify 2022.04.29 Start...1  GUI 적용
    //     // child: TextButton(
    //     //   onPressed: () async {
    //     //     if(orientation == Orientation.portrait){
    //     //       Platform.isAndroid ?
    //     //       showMaterialModalBottomSheet(
    //     //         context: context,
    //     //         isDismissible: true,
    //     //         duration: Duration(milliseconds: 300),
    //     //         builder: (context) => PhoneSettingsDialog(orientation: orientation!, bIsTablet: false, httpCommunicate: httpCommunicate!),
    //     //       ) :
    //     //       showCupertinoModalBottomSheet(
    //     //         context: context,
    //     //         isDismissible: true,
    //     //         duration: Duration(milliseconds: 300),
    //     //         builder: (context) => PhoneSettingsDialog(orientation: orientation!, bIsTablet: false, httpCommunicate: httpCommunicate!),
    //     //       );
    //     //     }else{
    //     //       SideSheet.right(
    //     //         context: context,
    //     //         barrierDismissible: true,
    //     //         body: PhoneSettingsDialog(orientation: orientation!, bIsTablet: false, httpCommunicate: httpCommunicate!),
    //     //       );
    //     //     }
    //     //   },
    //     //   child: Text(
    //     //     '설정',
    //     //     style: TextStyle(
    //     //       fontWeight: FontWeight.bold,
    //     //       color: Colors.white,
    //     //     ),
    //     //   ),
    //     // ),
    //     child: GestureDetector(
    //       onTap: () {
    //         if(orientation == Orientation.portrait){
    //           Platform.isAndroid ?
    //           showMaterialModalBottomSheet(
    //             context: context,
    //             isDismissible: true,
    //             duration: Duration(milliseconds: 300),
    //             builder: (context) => PhoneSettingsDialog(orientation: orientation!, bIsTablet: false, httpCommunicate: httpCommunicate!),
    //           ) :
    //           showCupertinoModalBottomSheet(
    //             context: context,
    //             isDismissible: true,
    //             duration: Duration(milliseconds: 300),
    //             builder: (context) => PhoneSettingsDialog(orientation: orientation!, bIsTablet: false, httpCommunicate: httpCommunicate!),
    //           );
    //         }else{
    //           SideSheet.right(
    //             context: context,
    //             barrierDismissible: true,
    //             body: PhoneSettingsDialog(orientation: orientation!, bIsTablet: false, httpCommunicate: httpCommunicate!),
    //           );
    //         }
    //       },
    //       child: Container(
    //         width: orientation == Orientation.portrait ?
    //         Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.3
    //             : Platform.isAndroid ?
    //         _size.width * 0.3 : _size.width * 0.27,
    //
    //         height: orientation! == Orientation.portrait ? _size.height * 0.07 : _size.height * 0.13,
    //
    //         decoration: BoxDecoration(
    //           //color: Colors.blue,
    //           image: DecorationImage(
    //             fit: BoxFit.fill,
    //             image: AssetImage('assets/images/buttons/settings_button.png'),
    //           ),
    //         ),
    //     ),
    //     ///SJW Modify 2022.04.29 End...1
    //   ),
    // );
    ///SJW Modify 2022.06.24 End...1
  }
}
