import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TestPage extends StatefulWidget {
  final FirebaseUser user;
  TestPage(this.user);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text('Tst'),
        ),
      );
  }
}

