import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'customized_page.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();

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
              facebookLogin.logOut();
            },
          ),
          RaisedButton(
            child: Text("Customized PIC"),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomPage(widget.user)));
          },
          )
        ],
      ),
    );
  }
}