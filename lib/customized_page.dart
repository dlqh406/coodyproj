import 'package:coodyproj/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CustomPage extends StatefulWidget {
  var stopTrigger = 1;
  var unchanging ;
  List<bool>bool_list_each_GridSell =[];
  List<String> styleList = [];
  var tf_copy = [];
  final FirebaseUser user;
  CustomPage(this.user);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  @override
  void initState() {
    super.initState();
    if(widget.stopTrigger == 1){
      setState(() {
        widget.unchanging = Firestore.instance.collection("uploaded_product").snapshots();
      });
    }
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
        var fF = items.where((doc)=> doc['style'] == "오피스룩").toList();
        var sF = items.where((doc)=> doc['style'] == "로맨틱").toList();
        var tF = items.where((doc)=> doc['style'] == "캐주얼").toList();
        fF.addAll(sF);
        fF.addAll(tF);
        widget.tf_copy.addAll(fF);
        if(widget.stopTrigger == 2 ){
          fF.shuffle();
          widget.unchanging = fF;
        }
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,),
            itemCount: fF.length,
            itemBuilder: (BuildContext context, int index) {
              for(var i=0; i<fF.length; i++){
                widget.bool_list_each_GridSell.add(false);
              }
              return _buildListItem(context,widget.unchanging[index]);
            }
        );


      },
    );
  }

  Widget _buildListItem(context, document) {
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
    widget.stopTrigger +=1;
    if(widget.stopTrigger == 2 ){
      return widget.unchanging;
    }
  }
}


