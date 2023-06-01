import 'dart:async';

import 'package:elfscoreprint_mobile/aging_test.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:elfscoreprint_mobile/src/resources/score/draw_score.dart';
import 'package:elfscoreprint_mobile/src/screens/phone/dialogs/phone_go_chrome_dialog.dart';
import 'dart:convert' as convert;

import 'src/providers/custom_font_provider.dart';
import 'src/providers/score_size_provider.dart';
import 'src/resources/method_channel/bridge_native.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'src/models/data/score_data.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image/image.dart' as imgLib;

import 'src/models/http/http_communicate.dart';
import 'src/providers/commandments_type_provider.dart';
import 'src/providers/dan_settings_provider.dart';
import 'src/providers/display_code_provider.dart';
import 'src/providers/display_lyrics_provider.dart';
import 'src/providers/ensemble_code_provider.dart';
import 'src/providers/keynote_assistant_provider.dart';
import 'src/providers/lyrics_commandments_provider.dart';
import 'src/providers/lyrics_type_provider.dart';
import 'src/providers/octave_provider.dart';
import 'src/providers/print_type_provider.dart';
import 'src/providers/score_data_provider.dart';
import 'src/providers/score_image_provider.dart';
import 'src/providers/transposition_code_fixed_provider.dart';
import 'src/providers/transposition_provider.dart';
import 'src/resources/ftp/ftp_controller.dart';
import 'src/resources/score/score_info_controller.dart';
import 'src/screens/main_screen.dart';
import 'src/screens/splash/splash_screen.dart';

//==============================================================================
void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranspositionProvider()),
        ChangeNotifierProvider(create: (_) => OctaveProvider()),
        ChangeNotifierProvider(create: (_) => KeynoteAssistantProvider()),
        ChangeNotifierProvider(create: (_) => TranspositionCodeFixedProvider()),
        ChangeNotifierProvider(create: (_) => DisplayCodeProvider()),
        ChangeNotifierProvider(create: (_) => DisplayLyricsProvider()),
        ChangeNotifierProvider(create: (_) => LyricsTypeProvider()),
        ChangeNotifierProvider(create: (_) => LyricsCommandmentsProvider()),
        ChangeNotifierProvider(create: (_) => CommandmentsTypeProvider()),
        ChangeNotifierProvider(create: (_) => EnsembleCodeProvider()),
        ChangeNotifierProvider(create: (_) => PrintTypeProvider()),
        ChangeNotifierProvider(create: (_) => ScoreImageProvider()),
        ChangeNotifierProvider(create: (_) => DanSettingsProvider()),
        ChangeNotifierProvider(create: (_) => ScoreDataProvider()),
        ChangeNotifierProvider(create: (_) => ScoreData()),
        ChangeNotifierProvider(create: (_) => ScoreSizeProvider()),
        ChangeNotifierProvider(create: (_) => CustomFontProvider()),
        ChangeNotifierProvider(create: (_) => PDFProvider())
      ],
      child: MyApp(),
    ),
  );
}
//==============================================================================


//==============================================================================
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  Uri? initialUri;
  Object? _err;
  bool _initialUriIsHandled = false;
  List<String> c03List = [];
  bool bIsAging = false;
  bool kIsWeb = false;
  Uri? _latestUri;
  StreamSubscription? _sub;
  Key key = UniqueKey();

  final completer = Completer<void>();

  Future<void> showC03DirList() async {
    // List<String> C03List = [];
    try{
      final jsonString = await rootBundle.loadString('AssetManifest.json');
      final jsonData = convert.json.decode(jsonString) as Map<String, dynamic>;
      // C03List.addAll(jsonData.keys);
      c03List = jsonData.keys
          // .where((String key) => key.contains('C03/'))
          .where((String key) => key.contains('.C03'))
          .toList();
      // print('C03List : $c03List');
      // print('C03List Length : ${c03List.length}');
      completer.complete();
    }catch(e){
      print('show C0 dir List error : ${e.toString()}');
    }
  }

