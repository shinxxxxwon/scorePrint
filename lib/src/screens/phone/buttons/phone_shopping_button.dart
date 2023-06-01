
import 'package:elfscoreprint_mobile/src/providers/transposition_provider.dart';
import 'package:elfscoreprint_mobile/src/screens/phone/dialogs/phone_purchase_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import '../../../models/http/http_communicate.dart';
import '../dialogs/phone_shopping_dialog.dart';
import 'package:provider/provider.dart';

class PhoneShoppingButton extends StatelessWidget {
  final Orientation? orientation;
  HttpCommunicate? httpCommunicate;

  PhoneShoppingButton({this.orientation, this.httpCommunicate});

  ///세로모드 UI
  Widget _portraitPhoneShoppingButton(BuildContext context, Size size){
    return Positioned(
        top: Platform.isAndroid ? size.height * 0.88 : size.height * 0.88,
        left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
        child: GestureDetector(
          onTap: () {
            Platform.isAndroid
                ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                ? PhoneShoppingDialog(httpCommunicate: httpCommunicate!) : PhonePurchaseDialog(),
            )
                : showCupertinoDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                  ? PhoneShoppingDialog(httpCommunicate: httpCommunicate!) : PhonePurchaseDialog(),
            );
          },
          child: Container(
            width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
            height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
            decoration: BoxDecoration(
              //color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/buttons/save_button.png'),
              ),
            ),
          ),
        )
    );
  }

  ///가로모드 UI
  Widget _landscapePhoneShoppingButton(BuildContext context, Size size){
    return Positioned(
        top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
        left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.05,
        child: GestureDetector(
          onTap: () {
            Platform.isAndroid
                ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                  ? PhoneShoppingDialog(httpCommunicate: httpCommunicate!) : PhonePurchaseDialog(),
            )
                : showCupertinoDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                  ? PhoneShoppingDialog(httpCommunicate: httpCommunicate!) : PhonePurchaseDialog(),
            );
          },
          child: Container(
            ///SJW Modify 2023.02.09 Start...
            ///버튼 width가 넓어서 줄임
            width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.27,
            ///SJW Modifu 2023.02.09 End...
            height: Platform.isAndroid ? size.height * 0.13 : size.height * 0.11,
            decoration: BoxDecoration(
              //color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/buttons/save_button.png'),
              ),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022.06.24 Start...1 ///세로 & 가로 모드 함수로 따로 구현
    return orientation == Orientation.portrait
        ? _portraitPhoneShoppingButton(context, _size)
        : _landscapePhoneShoppingButton(context, _size);
    // return Positioned(
    //   ///SJW Modify 2022.04.21 Start...1  좌표수정
    //   // top: orientation == Orientation.portrait ?              ///세로모드
    //   // Platform.isAndroid ?
    //   // _size.height * 0.85 : _size.height * 0.83
    //   //     : Platform.isAndroid ?                            ///가로모드
    //   // _size.height * 0.80 : _size.height * 0.80,
    //   top: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?      //세로모드
    //         _size.height * 0.90 : _size.height * 0.88
    //       :Platform.isAndroid ?     //가로모드
    //         _size.height * 0.85 : _size.height * 0.85,
    //   ///SJW Modify 2022.04.21 End...1
    //
    //   left: orientation == Orientation.portrait ?             ///세로모드
    //   Platform.isAndroid ?
    //   _size.width * 0.03 : _size.width * 0.03
    //       : Platform.isAndroid ?
    //   _size.width * 0.03 : _size.width * 0.05,
    //
    //     ///SJW Modify 2022.04.29 Start...1  GUI 적용
    //     // child: TextButton(
    //     //   onPressed: () {
    //     //     Platform.isAndroid
    //     //         ? showDialog(
    //     //       context: context,
    //     //       barrierDismissible: false,
    //     //       builder: (BuildContext context) => PhoneShoppingDialog(httpCommunicate: httpCommunicate!),
    //     //     )
    //     //         : showCupertinoDialog(
    //     //       context: context,
    //     //       barrierDismissible: false,
    //     //       builder: (BuildContext context) => PhoneShoppingDialog(httpCommunicate: httpCommunicate!),
    //     //     );
    //     //   },
    //     //   child: Text(
    //     //     '저장',
    //     //     style: TextStyle(
    //     //       fontWeight: FontWeight.bold,
    //     //       color: Colors.white,
    //     //     ),
    //     //   ),
    //     // ),
    //     child: GestureDetector(
    //       onTap: () {
    //         Platform.isAndroid
    //             ? showDialog(
    //           context: context,
    //           barrierDismissible: false,
    //           builder: (BuildContext context) => PhoneShoppingDialog(httpCommunicate: httpCommunicate!),
    //         )
    //             : showCupertinoDialog(
    //           context: context,
    //           barrierDismissible: false,
    //           builder: (BuildContext context) => PhoneShoppingDialog(httpCommunicate: httpCommunicate!),
    //         );
    //       },
    //       child: Container(
    //     width: orientation == Orientation.portrait ?
    //       Platform.isAndroid ?
    //       _size.width * 0.3 : _size.width * 0.3
    //         : Platform.isAndroid ?
    //       _size.width * 0.3 : _size.width * 0.27,
    //
    //       height: orientation == Orientation.portrait ? _size.height * 0.07 : _size.height * 0.13,
    //       decoration: BoxDecoration(
    //         //color: Colors.blue,
    //         image: DecorationImage(
    //           fit: BoxFit.fill,
    //           image: AssetImage('assets/images/buttons/save_button.png'),
    //         ),
    //       ),
    //     ///SJW Modify 2022.04.29 End...1
    //   ),
    // )
    // );
    ///SJW Modify 2022.06.24 End...1
  }
}
