import 'package:coodyproj/Tab_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login_page.dart';


//root: 뿌려주는 페이지니깐 stateless로
class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <FirebaseUser>(
      stream : FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          print("already logged in");
          return homePage(snapshot.data);
        }
        else{
          print("not logged ");
          return LoginPage();
        }
      },
    );
  }
}

