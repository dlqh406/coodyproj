import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteAnalysisPage extends StatefulWidget {
  final FirebaseUser user;
  FavoriteAnalysisPage(this.user);

  @override
  _FavoriteAnalysisPageState createState() => _FavoriteAnalysisPageState();
}

class _FavoriteAnalysisPageState extends State<FavoriteAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("favorite Analysis Page")),
      body:  _bodyBuilder(),
    );
  }

  Widget _bodyBuilder() {
    return Text(widget.user.email);
  }
}
