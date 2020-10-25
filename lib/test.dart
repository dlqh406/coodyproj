import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TestPage extends StatefulWidget {
  final FirebaseUser user;
  TestPage(this.user);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on:'),
        ),
      ),
    );
  }
}