//==============================================================================
  Future<void> _handleInitialUri() async {
    // In this example app this is an almost useless guard, but it is here to
    // show we are not going to call getInitialUri multiple times, even if this
    // was a weidget that will be disposed of (ex. a navigation route change).
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('no initial uri');
        } else {
          print('got initial uri: $uri');
        }
        if (!mounted) return;
        setState(() {
          initialUri = uri;
          _latestUri = initialUri;
          if (initialUri != null) {
            context.read<ScoreImageProvider>().url2Map(initialUri!.toString());
          } else {
            initialUri = null;
            print('URI IS NULL');
            ///구매
            // String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=OWJrN21kcWdkZTJ0cDVpaGJlbWttMGFuZzM%3D&DUID=NjNkMGJlZjVlMzM5MQ%3D%3D&SongNo=1044&NCountryMode=0&nScorePrice=300,300&nScoreType=0&nFileDataType=2&blsPreViewScore=1&strBuyTransPosList=&strMainKey=E&strWomankey=G&strMankey=D&nViewJeonKanjoo=0&strMainTempo=141&nSubType=0&DispNumber=1044&strUserId=ZGhLd29uMDkyNg&ElfWinSrv_Setup=1.0.5.4&ElfScorePrint=1.0.5.8";
            ///인쇄
            //String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=NWYxZ2xmbzdqZmlna242cWI5N2N0dmRvMDQ%3D&DUID=NjNkMWRlYTdjOTZmNg%3D%3D&ASID=QVNQU0VTU0lPTklEQ1VBUkRBREE9SU5GRVBMR0FETEhGTEpDRENFQkdOTUlL&SongNo=870&NCountryMode=0&nScoreType=0&nFileDataType=2&nViewJeonKanjoo=0&scPrintScoreTransPos=0&strMainKey=Dm&strMankey=Dm&strWomankey=Gm&blsPreViewScore=0&strMainTempo=74&strUserId=JXVBRDhDJXVCMzAwJXVENjA0&Tag=A8B458C7FFC9866C4195EFA6F25AE24DEF72D4ED0A7C90B3FFB051C84447915BA5DD19EB464A236D1D36A3FF3E1075DF&nSubType=&DispNumber=870&scPrintScoreTransPos2=&scPrintScoreTransPos3=&strMemberId=dhKwon0926&ElfWinSrv_Setup=1.0.5.4&ElfScorePrint=1.0.5.8";
            ///c03 2단
            String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=Y3MxcGtmNjkyczQ4MzJ2bHR1dG5tczNqbzA%3D&DUID=NjQ0NzI1NGMxYjJhZQ%3D%3D&ASID=QVNQU0VTU0lPTklEQVdEUkREQUE9RkJLSU5NRkRKTUhPTU9LUE5ER0hQS01Q&SongNo=11125&NCountryMode=3&nScoreType=15&nFileDataType=0&nViewJeonKanjoo=1&scPrintScoreTransPos=-11&strMainKey=Gm&strMankey=Dm&strWomankey=Gm&blsPreViewScore=0&strMainTempo=98&strUserId=JXVBRDhDJXVCMzAwJXVENjA0&Tag=2991C07CDC70690FA9327995954E479DD8D4C43D3FE5D4501C5B57DBE13C70DCBBDB6C4074CAB74F30C1628431866ED6&nSubType=&DispNumber=11125&scPrintScoreTransPos2=&scPrintScoreTransPos3=&strMemberId=dhKwon0926&ElfWinSrv_Setup=1.0.5.5&ElfScorePrint=1.0.5.8";
            ///섹소폰 2/3중주 3단
            // String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=NWlycmFmb2xldnI4dG5tdWJwb2Q2MTc1azI%3D&DUID=NjNkMzg2MGQxMGJjYQ%3D%3D&ASID=QVNQU0VTU0lPTklEQVVCUUNCREI9QkVBTE5IREJLRERMUEJGSUNORERCQ0xG&SongNo=12928&NCountryMode=0&nScoreType=30&nFileDataType=3&nViewJeonKanjoo=0&scPrintScoreTransPos=0&strMainKey=Bb&strMankey=Eb&strWomankey=Bb&blsPreViewScore=0&strMainTempo=82&strUserId=JXVBRDhDJXVCMzAwJXVENjA0&Tag=B426B631547B30DFDB1940E998C5C0BB41C17957915EB91828543528C6B32003879E8BDD62F8D1A31D1977398C11E253&nSubType=&DispNumber=12928&scPrintScoreTransPos2=0&scPrintScoreTransPos3=0&strMemberId=dhKwon0926&ElfWinSrv_Setup=1.0.5.4&ElfScorePrint=1.0.5.8";
            ///섹소폰 앙상블
            // String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=bXR1YmJ0OWNoaHF0a3Y1dDkxbTAzbnZjcTA%3D&DUID=NjNkYTBkNTU5YWJmZA%3D%3D&ASID=QVNQU0VTU0lPTklEQ1VCUUJBQ0E9RUJETUhIR0FMSUJBSUFPS0pNTEZIT0dP&SongNo=139697&NCountryMode=0&nScoreType=40&nFileDataType=1&nViewJeonKanjoo=0&scPrintScoreTransPos=0&strMainKey=Am&strMankey=Am&strWomankey=Am&blsPreViewScore=0&strMainTempo=67&strUserId=JXVBRDhDJXVCMzAwJXVENjA0&Tag=AC4AF102C1DD1A5152A8E0BA1C7FC473B4E1AB5F1B49BF2A6F471A644A02EC89B3CACFE38A392B78DBCF35864B4169F7&nSubType=&DispNumber=139697&scPrintScoreTransPos2=&scPrintScoreTransPos3=&strMemberId=dhKwon0926&ElfWinSrv_Setup=1.0.5.4&ElfScorePrint=1.0.5.8";
            ///일본곡
            // String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=bjRkM2JqcGFudXYzYWRlaGtjNjVkdTQzNDU%3D&DUID=NjQxYTQ2ZDY5ZjRmYg%3D%3D&SongNo=32479&NCountryMode=2&nScorePrice=300,800&nScoreType=0&nFileDataType=0&blsPreViewScore=1&strBuyTransPosList=&strMainKey=Am&strWomankey=Am&strMankey=Em&nViewJeonKanjoo=0&strMainTempo=70&nSubType=0&DispNumber=32479&strUserId=ZGhLd29uMDkyNg&ElfWinSrv_Setup=1.0.5.5&ElfScorePrint=1.0.5.8";
            ///중국곡
            // String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=bjRkM2JqcGFudXYzYWRlaGtjNjVkdTQzNDU%3D&DUID=NjQxYmQyY2E0Mzc2Yg%3D%3D&SongNo=20834&NCountryMode=1&nScorePrice=300,800&nScoreType=0&nFileDataType=0&blsPreViewScore=1&strBuyTransPosList=L&strMainKey=E&strWomankey=D&strMankey=A&nViewJeonKanjoo=0&strMainTempo=68&nSubType=0&DispNumber=20834&strUserId=ZGhLd29uMDkyNg&ElfWinSrv_Setup=1.0.5.5&ElfScorePrint=1.0.5.8";
            ///ACT(중국곡)
            // String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=bjRkM2JqcGFudXYzYWRlaGtjNjVkdTQzNDU%3D&DUID=NjQxYTQ4MGQwMzA3Nw%3D%3D&SongNo=200376&NCountryMode=1&nScorePrice=300,300&nScoreType=0&nFileDataType=2&blsPreViewScore=1&strBuyTransPosList=&strMainKey=Db&strWomankey=Db&strMankey=Ab&nViewJeonKanjoo=0&strMainTempo=128&nSubType=0&DispNumber=200376&strUserId=ZGhLd29uMDkyNg&ElfWinSrv_Setup=1.0.5.5&ElfScorePrint=1.0.5.8";
            // ///앙상블
            // String strUri = "https://127.0.0.1:9147/?mode=scoreprint&Port=NTAwMDE&IpAddress=MjExLjIxMC4xMzAuMjQ&SSID=bjRkM2JqcGFudXYzYWRlaGtjNjVkdTQzNDU%3D&DUID=NjQxYmRiOTBkYWZlNg%3D%3D&ASID=QVNQU0VTU0lPTklEQ1VEUUNDQkE9TkJKS09QTkJQQlBGRU9CREtQS0ZDQ01F&SongNo=139698&NCountryMode=0&nScoreType=40&nFileDataType=1&nViewJeonKanjoo=0&scPrintScoreTransPos=0&strMainKey=C&strMankey=C&strWomankey=C&blsPreViewScore=0&strMainTempo=57&strUserId=JXVBRDhDJXVCMzAwJXVENjA0&Tag=C18566E16254F4C23E5DFC6D19D6A1EB97BA79BFF2A4FA9BAA94BCE2FFD9F24A4AD30D9D5A4B5E6EDDE3631065C63EAB&nSubType=&DispNumber=139698&scPrintScoreTransPos2=&scPrintScoreTransPos3=&strMemberId=dhKwon0926&ElfWinSrv_Setup=1.0.5.5&ElfScorePrint=1.0.5.8";

            context.read<ScoreImageProvider>().url2Map(strUri);
            // initialUri = Uri.parse(strUri);
          }
        });
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  ///
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          initialUri = _latestUri;
          context.read<ScoreImageProvider>().url2Map(initialUri!.toString());
          // print('init set');
          ///SJW Modify 2023.02.09 Start...
          ///유니크 키로 데이터 새로 들어오면 rebuild
          key = UniqueKey();
          ///SHJW Modify 2023.02.09 End...
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;

        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }
  //==============================================================================
  @override
  void initState() {
    // TODO: implement initState
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    _handleIncomingLinks();
    _handleInitialUri();
      // showC03DirList();
    // });
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    // _handleInitialUri();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


  void initScoreData(BuildContext context, int nScoreType){
    print('initScoreData !!');
    context.read<TranspositionProvider>().init();
    context.read<CommandmentsTypeProvider>().init();
    context.read<DanSettingsProvider>().init();
    context.read<DisplayCodeProvider>().init(nScoreType);
    context.read<DisplayLyricsProvider>().init();
    context.read<EnsembleCodeProvider>().init();
    context.read<KeynoteAssistantProvider>().init();
    context.read<LyricsCommandmentsProvider>().init();
    context.read<LyricsTypeProvider>().init();
    context.read<OctaveProvider>().init();
    context.read<PrintTypeProvider>().init();
    context.read<ScoreSizeProvider>().init();
    context.read<TranspositionCodeFixedProvider>().init();

    return;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('resumed');
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
    } else if (state == AppLifecycleState.paused) {
      print('paused');
      ///SJW Modify 2023.02.09 Start...
      ///paused 상태일떄 무조건 앱을 끊는게 아니라 다른 데이터기 들아얼올때만 rebuild하게  해야함
      // Platform.isAndroid
      //     ? SystemChannels.platform.invokeMethod('SystemNavigator.pop')
      //     : exit(0);
      ///SJW Modify 2023.02.09 End...
    }
  }
