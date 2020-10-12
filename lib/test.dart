import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';


class TestPage extends StatefulWidget {

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Demo')),
      ),
    );
  }

}