import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'detail_product.dart';
import 'dart:io' show Platform;

class RecentPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;

  final FirebaseUser user;
  RecentPage(this.user);

  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {

    @override
    Widget build(BuildContext context) {
      return Container(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading:  IconButton(
                icon: Icon(Icons.arrow_back_ios,size: 19,color: Colors.white,),
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom:5.0),
                child: new IconButton( icon: new Icon(Icons.more_vert,size: 28,color: Colors.white,),
                    onPressed: () => {
                    }),
              ),
            ],
          ),
          backgroundColor: Color(0xff142035),
          body: _bodyBuilder(),
        ),
      );
    }
    Widget _bodyBuilder() {
      return ListView(
        children: [
          _buildTitleBar(),
          _gridBuilder()
        ],
      );
    }
    Widget _buildTitleBar() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:15,left:20.0,bottom: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("최근 본 상품",
                  style: TextStyle(
                    fontSize: 37, fontWeight: FontWeight.bold,color: Colors.white, letterSpacing:-1,),),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,bottom:3),
                  child: Text('최대 30개',style: TextStyle(color: Colors.white),),
                )
              ],
            ),
          ),
        ],
      );
    }
    Widget _gridBuilder() {
      return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('user_data')
                .document(widget.user.uid).collection('recent')
                .orderBy('date',descending: true).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child:Text("최근본 상품이 없습니다",style: TextStyle(color: Colors.grey),));
              }
              var Doc_length;
              for(var i= snapshot.data.documents.length-1; i>0; i--){
                for(var j=0; j<i; j++){
                    if(snapshot.data.documents[i]["docID"] == snapshot.data.documents[j]['docID']){
                      Firestore.instance.collection('user_data').document(widget.user.uid)
                          .collection('recent').document(snapshot.data.documents[i].documentID).delete();
                    }
                }
              }
              //30개
              if(snapshot.data.documents.length < 30){
                Doc_length=snapshot.data.documents.length;
              }
              //31개~
              else{
                Doc_length=30;
                for(var i=30; i< snapshot.data.documents.length; i++) {
                  Firestore.instance.collection('user_data').document(widget.user.uid)
                      .collection('recent').document(snapshot.data.documents[i].documentID).delete();
                }
              }
              return Column(
                children: [
                  for(var i=0; i< Doc_length; i++)
                  StreamBuilder(
                    stream: Firestore.instance.collection('uploaded_product')
                        .document("${snapshot.data.documents[i]['docID']}").snapshots(),
                    builder: (context, _snapshot) {
                      if(!_snapshot.hasData){
                        return Center(child: CircularProgressIndicator());
                      }
                      return _buildBestSelling(_snapshot.data,i);
                    }
                  ),
                ],
              );
            }
        ),
      );
    }

    Widget _buildBestSelling(doc,index){

      return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ProductDetail(widget.user, doc);
          }));
        },
        child: Padding(
          padding: const EdgeInsets.only(left:18.0,top:10,right:18),
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(doc['thumbnail_img'],
                        fit: BoxFit.cover,width: 75,height: 75,)),
                ),
                Expanded(
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: Container(
                        width: 150,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("캐주얼 노멀 하이퀄 니트",style: TextStyle(fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(doc['category'],style: TextStyle(fontWeight: FontWeight.w700,color: Colors.blue)),
                                Padding(
                                  padding: const EdgeInsets.only(top:3.0),
                                  child: Text("₩12,900",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.cancel,color: Colors.grey,size: 15,),
                              onPressed: (){
                                print(doc.documentID);
                                Firestore.instance.collection('user_data').document(widget.user.uid).collection('recent')
                                    .orderBy('date',descending: true).getDocuments().then((value) {
                                  Firestore.instance.collection('user_data').document(widget.user.uid)
                                      .collection('recent').document(value.documents[index].documentID).delete();
                                });
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );

    }
    String _timeStampToString(date) {
      Timestamp t = date;
      DateTime d = t.toDate();
      var list = d.toString().replaceAll('-', '.').split(" ");
      return list[0];
    }

  }
