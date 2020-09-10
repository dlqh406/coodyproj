import 'package:coodyproj/root_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'home_page.dart';


void main() {
  KakaoContext.clientId = "31e51f660c7b7a6323b8d7ce2f8467cd";
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: rootPage(),
    );
  }
}
