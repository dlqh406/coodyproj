import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_product.dart';
import 'package:intl/intl.dart';

class DetailLetterPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;
  var data;
  final FirebaseUser user;
  DetailLetterPage(this.user,this.data);

  @override
  _DetailLetterPageState createState() => _DetailLetterPageState();
}

class _DetailLetterPageState extends State<DetailLetterPage> {
  @override
  void initState() {
    super.initState();
    if( widget.data['state'] == "completion"){
      final data = {
        'state' : 'saw'
      };
      Firestore.instance
          .collection('inquiry_data')
          .document(widget.data.documentID)
          .updateData(data);
    }

  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
        appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),
            child:
            AppBar(
              titleSpacing: 6.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 00.0),
                child: Container(
                  child: GestureDetector(
                      child: Icon(Icons.arrow_back_ios,size: 18,),

                      onTap: (){
                        Navigator.pop(context);

                      }),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right:10.0),
                  child: new IconButton( icon: new Icon(Icons.home,size: 23,),
                    onPressed: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
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
        widget.data['state']=="board"?Container():buildMyQState(),
        SizedBox(
          height: 15,
        ),
        myQ(),
        SizedBox(
          height: 15,
        ),
        widget.data['answer'] == ""?Container():sellerAnswer()
      ],
    );
  }
  Widget buildMyQState() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('seller_data').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),),);
              // Text("쪽지함이 비어 있습니다",style: TextStyle(color: Colors.grey)
            }
            //레드 스크린 뜰 가능성
            var sellerCodeList = [];
            for( var i=0; i< snapshot.data.documents.length; i++){
              sellerCodeList.add(snapshot.data.documents[i].documentID);
            }
            return Column(
              children: [
                for( var i=0; i< sellerCodeList.length; i++)
                  StreamBuilder(
                      stream: Firestore.instance.collection('seller_data').document(sellerCodeList[i]).collection('inquiry').snapshots(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.blue),),);
                        }
                        var _list = snapshot.data.documents.where((doc) => doc['userID'] == widget.user.uid).toList();
                        return _stateMyQ(_list[i].data,i);

                      }
                  ),
              ],
            );
            // return Column(
            //   children: [
            //     for(var i=0; i< list.length; i++)
            //     _buildBestSelling0(list[i].data,i)
            //   ],
            // );
          }
      ),
    );
  }
  Widget _stateMyQ(doc,index)
  {

    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('uploaded_product').document(doc['productCode']).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),),);
            // Text("쪽지함이 비어 있습니다",style: TextStyle(color: Colors.grey)
          }
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return ProductDetail(widget.user, doc);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(left:18.0,top:10,right:18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(10,23),
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
                              padding: const EdgeInsets.only(right:8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: FadeInImage.assetNetwork(
                                    placeholder:'assets/images/19.png',
                                    image: snapshot.data.data['thumbnail_img'],
                                    fit: BoxFit.cover,width: 80,height: 80),
                              )),
                          Expanded(
                            child: Container(
                              height: 75,
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
                                          state(),
                                          Text('${snapshot.data.data['productName']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          Text('${_timeStampToString(doc['date'])} 문의 등록',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black)),
                                        ],
                                      ),
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
  Widget myQ() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(10,23),
              blurRadius: 40,
              color: Colors.black12,
            ),
          ],
        ),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 17,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child:
              Row(
                children: [
                  widget.data['state']!='board'?Text("나의 질문",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)):Text("공지 사항",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20,right: 20,top:12),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Text('${widget.data['question']}')
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 17,
            )
          ],
        ),
      ),
    );
  }
  Widget sellerAnswer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(10,23),
              blurRadius: 40,
              color: Colors.black12,
            ),
          ],
        ),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 17,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child:
              Row(
                children: [
                  Text("판매자 답변",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20,right: 20,top:12),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(

                        child:
                        Text('${widget.data['answer']}')
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 17,
            )
          ],
        ),
      ),
    );
  }

  Widget state(){

    if(widget.data['state'] == 'ongoing'){
      return Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Text("답변 전",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.deepOrangeAccent),),
        );
    }
    else if(widget.data['state'] == 'completion' || widget.data['state'] == 'saw') {
      return Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Text("답변 완료",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
        );
    }
    else if(widget.data['board']){
      return Padding(
        padding: const EdgeInsets.only(bottom:5.0),
        child: Text("공지 사항",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green),),
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
  Widget _clearBtn(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 46,
        width: MediaQuery.of(context).size.width*1,
        child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),),
          color: Colors.blueAccent,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => null));
          },
          child: const Text('바로 구매하기',
              style: TextStyle(color: Colors.white, fontSize: 13,fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

}