//==============================================================================

//==============================================================================
  @override
  Widget build(BuildContext context) {

    HttpCommunicate? httpCommunicate =
      context.read<ScoreImageProvider>().scoreInfo['blsPreViewScore'] == "1"
          ? HttpCommunicate(context.read<ScoreImageProvider>().scoreInfo, 1)
          : HttpCommunicate(context.read<ScoreImageProvider>().scoreInfo, 0);

    initScoreData(context, httpCommunicate.nScoreType!);

    if(bIsAging) {
      completer.future;
    }

    // print('rebuild?');

    if(bIsAging){
      if(c03List.isEmpty){
        print('aging data Empty');
      }
      ///SJW Modify 2023.02.09 Start...
      return Platform.isAndroid
          ? MaterialApp(
                home: Scaffold(
                  body: AgingTest(agingData: c03List, httpCommunicate: httpCommunicate),
                ),
          )
          : CupertinoApp(
              home: CupertinoPageScaffold(
                child: AgingTest(agingData: c03List, httpCommunicate: httpCommunicate),
              ),
            );
    }
    else {
      ///SJW Modify 2023.02.09 Start...
      ///Key값에 따라 reBuild
      
      return Platform.isAndroid
          ? KeyedSubtree(
              key: key,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                    // body: initialUri != null
                    //     ? Home(httpCommunicate: httpCommunicate, uri: initialUri!,)
                    //     : NonUrlPage(httpCommunicate: httpCommunicate,)
                  body: CheckData(httpCommunicate),
                ),
              ),
            )
          : KeyedSubtree(
              key: key,
              child: CupertinoApp(
                debugShowCheckedModeBanner: false,
                home: CupertinoPageScaffold(
                  // child: initialUri != null
                  //   ? Home(httpCommunicate: httpCommunicate, uri: initialUri!)
                  //   : NonUrlPage(httpCommunicate: httpCommunicate,)
                  child: CheckData(httpCommunicate),
                ),
              ),
      );
      ///SJW Modify 2023.02.09 End...
    }
  }
  
  Widget CheckData(HttpCommunicate httpCommunicate){
    print("httpCommunicate.bIsPreViewScore : ${httpCommunicate.bIsPreViewScore}");
    if(initialUri != null && httpCommunicate.bIsPreViewScore == false){
      print("Home");
      return Home(httpCommunicate: httpCommunicate, uri: initialUri!);
    }
    else{
      print("NullPage");
      return NonUrlPage(httpCommunicate: httpCommunicate,);
    }
  }
}
//==============================================================================

