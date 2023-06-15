
import 'dart:async';

import 'package:elfscoreprint_mobile/src/providers/dan_settings_provider.dart';
import 'package:elfscoreprint_mobile/src/providers/pdf_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class FtpController{


  ///FTP 정보 저장 변수
  // FTPConnect _ftpConnect = FTPConnect('211.210.130.24', user: 'SCORE-10', pass: r'1q2w3e$R', port: 50002);
  FTPConnect? _ftpConnect;
  FTPConnect get ftpConnect => _ftpConnect!;

  ///FTP 서버 파일 크기
  Future<int>? _ftpFileSize;
  Future<int> get ftpFileSize => _ftpFileSize!;

  ///다운로드 파일 저장 변수
  File? _file;
  File get file => _file!;

  ///유효성 검사 확인 Flag
  bool _bValidationFile = false;
  bool get bValidationFile => _bValidationFile;

  ///FTP 서버 파일 Path
  String _strFTPFilePath = '';
  String get strFTPFilePath => _strFTPFilePath;

  ///파일저장 경로
  String strSavePath = '';
  // String get strSavePath => _strSavePath;

  String strDownloadPath = '';

  void setSavePath(String strPath){
    strSavePath = strPath;
  }

  void setDownloadSavePath(String strPath){
    strDownloadPath = strPath;
  }
  ///FTP 파일 경로 설정
//==============================================================================
  void setFtpFilePath(int nFileDataType, int nSongNo, int nScoreType, int nSubType, int nViewJeonKanjoo){

    int nResult = ((nSongNo / 100).toInt()) * 100;

    switch(nFileDataType){
    ///C02 File
      case 0:
        _strFTPFilePath = "C02/${nResult.toString()}/${nSongNo.toString()}.C02";
        break;
    ///C01 File
      case 1:
        _strFTPFilePath = "C01/${nResult.toString()}/${nSongNo.toString()}_${nScoreType.toString()}0${(nSubType & 0x0F).toInt()}${nViewJeonKanjoo > 0 ? 'Y' : 'N'}.C01";
        // print('?? : ${nSubType.toString()}');
        break;
    ///ACT File
      case 2:
        _strFTPFilePath = "ACT/${nResult.toString()}/${nSongNo.toString()}.act";
        break;
    ///C03 File
      case 3:
        _strFTPFilePath = "C03/${nResult.toString()}/${nSongNo.toString()}.C03";
        break;
      default:
        _strFTPFilePath = "nFileDataType Error!";
        print("nFileDataType : $nFileDataType}");
        break;

    }
  }
//==============================================================================

//==============================================================================
  Future<void> _fileMock(String strFileName) async {
    try {
      final Directory appDocDir = await getTemporaryDirectory()..createSync(recursive: true);
      String appDocPath = appDocDir.path;
      // print('appDocPath : $appDocPath');
      _file = File('$appDocPath/$strFileName');
      setSavePath('$appDocPath/$strFileName');
      // print('file : $file');
    }catch(e){
      // print('_fileMock Error : ${e.toString()}');

      final File file = File('');
    }
  }
//==============================================================================

  ///FTP연결
//==============================================================================
  //FTP연결 함수
  Future<void> connectionFTP() async {
    String strHost = '127.0.0.1';
    String strUser = 'userId';
    String strPass = 'password';
    int nPort = 80;

    _ftpConnect = FTPConnect(strHost, user: strUser, pass: strPass, port: nPort);

    if(_ftpConnect != null) {
      print('FTP 연결 : ${_ftpConnect.toString()}');
      await _ftpConnect!.connect();
    }
    else{
      for(int nCount=0; nCount<10; nCount++){
        _ftpConnect = FTPConnect(strHost, user: strUser, pass: strPass, port: nPort);
        if(_ftpConnect != null){
          return;
        }
        else{
          _ftpConnect!.disconnect();
        }
      }
    }
  }
//==============================================================================

  ///파일 다운로드
//==============================================================================
  Future<bool> downloadFileFTP(BuildContext context) async{
    bool bCon = false;
    bool bDownloadRes = false;

    try {
      // if(_ftpConnect != null) {
      //   bCon = await _ftpConnect!.connect();
      // }
      //
      // if(bCon){
      //    print('FTP 연결 성공');
      // }
      // else{
      //    print('FTP 연결 실패');
      // }


      await _fileMock('${_strFTPFilePath.split("/").last}');
      // print('_strFTPFilePath.split("/").last : ${_strFTPFilePath.split("/").last}');
      print('start downloadFile');


      bDownloadRes = await _ftpConnect!.downloadFileWithRetry('${_strFTPFilePath}', _file!, pRetryCount: 5);


      if(bDownloadRes) {
         print('다운로드 완료');
        return true;
      }
      else {
         print('다운로드 실패');
      }

    } catch(e){
      print('download Error : ${e.toString()}');
    }
    return false;
  }
//==============================================================================

  ///파일 유효성 검사
//==============================================================================
  Future<bool> checkValidationFile() async {
    _ftpFileSize = _ftpConnect!.sizeFile(_strFTPFilePath);
    // print('유효성 검사 시작');
    if((await _ftpFileSize!) == _file!.lengthSync()){
      ///정상
      print('유효성 검사 통과');
      _bValidationFile = true;

      // print('ftpFileSize : ${(await _ftpFileSize!)}');

      // print('fileSize : ${_file!.lengthSync()}');

      await disconnectFTP();

      return true;

    }else {
      int nRetry = 0;

      ///비정상
      print('유효성 검사 불통과');
      _bValidationFile = false;
      print('ftpFileSize : ${(await _ftpFileSize!)}');

      print('fileSize : ${_file!.lengthSync()}');
      await deleteAppFile();
      await disconnectFTP();

      return false;
    }
  }
//==============================================================================

  ///FTP 연결 해제
//==============================================================================
  Future<void> disconnectFTP() async {
    try {
      await _ftpConnect!.disconnect();
      print('연결 해제');
    }catch(e){
      print('disconnect Error : ${e.toString()}');
    }
    //  notifyListeners();
  }
//==============================================================================

  ///다운로드한 파일 삭제
//==============================================================================
  Future<void> deleteAppFile() async{
    try {
      await _file!.delete();
      print('삭제 성공!!');
    }catch(e){
      print('delete Error : ${e.toString()}');
    }
  }
//==============================================================================

}