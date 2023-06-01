import 'dart:async';

import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../../models/http/http_communicate.dart';
import '../../providers/score_image_provider.dart';

class SplashScreen extends StatefulWidget {
  HttpCommunicate? httpCommunicate;

  SplashScreen({this.httpCommunicate});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //음표 로딩 이미지 45프레임
  List<String> keynoteImageList = [
    "assets/images/splash/keynoteImage1.png",
    "assets/images/splash/keynoteImage2.png",
    "assets/images/splash/keynoteImage3.png",
    "assets/images/splash/keynoteImage4.png",
    "assets/images/splash/keynoteImage5.png",
    "assets/images/splash/keynoteImage6.png",
    "assets/images/splash/keynoteImage7.png",
    "assets/images/splash/keynoteImage8.png",
    "assets/images/splash/keynoteImage9.png",
    "assets/images/splash/keynoteImage10.png",
    "assets/images/splash/keynoteImage11.png",
    "assets/images/splash/keynoteImage12.png",
    "assets/images/splash/keynoteImage13.png",
    "assets/images/splash/keynoteImage14.png",
    "assets/images/splash/keynoteImage15.png",
    "assets/images/splash/keynoteImage16.png",
    "assets/images/splash/keynoteImage17.png",
    "assets/images/splash/keynoteImage18.png",
    "assets/images/splash/keynoteImage19.png",
    "assets/images/splash/keynoteImage20.png",
    "assets/images/splash/keynoteImage21.png",
    "assets/images/splash/keynoteImage22.png",
    "assets/images/splash/keynoteImage23.png",
    "assets/images/splash/keynoteImage24.png",
    "assets/images/splash/keynoteImage25.png",
    "assets/images/splash/keynoteImage26.png",
    "assets/images/splash/keynoteImage27.png",
    "assets/images/splash/keynoteImage28.png",
    "assets/images/splash/keynoteImage29.png",
    "assets/images/splash/keynoteImage30.png",
    "assets/images/splash/keynoteImage31.png",
    "assets/images/splash/keynoteImage32.png",
    "assets/images/splash/keynoteImage33.png",
    "assets/images/splash/keynoteImage34.png",
    "assets/images/splash/keynoteImage35.png",
    "assets/images/splash/keynoteImage36.png",
    "assets/images/splash/keynoteImage37.png",
    "assets/images/splash/keynoteImage38.png",
    "assets/images/splash/keynoteImage39.png",
    "assets/images/splash/keynoteImage40.png",
    "assets/images/splash/keynoteImage41.png",
    "assets/images/splash/keynoteImage42.png",
    "assets/images/splash/keynoteImage43.png",
    "assets/images/splash/keynoteImage44.png",
    "assets/images/splash/keynoteImage45.png",
    "assets/images/splash/keynoteImage46.png",
    "assets/images/splash/keynoteImage47.png",
    "assets/images/splash/keynoteImage48.png",
    "assets/images/splash/keynoteImage49.png",
    "assets/images/splash/keynoteImage50.png",
    "assets/images/splash/keynoteImage51.png",
    "assets/images/splash/keynoteImage52.png",
    "assets/images/splash/keynoteImage53.png",
    "assets/images/splash/keynoteImage54.png",
    "assets/images/splash/keynoteImage55.png",
    "assets/images/splash/keynoteImage56.png",
    "assets/images/splash/keynoteImage57.png",
    "assets/images/splash/keynoteImage58.png",
    "assets/images/splash/keynoteImage59.png",
    "assets/images/splash/keynoteImage60.png",
    "assets/images/splash/keynoteImage61.png",
    "assets/images/splash/keynoteImage62.png",
    "assets/images/splash/keynoteImage63.png",
    "assets/images/splash/keynoteImage64.png",
    "assets/images/splash/keynoteImage65.png",
    "assets/images/splash/keynoteImage66.png",
    "assets/images/splash/keynoteImage67.png",
    "assets/images/splash/keynoteImage68.png",
    "assets/images/splash/keynoteImage69.png",
    "assets/images/splash/keynoteImage70.png",
    "assets/images/splash/keynoteImage71.png",
    "assets/images/splash/keynoteImage72.png",
    "assets/images/splash/keynoteImage73.png",
    "assets/images/splash/keynoteImage74.png",
    "assets/images/splash/keynoteImage75.png",
    // "assets/images/splash/keynoteImage76.png",
    // "assets/images/splash/keynoteImage77.png",
    // "assets/images/splash/keynoteImage78.png",
    // "assets/images/splash/keynoteImage79.png",
    // "assets/images/splash/keynoteImage80.png",
    // "assets/images/splash/keynoteImage81.png",
    // "assets/images/splash/keynoteImage82.png",
    // "assets/images/splash/keynoteImage83.png",
    // "assets/images/splash/keynoteImage84.png",
    // "assets/images/splash/keynoteImage85.png",
    // "assets/images/splash/keynoteImage86.png",
    // "assets/images/splash/keynoteImage87.png",
    // "assets/images/splash/keynoteImage89.png",
    // "assets/images/splash/keynoteImage90.png",
  ];