//==============================================================================

class Home extends StatefulWidget {
  HttpCommunicate? httpCommunicate;
  final Uri? uri;

  Home({this.httpCommunicate, this.uri});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = const MethodChannel("native.flutter.kisatest");

  bool bFtpRes = true;
  bool bSuccess = true;
  List<int> _scoredata = [];

  Future? myFuture;
  // HttpCommunicate? httpCommunicate;
  ScoreInfoController scoreInfoController = ScoreInfoController();


//==============================================================================
  ///FTP File Download
  ///비동기 처리
  Future<void> _getFtpFile(BuildContext context,
      HttpCommunicate httpCommunicate, ScoreInfoController controller) async {

    // print('get ftp run()');


    //Ftp 레퍼런스 생성
    FtpController ftpController = FtpController();
    File? wrkFile;

    ///다운로드 받은 악보 파일 경로 입니다.FG
    List<String> strScoreImagePath = [];

    ///악보 경로 저장 List
    int nScorePageNum = 0;

    ///악보 총 장수

    //FTP파일 경로 설정
    ftpController.setFtpFilePath(
        httpCommunicate.nFileDataType!, httpCommunicate.nSongNo!, httpCommunicate.nScoreType!, httpCommunicate.nSubType!, httpCommunicate.nViewJeonKanjoo!);


    // for (int nCount = 0; nCount < 5; nCount++) {
    //FTP 파일 다운로드
    for(int i=0; i<5; i++) {
      //FTP 연결
      await ftpController.connectionFTP();
      context.read<PDFProvider>().bFtpRes = await ftpController.downloadFileFTP(context);

      if(context.read<PDFProvider>().bFtpRes)
        break;
      else
        await ftpController.disconnectFTP();
    }

    // print('bFtpRes : $bFtpRes');
    //파일 유효성 검사
    await ftpController.checkValidationFile();

    // if (bFtpRes && bSuccess) break;
    // }

    if (!context.read<PDFProvider>().bFtpRes || !bSuccess) {
      showAlert(context);
    }

    if (context.read<PDFProvider>().bFtpRes) {
      wrkFile = ftpController.file;
      // print("WRK File: $wrkFile");
    }

    ///권대현 전임님
    ///처음으로 악보 이미지 만드는 곳( 로딩 화면 중... )
    ///wrkFile은 FTP 서버에서 다운 받은 C02, C03... 파일 저장 경로입니다.
    ///매서드 연결해서 접근하고 복사하시면 됩니다.
    if (wrkFile != null) {
      context.read<ScoreDataProvider>().setUrlData(controller.dataToMap(context, httpCommunicate));

      ///url데이터와 설정값 데이터을 저장하고 변경된 이미지 처리하는 함수
      controller.postDataToModule(context, httpCommunicate);
      controller.postURLDataToModule(context);

      // bool bP02Res = await _checkValidationP02File(ftpController.file);
      await _checkValidationP02File(context, httpCommunicate, ftpController.file);

      ///스토리지의 악보 파일 삭제 (복사 완료되면 수행할것, 테스트 할때는 주석 또는 then()사용해서 복사후 삭제하도록 해야함.)
      // await ftpController.deleteAppFile();

      // bFtpRes = false;
    }

    // print('download End');
  }

//==============================================================================

//==============================================================================


