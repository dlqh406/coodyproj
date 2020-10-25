import 'package:coodyproj/home_page.dart';
import 'package:coodyproj/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'favorite_analysis_page.dart';
import 'login_page.dart';
import 'home.dart';

//root: 뿌려주는 페이지니깐 stateless로
class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder <FirebaseUser>(
      stream : FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return SearchPage(snapshot.data);
        }
        else{
          return LoginPage();
        }
      },
    );
  }
}
