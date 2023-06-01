
import 'package:elfscoreprint_mobile/src/models/http/http_communicate.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/score_image_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/method_channel/bridge_native.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../models/data/score_data.dart';
import '../../models/data/user_data.dart';
import '../../providers/commandments_type_provider.dart';
import '../../providers/dan_settings_provider.dart';
import '../../providers/display_code_provider.dart';
import '../../providers/display_lyrics_provider.dart';
import '../../providers/ensemble_code_provider.dart';
import '../../providers/keynote_assistant_provider.dart';
import '../../providers/lyrics_commandments_provider.dart';
import '../../providers/lyrics_type_provider.dart';
import '../../providers/octave_provider.dart';
import '../../providers/print_type_provider.dart';
import '../../providers/score_data_provider.dart';
import '../../providers/score_size_provider.dart';
import '../../providers/transposition_code_fixed_provider.dart';
import '../../providers/transposition_provider.dart';
import 'score_tables.dart';
import 'dart:io';

class ScoreInfoController{

  ScoreInfoController();

  void setScoreSettingOption(BuildContext context, UserData userData, HttpCommunicate httpCommunicate){

    // print('setScoreSettingOPtion');

    //1단 이조
    context.read<TranspositionProvider>().setTransposition(1, userData.nKeyTrans1!);
    //1단 옥타브
    context.read<OctaveProvider>().setOctave(1, userData.nOctave1! == -1 ? 0 : (userData.nOctave1! - 1) * -1);
    //2단 이조
    // context.read<TranspositionProvider>().setTransposition(2, int.parse(httpCommunicate.strscPrintScoreTransPos2!));
    context.read<TranspositionProvider>().setTransposition(2, userData.nKeyTrans2!);
    //2단 옥타브
    context.read<OctaveProvider>().setOctave(2, userData.nOctave2! == -1 ? 0 : (userData.nOctave2! - 1) * -1);
    //3단 이조
    // context.read<TranspositionProvider>().setTransposition(3, int.parse(httpCommunicate.strscPrintScoreTransPos3!));
    context.read<TranspositionProvider>().setTransposition(3, userData.nKeyTrans3!);
    //3단 옥타브
    context.read<OctaveProvider>().setOctave(3, userData.nOctave3! == -1 ? 0 : (userData.nOctave3! - 1) * -1);

    //조표인식 도우미
    context.read<KeynoteAssistantProvider>().setKeynoteAssistantValue(userData.nChordHelp!);
    //이조시 코드고정
    context.read<TranspositionCodeFixedProvider>().setTranspositionCodeFixedValue(userData.nChordFix!);
    //코드 표시
    context.read<DisplayCodeProvider>().setDisplayCodeValue(userData.nChordSize!);
    //가사 표시
    context.read<DisplayLyricsProvider>().setDisplayLyricsValue(userData.nLyricsSize!);
    //가사 종류
    context.read<LyricsTypeProvider>().setLyricsTypeValue(userData.nLyricsType!);
    //가사/계명
    context.read<LyricsCommandmentsProvider>().setLyricsCommandmentsValue(userData.nLyricsToneName!);
    //계명 종류
    context.read<CommandmentsTypeProvider>().setCommandmentsTypeValue(userData.nToneNameType!);
    //합주 코드
    context.read<EnsembleCodeProvider>().setEnsembleCode(userData.nSetHapJooChord!);
    ///악보 사이즈 (아직 적용 안됨)
    context.read<ScoreSizeProvider>().setScoreSize(userData.nScoreSize!);
  }

