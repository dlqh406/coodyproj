import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coodyproj/model//drawer_configure.dart';
import 'home_page.dart';


class DrawerScreen extends StatefulWidget {
  final FirebaseUser user;


  DrawerScreen(this.user);
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:  LinearGradient(
            colors: [
              Colors.lightBlue,
              Color(0xff0859c6)
            ],
        ),
      ),
      padding: EdgeInsets.only(top:10,bottom: 70,left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70, left:30.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photoUrl),
                ),
                SizedBox(width: 10,),
                Text('${widget.user.displayName}님 반가워요!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right:18.0),
                )
              ],
            ),
          ),

          Column(
            children: drawerItems.map((element) =>
                Padding(
              padding: const EdgeInsets.only(top: 40.0,right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(element['icon'],color: Colors.white,size: 30,),
                  SizedBox(width: 10,),
                  Text(element['title'],style:
                  TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20))
                ],

              ),
            )).toList(),
          ),

          SizedBox(
            height: 100,
          )
        ],
      ),

    );
  }
}