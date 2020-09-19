import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteAnalysisPage extends StatefulWidget {
  final FirebaseUser user;
  FavoriteAnalysisPage(this.user);

  @override
  _FavoriteAnalysisPageState createState() => _FavoriteAnalysisPageState();
}

class _FavoriteAnalysisPageState extends State<FavoriteAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("favorite Analysis Page")),
      body:  _bodyBuilder(),
    );
  }

  Widget _bodyBuilder() {
    //  TODO : 그 예시를 어떻해 stream View로 보여줄것인가
    return StreamBuilder <QuerySnapshot>(
      stream: _commentStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(child:  CircularProgressIndicator());
        }
        var items =  snapshot.data?.documents ??[];
//        TODO:  (완)합치기 => 리스트.length 구해서 .take(리스트.length)로 가져오기 => (완성)랜덤으로 섞기

        var fF = items.where((doc)=> doc['style'] == "오피스룩").toList();
        var sF = items.where((doc)=> doc['style'] == "로맨틱").toList();
        var tF = items.where((doc)=> doc['style'] == "에스레저").toList();
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



  Widget _buildListItem(context, document) {
    return InkWell(
        splashColor: Colors.brown.withOpacity(0.5),
     child:Image.network(
         document['thumbnail_img'],
         fit : BoxFit.cover
     )
    );
  }

  Stream<QuerySnapshot> _commentStream() {
    // 여기에 계절분류 코드를 넣으면 됨
    return Firestore.instance.collection("uploaded_product").snapshots();
    //.where("season",whereIn:["FW","WI","SU"])

  }
}


