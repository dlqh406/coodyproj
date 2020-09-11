import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("AppBar"),),
        body: _buildBody()
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        children: [
          Text('Hello world'),
          RaisedButton(
            child: Text("logout"),
            onPressed: () {

            },
          )
        ],
      ),
    );
  }
}