  ///악보별 설정 가능 값 유무 체크
  void initScoreSettingOption(BuildContext context, int nFileDataType, HttpCommunicate httpCommunicate, int nScoreType, bool bIsPreviewScore, String strMainKey){
    context.read<TranspositionProvider>().bOneIsDrum = false;
    context.read<TranspositionProvider>().bTwoIsDrum = false;
    context.read<TranspositionProvider>().bThreeIsDrum = false;
    switch(nFileDataType){
    ///C02 File
      case 0:
        switch(nScoreType){
          case 0:   ///기본
          case 2:   ///색소폰
          case 3:   ///기타
          case 4:   ///복음성가
            context.read<DanSettingsProvider>().nDan = 1;   ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = true;          ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = true;              ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;

            // bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false;                          ///1이면 미리보기 모드, 0이면 인쇄모드
            // context.read<PrintTypeProvider>().bIsPrintType = true;
            context.read<DanSettingsProvider>().nSettingsCount = 9;
            break;

          case 15:    ///하모니카
            context.read<DanSettingsProvider>().nDan = 1;   ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = false;         ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = false;             ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            // bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false;                           ///1이면 미리보기 모드, 0이면 인쇄모드
            // context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 8;
            break;

          case 16:   ///숫자보
            context.read<DanSettingsProvider>().nDan = 1;    ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = false;             ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = false;         ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = false;             ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            // bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false;                           ///1이면 미리보기 모드, 0이면 인쇄모드
            // context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 7;
            break;

          case 1:   ///강사용
            context.read<DanSettingsProvider>().nDan = 1;    ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = false;                   ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = false;                                 ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = false; ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = false;                   ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = false;         ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = false;             ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = false;                     ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            // bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false;                           ///1이면 미리보기 모드, 0이면 인쇄모드
            // context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 5;
            break;
        }
        break;

    ///C01 File
      case 1:
        switch(nScoreType){
          case 40:
          case 41:
          case 42:
          case 43:
          case 44:
          context.read<DanSettingsProvider>().nDan = 0;    ///이미지 또는 PDF이므로 단이 없음

          context.read<TranspositionProvider>().bIsTransposition = false;                    ///이조 설정 가능
          context.read<OctaveProvider>().bIsOctave = false;                                  ///옥타브 설정 가능
          context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = false;             ///조표 인식 도우미 설정 가능
          context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = false;  ///이조시 코드 고정 설정 가능
          context.read<DisplayCodeProvider>().bIsDisplayCode = false;                        ///코드표시 설정 가능
          context.read<DisplayLyricsProvider>().bIsDisplayLyrics = false;                    ///가사표시 설정 가능
          context.read<LyricsTypeProvider>().bIsLyricsType = false;                          ///가사종류 설정 가능
          context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = false;         ///가사/계명 설정 가능
          context.read<CommandmentsTypeProvider>().bIsCommandmentsType = false;             ///계명종류 설정 가능
          context.read<EnsembleCodeProvider>().bIsEnsembleCode = false;                      ///합주코드 설정 가능
          context.read<ScoreSizeProvider>().bIsScoreSize = false;                            ///악보크기 설정 가능

          context.read<PrintTypeProvider>().bIsPrintType = false;                          ///1이면 미리보기 모드, 0이면 인쇄모드

          context.read<DanSettingsProvider>().nSettingsCount = 0;
          break;
        }
        break;

      ///ACT
      case 2:
        context.read<DanSettingsProvider>().nDan = 1;
        context.read<TranspositionProvider>().bOneIsDrum = false;

        context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
        context.read<OctaveProvider>().bIsOctave = false;                                 ///옥타브 설정 가능
        context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = false;             ///조표 인식 도우미 설정 가능
        context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = false; ///이조시 코드 고정 설정 가능
        context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
        context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
        context.read<LyricsTypeProvider>().bIsLyricsType = false;                         ///가사종류 설정 가능
        context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = false;         ///가사/계명 설정 가능
        context.read<CommandmentsTypeProvider>().bIsCommandmentsType = false;             ///계명종류 설정 가능
        context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
        context.read<ScoreSizeProvider>().bIsScoreSize = false;

        // bIsPreviewScore == true ?
        // context.read<PrintTypeProvider>().bIsPrintType = false;                           ///1이면 미리보기 모드, 0이면 인쇄모드
        // context.read<PrintTypeProvider>().bIsPrintType = true;
        context.read<DanSettingsProvider>().nSettingsCount = 5;
        break;

        break;

    ///C03 File
      case 3:
        switch(nScoreType){
          case 5:     ///멜로디 + 멜로디
          case 6:     ///멜로디 + 오브리
          case 7:     ///멜로디 + 드럼
          case 8:     ///멜로디 + 베이스기타

         if(nScoreType == 7)
         {
           context.read<TranspositionProvider>().bOneIsDrum = false;
           context.read<TranspositionProvider>().bTwoIsDrum = true;
           context.read<TranspositionProvider>().bThreeIsDrum = false;
         }
            context.read<DanSettingsProvider>().nDan = 2;   ///2단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = true;          ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = true;              ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false :                          ///1이면 미리보기 모드, 0이면 인쇄모드
            context.read<PrintTypeProvider>().bIsPrintType = true;
            context.read<DanSettingsProvider>().nSettingsCount = 8;
            break;

          case 17:    ///드럼
            context.read<DanSettingsProvider>().nDan = 0;    ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = false;                   ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = false;                                 ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = false;             ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = false; ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = false;         ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = false;             ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = false;                     ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능


            context.read<PrintTypeProvider>().bIsPrintType = false;                          ///1이면 미리보기 모드, 0이면 인쇄모드


            context.read<DanSettingsProvider>().nSettingsCount = 5;
            break;

          case 18:    ///베이스기타
            context.read<DanSettingsProvider>().nDan = 1;    ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능

            bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false :                          ///1이면 미리보기 모드, 0이면 인쇄모드
            context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 7;
            break;

          case 19:    ///C03 멜로디
            context.read<DanSettingsProvider>().nDan = 1;    ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = false;         ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = false;             ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = false;                     ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            context.read<PrintTypeProvider>().bIsPrintType = false;                           ///1이면 미리보기 모드, 0이면 인쇄모드


            context.read<DanSettingsProvider>().nSettingsCount = 8;
            break;

          case 20:    ///C03 오브리
            context.read<DanSettingsProvider>().nDan = 1;    ///1단 악보

            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능

            bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false :                          ///1이면 미리보기 모드, 0이면 인쇄모드
            context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 5;
            break;

          case 30:    ///색소폰 3중주
            context.read<DanSettingsProvider>().nDan = 3;    ///3단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = true;          ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = true;              ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false :                          ///1이면 미리보기 모드, 0이면 인쇄모드
            context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 8;
            break;

          case 31:    ///색소폰 3중주_듀엣1
          case 32:    ///색소폰 3중주_듀엣2
          context.read<DanSettingsProvider>().nDan = 2;   ///2단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = true;          ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = true;              ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            bIsPreviewScore == true ?
            context.read<PrintTypeProvider>().bIsPrintType = false :                          ///1이면 미리보기 모드, 0이면 인쇄모드
            context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 8;
            break;

          case 50:    ///피아노 멜로디 + 왼손 + 오른손
            context.read<DanSettingsProvider>().nDan = 2;    ///2단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = true;          ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = true;              ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            // bIsPreviewScore == true ?
            // context.read<PrintTypeProvider>().bIsPrintType = false :                          ///1이면 미리보기 모드, 0이면 인쇄모드
            // context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 8;
            break;

          case 51:    ///피아노 멜로디
          case 52:    ///피아노 왼손 + 오른손
          context.read<DanSettingsProvider>().nDan = 1;    ///1단 악보

            context.read<TranspositionProvider>().bIsTransposition = true;                    ///이조 설정 가능
            context.read<OctaveProvider>().bIsOctave = true;                                  ///옥타브 설정 가능
            context.read<KeynoteAssistantProvider>().bIsKeynoteAssistant = true;              ///조표 인식 도우미 설정 가능
            context.read<TranspositionCodeFixedProvider>().bIsTranspositionCodeFixed = true;  ///이조시 코드 고정 설정 가능
            context.read<DisplayCodeProvider>().bIsDisplayCode = true;                        ///코드표시 설정 가능
            context.read<DisplayLyricsProvider>().bIsDisplayLyrics = true;                    ///가사표시 설정 가능
            context.read<LyricsTypeProvider>().bIsLyricsType = true;                          ///가사종류 설정 가능
            context.read<LyricsCommandmentsProvider>().bIsLyricsCommandments = true;          ///가사/계명 설정 가능
            context.read<CommandmentsTypeProvider>().bIsCommandmentsType = true;              ///계명종류 설정 가능
            context.read<EnsembleCodeProvider>().bIsEnsembleCode = true;                      ///합주코드 설정 가능
            context.read<ScoreSizeProvider>().bIsScoreSize = true;                            ///악보크기 설정 가능

            // bIsPreviewScore == true ?
            // context.read<PrintTypeProvider>().bIsPrintType = false :                          ///1이면 미리보기 모드, 0이면 인쇄모드
            // context.read<PrintTypeProvider>().bIsPrintType = true;

            context.read<DanSettingsProvider>().nSettingsCount = 8;
            break;
        }
        break;
    }
    context.read<TranspositionProvider>().initKeyChordTransPos();

    if(context.read<DanSettingsProvider>().nDan == 1) {
      setKeyChordTransPosList(context, httpCommunicate, strMainKey, 0);
    }
    else if(context.read<DanSettingsProvider>().nDan == 2) {
      setKeyChordTransPosList(context, httpCommunicate, strMainKey, 0);
      setKeyChordTransPosList(context, httpCommunicate, strMainKey, 1);
    }
    else if(context.read<DanSettingsProvider>().nDan == 3) {
      setKeyChordTransPosList(context, httpCommunicate, strMainKey, 0);
      setKeyChordTransPosList(context, httpCommunicate, strMainKey, 1);
      setKeyChordTransPosList(context, httpCommunicate, strMainKey, 2);
    }

    if(isApplayTrioSong(httpCommunicate)) {
      context.read<TranspositionProvider>().setTransPosString(context, httpCommunicate);
      setKeyChordTransPosList(context, httpCommunicate, context.read<TranspositionProvider>().realKeyChordTransPost1[11].strKeyChord!, 0);
      setKeyChordTransPosList(context, httpCommunicate, context.read<TranspositionProvider>().realKeyChordTransPost2[11].strKeyChord!, 1);
      setKeyChordTransPosList(context, httpCommunicate, context.read<TranspositionProvider>().realKeyChordTransPost3[11].strKeyChord!, 2);
    }
  }

