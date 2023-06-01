
import 'package:elfscoreprint_mobile/src/providers/score_size_provider.dart';
import 'package:elfscoreprint_mobile/src/screens/settings/socre_size/socre_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:flutter/services.dart';

import '../../../models/http/http_communicate.dart';
import '../../../providers/commandments_type_provider.dart';
import '../../../providers/dan_settings_provider.dart';
import '../../../providers/display_code_provider.dart';
import '../../../providers/display_lyrics_provider.dart';
import '../../../providers/ensemble_code_provider.dart';
import '../../../providers/keynote_assistant_provider.dart';
import '../../../providers/lyrics_commandments_provider.dart';
import '../../../providers/lyrics_type_provider.dart';
import '../../../providers/print_type_provider.dart';
import '../../../providers/transposition_code_fixed_provider.dart';
import '../../../providers/transposition_provider.dart';
import '../../settings/commandments_type/commandments_type.dart';
import '../../settings/display_code/display_code.dart';
import '../../settings/display_lyrics/display_lyrics.dart';
import '../../settings/ensemble_code/ensemble_code.dart';
import '../../settings/keynote_assistant/keynote_assistant.dart';
import '../../settings/lyrics_commandments/lyrics_commadments.dart';
import '../../settings/lyrics_type/lyrics_type.dart';
import '../../settings/print_type/print_type.dart';
import '../../settings/transposition_and_octave/phone_transposition_octave_setting.dart';
import '../../settings/transposition_code_fixed/transposition_code_Fixed.dart';

class PhoneSettingsDialog extends StatefulWidget {
  final Orientation? orientation;
  final bool? bIsTablet;
  HttpCommunicate? httpCommunicate;

  PhoneSettingsDialog({this.orientation, this.bIsTablet, this.httpCommunicate});

  @override
  _PhoneSettingsDialogState createState() => _PhoneSettingsDialogState();
}

class _PhoneSettingsDialogState extends State<PhoneSettingsDialog> {

