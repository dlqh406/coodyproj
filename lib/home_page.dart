import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorite_analysis_page.dart';
import 'loading_page.dart';
import 'favorite.dart';


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
    // 여기에 스트림
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("user_data").document(widget.user.email).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data.data == null){
            return FavoriteAnalysisPage(widget.user);

          }else{
            return Scaffold(
                appBar: AppBar(title: Text("Home page"),),
                body: _buildBody()
            );
          }
        }else{
          return LoadingPage();
        }

      }
    );
    }

  Widget _buildBody() {
    return Center(
      child: Column(
        children: [
          Text(widget.user.displayName),
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
                MaterialPageRoute(builder: (context) => Favorite(widget.user)));
          },
          )
        ],
      ),
    );
  }
}