  // realDrawScore(BuildContext context, double posY, int nFontData) {
  //   print('realDrawScore !');
  //   DrawScore drawScore = DrawScore();
  //   // print('_scoredata :::: $_scoredata');
  //   // context.read<PDFProvider>().setPDF(drawScore.drawPDF(context, posY, nFontData));
  //   context.read<PDFProvider>().editPDF(context, 0, posY, nFontData);
  // }
//==============================================================================

//==============================================================================
  ///폰트 파일 로드
  void _loadFontFile(BuildContext context){
    context.read<CustomFontProvider>().setElfScoreTTF();
    context.read<CustomFontProvider>().setElfChordTTF();
    context.read<CustomFontProvider>().setElfSymbolTTF();
    context.read<CustomFontProvider>().setElfToneNameTTF();
    context.read<CustomFontProvider>().setKBIZHanmaumMyeonjoBTTF();
    context.read<CustomFontProvider>().setKBIZHanmaumMyeonJoBTTF_kor();
    context.read<CustomFontProvider>().setMaestroTTF();
    context.read<CustomFontProvider>().setMalgunTTF();
    context.read<CustomFontProvider>().setNanumMyeongjoBTTF();
    context.read<CustomFontProvider>().setSourceHanSansMediumTTF();
    context.read<CustomFontProvider>().setSourceHanSansNormalTTF();
    context.read<CustomFontProvider>().setTimesNewRomanTTF();

    context.read<CustomFontProvider>().setFontByteData(context);
    context.read<CustomFontProvider>().setFontSize();
    context.read<CustomFontProvider>().setGasaSize();
    context.read<CustomFontProvider>().setScoreFontSize();
    context.read<CustomFontProvider>().setFontLineSize();
    context.read<CustomFontProvider>().setFontSizePosX();
    // context.read<PDFProvider>().setPDF();
  }
//==============================================================================

//==============================================================================
  ///FTP 파일 다운로드 동안 대기
  ///추후 악보 모듈도 여기서 실행
  Future<List> _loadData(BuildContext context, HttpCommunicate httpCommunicate, ScoreInfoController controller) async {
    // _showCacheDirList();

    print('cache dir flush');
    deleteCacheDir(); ///앱 실행시 Cache 디렉토리 내부 파일 삭제 ( 초기화 )
    initData();


    BridgeNative bridgeNative = BridgeNative();
    if(httpCommunicate.bIsPreViewScore! == false) {
      String str = const convert.Utf8Decoder().convert(convert.base64Decode(
          httpCommunicate.urlDecode(httpCommunicate.strUserId!)));
      int strLen = httpCommunicate.GetRealUserID(context, str);
      if (strLen == 0) {
        print('strUserId Error');
      }
    }

    return Future.wait([
      httpCommunicate.secureTest(context, httpCommunicate, platform)
          .whenComplete(() => _getFtpFile(context, httpCommunicate, controller)
          .whenComplete(() => bridgeNative.callDrawFromModule(context, httpCommunicate, true, true)))
    ]);

  }

//==============================================================================

//==============================================================================
//   _showCacheDirList() async {
//     List<FileSystemEntity> _dirFiles;
//     final dir = await getTemporaryDirectory()..createSync(recursive: true);
//     String dirPath = dir.path + '/';
//     final myDir = Directory(dirPath);
//     _dirFiles = myDir.listSync(recursive: true, followLinks: false);
//     print('_dirFiles : $_dirFiles');
//     // _dirFiles.remove(true);
//   }
//==============================================================================

//==============================================================================
  ///실행 안됨 현재 flytter에서 tiff파일을 지원하지 않음
  ///c++ 또는 java, objc에서 converting 해야함(jpg, png)
  _tiffConvertToPNG(String fileName){
    File tiff = File('/data/user/0/com.example.elfscoreprint_mobile_20220531/cache/$fileName');
    imgLib.Decoder? dec = imgLib.findDecoderForData(tiff.readAsBytesSync());
  }
//==============================================================================

//==============================================================================
  List<String> getFileInfo(File file){
    List<String> temp = file.path.split("/");

    String strFileName = temp.last.toString().split(".")[0];

    if(file.path.contains(".C02")){
      strFileName += ".P02";
    }
    else if(file.path.contains(".C03")){
      strFileName += ".P03";
    }
    else if(file.path.contains(".C01")){
      strFileName = strFileName.split("_")[0];
      strFileName += "_001.tiff";
    }
    else if(file.path.contains(".act")){
      strFileName += ".act";
    }

    String strFilePath = "";
    for (int i = 0; i < temp.length - 1; i++) {
      strFilePath += temp[i] + (i < temp.length - 2 ? "/" : "");
    }
    strFilePath += "/$strFileName";

    List<String> res = [strFilePath, strFileName];

    // print('getFileInfo : $res');

    return res;
  }
//==============================================================================

