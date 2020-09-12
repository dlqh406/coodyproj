import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class homePage extends StatefulWidget {
  final FirebaseUser user;
  homePage(this.user);


  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("AppBar"),),
        body: _buildBody()
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        children: [
          Text('Hello world'),
          RaisedButton(
            child: Text("logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              _googleSignIn.signOut();
            },
          )
        ],
      ),
    );
  }
}