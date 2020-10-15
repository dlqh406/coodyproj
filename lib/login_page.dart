import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

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
      body: Container(
        decoration: new BoxDecoration(
        image: new DecorationImage(
        image: new NetworkImage('https://c.pxhere.com/images/f2/b7/eca8a1b0f46b7affb1f249377808-1597347.jpg!d'),
        fit: BoxFit.cover,)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
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
              Padding(
                padding: EdgeInsets.only(bottom:90),
              )
            ],
          ),
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
    return  showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
          image: Image.network(
            "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
            fit: BoxFit.cover,
          ),
          entryAnimation: EntryAnimation.TOP_LEFT,
          title: Text(
            '확인해주세요',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22.0, fontWeight: FontWeight.w700),
          ),
          description: Text(
            '이미 가입이 되어있는 이메일입니다 \n 다른 SNS계정으로 시도해보세요',
            textAlign: TextAlign.center,
          ),
          buttonOkColor: Colors.blue,
          onlyOkButton: true,
          onOkButtonPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }

}