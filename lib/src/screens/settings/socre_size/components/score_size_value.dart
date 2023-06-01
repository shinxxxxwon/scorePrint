import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../providers/score_size_provider.dart';

class ScoreSizeValue extends StatelessWidget {
  final Orientation? orientation;
  final bool? bIsTablet;

  ScoreSizeValue({this.orientation, this.bIsTablet});

  Widget _showScoreSizeValue(Size size){
    return Consumer<ScoreSizeProvider>(
      builder: (context, scoreSize, child){
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/transposition_container.png'),
            ),
          ),
          child: Text(
            scoreSize.nScoreSizeValue == 0
                ? '기본'
                : '${scoreSize.nScoreSizeValue > 0 ? "+" : ""} ${scoreSize.nScoreSizeValue}',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: scoreSize.nScoreSizeValue == 0 ? FontWeight.normal : FontWeight.bold,
                fontSize: bIsTablet == true
                  ? orientation == Orientation.portrait ? size.width * 0.03 : size.height * 0.03
                  : orientation == Orientation.portrait ? size.width * 0.04 : size.height * 0.04
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return Expanded(
      flex: 2,
      child: Container(
        width: _size.width,
        height: orientation == Orientation.portrait ? _size.height * 0.05 : _size.width * 0.05,
        alignment: Alignment.center,
        child: _showScoreSizeValue(_size),
      ),
    );
  }
}
