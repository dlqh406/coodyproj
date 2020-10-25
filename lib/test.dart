import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:opencv_histogram_equality/opencv_histogram_equality.dart';

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

    checkSimilairtyTestImages();
  }

  Future<void> checkSimilairtyTestImages() async {
    ByteData first = await rootBundle.load('assets/images/gondola.jpg');
    ByteData second = await rootBundle.load('assets/images/hotel0.jpg');

    OpencvHistogramEquality()
        .similarity(first.buffer.asUint8List(), second.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

