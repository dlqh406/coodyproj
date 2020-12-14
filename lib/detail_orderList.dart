import 'package:coodyproj/detail_tracking.dart';
import 'package:coodyproj/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'detail_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class DetailOrderList extends StatefulWidget {
  final FirebaseUser user;
  var data;

  DetailOrderList(this.user,this.data);
  @override
  _DetailOrderListState createState() => _DetailOrderListState();
}

class _DetailOrderListState extends State<DetailOrderList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  IconButton(
            icon: Icon(Icons.arrow_back_ios,size: 19,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text('주문 목록'),
        actions: [
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
      ),
      body: ListView(
        children: [
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder:(BuildContext context, int index){
                  return Column(
                    children: [
                      for(var i=0; i< widget.data.length; i++)
                      buildOrderInfo(i),
                    ],
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderInfo(i) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Padding(
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
          Padding(
            padding: const EdgeInsets.only(left:18.0,right: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20,bottom:16),
                  child:
                  Row(
                    children: [
                      Text('${_timeStampToString(widget.data[i]['orderDate'])}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Spacer(),
                      Text('주문 상세 ',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                      Icon(Icons.arrow_forward_ios,size: 13,color: Colors.blue),

                    ],
                  ),
                ),
                state(widget.data[i]['state']),
                _buildListView(widget.data[i],i),

                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget state(data) {
    if(data == "standby"){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child: Image.asset('assets/icons/list.png',width: 30,)
          ),
          Text('주문 확인 중' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.black),),
        ],
      );
    }

    else if(data == "ongoing"){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child: Image.asset('assets/icons/box.png',width: 30,)
          ),
          Text('발송 준비 중' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }

    else if(data== "shipping"){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child: Image.asset('assets/icons/truck.png',width: 30,)
          ),
          Text('배송 중' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }

    else if (data == "completion"){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.green,)
          ),
          Text('배송 완료' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
  }
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }


  Widget _buildListView(doc, index){
    print(index);
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('uploaded_product').document(doc['productCode']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              Container(
                                  width: 230,
                                  child: Text("${snapshot.data.data['productName']}",
                                    style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  )),
                            ],
                          ),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Expanded(
                                  child: Text("색상 : ${doc["orderColor"]} / 사이즈 : ${doc['orderSize']} / 수량 : ${doc['orderQuantity']}개",
                                      style: TextStyle(fontSize:12 ,color: Colors.black87,
                                      ),maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false)),
                            ],
                          ),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Text('₩ ${numberWithComma(int.parse(snapshot.data.data['price']))}',style: TextStyle(fontSize: 16),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: RaisedButton(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),),
                      child: Text("교환 신청",style: TextStyle(color: Colors.black,),),
                      onPressed:(){
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: RaisedButton(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),),
                      child: Text("반품 신청",style: TextStyle(color: Colors.black),),
                      onPressed:(){
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: RaisedButton(
                      color: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),),
                      child: Text("배송 조회",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      onPressed:(){
                        if(doc['state'] != "standby" && doc['state'] != "ongoing"){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  DetailTracking(widget.user,doc)));
                        }
                        else{

                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(duration: const Duration(seconds: 2),content:
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle,color: Colors.blueAccent,),
                                SizedBox(width: 14,),
                                Text("배송 중 상태가 아니라 조회가 불가합니다",
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:16),),
                              ],
                            ),
                          )));
                        }

                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*1,
                child: RaisedButton(
                  color: Colors.orangeAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),),
                  child: Text("상품 후기 작성",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                  onPressed:(){
                  },
                ),
              )
            ],
          );
        }
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
  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
}
