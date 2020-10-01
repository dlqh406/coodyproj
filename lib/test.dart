import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';


class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);
  bool top_downbtn = false;
  bool bottom_downbtn = false;
  bool dress_downbtn = false;
  bool beachWear_downbtn = false;
  bool outer_downbtn = false;
  bool innerWear_downbtn = false;
  bool fitnessWear_downbtn = false;

  int selectedCount =0;
  var selectedCategoryList=[];
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Demo')),
          body: _buildbody()
      ),
    );
  }

  Widget _buildbody() {
    return Center(
      child: Column(
        children: [
          RaisedButton(
            child: Text("asds"),
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }

}