  ///P02 파일 사이즈 체크 및 다운로드
//==============================================================================
  Future<void> _checkValidationP02File(BuildContext context, HttpCommunicate httpCommunicate, File file) async {
    bool bP02Copy = true;

    ///true면 복사, false면 복사하지 않음
    int nSize = 0;

    List<String> fileInfo = getFileInfo(file);

    // print('res :: $fileInfo');

    Map<String, String> ftpFilePath = {
      "ftpFilePath" : file.path,
      "p0FilePath" : fileInfo[0],
    };

    context.read<ScoreDataProvider>().strP0Path = fileInfo[0];

    // print('ftpFilePath : ${file}');
    // print('p0FilePath : ${fileInfo[0]}');
    // print('P0File Path : $ftpFilePath');

    BridgeNative bridgeNative = BridgeNative();

    nSize = await bridgeNative.compressorFile(file.path, ftpFilePath);
    // print('compressor done');

    if(nSize == -9999){
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => bridgeNative.errorDialog(context),
      );
    }

    if(Platform.isAndroid){
      Map<String, String> data = {
        "path": fileInfo[0],
        "fileName": fileInfo[1]
      };

      // print('map data : $data');

      scoreInfoController.postURLDataToModule(context);
      scoreInfoController.postDataToModule(context, httpCommunicate);

      // print('MAP<> : $data');
      // print('res Size : $nSize');
      ///첫 번째 매개변수 true시에만 저장함
      // String strDownloadFilePath = await bridgeNative.downloadFiles(false, nSize, data);
      // print('download file path : $strDownloadFilePath');
    }

  }