  //==============================================================================
  bool isApplayTrioSong(HttpCommunicate httpCommunicate){
    bool bIsApplyTrioSong = false;
    int SCORE_TYPE_SAXOPHONE_TRIO = 30;   ///색소폰 3중주
    int SCORE_TYPE_SAXOPHONE_DUET_1 = 31; ///색소폰 3중주
    int SCORE_TYPE_SAXOPHONE_DUET_2 = 32; ///색소폰 3중주
    int SCORE_TYPE_SAXOPHONE_SOLO_1 = 35; ///색소폰 1단 first
    int SCORE_TYPE_SAXOPHONE_SOLO_2 = 36; ///색소폰 1단 second
    int SCORE_TYPE_SAXOPHONE_SOLO_3 = 37; ///색소폰 1단 third

    if( SCORE_TYPE_SAXOPHONE_TRIO == httpCommunicate.nScoreType) {
      bIsApplyTrioSong = true;
    }
    else if( SCORE_TYPE_SAXOPHONE_DUET_1 == httpCommunicate.nScoreType) {
      bIsApplyTrioSong = true;
    }
    else if( SCORE_TYPE_SAXOPHONE_DUET_2 == httpCommunicate.nScoreType) {
      bIsApplyTrioSong = true;
    }
    else if( SCORE_TYPE_SAXOPHONE_SOLO_1 == httpCommunicate.nScoreType) {
      bIsApplyTrioSong = true;
    }
    else if( SCORE_TYPE_SAXOPHONE_SOLO_2 == httpCommunicate.nScoreType) {
      bIsApplyTrioSong = true;
    }
    else if( SCORE_TYPE_SAXOPHONE_SOLO_3 == httpCommunicate.nScoreType) {
      bIsApplyTrioSong = true;
    }

    return bIsApplyTrioSong;
  }
  ///이조 값 계산
  Future<void> setKeyChordTransPosList(BuildContext context, HttpCommunicate httpCommunicate, String strKey, int nOption) async {

    ScoreTables scoreTables = ScoreTables();

    bool bIsMinor = false;
    int nRow = 0;
    int nMeterKey = 0;
    int nKeyChordPos = 0;
    String strManKey = "";
    String strWomanKey = "";

    String strMainKey = strKey;

    if (strMainKey.length > 0) {
      nRow = strMainKey.contains("m") ? 1 : 0;
      bIsMinor = strMainKey[strMainKey.length - 1] == 'm' ? true : false;

      int nTrioTrans = 0;


      if(isApplayTrioSong(httpCommunicate)){
        // print('trioSong');
        nKeyChordPos = findKeyChordPosition(strMainKey, bIsMinor) - 3;
        nMeterKey = findMeterKeyPosition(strMainKey, bIsMinor, nMeterKey);
      }
    }
    else {
      nRow = 0;
      bIsMinor = false;
      strMainKey = "C";
    }



    if(nOption == 0) {
      nKeyChordPos = findKeyChordPosition(strMainKey, bIsMinor);
      nMeterKey = findMeterKeyPosition(strMainKey, bIsMinor, nMeterKey);

      context.read<TranspositionProvider>().pKeyChordTransPos1[11] = KeyChordTransPos(0, nMeterKey, strMainKey);
      if (nKeyChordPos >= 12) {
        nKeyChordPos = findSpecialChordPosition(strMainKey, bIsMinor);
        nMeterKey = findSpecialMeterKeyPosition(strMainKey, bIsMinor, nMeterKey);
        context.read<TranspositionProvider>().pKeyChordTransPos1[11] = KeyChordTransPos(0, nMeterKey, strMainKey);
      }

      for (int nIndex = 12, nTransPos = 1, nCount = nKeyChordPos + 1; nIndex < 23; nIndex++) {
        if (nCount >= 12) nCount = 0;

        context.read<TranspositionProvider>().pKeyChordTransPos1[nIndex] = KeyChordTransPos(nTransPos++, scoreTables.strSharpFlatSuTable[nRow][nCount], scoreTables.strMeterKeyChordTable[nRow][nCount++]);
      }

      for (int nIndex = 10, nTransPos = -1, nCount = nKeyChordPos - 1; nIndex >= 0; nIndex--) {
        if (nCount < 0) nCount = 11;

        context.read<TranspositionProvider>().pKeyChordTransPos1[nIndex] = KeyChordTransPos(nTransPos--, scoreTables.strSharpFlatSuTable[nRow][nCount], scoreTables.strMeterKeyChordTable[nRow][nCount--]);
      }
    }

    if(nOption == 1) {
      nKeyChordPos = findKeyChordPosition(strMainKey, bIsMinor);
      nMeterKey = findMeterKeyPosition(strMainKey, bIsMinor, nMeterKey);
      context.read<TranspositionProvider>().pKeyChordTransPos2[11] = KeyChordTransPos(0, nMeterKey, strMainKey);
      if (nKeyChordPos >= 12) {
        nKeyChordPos = findSpecialChordPosition(strMainKey, bIsMinor);
        nMeterKey = findSpecialMeterKeyPosition(strMainKey, bIsMinor, nMeterKey);
        context.read<TranspositionProvider>().pKeyChordTransPos2[11] = KeyChordTransPos(0, nMeterKey, strMainKey);
      }

      for (int nIndex = 12, nTransPos = 1, nCount = nKeyChordPos + 1; nIndex <
          23; nIndex++) {
        if (nCount > 11) nCount = 0;

        context.read<TranspositionProvider>().pKeyChordTransPos2[nIndex] = KeyChordTransPos(nTransPos++, scoreTables.strSharpFlatSuTable[nRow][nCount], scoreTables.strMeterKeyChordTable[nRow][nCount++]);
      }

      for (int nIndex = 10, nTransPos = -1, nCount = nKeyChordPos - 1; nIndex >=
          0; nIndex--) {
        if (nCount < 0) nCount = 11;

        context.read<TranspositionProvider>().pKeyChordTransPos2[nIndex] = KeyChordTransPos(nTransPos--, scoreTables.strSharpFlatSuTable[nRow][nCount], scoreTables.strMeterKeyChordTable[nRow][nCount--]);
      }
    }

    if(nOption == 2) {
      nKeyChordPos = findKeyChordPosition(strMainKey, bIsMinor);
      nMeterKey = findMeterKeyPosition(strMainKey, bIsMinor, nMeterKey);
      context.read<TranspositionProvider>().pKeyChordTransPos3[11] = KeyChordTransPos(0, nMeterKey, strMainKey);
      if (nKeyChordPos >= 12) {
        nKeyChordPos = findSpecialChordPosition(strMainKey, bIsMinor);
        nMeterKey = findSpecialMeterKeyPosition(strMainKey, bIsMinor, nMeterKey);
        context.read<TranspositionProvider>().pKeyChordTransPos3[11] = KeyChordTransPos(0, nMeterKey, strMainKey);
      }

      for (int nIndex = 12, nTransPos = 1, nCount = nKeyChordPos + 1; nIndex <
          23; nIndex++) {
        if (nCount > 11) nCount = 0;

        context.read<TranspositionProvider>().pKeyChordTransPos3[nIndex] = KeyChordTransPos(nTransPos++, scoreTables.strSharpFlatSuTable[nRow][nCount], scoreTables.strMeterKeyChordTable[nRow][nCount++]);
      }

      for (int nIndex = 10, nTransPos = -1, nCount = nKeyChordPos - 1; nIndex >=
          0; nIndex--) {
        if (nCount < 0) nCount = 11;

        context.read<TranspositionProvider>().pKeyChordTransPos3[nIndex] = KeyChordTransPos(nTransPos--, scoreTables.strSharpFlatSuTable[nRow][nCount], scoreTables.strMeterKeyChordTable[nRow][nCount--]);
      }

    }
    ///SJW Modify 2022.04.29 End...1
    if (httpCommunicate.strManKey!.isNotEmpty) {
      strMainKey = httpCommunicate.strManKey!;
      setManWomanKeyChord(context, strMainKey, bIsMinor, nOption);
    }

    if (httpCommunicate.strWomanKey!.isNotEmpty) {
      strWomanKey = httpCommunicate.strWomanKey!;
      setManWomanKeyChord(context, strWomanKey, bIsMinor, nOption);
    }

  }

//==============================================================================