  //Timer로 음포 로딩 이미지 표시
  int nCount = 0;
  Timer? timer;
  Timer? chkTime;
  int nChkCount = 0;

  initState() {

    // Navigator.pop(context);

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    chkTime = Timer.periodic(Duration(seconds: 1), (timer) {
      if(widget.httpCommunicate!.nFileDataType == 1){//앙상블
        if (nChkCount >= 20) {
          if(!context.read<PDFProvider>().bFtpRes) {
            Timer.run(() {
              showAlert(context);
              timer.cancel();
            });
          }
        }
      }
      else{

        if (nChkCount >= 20) {
          if(!context.read<PDFProvider>().bFtpRes) {
            Timer.run(() {
              showAlert(context);
            });
          }
        }
        timer.cancel();
      }
      nChkCount++;
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      timer = Timer.periodic(Duration(milliseconds: 80), (timer) {
        setState(() {
          // nCount++;
          if (nCount > 74) {
            nCount = 0;
          }
          nCount = (nCount + 1) % keynoteImageList.length;
        });
      });
    });
    super.initState();
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
          height: size.height * 0.02,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/error.png'),
            ),
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

//==============================================================================

  Widget _displaySplashScreen(Size size) {
    return OrientationBuilder(
      builder: (context, orientation) {
        ///SJW Modify 2022-05-31 Start...1
        ///GUI 적용
        // return Center(
        //   child: Container(
        //     // width: orientation == Orientation.portrait ? size.width * 0.5 : size.width * 0.2,
        //     // height: orientation == Orientation.portrait ? size.height * 0.1 : size.height * 0.3,
        //     width: size.width,
        //     height: size.height,
        //     child: Image(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/splash_img.png'),
        //     ),
        //   ),
        // );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height * 0.75,
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/splash/splash_img.png'),
              ),
            ),
            Container(
              width: size.width,
              height: size.height * 0.15,
              color: Colors.white,
              child: Image(
                fit: BoxFit.contain,
                image: AssetImage(keynoteImageList[nCount]),
                gaplessPlayback: true,
              ),
            ),
            Container(
              width: size.width,
              height: size.height * 0.1,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                '잠시만 기다려주세요...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
          ],
        );

        // return Stack(
        //   children: <Widget>[
        //
        //     Positioned(
        //       top: size.height * 0.3,
        //       left: 0,
        //       child: Container(
        //         width: size.width,
        //         height: size.height * 0.3,
        //         color: Colors.white,
        //         child: Image(
        //           fit: BoxFit.contain,
        //           image: AssetImage(keynoteImageList[nCount]),
        //           gaplessPlayback: true,
        //         ),
        //       ),
        //     ),
        //
        //     Positioned(
        //       top: 0,
        //       left: 0,
        //       child: Container(
        //         width: size.width,
        //         height: size.height,
        //         decoration: BoxDecoration(
        //           image: DecorationImage(
        //               image: AssetImage('assets/images/splash/splash_img-removebg-preview.png'),
        //               fit: BoxFit.fill
        //           ),
        //         ),
        //       ),
        //     ),
        //
        //     Positioned(
        //       top: size.height * 0.8,
        //       left: 0,
        //       child: Container(
        //       width: size.width,
        //       height: size.height * 0.1,
        //       color: Colors.white,
        //       alignment: Alignment.center,
        //       child: Text(
        //         '잠시만 기다려주세요...',
        //          style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           fontSize: 26,
        //          ),
        //        ),
        //       ),
        //     ),
        //
        //   ],
        // );
      },

      ///SJW Modify 2022-05-31 End...1
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    timer = null;
    chkTime!.cancel();
    chkTime = null;
    SystemChrome.setPreferredOrientations([]);
    print('dispos splash screnn');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //디바이스 사이즈 [넓이, 높이]
    Size _size = MediaQuery.of(context).size;

    List<String> _scoreImageList = [
      'assets/images/test_score1.jpg',
      'assets/images/score_1.jpg',
      // '/data/user/0/com.example.elfscoreprint_mobile_20220531/cache/139686_4000N.TIFF'
    ];

    //이미지 저장
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<ScoreImageProvider>().getScoreImage(_scoreImageList);
    });

    return Platform.isAndroid
        ? MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              body: _displaySplashScreen(_size),
            ),
          )
        : CupertinoApp(
            debugShowCheckedModeBanner: false,
            home: CupertinoPageScaffold(
              backgroundColor: Colors.white,
              child: _displaySplashScreen(_size),
            ),
          );
  }
}
