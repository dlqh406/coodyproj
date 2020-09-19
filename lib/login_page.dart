import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Instagram Clon',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.all(50.0),
            ),
            SignInButton(
              Buttons.Google,
              onPressed: () {
                _handleG_SignIn().then((user) {
                  print(user);
                  print('111');
                });
              },
            ),
            SignInButton(
              Buttons.Facebook,
              onPressed: () {
                _handleF_SignIn().then((user) => print(user)).catchError((e)=> {
                  _showMyDialog()
                }
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleG_SignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = (await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken))).user;
    print("signed in " + user.displayName);
    return user;
  }
  Future<FirebaseUser> _handleF_SignIn() async {
    FacebookLoginResult result = await facebookLogin.logIn(['email', 'public_profile']);
    AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
    AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    print(user);
    print("signed in " + user.displayName);
    return user;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text("확인해주세요 🙏"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('이미 가입이 되어있는 이메일입니다'),
                Text('다른 SNS계정으로 시도해보세요'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}