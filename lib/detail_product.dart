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
      body: _buildBody(context),
//
//      floatingActionButtonLocation:
//        FloatingActionButtonLocation.centerDocked,
//        floatingActionButton: Padding(
//          padding: const EdgeInsets.only(bottom: 15,left: 17,right: 17),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Container(
//                  decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.all(Radius.circular((29))),
//                  boxShadow: [
//                      BoxShadow(
//                        color: Colors.grey.withOpacity(0.5),
//                        spreadRadius: 2,
//                        blurRadius: 7,
//                        offset: Offset(0, 5), // changes position of shadow
//                      ),
//                    ],
//                    gradient: LinearGradient(
//                        begin: Alignment.topRight,
//                        end: Alignment.bottomLeft,
//                        colors: [Colors.lightBlueAccent, Colors.blueAccent])
//                      ),
//              width: size.width*0.73,
//              height: 60.0,
//              child: new RawMaterialButton(
//                shape: new CircleBorder(),
//                elevation: 0.0,
//                child: Text("구매하기",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white),),
//                onPressed: (){},
//              )),
//
//              Container(
//                height: 60,
//                child: FloatingActionButton(
//                  onPressed: () {},
//                  child: Image.asset('assets/icons/cart_blue.png',width: 30,),
//                ),
//
//              )
//            ],
//          ),
//        )

    );
  }

  Widget _buildBody(BuildContext context) {
  return ListView(
    children: [
      _buildPriceInfoBody(context),
      _buildFirstBody(context),
      _buildReviewBody(context)
    ],
  );
  }

  Widget _buildPriceInfoBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15,right: 20,left: 20,bottom:20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(document['category'],style: TextStyle(fontWeight: FontWeight.bold),),
              Container(
                  width: 220,
                  child: Text(document['productName'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:12.0),
            child: Row(
              children: [
                Text('₩ '),
                Text('39,000',style: TextStyle(fontWeight: FontWeight.w500,fontStyle:  FontStyle.italic,fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFirstBody(context) {
   Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          SizedBox(
            height: size.height *0.75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width:93,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:6),
                    child: Padding(
                      padding: const EdgeInsets.only(top : 10.0),
                      child: Column(
                        // -  당일배송가능 여부// - 우수판매자 // 0핀매자 썸내일 // 소재 // 카테고리종류//- 무료배송
                        children: [

                          IconButton(icon : Icon(Icons.arrow_back_ios,color:Colors.black),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },),
                          Padding(
                            padding: const EdgeInsets.only(top:60.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:3.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.lightBlueAccent,
                                          backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/coody-f21eb.appspot.com/o/ml%2FblackB.png?alt=media&token=a457de59-01ef-4dc6-bbab-4ce47f8f9345"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Text(''),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:4.0),
                                        child: Image.asset('assets/icons/free-shipping.png',width: 45,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('무료배송'),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:4.0),
                                        child: Image.asset('assets/icons/fast-delivery.png',width: 45,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('당일배송'),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:4.0),
                                        child: Image.asset('assets/icons/medal.png',width: 45,height: 40,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('우수셀러'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Hero(
                    tag: document['thumbnail_img'],
                    child:
                    Container(
                        height: size.height *0.70,
                        width: size.width *0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(63),
                                bottomLeft: Radius.circular(63)
                            ),
                            boxShadow: [BoxShadow(
                                offset:  Offset(0,10),
                                blurRadius: 60,
                                color: Colors.black38
                            )],
                            image: DecorationImage(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.cover,
                                image: NetworkImage(document['thumbnail_img'])
                            ))
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
 }

 Widget _buildReviewBody(context) {
    return StreamBuilder<QuerySnapshot>(
      stream:Firestore.instance.collection('uploaded_product').document(document.documentID).collection('review').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return _buildHasReview(context,snapshot.data.documents.length);
        }else{
          print("here");
          return _buildNoReview();
        }
      },
    );

 }

  Widget _buildNoReview() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Text("실사용 리뷰",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(top:14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("아직 후기가 없습니다",style: TextStyle(fontSize: 13,color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHasReview(context, length) {
    Size size = MediaQuery.of(context).size;
    var reviewCount = length;

    return Padding(
      padding: const EdgeInsets.only(top:30.0,right: 10.0,left: 10.0,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text("실사용 리뷰",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:17.0,bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:8.0,left:20),
                  child:reviewCount>0
                    ?Text("4.7",style: TextStyle(fontSize: 38))
                      :Text("아직 후기가 없습니다",style: TextStyle(fontSize: 13,color: Colors.grey)),
                    ),
                if(reviewCount>0)
                 Padding(
                  padding: const EdgeInsets.only(left:4.0),
                  child: Column(
                    // ignore: sdk_version_ui_as_code, sdk_version_ui_as_code
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('총 ${reviewCount}개 리뷰'),
                      Image.asset('assets/star/star1.png',width: 110,)
                    ],
                  ),
                )
              ],
            ),
          ),

          Visibility(
            visible: reviewCount>0?true:false,
            child: Scrollbar(
              child: Container(
                height: 280,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _commentStream(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData){
                        return Center(
                          child:  CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        children: snapshot.data.documents.map((doc) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc['writer'],style: TextStyle(fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: const EdgeInsets.only(top:4.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/star/star1.png',width: 75),
                                      Padding(
                                        padding: const EdgeInsets.only(left:5.0),
                                        child: Text(_timeStampToString(doc['date']),style: TextStyle(fontSize: 12),),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      doc['img']==null?Visibility(visible: false,child: Text(""),):Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Container(
                                            width:60,
                                            height:60,
                                            child: Image.network(doc['img'],fit: BoxFit.cover,)),
                                      ),
                                      SizedBox(
                                           width: doc['img']==null?size.width*0.77:size.width*0.58,
                                           height: 60,
                                           child: Text(doc['review'],
                                             maxLines: 4,
                                             overflow: TextOverflow.ellipsis,
                                           softWrap: false,)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle:Opacity(
                              opacity: 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(top:10.0,bottom: 5.0),
                                child: Container(
                                  width: size.width*0.8,
                                  height: 1,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top:40),
                              child: Container(
                                  child:Icon(Icons.arrow_forward_ios,size: 10,)
                              ),
                            ) ,
                            dense: true,
                          );
                        }).toList(),
                      );
                    }
                    ),
              ),
            ),
          ),
          Visibility(
            visible: reviewCount>0?true:false,
            child: Padding(
              padding: const EdgeInsets.only(top:10,left:15,right:15),
              child: SizedBox(
                width: size.width*1,
                child: RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                  color: Colors.blueAccent,
                  onPressed: () {},
                  child: const Text('후기 전체 보기', style: TextStyle(color: Colors.white,fontSize: 13)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _commentStream() {
    return Firestore.instance.collection('uploaded_product')
        .document(document.documentID).collection('review').orderBy('date',descending: true)
        .snapshots();

  }

  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }
}