//==============================================================================

//==============================================================================



  @override
  void initState() {
    print('Home Init');
    // TODO: implement initState
    // getScoreDataFromModule(context);
    //라이트 모드로 고정

    // _showCacheDirList();
    // httpCommunicate =
    // context.read<ScoreImageProvider>().scoreInfo['blsPreViewScore'] == "1"
    //     ? HttpCommunicate(context.read<ScoreImageProvider>().scoreInfo, 1)
    //     : HttpCommunicate(context.read<ScoreImageProvider>().scoreInfo, 0);

    if (widget.httpCommunicate!.strTag != null) {
      widget.httpCommunicate!.strTag =
          widget.httpCommunicate!.urlDecode(widget.httpCommunicate!.strTag!);
    }

    ///악보 설정 가능 항목 Flag 초기화
    scoreInfoController.initScoreSettingOption(
        context,
        widget.httpCommunicate!.nFileDataType!,
        widget.httpCommunicate!,
        widget.httpCommunicate!.nScoreType!,
        widget.httpCommunicate!.bIsPreViewScore!,
        widget.httpCommunicate!.strMainKey!);

    myFuture = _loadData(context, widget.httpCommunicate!, scoreInfoController);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light) // Or Brightness.dark
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  ///Cache Dir File 삭제
  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    print('cache dir path : ${cacheDir.path}');
    cacheDir.deleteSync(recursive: true);
    print('delete cacheDir');
  }



  void initData(){
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<PDFProvider>().setDataInit();
      _loadFontFile(context);
    });
  }

  @override
  Widget build(BuildContext context) {


    BridgeNative bridgeNative = BridgeNative();
    bridgeNative.getScoreDataFromModule(context, widget.httpCommunicate!);


    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen(
            httpCommunicate: widget.httpCommunicate,
          );
        } else {
          if (context.read<PDFProvider>().bFtpRes) {
            return MainScreen(
              httpCommunicate: widget.httpCommunicate,
            );
            // return CheckUri(uri: widget.uri!, httpCommunicate: widget.httpCommunicate!);
          } else {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('ERROR'),
                ),
              ),
            );
          }
        }
      },
    );
  }

