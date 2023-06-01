
import 'package:elfscoreprint_mobile/src/screens/tablet/dialogs/tablet_cancel_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../../../models/http/http_communicate.dart';
import '../../../providers/transposition_provider.dart';
import '../dialogs/tablet_purchased_dialog.dart';
import '../dialogs/tablet_shopping_dialog.dart';

class TabletShoppingButton extends StatelessWidget {
  final Orientation? orientation;
  HttpCommunicate? httpCommunicate;

  TabletShoppingButton({this.orientation, this.httpCommunicate});

//==============================================================================

  ///장바구니 버튼
  Widget _shoppingCartButton(BuildContext context, Size size){
    return orientation == Orientation.portrait
        ? _portraitShoppingCartButton(context, size)
        : _landscapeShoppingCartButton(context, size);
  }

  ///세로모드 장바구니 버튼
  Widget _portraitShoppingCartButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.9 : size.height * 0.9,
      left: Platform.isAndroid ? size.width * 0.03 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          Platform.isAndroid
              ? showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                    ? TabletShoppingDialog(httpCommunicate: httpCommunicate!) : const TabletPurchasedDialog()
              )
              : showCupertinoDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                    ? TabletShoppingDialog(httpCommunicate: httpCommunicate!) : const TabletPurchasedDialog()
                  // builder: (BuildContext context) => TabletPurchasedDialog(),
              );
        },
        child: Container(
          width: Platform.isAndroid ? size.width * 0.3 : size.width * 0.3,
          height: Platform.isAndroid ? size.height * 0.07 : size.height * 0.07,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/buttons/save_button.png'),
            ),
          ),
        ),
      ),
    );
  }

  ///가로 모드 장바구니 버튼
  Widget _landscapeShoppingCartButton(BuildContext context, Size size){
    return Positioned(
      top: Platform.isAndroid ? size.height * 0.85 : size.height * 0.85,
      left: Platform.isAndroid ? size.width * 0.02 : size.width * 0.03,
      child: GestureDetector(
        onTap: (){
          Platform.isAndroid
              ? showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                  ? TabletShoppingDialog(httpCommunicate: httpCommunicate!) : const TabletPurchasedDialog(),
              )
              : showCupertinoDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false
                  ? TabletShoppingDialog(httpCommunicate: httpCommunicate!) : const TabletPurchasedDialog()
                // builder: (BuildContext context) => TabletPurchasedDialog(),
              );
        },
        child: Container(
          ///SJW Modify 2023.02.09 Start...
          ///버튼 width가 넓어서 줄임
          width: Platform.isAndroid ? size.width * 0.25 : size.width * 0.3,
          ///SJW Modify 2023.02.09 End...
          height: Platform.isAndroid ? size.width * 0.07 : size.width * 0.07,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/buttons/save_button.png'),
            ),
          ),
        ),
      ),
    );
  }
//==============================================================================

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    ///SJW Modify 2022.06.29 Start...1  ///가로 & 세로 모드 함수로 따로 구현
    return _shoppingCartButton(context, _size);
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
    //           _size.width * 0.03 : _size.width * 0.03
    //       : Platform.isAndroid ?
    //           _size.width * 0.02 : _size.width * 0.03,
    //
    //     ///SJW Modify 2022.04.29 Start...1  버튼 GUI 적용
    //     // child: TextButton(
    //     //   onPressed: (){
    //     //     Platform.isAndroid ?
    //     //         showDialog(
    //     //           context: context,
    //     //           barrierDismissible: false,
    //     //           builder: (context) => TabletShoppingDialog(httpCommunicate: httpCommunicate!)
    //     //         ) :
    //     //         showCupertinoDialog(
    //     //           context: context,
    //     //           barrierDismissible: false,
    //     //           builder: (context) => TabletShoppingDialog(httpCommunicate: httpCommunicate!)
    //     //     );
    //     //   },
    //     //   child: Text(
    //     //     '저장',
    //     //     style: TextStyle(
    //     //       fontWeight: FontWeight.bold,
    //     //       color: Colors.white,
    //     //       fontSize: Platform.isAndroid ? 18 : 24,
    //     //     ),
    //     //   ),
    //     // ),
    //     child: GestureDetector(
    //       onTap: (){
    //         Platform.isAndroid ?
    //           showDialog(
    //               context: context,
    //               barrierDismissible: false,
    //               builder: (context) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false ?
    //               TabletShoppingDialog(httpCommunicate: httpCommunicate!) : TabletPurchasedDialog()
    //             // builder: (context) => TabletShoppingDialog(httpCommunicate: httpCommunicate!,),
    //
    //           ) :
    //           showCupertinoDialog(
    //               context: context,
    //               barrierDismissible: false,
    //               builder: (context) => context.read<TranspositionProvider>().isPurchasedScore(context, httpCommunicate!) == false ?
    //               TabletShoppingDialog(httpCommunicate: httpCommunicate!) : TabletPurchasedDialog()
    //         );
    //       },
    //       child: Container(
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
    //         decoration: BoxDecoration(
    //           //color: Colors.blue,
    //           borderRadius: BorderRadius.circular(16.0),
    //           image: DecorationImage(image: AssetImage('assets/images/buttons/save_button.png'), fit: BoxFit.fill),
    //         ),
    //         alignment: Alignment.center,
    //     ),
    //     ///SJW Modify 2022.04.29 End...1
    //   ),
    // );
    ///SJW Modify 2022.06.29 End...1
  }
}
