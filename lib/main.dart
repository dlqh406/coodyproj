import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coodyproj/splash_page/splash_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      systemNavigationBarIconBrightness: Brightness.dark,
//        systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coody',
      theme: ThemeData(
        fontFamily: 'Kopup',
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}