  void setManWomanKeyChord(BuildContext context, String strKeyChord, bool bIsMinor, int nOption){
    int nkeyChordPos = 0;
    int nMeterKey = 0;
    ScoreTables scoreTables = ScoreTables();

    nkeyChordPos = findKeyChordPosition(strKeyChord, bIsMinor);
    nMeterKey = findMeterKeyPosition(strKeyChord, bIsMinor, nMeterKey);
    
    if(nkeyChordPos >= 12){
      nkeyChordPos = findSpecialChordPosition(strKeyChord, bIsMinor);
      nMeterKey = findSpecialMeterKeyPosition(strKeyChord, bIsMinor, nMeterKey);

      for(int i=0; i<23; i++) {
        if (nOption == 0) {
          if (context.read<TranspositionProvider>().pKeyChordTransPos1[i].strKeyChord == scoreTables.strMeterKeyChordTable[(bIsMinor ? 1 : 0)][nkeyChordPos]) {
            context.read<TranspositionProvider>().pKeyChordTransPos1[i].nMeterKey = nMeterKey;
            context.read<TranspositionProvider>().pKeyChordTransPos1[i].strKeyChord = strKeyChord;
          }
        }
        if (nOption == 1) {
          if (context.read<TranspositionProvider>().pKeyChordTransPos2[i].strKeyChord == scoreTables.strMeterKeyChordTable[(bIsMinor ? 1 : 0)][nkeyChordPos]) {
            context.read<TranspositionProvider>().pKeyChordTransPos2[i].nMeterKey = nMeterKey;
            context.read<TranspositionProvider>().pKeyChordTransPos2[i].strKeyChord = strKeyChord;
          }
        }
        if (nOption == 2) {
          if (context.read<TranspositionProvider>().pKeyChordTransPos3[i].strKeyChord == scoreTables.strMeterKeyChordTable[(bIsMinor ? 1 : 0)][nkeyChordPos]) {
            context.read<TranspositionProvider>().pKeyChordTransPos3[i].nMeterKey = nMeterKey;
            context.read<TranspositionProvider>().pKeyChordTransPos3[i].strKeyChord = strKeyChord;
          }
        }
      }
    }
    return;
  }

//==============================================================================
  int findKeyChordPosition(String strKeyChord, bool bIsMinor) {
    ScoreTables scoreTables = ScoreTables();

    int nKeyChordPos = 0;
    int nRow = bIsMinor ? 1 : 0;

    for (nKeyChordPos = 0; nKeyChordPos < 12; nKeyChordPos++) {
      if (strKeyChord == scoreTables.strMeterKeyChordTable[nRow][nKeyChordPos])
        break;
    }

    if (nKeyChordPos >= 12) {
      if (bIsMinor) {
        if (strKeyChord == "D#m") {
          nKeyChordPos = 3;
        }
      }
      else {
        if (strKeyChord == "Gb") {
          nKeyChordPos = 6;
        }
      }
    }

    return nKeyChordPos;
  }

//==============================================================================

//==============================================================================
  int findMeterKeyPosition(String strKeyChord, bool bIsMinor, int nMeterKey) {
    ScoreTables scoreTables = ScoreTables();

    int nKeyChordPos = 0;
    int nRow = bIsMinor ? 1 : 0;
    nMeterKey = 0;

    // print('mainkey : $strKeyChord');
    // print('mainkey2 : ${scoreTables.strMeterKeyChordTable[1][7]}');

    for (nKeyChordPos = 0; nKeyChordPos < 12; nKeyChordPos++) {
      if (strKeyChord == scoreTables.strMeterKeyChordTable[nRow][nKeyChordPos]) {
        nMeterKey = scoreTables.strSharpFlatSuTable[nRow][nKeyChordPos];
        // print('meter Res :: $nMeterKey :: $nRow :: $nKeyChordPos');
        break;
      }
    }

    if (nKeyChordPos >= 12) {
      if (bIsMinor) {
        if (strKeyChord == "D#m") {
          nMeterKey = 6;
        }
      }
      else {
        if (strKeyChord == "Gb") {
          nMeterKey = -6;
        }
      }
    }

    return nMeterKey;
  }

//==============================================================================

//==============================================================================
  int findSpecialChordPosition(String strKeyChord, bool bIsMinor) {
    int nKeyChordPos = 0;

    if (bIsMinor) {
      if (strKeyChord == "Abm")       {nKeyChordPos = 8;} // G#m
      else if (strKeyChord == "A#m")  {nKeyChordPos = 10;}// Bbm
      else                            {nKeyChordPos = findEnharmonicKeyChord(strKeyChord, bIsMinor);}
    }
    else
    {
      if(strKeyChord == "Cb")         {nKeyChordPos = 8;} // B
      else if(strKeyChord == "C#")    {nKeyChordPos = 7;} // Db
      else                            {nKeyChordPos = findEnharmonicKeyChord(strKeyChord, bIsMinor);}
    }

    return nKeyChordPos;
  }

//==============================================================================

//==============================================================================
  int findSpecialMeterKeyPosition(String strKeyChord, bool bIsMinor,
      int nMeterKey) {
    if (bIsMinor) {
      if (strKeyChord == "Abm")       {nMeterKey = -7;}
      else if (strKeyChord == "A#m")  {nMeterKey = 7;}
      else                            {nMeterKey = findEnharmonicMeterKeyChord(strKeyChord, bIsMinor, nMeterKey);}
    }
    else
    {
      if(strKeyChord == "Cb")         {nMeterKey = -7;} // B
      else if(strKeyChord == "C#")    {nMeterKey = 7;} // Db
      else                            {nMeterKey = findEnharmonicMeterKeyChord(strKeyChord, bIsMinor, nMeterKey);}
    }

    return nMeterKey;
  }

//==============================================================================

//==============================================================================
  int findEnharmonicKeyChord(String strKeyChord, bool bIsMinor)
  {

    ScoreTables scoreTables = ScoreTables();

    bool bIsFind = false;
    String strFindChord;
    int nKeyChordPos = 0;
    int nRow = 0;
    int nCol = 0;
    int nLength = 0;

    if(bIsMinor)
    {
      strKeyChord.replaceRange(strKeyChord.length - 1, strKeyChord.length - 1, "\0");
    }

    for(nRow=0; nRow<9; nRow++)
    {
      for(nCol=0; nCol<2; nCol++)
      {
        if(scoreTables.strEnharmonicKeyChord[nRow][nCol] == strKeyChord)
        {
          bIsFind =  true;
          break;
        }
      }
      if(bIsFind) break;
    }

    if(bIsFind)
    {
      strFindChord = scoreTables.strEnharmonicKeyChord[nRow][(nCol==1) ? 0 : 1];
      if(bIsMinor)
      {
        nLength = strFindChord.length;
        strFindChord.replaceRange(nLength, nLength, 'm');
      }

      nKeyChordPos = findKeyChordPosition(strFindChord, bIsMinor);
      if(nKeyChordPos >= 12)
      {
        nKeyChordPos = (bIsMinor ? 9 : 0);
      }
    }
    else
    {
      nKeyChordPos = (bIsMinor ? 9 : 0);
    }
    return nKeyChordPos;
  }

//==============================================================================

