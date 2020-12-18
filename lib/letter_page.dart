import 'package:coodyproj/detail_letter.dart';
import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_product.dart';
import 'package:intl/intl.dart';
class LetterPage extends StatefulWidget  {
  bool more_Btn = true;
  bool cancel_Btn = false;
  var aa =[];

  final FirebaseUser user;
  LetterPage(this.user);
  @override
  _LetterPageState createState() => _LetterPageState();
}
class _LetterPageState extends State<LetterPage> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(40.0),
            child:
            AppBar(
              titleSpacing: 6.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 00.0),
                child: Container(
                  child: GestureDetector(
                      child: Icon(Icons.arrow_back_ios, size: 18,),

                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: new IconButton(icon: new Icon(Icons.home, size: 23,),
                    onPressed: () =>
                    {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return Home(widget.user);
                      }))
                    },
                  ),
                ),
              ],

            )),
        body: _bodyBuilder(),
      ),
    );
  }

  Widget _bodyBuilder() {
    return ListView(
      children: [
        _buildTitleBar(),
        _gridBuilder(),
      ],
    );
  }

  Widget _buildTitleBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 20.0, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("나의 쪽지함",
                style: TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -1,),),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gridBuilder() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('inquiry_data').orderBy(
              'date', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),),);
            }
            var _list = snapshot.data.documents.where((doc) =>
            doc['userID'] == widget.user.uid).toList();

            return Column(
              children: [
                for( var i = 0; i < _list.length; i++)
                  _buildBestSelling(_list[i], i),
              ],
            );
          }
      ),
    );
  }


  Widget _buildBestSelling(doc, index) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('uploaded_product').document(doc['productCode']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Colors.blue),),);
          }
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailLetterPage(widget.user, doc);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 10, right: 18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(10, 23),
                      blurRadius: 40,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/19.png',
                                    image: snapshot.data.data['thumbnail_img'],
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80),
                              )),
                          Expanded(
                            child: Container(
                              height: 75,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              state(doc['state']),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              doc['state'] != 'ongoing'
                                                  ? Text('${_timeStampToString(
                                                  doc['replyDate'])}')
                                                  : Container()
                                            ],
                                          ),
                                          Visibility(
                                            visible: doc['state']=='board'?false:true,
                                            child: Column(
                                              children: [
                                                Text('${snapshot.data
                                                    .data['productName']}',
                                                    style: TextStyle(fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis),
                                                Text('${_timeStampToString(
                                                    doc['date'])} 문의 등록',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.black)),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_ios,
                                        color: Colors.black, size: 20,),
                                      SizedBox(
                                        width: 15,
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

                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  // ignore: missing_return
  Widget state(val) {
    if (val == 'ongoing') {
      return
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text("답변 전", style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrangeAccent),),
        );
    }
    else if (val == 'completion' || val == 'saw') {
      return
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text("답변 완료", style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),),
        );
    }
    else if(val =='board') {
      return
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text("공지 사항", style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),),
        );
    }
  }
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }

  String numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }

}