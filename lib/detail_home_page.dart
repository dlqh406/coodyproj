import 'package:flutter/material.dart';
import 'element_homepage/contents_carousel.dart';
import 'element_homepage/gridView_of_homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;
  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("로고 --- 기다란둥근 사각형 --- 메뉴점점점")),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        children: <Widget>[
          // top destination List
          ContentsCarousel(),
          SizedBox(height: 20.0),
          // hotel List
          gridViewOfCustomizedView(widget.user),
        ],
      ),

    );
  }
}