  int findEnharmonicMeterKeyChord(String strKeyChord, bool bIsMinor, int nMeterKey)
  {

    ScoreTables scoreTables = ScoreTables();

    bool bIsFind = false;
    String strFindChord;
    int nKeyChordPos = 0;
    int nRow = 0;
    int nCol = 0;
    int nLength = 0;

    nMeterKey = 0;

    if(bIsMinor)
    {
      strKeyChord.replaceRange(strKeyChord.length - 1, strKeyChord.length - 1, "\0");
    }

    for(nRow=0; nRow<9; nRow++)
    {
      for(nCol=0; nCol<2; nCol++)
      {
        if(scoreTables.strEnharmonicKeyChord[nRow][nCol] == strKeyChord)
        {
          bIsFind =  true;
          break;
        }
      }
      if(bIsFind) break;
    }

    if(bIsFind)
    {
      strFindChord = scoreTables.strEnharmonicKeyChord[nRow][(nCol==1) ? 0 : 1];
      if(bIsMinor)
      {
        nLength = strFindChord.length;
        strFindChord.replaceRange(nLength, nLength, 'm');
      }

      nKeyChordPos = findKeyChordPosition(strFindChord, bIsMinor);
      nMeterKey = findMeterKeyPosition(strKeyChord, bIsMinor, nMeterKey);

      if(nKeyChordPos >= 12)
      {
        nMeterKey = 0;
        nKeyChordPos = (bIsMinor ? 9 : 0);
      }
    }
    else
    {
      nMeterKey = 0;
      nKeyChordPos = (bIsMinor ? 9 : 0);
    }
    return nMeterKey;
  }
//==============================================================================

//==============================================================================
  Map<String, dynamic> dataToMap(BuildContext context, HttpCommunicate httpCommunicate){
    ///권대현 전임님 map 데이터값 입니다.
    Map<String, dynamic> data= {
      //web 데이터
      "mode" : httpCommunicate.strMode!,
      "Port" : httpCommunicate.strPort!,
      "IpAddress" : httpCommunicate.strIpAddress!,
      "SSID" :  httpCommunicate.strSSID!,
      "DUID" : httpCommunicate.strDUID!,
      "ASID" : httpCommunicate.strDUID!,
      "strBuyTransPosList" : httpCommunicate.strBuyTransPosList!,
      "strMainKey" : httpCommunicate.strMainKey!,
      "strMankey" : httpCommunicate.strManKey!,
      "strWomanKey" : httpCommunicate.strWomanKey!,
      "strUserId" : httpCommunicate.strUserId!,
      "Tag" : httpCommunicate.strTag!,
      "strMemberId" : httpCommunicate.strMemberId!,
      "nScorePrice" : httpCommunicate.strScorePrice!,
      "strMainTempo" : httpCommunicate.strMainTempo!,
      "scPrintScoreTransPos" : httpCommunicate.strscPrintScoreTransPos!,
      "scPrintScoreTransPos2" : httpCommunicate.strscPrintScoreTransPos2!,
      "scPrintScoreTransPos3" : httpCommunicate.strscPrintScoreTransPos3!,
      "SongNo" : httpCommunicate.nSongNo!,
      "NCountryMode" : httpCommunicate.nCountryMode!,
      "nScoreType" : httpCommunicate.nScoreType!,
      "nFileDataType" : httpCommunicate.nFileDataType!,
      "nViewJeonKanjoo" : httpCommunicate.nViewJeonKanjoo!,
      "nSubType" : httpCommunicate.nScoreType!,
      "DispNumber" : httpCommunicate.nDispNumber!,
      "blsPreViewScore" : httpCommunicate.bIsPreViewScore!,


      // //유저 설정 데이터
      // "Trans1" : context.read<TranspositionProvider>().nOneTranspositionValue,
      // "Octave1" : context.read<OctaveProvider>().nOneOctaveValue,
      // "Trans2" : context.read<TranspositionProvider>().nTwoTranspositionValue,
      // "Octave2" : context.read<OctaveProvider>().nTwoOctaveValue,
      // "Trans2" : context.read<TranspositionProvider>().nThreeTranspositionValue,
      // "Octave2" : context.read<OctaveProvider>().nThreeOctaveValue,
      // "ChordHelper" : context.read<KeynoteAssistantProvider>().bKeynoteAssistantValue,
      // "ChordFixed" : context.read<TranspositionCodeFixedProvider>().bTranspositionCodeFixedValue,
      // "DisplayChord" : context.read<DisplayCodeProvider>().nDisplayCodeValue,
      // "DisplayLyrics" : context.read<DisplayLyricsProvider>().nDisplayLyricsValue,
      // "LyricsType" : context.read<LyricsTypeProvider>().nLyricsTypeValue,
      // "LyricsComandments" : context.read<LyricsCommandmentsProvider>().nLyricsCommandmentsValue,
      // "CommandmentsType" : context.read<CommandmentsTypeProvider>().nCommandmentsTypeValue,
      // "HapjooChord" : context.read<EnsembleCodeProvider>().nEnsembleCode,
      // "PrintType" : context.read<PrintTypeProvider>().nPrintTypeValue,
    };

    return data;
  }

//==============================================================================

