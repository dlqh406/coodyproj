
import 'package:coodyproj/dashboard.dart';
import 'package:coodyproj/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);

    return StreamBuilder <FirebaseUser>(
      stream : FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return  LoginPage();

        }
        else{
          return DashBoard(snapshot.data);
        }
      },
    );
  }
}
