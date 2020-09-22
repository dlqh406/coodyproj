import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProductDetail extends StatelessWidget {
  final DocumentSnapshot document;
  final FirebaseUser user;

  ProductDetail(this.user,this.document);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Column(),),
              Container(
                height: size.height *0.8,
                width: size.width *0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(63),
                    bottomLeft: Radius.circular(63)

                  ),
                  image: DecorationImage(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.cover,
                    image: NetworkImage(document['thumbnail_img']))
                  )
                ),
              ],
          )
        ],
      ),
    );
  }


}
