import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';


class CustomPage extends StatefulWidget {
  final FirebaseUser user;
  CustomPage(this.user);



  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  var randomNumber =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Random random = new Random();
    setState(() {
      randomNumber = random.nextInt(2);
    });


  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: _bodyBuilder(),
        ),
      ),
    );
  }

  Widget _bodyBuilder() {
    return StreamBuilder <QuerySnapshot>(
      stream: _commentStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(child:  CircularProgressIndicator());
        }
        var items =  snapshot.data?.documents ??[];
//        converting

        var fF = items.where((doc)=> doc['season'] == "WI").toList();
        var sF = items.where((doc)=> doc['season'] == "SU").toList();
        fF.addAll(sF);
//
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0),
            itemCount: fF.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(context, fF[index]);
            });
      },
    );
  }

  Widget _buildListItem(context, document) {
    return
//      InkWell(
//      onTap: (){
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          return DetailPostPage(document);
//        }));
//      },
       Image.network(
          document['thumbnail_img'],
          fit : BoxFit.cover);
//    );

  }

  Stream<QuerySnapshot> _commentStream() {
   return Firestore.instance.collection("postProduct").where("season",whereIn:["FW","WI","SU"]).snapshots();

  }
}