  Map<String, dynamic> settingsDataToMap(BuildContext context, HttpCommunicate httpCommunicate){
    Map<String, dynamic> data = {
      "Trans1" : context.read<TranspositionProvider>().nOneTranspositionValue,
      "Octave1" : context.read<OctaveProvider>().nOneOctaveValue,
      "Trans2" : context.read<TranspositionProvider>().nTwoTranspositionValue,
      "Octave2" : context.read<OctaveProvider>().nTwoOctaveValue,
      "Trans3" : context.read<TranspositionProvider>().nThreeTranspositionValue,
      "Octave3" : context.read<OctaveProvider>().nThreeOctaveValue,
      "ChordHelper" : context.read<KeynoteAssistantProvider>().bKeynoteAssistantValue,
      "ChordFixed" : context.read<TranspositionCodeFixedProvider>().bTranspositionCodeFixedValue,
      ///SJW Modify 2023.02.27 Start...
      ///ACT와 이외 악보의 악보 크기 옵션이 달라 분기로 데이터 처리
      "DisplayChord" : httpCommunicate.nFileDataType != 2 ? context.read<DisplayCodeProvider>().nDisplayCodeValue - 1 : context.read<DisplayCodeProvider>().nDisplayCodeValue,
      "DisplayLyrics" : httpCommunicate.nFileDataType != 2 ? context.read<DisplayLyricsProvider>().nDisplayLyricsValue - 1 : context.read<DisplayLyricsProvider>().nDisplayLyricsValue,
      ///SJW Modify 2023.02.27 End...
      "LyricsType" : context.read<LyricsTypeProvider>().nLyricsTypeValue,
      "LyricsCommandments" : context.read<LyricsCommandmentsProvider>().nLyricsCommandmentsValue,
      "CommandmentsType" : context.read<CommandmentsTypeProvider>().nCommandmentsTypeValue,
      "HapjooChord" : context.read<EnsembleCodeProvider>().nEnsembleCode,
      "PrintType" : context.read<PrintTypeProvider>().nPrintTypeValue,
      "ScoreSize" : context.read<ScoreSizeProvider>().nScoreSizeValue + 2, ///실제 값은 -2 ~ 6 이지만 데이터를 보낼땐 0~8로 보낸다

    };
     //print('ChoRD HELER : ${data['DisplayChord']}');
    return data;
  }
//==============================================================================

///악보 설정 변경시 모듈 통신 함수
//==============================================================================
  postDataToModule(BuildContext context, HttpCommunicate httpCommunicate) async {
    ///조표 인식 도우미 boolean 변수입니다.
    ///이조시 코드 고정 boolean 변수입니다.
    ///코드 표시 ( -1 = 안함 , 0 = 소, 1 = 중, 2 = 대 )
    ///가사 표시 ( 0 = 안함 , 1 = 소, 2 = 중, 3 = 대 )
    ///가사 종류 ( 0 = 원어 , 1 = 독음 )
    ///가사 / 계명 ( 0 = 가사, 1 = 계명 )
    ///계명 종류 ( 0 = 이동도 , 1 = 고정도 )
    ///합주 코드 ( 0 = 안함 , 1 = 테너, 2 = 알토 )
    ///출력 선택 ( 0 = 전체, 1 = 1보만, 2 = 2보만, 3 = 3보만)

    Map<String,dynamic> settingsData = settingsDataToMap(context, httpCommunicate);
    // print('settingsData : $settingsData');
    BridgeNative bridgeNative = BridgeNative();
    await bridgeNative.GetScoreData(settingsData);
  }

  postURLDataToModule(BuildContext context){
    //데이터
    Map<String, dynamic> urlData = context.read<ScoreDataProvider>().urlData;
    // print('urlData : $urlData');
    BridgeNative bridgeNative = BridgeNative();
    bridgeNative.GetWebServerData(urlData);
  }

//==============================================================================
}

