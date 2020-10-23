import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailReview extends StatefulWidget {

  final DocumentSnapshot document;
  final FirebaseUser user;
  final int length;

  final ScrollController _controllerOne = ScrollController();
  DetailReview(this.user, this.document, this.length);

  @override
  _DetailReviewState createState() => _DetailReviewState();
}

class _DetailReviewState extends State<DetailReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHasReview(context, widget.length),
    );
  }

  Widget _buildHasReview(context, length) {
    Size size = MediaQuery.of(context).size;
    var reviewCount = length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 30.0, right: 10.0, left: 10.0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("실사용 리뷰",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 20),
                    child: reviewCount > 0
                        ? Text("4.7", style: TextStyle(fontSize: 38))
                        : Text("아직 후기가 없습니다",
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ),
                  if(reviewCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Column(
                        // ignore: sdk_version_ui_as_code, sdk_version_ui_as_code
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('총 ${reviewCount}개 리뷰'),
                          Image.asset('assets/star/star1.png', width: 110,)
                        ],
                      ),
                    )
                ],
              ),
            ),
            Visibility(
              visible: reviewCount > 0 ? true : false,
              child: Container(
                height: size.height*0.7,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _commentStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return CupertinoScrollbar(
                        controller: widget._controllerOne,
                        isAlwaysShown: true,
                        child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          controller: widget._controllerOne,
                            itemBuilder: (BuildContext context, int index){
                              return _buildListView(context, snapshot.data.documents[index], index);
                            }
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, doc, int index) {
    Size size = MediaQuery.of(context).size;

  return Padding(
    padding: const EdgeInsets.only(left:15.0,right: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(doc['writer'], style: TextStyle(
            fontWeight: FontWeight.bold),),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Image.asset(
                  'assets/star/star1.png', width: 75),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5.0),
                child: Text(
                  _timeStampToString(doc['date']),
                  style: TextStyle(fontSize: 12),),
              )
            ],
          ),
        ),
        doc['img'] == null ? Visibility(
          visible: false, child: Text(""),) : Padding(
          padding: const EdgeInsets.only(right: 10,top:15,bottom: 15),
          child: Container(
              width: 100,
              height: 100,
              child: Image.network(
                doc['img'], fit: BoxFit.cover,)),
        ),
        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: SizedBox(
              width: size.width * 1,
              child: Text(doc['review'],style: TextStyle(fontSize: 14),)),
        ),
        Opacity(
            opacity: 0.15,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15.0),
                child: Container(
                  height: 1,
                  color: Colors.black38,
                ))),

      ],
    ),
  );
  }
  Stream<QuerySnapshot> _commentStream() {
    return Firestore.instance.collection('uploaded_product')
        .document(widget.document.documentID).collection('review').orderBy(
        'date', descending: true)
        .snapshots();
  }
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }
}
