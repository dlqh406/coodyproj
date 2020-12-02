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
    var _duration = new Duration(seconds: 5);
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
            return  LoginPage();
          }
          else if(snapshot.hasData){
            return Stack(
                  children:[
                    SearchPage(snapshot.data,0),
                    HomePage(snapshot.data),
                  ]
                  );
          }
          else{
            return Stack(
                children:[
                  SearchPage(snapshot.data,0),
                  HomePage(snapshot.data),
                ]
            );
          }
        },
      ),



          Scaffold(
            body: Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage('assets/splash/${randomNumber+1}.png'),
                    fit: BoxFit.cover,)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(bottom: 58.0, left:30),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFff6e6e),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.0),
                                    child: Text("쿠디 런칭 이벤트",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 5),

                          Row(
                            children: [
                              Text('구매 적립 ',style: TextStyle(fontSize: 25,color: Colors.white)),
                              Text('2%',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text("포토후기 ",style: TextStyle(fontSize: 25,color: Colors.white),),
                              Text("500원 적립",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text('(2021년 4월 15일까지)',style: TextStyle(fontSize: 13,color: Colors.white)),
                        ],
                      ),
                    ),

                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("사용자 데이터를 로드하고있습니다",style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Image.asset(
                              'assets/splash/loading.gif',
                              width: 110),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ),

        ],

      ),
    );
  }

}


