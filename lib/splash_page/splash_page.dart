import 'dart:async';
import 'package:coodyproj/home.dart';
import 'package:coodyproj/home_page.dart';
import 'package:coodyproj/login_page.dart';
import 'package:coodyproj/root_page.dart';
import 'package:coodyproj/search_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  var isLogged = true;


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
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
      // print("true123");
      // print('456:s ${widget.isLogged}');
      Navigator.push(context,
          MaterialPageRoute(builder: (context){
            return RootPage();
          }));

  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [

          Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Center(child: Image.asset('assets/logo/logo.png',width: 150,)),

                    ],
                  ),
                ),
              ),

            ),
          ),

        ],

      ),
    );
  }
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

}


