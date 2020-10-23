import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class TestPage extends StatefulWidget {
  final FirebaseUser user;
  TestPage(this.user);




  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHasReview(context),
    );
  }

  Widget _buildHasReview(context) {
    return AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
      ..scale(scaleFactor)..rotateY(isDrawerOpen? -0.5:0),
    duration: Duration(milliseconds: 250),
    decoration: BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)
    ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isDrawerOpen?IconButton(
                icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
                onPressed: (){
                  setState(() {
                    xOffset=0;
                    yOffset=0;
                    scaleFactor=1;
                    isDrawerOpen=false;

                  });
                },

              ): IconButton(
                  icon: Icon(Icons.menu, color: Colors.blue),
                  onPressed: () {
                    setState(() {
                      xOffset = 230;
                      yOffset = 150;
                      scaleFactor = 0.6;
                      isDrawerOpen=true;
                    });
                  }),
            ],
          )
      ));


  }


}
