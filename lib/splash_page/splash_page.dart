import 'dart:async';
import 'package:coodyproj/home.dart';
import 'package:coodyproj/root_page.dart';
import 'package:flutter/material.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();

}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.push(context,
    MaterialPageRoute(builder: (context){
     return RootPage();
     }));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.asset('assets/images/office.jpg'),
      ),
    );
  }
}
