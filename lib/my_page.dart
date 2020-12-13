import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'detail_product.dart';
import 'dart:io' show Platform;import 'package:intl/intl.dart';

class MyPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;

  final FirebaseUser user;
  MyPage(this.user);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyBuilder(),
    );
  }
  Widget _bodyBuilder() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('user_data').document(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        return ListView(
          children: [
            SizedBox(height: 15),
            _buildHeader(snapshot.data.data),
            SizedBox(height: 20),
            _buildOrderList(),
          ],
        );
      }
    );
  }
  Widget _buildHeader(Map<String, dynamic> doc) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 26.0),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("${widget.user.photoUrl}"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${widget.user.displayName}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            Text('님 반가워요!',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w100),),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFff6e6e),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Text("이벤트 1",
                                      style: TextStyle(
                                        fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text("포토후기 작성하면 1% 구매 적립",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.redAccent),),
                          ],
                        ),
                        SizedBox(height: 6,),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Text("이벤트 2",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text("구매만 해도 1% 바로 적립",
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.blue),),
                          ],
                        ),
                        SizedBox(height: 6,),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Text("이벤트 3",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text("가입 환영 웰컴 쿠폰 2,000원 적립",
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.orange),),
                          ],
                        ),
                      ],
                    ),

                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/icons/coin2.png',width: 20,),
                        SizedBox(
                          width: 7,
                        ),
                        Text('나의 포인트',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Spacer(),
                        Text('${numberWithComma(int.parse(doc['reward']))}',style:TextStyle(fontWeight: FontWeight.bold),),
                        Text('p'),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
              SizedBox(
                height: 20,
              )
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: Opacity(
//                  opacity: 0.15,
//                  child: Padding(
//                      padding: const EdgeInsets.only(
//                         top: 35, bottom: 10.0),
//                      child: Container(
//                        height: 1,
//                        color: Colors.black38,
//                      ))),
//            ),
          ],
        ),
      ),
    );
 }
  Widget _buildOrderList() {

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child:
                  Text("주문배송 현황",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20,right: 20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('order_data')
                          .where('userID', isEqualTo: "${widget.user.uid}").snapshots(),
                      builder: (context, snapshot) {
                        if ( !snapshot.hasData){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        //return Text('${snapshot.data.documents[1]['I_code']}');
                       return ListView.builder(
                         shrinkWrap: true,
                         itemCount: 1,
                         physics: NeverScrollableScrollPhysics(),
                           itemBuilder:(BuildContext context, int index){
                             return Column(
                               children: [
                                 for(var i=0; i<snapshot.data.documents.length; i++)
                                   _buildListView(context,snapshot.data.documents[i],i),
                               ],
                             );
                           }
                       );

                      }
                    )

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
  Widget opacityLine (){
    return Opacity(
        opacity: 0.15,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0),
            child: Container(
              height: 1,
              color: Colors.black38,
            )));

  }

  Widget _buildListView(context, doc, index){
    print(index);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('uploaded_product').document(doc['productCode']).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        return Column(
          children: [
            index==0?Container():opacityLine(),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FadeInImage.assetNetwork(
                      placeholder:'assets/images/19.png',
                      image: snapshot.data.data['thumbnail_img'],width: 75,height:75,fit: BoxFit.cover,)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:14.0),
                              child: Container(
                                  width: 200,
                                  child: Text("${snapshot.data.data['productName']}",
                                    style:TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  )),
                            ),

                          ],
                        ),
                        SizedBox(height: 6,),
                        Row(
                          children: [
                            Expanded(
                                child: Text("색상 : ${doc["orderColor"]} / 사이즈 : ${doc['orderSize']} / 수량 : ${doc['orderQuantity']}개",
                                    style: TextStyle(fontSize:11 ,color: Colors.black87,
                                    ),maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false)),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:5.0,bottom: 10),
                          child: Container(
                            child: Row(
                              children: [
                                 state(doc['state']),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),


          ],
        );
      }
    );

  }

  Widget _buildOrder2() {
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child:
              Text("후기를 남겨주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),


            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('결제 완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_ios, size: 15,color: Colors.grey,

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송준비중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('구매확정',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),


                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: Opacity(
//                  opacity: 0.15,
//                  child: Padding(
//                      padding: const EdgeInsets.only(
//                         top: 35, bottom: 10.0),
//                      child: Container(
//                        height: 1,
//                        color: Colors.black38,
//                      ))),
//            ),
          ],
        ),
      ),
    );
  }
  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }

   Widget state( var doc) {
     if(doc == "standby"){
     return Row(
       children: [
         Padding(
         padding: const EdgeInsets.only(left: 1,right: 7),
         child: Image.asset('assets/icons/list.png',width: 20,)
         ),
     Text('주문 확인 중' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
       ],
     );
   }


    else if(doc == "ongoing"){
     return Row(
       children: [
         Padding(
             padding: const EdgeInsets.only(left: 1,right: 7),
             child: Image.asset('assets/icons/box.png',width: 20,)
         ),
         Text('배송 준비 중' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
       ],
     );
     }



    else if(doc== "shipping"){
     return Row(
       children: [
         Padding(
             padding: const EdgeInsets.only(left: 1,right: 7),
             child: Image.asset('assets/icons/truck.png',width: 25,)
         ),
         Text('배송 중' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
       ],
     );
     }

     else if (doc == "completion"){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 19,color: Colors.green,)
          ),
          Text('배송 완료' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
     }
   }
}

