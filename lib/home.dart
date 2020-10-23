import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer_screen.dart';
import 'home_page.dart';


class Home extends StatelessWidget {
  final FirebaseUser user;
  Home(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(user),
          HomePage(user),
        ],
      ),

    );
  }
}