  ///scorllbar controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.orientation! == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
    }

    if(widget.orientation! == Orientation.landscape){
      ///가로모드 고정
      //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PhoneSettingsDialog oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
   SystemChrome.setPreferredOrientations([]);
    _scrollController.dispose();
    super.dispose();
  }

  ///악보설정 텍스트
  Widget _displaySettingsText(Size size){
    return Container(
      width: size.width,
      height: widget.orientation == Orientation.portrait ?
          size.height * 0.03 : size.width * 0.03,

      alignment: Alignment.center,
      ///SJW Modify 2022.04.19 Start...1 아이콘 추가
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[

          // Icon(Icons.menu_book_outlined, color: Colors.black,),
          //
          // Text(
          //   '악보설정',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //     fontSize: widget.bIsTablet! ? 24 : 16,
          //   ),
          // ),
       // ],
     // ),
      ///SJW Modify 2022.04.19 End...1
      child: Transform.scale(
        scale: 0.8,
        child: Image(
        image: AssetImage('assets/images/score_settings_img.png'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    //디바이스 크기 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    return SafeArea(
      ///SJW Modify 2023.02.09 Start...
      ///BottomSheet 상단 라운드  처리
      child: widget.orientation == Orientation.portrait ? Container(
        height: _size.height * 0.06 * context.read<DanSettingsProvider>().nSettingsCount + _size.height * 0.03,
        // color: Color(0xffffffff),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
        child: Column(
          children: <Widget>[

            widget.orientation == Orientation.portrait ?
            Container(height: _size.height * 0.03) : SizedBox(),
            //악보 설정 텍스트
            // _displaySettingsText(_size),

            // Container(
            //   alignment: Alignment.center,
            //   child: Image(
            //     image: AssetImage('assets/images/divider.png'),
            //   ),
            // ),

            Container(
              color: Colors.white,
              width: _size.width,
              height: _size.height * 0.06 * context.read<DanSettingsProvider>().nSettingsCount,
              child: Platform.isAndroid ?
              Scrollbar(
                controller: _scrollController,
                radius: Radius.circular(10.0),
                // isAlwaysShown: true,
                hoverThickness: 5.0,
                // thickness: 10.0,
                child: ListView(
                  children: <Widget>[

                    //Divider(thickness: 2.0,),


                    //공백
                    SizedBox(height: _size.height * 0.01,),

                    //옥타브 & 이조 설정 UI
                    for(int nDanIndex=0; nDanIndex<context.read<DanSettingsProvider>().nDan; nDanIndex++)
                      context.read<TranspositionProvider>().bIsTransposition == true ?
                      PhoneTranspositionOctaveSetting(orientation: widget.orientation!, nDanIndex: nDanIndex+1, httpCommunicate: widget.httpCommunicate!, bIsTablet: widget.bIsTablet!) :
                      SizedBox(),

                    //조표 인식 도우미 UI
                    context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant == true ?
                    KeynoteAssistant(orientation: widget.orientation!, bTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //이조시 코드 고정 UI
                    context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed == true ?
                    TranspositionCodeFixed(orientation: widget.orientation!, bIsTablet: widget.bIsTablet, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //코드 표시 UI
                    context.read<DisplayCodeProvider>().bIsDisplayCode == true ?
                    DisplayCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //가사 표시 UI
                    context.read<DisplayLyricsProvider>().bIsDisplayLyrics == true ?
                    DisplayLyrics(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //가사 종류 UI
                    context.read<LyricsTypeProvider>().bIsLyricsType == true ?
                    LyricsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

                    //가사/계명 UI
                    context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments == true ?
                    LyricsCommandments(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

                    //계명 종류
                    context.read<CommandmentsTypeProvider>().bIsCommandmentsType == true ?
                    CommandmentsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //악보 사이즈 UI
                    context.read<ScoreSizeProvider>().bIsScoreSize == true ?
                    ScoreSize(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //합주코드 UI
                    context.read<EnsembleCodeProvider>().bIsEnsembleCode == true ?
                    EnsembleCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

                    //출력 선택 UI
                    context.read<PrintTypeProvider>().bIsPrintType == true ?
                    PrintType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

                  ],
                ),
              )
                  :
              CupertinoScrollbar(
                controller: _scrollController,
                radius: Radius.circular(10.0),
                isAlwaysShown: true,
                thickness: 10.0,
                child: ListView(
                  children: <Widget>[

                    //악보 설정 텍스트
                    // _displaySettingsText(_size),

                    //공백
                    SizedBox(height: _size.height * 0.01,),

                    //옥타브 & 이조 설정 UI
                    for(int nDanIndex=0; nDanIndex<context.read<DanSettingsProvider>().nDan; nDanIndex++)
                      context.read<TranspositionProvider>().bIsTransposition == true ?
                      PhoneTranspositionOctaveSetting(orientation: widget.orientation!, nDanIndex: nDanIndex+1, httpCommunicate: widget.httpCommunicate!, bIsTablet: widget.bIsTablet!) :
                      SizedBox(),

                    //조표 인식 도우미 UI
                    context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant == true ?
                    KeynoteAssistant(orientation: widget.orientation!, bTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //이조시 코드 고정 UI
                    context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed == true ?
                    TranspositionCodeFixed(orientation: widget.orientation!, bIsTablet: widget.bIsTablet, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //코드 표시 UI
                    context.read<DisplayCodeProvider>().bIsDisplayCode == true ?
                    DisplayCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //가사 표시 UI
                    context.read<DisplayLyricsProvider>().bIsDisplayLyrics == true ?
                    DisplayLyrics(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //가사 종류 UI
                    context.read<LyricsTypeProvider>().bIsLyricsType == true ?
                    LyricsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //가사/계명 UI
                    context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments == true ?
                    LyricsCommandments(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //계명 종류 UI
                    context.read<CommandmentsTypeProvider>().bIsCommandmentsType == true ?
                    CommandmentsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //악보 사이즈 UI
                    context.read<ScoreSizeProvider>().bIsScoreSize == true ?
                    ScoreSize(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //합주코드 UI
                    context.read<EnsembleCodeProvider>().bIsEnsembleCode == true ?
                    EnsembleCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                    //출력 선택 UI
                    context.read<PrintTypeProvider>().bIsPrintType == true ?
                    PrintType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

                  ],
                ),
              ),
            ),

          ],
        ),
      )
      :  Container(
        width: _size.width,
        height: _size.height * 0.06 * context.read<DanSettingsProvider>().nSettingsCount,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Platform.isAndroid ?
        Scrollbar(
          controller: _scrollController,
          radius: Radius.circular(10.0),
          // isAlwaysShown: true,
          hoverThickness: 5.0,
          // thickness: 10.0,
          child: ListView(
            children: <Widget>[

              //Divider(thickness: 2.0,),


              //공백
              SizedBox(height: _size.height * 0.01,),

              //옥타브 & 이조 설정 UI
              for(int nDanIndex=0; nDanIndex<context.read<DanSettingsProvider>().nDan; nDanIndex++)
                context.read<TranspositionProvider>().bIsTransposition == true ?
                PhoneTranspositionOctaveSetting(orientation: widget.orientation!, nDanIndex: nDanIndex+1, httpCommunicate: widget.httpCommunicate!, bIsTablet: widget.bIsTablet!) :
                SizedBox(),

              //조표 인식 도우미 UI
              context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant == true ?
              KeynoteAssistant(orientation: widget.orientation!, bTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //이조시 코드 고정 UI
              context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed == true ?
              TranspositionCodeFixed(orientation: widget.orientation!, bIsTablet: widget.bIsTablet, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //코드 표시 UI
              context.read<DisplayCodeProvider>().bIsDisplayCode == true ?
              DisplayCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //가사 표시 UI
              context.read<DisplayLyricsProvider>().bIsDisplayLyrics == true ?
              DisplayLyrics(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //가사 종류 UI
              context.read<LyricsTypeProvider>().bIsLyricsType == true ?
              LyricsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

              //가사/계명 UI
              context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments == true ?
              LyricsCommandments(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

              //계명 종류
              context.read<CommandmentsTypeProvider>().bIsCommandmentsType == true ?
              CommandmentsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //악보 사이즈 UI
              context.read<ScoreSizeProvider>().bIsScoreSize == true ?
              ScoreSize(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //합주코드 UI
              context.read<EnsembleCodeProvider>().bIsEnsembleCode == true ?
              EnsembleCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

              //출력 선택 UI
              context.read<PrintTypeProvider>().bIsPrintType == true ?
              PrintType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!) : SizedBox(),

            ],
          ),
        )
            :
        CupertinoScrollbar(
          controller: _scrollController,
          radius: Radius.circular(10.0),
          isAlwaysShown: true,
          thickness: 10.0,
          child: ListView(
            children: <Widget>[

              //악보 설정 텍스트
              // _displaySettingsText(_size),

              //공백
              SizedBox(height: _size.height * 0.01,),

              //옥타브 & 이조 설정 UI
              for(int nDanIndex=0; nDanIndex<context.read<DanSettingsProvider>().nDan; nDanIndex++)
                context.read<TranspositionProvider>().bIsTransposition == true ?
                PhoneTranspositionOctaveSetting(orientation: widget.orientation!, nDanIndex: nDanIndex+1, httpCommunicate: widget.httpCommunicate!, bIsTablet: widget.bIsTablet!) :
                SizedBox(),

              //조표 인식 도우미 UI
              context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant == true ?
              KeynoteAssistant(orientation: widget.orientation!, bTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //이조시 코드 고정 UI
              context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed == true ?
              TranspositionCodeFixed(orientation: widget.orientation!, bIsTablet: widget.bIsTablet, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //코드 표시 UI
              context.read<DisplayCodeProvider>().bIsDisplayCode == true ?
              DisplayCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //가사 표시 UI
              context.read<DisplayLyricsProvider>().bIsDisplayLyrics == true ?
              DisplayLyrics(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //가사 종류 UI
              context.read<LyricsTypeProvider>().bIsLyricsType == true ?
              LyricsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //가사/계명 UI
              context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments == true ?
              LyricsCommandments(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //계명 종류 UI
              context.read<CommandmentsTypeProvider>().bIsCommandmentsType == true ?
              CommandmentsType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //악보 사이즈 UI
              context.read<ScoreSizeProvider>().bIsScoreSize == true ?
              ScoreSize(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //합주코드 UI
              context.read<EnsembleCodeProvider>().bIsEnsembleCode == true ?
              EnsembleCode(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

              //출력 선택 UI
              context.read<PrintTypeProvider>().bIsPrintType == true ?
              PrintType(orientation: widget.orientation!, bIsTablet: widget.bIsTablet!, httpCommunicate: widget.httpCommunicate!,) : SizedBox(),

            ],
          ),
        ),
      ),
      ///SJW Modify 2023.02.09 End...
    );
  }
}
