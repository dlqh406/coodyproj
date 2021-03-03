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
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    if(widget.isLogged = false){
      Navigator.push(context,
          MaterialPageRoute(builder: (context){
            return LoginPage();
          }));
    }
    else{
      Navigator.push(context,
          MaterialPageRoute(builder: (context){
            return RootPage();
          }));
    }

  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    Random random = new Random();
    int randomNumber = random.nextInt(4);
    print(randomNumber);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
      StreamBuilder <FirebaseUser>(
      stream : FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            setState(() {
              widget.isLogged = false;
            });
            return  LoginPage();
          }
          else{
            setState(() {
              widget.isLogged = false;
            });
            return Stack(
                  children:[
                    SearchPage(snapshot.data,0),
                    HomePage(snapshot.data),
                  ]
                  );
              }
            },
          ),
          Container(
            child: Scaffold(
              backgroundColor: Colors.indigoAccent,
              body: Container(
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      _getColorFromHex('00e5ff'),
                      _getColorFromHex('1200ff'),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Image.asset('assets/logo/whitehor.png',width: 250,),
                      SizedBox(height: 30,),

                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        ],
                      ),
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


