import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return StreamBuilder(
      stream: Firestore.instance.collection('postProduct').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(child:  CircularProgressIndicator());
        }
        var items =  snapshot.data?.documents ??[];
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {return _buildListItem(context, items[index]);
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
}
