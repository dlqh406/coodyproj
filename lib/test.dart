import 'package:flutter/material.dart';


class TestPage extends StatefulWidget {
  bool showFab = true;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('HomeView')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: buildBottomSheet
          );
        },
        child: Icon(Icons.add),
      )
    );
  }


  Widget buildBottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(child: Icon(Icons.close,),onTap:(){
            Navigator.pop(context);
          }),
         Text("asd"),
        ],
      ),
    );
  }
}
