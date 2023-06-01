
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../../../../../providers/transposition_provider.dart';

class TranspositionValue extends StatelessWidget {
  final Orientation? orientation;
  final int? nDanIndex;
  final bool? bIsTablet;

  TranspositionValue({this.orientation, this.nDanIndex, this.bIsTablet});

//==============================================================================
  ///이조 값 출력
  Widget _displayTranspositionValue(BuildContext context, Size size){

    return Consumer<TranspositionProvider>(
      builder: (context, transposition, child){

        String strMeterKey = transposition.setMeterKey(nDanIndex!);


        if(nDanIndex == 1){ //1단
          ///SJW Modify 2022-06-02 Start...1
          ///GUI 적용
          // return Text(
          //   ///SJW Modify 2022.04.29 Start...1  [이조 값] [키 값] [조표]로 출력하도록 변경
          //   //transposition.nOneTranspositionValue.toString(),
          //   '${transposition.nOneTranspositionValue}\t${transposition.pKeyChordTransPos[transposition.nOneTranspositionValue + 11].strKeyChord}\t$strMeterKey',
          //   ///SJW Modify 2022.04.29 End...1
          //   style: TextStyle(
          //     ///SJW Modify 2022.04.19 Start...1 값에 따른 fontWeight 변경
          //     //fontWeight: FontWeight.bold,
          //     fontWeight: transposition.nOneTranspositionValue == 0 ? FontWeight.normal : FontWeight.bold,
          //     ///SJW Modify 2022.04.19 End...1
          //     color: Colors.black,
          //     fontSize: bIsTablet == true ? 22: 16,
          //   ),
          // );
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/transposition_container.png'),
              ),
            ),
            child: Text(
              context.read<TranspositionProvider>().bOneIsDrum == false && nDanIndex == 1
                  ? '${transposition.nOneTranspositionValue > -1 ? '+' : ''}${transposition.nOneTranspositionValue}\t\t${transposition.pKeyChordTransPos1[transposition.nOneTranspositionValue + 11].strKeyChord}\t\t$strMeterKey'
                  : '0',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontWeight: transposition.nOneTranspositionValue == 0 ? FontWeight.normal : FontWeight.bold,
                  fontSize: bIsTablet == true
                      ? orientation == Orientation.portrait ? size.width * 0.03 : size.height * 0.03
                      : orientation == Orientation.portrait ? size.width * 0.04 : size.height * 0.04,
                  color: Colors.black,
                ),
              ),
            ),
          );
          ///SJW Modify 2022-06-02 End...1

        }else if(nDanIndex == 2){ //2단
          ///SJW Modify 2022-06-02 Start...2
          ///GUI 적용
          // return Text(
          //   ///SJW Modify 2022.04.29 Start...2  [이조 값] [키 값] [조표]로 출력하도록 변경
          //   context.read<TranspositionProvider>().bIsDrum == true ? '0' :
          //   '${transposition.nTwoTranspositionValue}\t${transposition.pKeyChordTransPos[transposition.nTwoTranspositionValue + 11].strKeyChord}\t$strMeterKey',
          //   ///SJW Modify 2022.04.29 End...2
          //   style: TextStyle(
          //     ///SJW Modify 2022.04.19 Start...2 값에 따른 fontWeight 변경
          //     //fontWeight: FontWeight.bold,
          //     fontWeight: transposition.nTwoTranspositionValue == 0 ? FontWeight.normal : FontWeight.bold,
          //     ///SJW Modify 2022.04.19 End...2
          //     color: Colors.black,
          //     fontSize: bIsTablet == true ? 22: 16,
          //   ),
          // );
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/transposition_container.png'),
              ),
            ),
            child: Text(
              context.read<TranspositionProvider>().bTwoIsDrum == false && nDanIndex == 2
                  ? '${transposition.nTwoTranspositionValue > -1 ? '+' : ''}${transposition.nTwoTranspositionValue}\t\t${transposition.pKeyChordTransPos2[transposition.nTwoTranspositionValue + 11].strKeyChord}\t\t$strMeterKey'
                  : '0',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontWeight: transposition.nTwoTranspositionValue == 0 ? FontWeight.normal : FontWeight.bold,
                  fontSize: bIsTablet == true
                      ? orientation == Orientation.portrait ? size.width * 0.03 : size.height * 0.03
                      : orientation == Orientation.portrait ? size.width * 0.04 : size.height * 0.04,
                  color: Colors.black,
                ),
              ),
            ),
          );
          ///SJW Modify 2022-06-02 End...2
        }else{  //3단
          ///SJW Modify 2022-06-02 Start...3
          ///GUI 적용
          // return Text(
          //   ///SJW Modify 2022.04.29 Start...3  [이조 값] [키 값] [조표]로 출력하도록 변경
          //   '${transposition.nThreeTranspositionValue}\t${transposition.pKeyChordTransPos[transposition.nThreeTranspositionValue + 11].strKeyChord}\t$strMeterKey',
          //   ///SJW Modify 2022.04.29 End...3
          //   style: TextStyle(
          //     ///SJW Modify 2022.04.19 Start...3 값에 따른 fontWeight 변경
          //     //fontWeight: FontWeight.bold,
          //     fontWeight: transposition.nThreeTranspositionValue == 0 ? FontWeight.normal : FontWeight.bold,
          //     ///SJW Modify 2022.04.19 End...3
          //     color: Colors.black,
          //     fontSize: bIsTablet == true ? 22: 16,
          //   ),
          // );
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/transposition_container.png'),
              ),
            ),
            child: Text(
              context.read<TranspositionProvider>().bThreeIsDrum == false && nDanIndex == 3
                  ? '${transposition.nThreeTranspositionValue > -1 ? '+' : ''}${transposition.nThreeTranspositionValue}\t\t${transposition.pKeyChordTransPos3[transposition.nThreeTranspositionValue + 11].strKeyChord}\t\t$strMeterKey'
                  : '0',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontWeight: transposition.nThreeTranspositionValue == 0 ? FontWeight.normal : FontWeight.bold,
                  fontSize: bIsTablet == true
                      ? orientation == Orientation.portrait ? size.width * 0.03 : size.height * 0.03
                      : orientation == Orientation.portrait ? size.width * 0.04 : size.height * 0.04,
                  color: Colors.black,
                ),
              ),
            ),
          );
          ///SJW Modify 2022-06-02 End...3
        }
      },
    );
  }
//==============================================================================

//==============================================================================

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    // print('DanIndex : $nDanIndex');

    return Expanded(
      flex: 2,
      child: Container(
        width: _size.width,
        height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
        alignment: Alignment.center,
        child: _displayTranspositionValue(context, _size),
      ),
    );
  }
}
