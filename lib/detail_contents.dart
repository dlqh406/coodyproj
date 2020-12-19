import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;

class DetailContents extends StatefulWidget {
  bool _heart = false;
  final title, date, detail_img;
  var docID;

  DetailContents(this.title,this.date,this.detail_img);

  @override
  _DetailContentsState createState() => _DetailContentsState();
}

class _DetailContentsState extends State<DetailContents> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              child: Image.network("${widget.detail_img}",fit: BoxFit.cover,))),
      floatingActionButton:
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('magazine').snapshots(),
            builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
             }
              var aa = snapshot.data.documents.where((element) => element['date'] == widget.date).toList();
              var bb = aa[0].documentID;
              var cc = aa[0]['like'];
              if ( cc==null){
                cc = 0;
              }
              return SizedBox(
                width: 65,
                height: 65,
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  onPressed: () {

                    if( widget._heart == false){
                      final data = {
                        'like': cc + 1,
                      };
                      // 댓글 추가
                      Firestore.instance
                          .collection('magazine')
                          .document(bb).updateData(data);
                      setState(() {
                        widget._heart = true;
                      });
                    }

                    else if( widget._heart == true){
                      final data = {
                        'like': cc - 1,
                      };
                      // 댓글 추가
                      Firestore.instance
                          .collection('magazine')
                          .document(bb).updateData(data);
                      setState(() {
                        widget._heart = false;
                      });
                    }

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right : 0.0),
                    child: widget._heart==true?Icon(Icons.favorite,color: Colors.redAccent,):Icon(Icons.favorite,color: Colors.grey,),
                  ),
                ),
              );
            }
          ),
          SizedBox(
            height:10
          ),
          SizedBox(
            width: 65,
            height: 65,
            child: RaisedButton(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right : 2.0),
                child:Icon(Icons.arrow_back_ios,color: Colors.white,),
              ),
            ),
          ),
        ],
      )
    );
  }



}