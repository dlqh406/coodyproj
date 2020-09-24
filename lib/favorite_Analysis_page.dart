import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteAnalysisPage extends StatefulWidget {
  var stopTrigger = 1;
  var unchanging ;
  List<bool>bool_list_each_GridSell =[];

  final FirebaseUser user;
  FavoriteAnalysisPage(this.user);

  @override
  _FavoriteAnalysisPageState createState() => _FavoriteAnalysisPageState();
}

class _FavoriteAnalysisPageState extends State<FavoriteAnalysisPage> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.stopTrigger == 2){
      setState(() {
       widget.unchanging = Firestore.instance.collection("uploaded_product").snapshots();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("favorite Analysis Page")),
      body:  _bodyBuilder(),
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
        var fF = items.where((doc)=> doc['style'] == "오피스룩").toList();
        var sF = items.where((doc)=> doc['style'] == "로맨틱").toList();
        var tF = items.where((doc)=> doc['style'] == "캐주얼").toList();
        fF.addAll(sF);
        fF.addAll(tF);
//        fF.shuffle();

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0),
            itemCount: fF.length,
            itemBuilder: (BuildContext context, int index) {
              for(var i=0; i<fF.length; i++){
                widget.bool_list_each_GridSell.add(false);
              }
              return _buildListItem(context,fF[index],index);
            });
      },
    );
  }
  Widget _buildListItem(context, document,index) {

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image : NetworkImage(document['thumbnail_img']),
              fit : BoxFit.cover,
            )
        ),
        child: widget.bool_list_each_GridSell[index]?Container(
            alignment: Alignment.center,
            color: Colors.black38,
            child:Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(60))
                ),
                child:Icon(Icons.check,color: Colors.white,size: 60,)
            )
        ):Container(),
      ),
      onTap: (){
        setState(() {
          widget.bool_list_each_GridSell[index] = !widget.bool_list_each_GridSell[index];
        });
      },
    );
  }

  Stream<QuerySnapshot> _commentStream() {
    widget.stopTrigger +=1;
    print(widget.stopTrigger);
    if(widget.unchanging == 2 ){
      return widget.unchanging;
    }

  }
}


