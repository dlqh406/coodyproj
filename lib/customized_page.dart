import 'package:coodyproj/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/product_detail.dart';

import 'dart:math';

//class CustomPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}




class CustomPage extends StatefulWidget {
  final FirebaseUser user;
  CustomPage(this.user);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {

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
//        TODO:  (완)합치기 => 리스트.length 구해서 .take(리스트.length)로 가져오기 => (완성)랜덤으로 섞기

        var fF = items.where((doc)=> doc['style'] == "오피스룩").toList();
        var half_length = (fF.length/2).round();
        print(half_length);
        var sF = items.where((doc)=> doc['style'] == "로맨틱").take(half_length).toList();
        var tF = items.where((doc)=> doc['style'] == "에스레저").take(half_length).toList();
        fF.addAll(sF);
        fF.addAll(tF);
        fF.shuffle();

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

  Widget _buildListItem(context, DocumentSnapshot document) {
    return
      InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ProductDetail(widget.user, document);
        }));
      },
       child: Image.network(
          document['thumbnail_img'],
          fit : BoxFit.cover)
    );

  }

  Stream<QuerySnapshot> _commentStream() {
    // 여기에 계절분류 코드를 넣으면 됨
   return Firestore.instance.collection("uploaded_product").snapshots();
//    .where("season",whereIn:["FW","WI","SU"])

  }
}


