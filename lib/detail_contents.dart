import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;

class DetailContents extends StatefulWidget {

  final title, date, detail_img;

  DetailContents( this.title, this.date, this.detail_img);

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
      Visibility(
        visible: !Platform.isAndroid,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:31.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                backgroundColor: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }



}