//==============================================================================
  void showAlert(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Platform.isAndroid
        ? showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: _displayTitle(size),
          content: _displayContent(size),
          actions: [_displayOkButton(size)],
        ))
        : showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CupertinoAlertDialog(
          title: _displayTitle(size),
          content: _displayContent(size),
          actions: [_displayOkButton(size)],
        ));
  }

  ///Title
  Widget _displayTitle(Size size) {
    return Column(
      children: <Widget>[
        Container(
          width: size.width * 0.7,
          height: size.height * 0.04,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.error_outline,
                  color: Colors.black, size: size.width * 0.08),
              Text('오류',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        Container(
          height: size.height * 0.03,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/divider.png'),
            ),
          ),
        ),
      ],
    );
  }

  ///Content
  Widget _displayContent(Size size) {
    return Container(
      width: size.width * 0.7,
      height: size.height * 0.1,
      alignment: Alignment.center,
      child: Text(
        '오류가 발생했습니다.\n다시 시도해 주세요.',
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: size.width > 600 ? size.width * 0.025 : size.width * 0.035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ///OK Button
  Widget _displayOkButton(Size size) {
    return Container(
      height: size.height * 0.06,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Platform.isAndroid ? SystemNavigator.pop() : exit(0);
        },
        child: Image(
          image: AssetImage('assets/images/buttons/ok_button.png'),
        ),
      ),
    );
  }
}

class NonUrlPage extends StatefulWidget {
  final HttpCommunicate? httpCommunicate;

  const NonUrlPage({Key? key, this.httpCommunicate}) : super(key: key);

  @override
  State<NonUrlPage> createState() => _NonUrlPageState();
}

class _NonUrlPageState extends State<NonUrlPage> {
  showGuid(BuildContext context) async {

    if(Platform.isAndroid) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => PhoneGoChrome(bIsPreview: widget.httpCommunicate!.bIsPreViewScore,)
      );
    }
    else{
      showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => PhoneGoChrome(bIsPreview: widget.httpCommunicate!.bIsPreViewScore,)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Non Url");
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
      return Platform.isAndroid
          ? MaterialApp(
            home: Scaffold(
            backgroundColor: Colors.white,
            body: showGuid(context),
          ),
        )
          : CupertinoApp(
        home: CupertinoPageScaffold(
          backgroundColor: Colors.white,
          child: showGuid(context),
        ),
      );
    // });

    return Container();
  }
}

//==============================================================================

