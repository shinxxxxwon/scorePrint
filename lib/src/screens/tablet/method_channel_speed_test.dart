import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MethodChannelSpeedTest extends StatefulWidget {
  const MethodChannelSpeedTest({Key? key}) : super(key: key);

  @override
  _MethodChannelSpeedTestState createState() => _MethodChannelSpeedTestState();
}

class _MethodChannelSpeedTestState extends State<MethodChannelSpeedTest> {
  static const platform = const MethodChannel("native.flutter.kisatest");

  List<int> _list = [];
  _drawFont() async {


    for(int i=0; i<1000; i++) {
      // Map<String, int> map = {
      //   'fontNo' : i
      // };
      int res = await platform.invokeMethod('dataSpeedTest', i);
      _list.add(res);
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    // _drawFont();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            _list.clear();
            await _drawFont();
            print(_list);
          },
        ),
        body: _list.isEmpty
          ? Text('_list is Empty')
          : ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Icon(IconData(_list[index], fontFamily: 'ElfScore'))
            );
          },
        ),
      ),
    );
  }
}

