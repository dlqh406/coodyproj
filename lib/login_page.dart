import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kakao_flutter_sdk/all.dart';


class loginPage extends StatefulWidget {

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in',
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.all(50.0),),
            SignInButton(Buttons.Google, onPressed: (){

            },)


          ],
        ),
      ),
    );
  }
}


