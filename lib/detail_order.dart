import 'package:coodyproj/detail_tracking.dart';
import 'package:coodyproj/home.dart';
import 'package:coodyproj/review_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'ApplyForExchageAndRefund.dart';
import 'detail_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class DetailOrder extends StatefulWidget {
  var trackingData;
  var trackingNum;

  int totalPrice=0;
  int totalDiscount=0;

  final FirebaseUser user;
  var data;
  final ScrollController _controllerOne = ScrollController();

  DetailOrder(this.user,this.data);
  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {

  final myController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
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
        title: Text('상세 주문 조회'),
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
      //body:ListView(
      body:
       ListView(
        children: [
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder:(BuildContext context, int index){
                  return Column(
                    children: [
                      basic(widget.data),
                      orderView(),
                      orderAddress()
                    ],
                  );
                }
            ),
          ),

        ],
      ),
    );
  }




  Widget orderView() {
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
            padding: const EdgeInsets.only(left:20,right: 20,top:15,bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Text("결제 내역",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Text("${_timeStampToString(widget.data['orderDate'])} 주문",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Spacer(),
                    Column(
                      children: [
                        Text("주문번호: ${widget.data['P_code']}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 12)),

                      ],
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('order_data').where('P_code', isEqualTo: "${widget.data['P_code']}").snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder:(BuildContext context, int index){
                            _cal(var doc){
                              widget.totalDiscount = int.parse(doc[0]['usedReward']);
                              for(var i=0; i<doc.length; i++)
                                widget.totalPrice += int.parse(doc[i]['totalPrice']);
                            }
                            _cal(snapshot.data.documents);

                            return Column(
                              children: [
                                for(var i=0; i<snapshot.data.documents.length; i++)
                                  orderElement(snapshot.data.documents[i],i),

                                _calculationView(context),
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
      ),
    );
  }
  Widget orderAddress() {
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
            padding: const EdgeInsets.only(left:18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text("주문자 배송 정보",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                SizedBox(
                height: 18,
                ),
                Text("${widget.data['buyerName']}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(
                  height: 6,
                ),
                Text("[${widget.data['zoneCode']}] ${widget.data['address']} ${widget.data['addressDetail']}"
                    ,style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,softWrap: false),
                SizedBox(
                  height: 6,
                ),
                Text("${widget.data['buyerTel']}",style: TextStyle( fontSize: 14)),
                SizedBox(
                  height: 6,
                ),
                Text("${widget.data['request']}",style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,softWrap: false),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 내용
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
        ),
      ),
    );
  }
  Widget _calculationView(BuildContext context) {
    return Container(
      child: Column(
        children: [

          Padding(
            padding:const EdgeInsets.only(top:20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('배송비',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                    Text('무료배송', style: TextStyle(fontSize:15, fontWeight: FontWeight.bold),)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top:6.0),
                  child: Row(

                    children: [
                      Text('합계',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                      Spacer(),
                      Text('${ numberWithComma( widget.totalPrice)}' ,style: TextStyle(height:1.3,fontSize: 16.5,fontWeight: FontWeight.w900,
                          fontFamily: 'metropolis')),
                      SizedBox(
                          width: 1
                      ),
                      Text("원",style: TextStyle(height:2.0,fontSize: 10.5,fontWeight: FontWeight.w700,
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:6.0),
                  child: Row(
                    children: [
                      Text('적립금 사용 합계',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color:Colors.redAccent),),
                      Spacer(),
                      Text('-${ numberWithComma( widget.totalDiscount)}',style: TextStyle(color: Colors.redAccent,height:1.3,fontSize: 16.5,fontWeight: FontWeight.w900,
                      fontFamily: 'metropolis')),
                SizedBox(
                    width: 1
                ),
                Text("원",style: TextStyle(height:2.0,fontSize: 10.5,fontWeight: FontWeight.w700,color: Colors.redAccent
                )),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:5.0,bottom: 5.0),
                    child: Row(

                      children: [
                        Text('최종 합계',style: TextStyle(fontSize:19,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
                        Spacer(),
                        Text('${numberWithComma(widget.totalPrice-widget.totalDiscount)}',style: TextStyle(color: Colors.blueAccent,height:1.3,fontSize: 20.5,fontWeight: FontWeight.w900,
                            fontFamily: 'metropolis')),
                    Text("원",style: TextStyle(height:2.0,fontSize: 11.5,fontWeight: FontWeight.w700,color: Colors.blueAccent))
                      ],
                    ),
                  ),
                ),


              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),


        ],
      ),
    );
  }
  Widget orderElement(DocumentSnapshot doc,index){

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('uploaded_product').document(doc['productCode']).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        return Column(
          children: [
            index == 0 ?Container():opacityLine(),
            Row(
              children: [
              ],
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Text('${numberWithComma(int.parse(doc['totalPrice']))}'    ,style: TextStyle(height:1.3,fontSize: 16.5,fontWeight: FontWeight.w900,
                                      fontFamily: 'metropolis')),
                                  SizedBox(
                                      width: 1
                                  ),
                                  Text("원",style: TextStyle(height:2.0,fontSize: 10.5,fontWeight: FontWeight.w700,
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 내용
                ],
              ),
            ),
          ],
        );
      }
    );
  }
  Widget opacityLine (){
    return Opacity(
      opacity: 0.25,
      child: Padding(
          padding: const EdgeInsets.only(
              top: 5.0, bottom: 5.0),
          child: Container(
            height: 1,
            color: Colors.black38,
          )),
    );

  }
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }
  Widget basic(doc) {
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      state(doc['state']),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left:0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        firstLineOrderStateBtn(doc),
                        GestureDetector(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*1,
                            child: RaisedButton(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("판매자에게 1:1 문의 남기기",style: TextStyle(fontSize: 15,color: Colors.black,),),
                                  SizedBox(width:5,),
                                  Image.asset(
                                    'assets/icons/paper-plane.png', width: 20,
                                    height: 30,),
                                ],
                              ),
                              onPressed:(){
                                print("aa");
                                _showAlert();
                              },
                            ),
                          ),
                        ),
                        thirdLineReviewWriteBtn(doc),
                        // 내용
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
          Text('주문 확인 중' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
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
          Text(' 발송 준비 중' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }

    else if(data== "shipping"){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child: Image.asset('assets/icons/truck.png',width: 35,)
          ),
          Text(' 배송 중' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
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
          Text(' 배송 완료' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }

    else if(data == 'reviewEnd'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text('후기 작성 완료(구매확정)' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }

    else if(data == 'completionEnd'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 8),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text('자동 구매 확정' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }

    // 반품
    else if(data == 'standbyCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.green,)
          ),
          Text(' 주문 취소 완료' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'wishToCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.orangeAccent,)
          ),
          Text('반품 요청' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'ApprovalToCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.orangeAccent,)
          ),
          Text(' 반품 승인' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'completionCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.orangeAccent,)
          ),
          Text(' 반품 완료' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'shippingNoCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child: Image.asset('assets/icons/truck.png',width: 35,)
          ),
          Text(' 배송 중(반품 불가)' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'completionNoCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.green,)
          ),
          Text(' 배송 완료' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'reviewEndNoCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 8),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text('리뷰 작성 완료(구매확정)' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'completionEndNoCancel'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text(' 자동 구매 확정' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }

    // 교환
    else if(data == 'wishToEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.orangeAccent,)
          ),
          Text(' 교환 요청' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'approvalToEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.orangeAccent,)
          ),
          Text(' 교환 승인' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'shippingEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child: Image.asset('assets/icons/truck.png',width: 30,)
          ),
          Text(' 배송 중 (교환 상품)' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'completionEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text(' 배송 완료' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'reviewEndEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text(' 리뷰 작성 완료(구매 확정)' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'completionEndEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 8),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text('자동 구매 확정' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'shippingNoEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child: Image.asset('assets/icons/truck.png',width: 35,)
          ),
          Text(' 배송 중(교환 불가)' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'completionNoEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 8),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text('배송 완료' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'reviewEndNoEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 8),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text('리뷰 작성 완료(구매 확정)' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    else if(data == 'completionEndNoEx'){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 8),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text('자동 구매 확정' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
    }
    // repeat
    else{
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 30,color: Colors.blue,)
          ),
          Text(' 주문데이터 확인 중' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );

    }

  }
  Widget _showAlert() {

    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 350.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          children: <Widget>[
            // dialog top
            new Row(
              children: <Widget>[
                new Container(
                  // padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: new Text(
                    '1:1 문의',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: 'helvetica_neue_light',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                GestureDetector(
                    onTap: (){
                      myController.clear();
                      Navigator.pop(context, true);
                    },
                    child: Icon(Icons.clear))
              ],
            ),
            // dialog centre
            SizedBox(
              height: 10,
            ),
            new Container(
                height: MediaQuery.of(context).size.height*0.3,
                child: new TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: myController,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: new EdgeInsets.only(
                        left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                    hintText: '질문을 남겨주시면 셀러가 확인 후 답을 드립니다',
                    hintStyle: new TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.0,
                    ),
                  ),
                )),

            // dialog bottom
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      print(myController.text);
                      print(widget.data['sellerCode']);
                      final _addData = {
                        'answer': "",
                        'P_Code' : widget.data['P_code'],
                        'I_Code' : widget.data['I_code'],
                        'name' : widget.user.displayName,
                        'productCode' : widget.data['productCode'],
                        'question' : myController.text,
                        'state' : "ongoing",
                        'date' : DateTime.now(),
                        'userID': widget.user.uid,
                        'sellerCode' :widget.data['sellerCode'],
                      };
                      Firestore.instance
                          .collection('inquiry_data')
                          .add(_addData);


                      myController.clear();
                      Navigator.pop(context, true);


                      scaffoldKey.currentState
                          .showSnackBar(SnackBar(duration: const Duration(seconds: 3),content:
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,color: Colors.blueAccent,),
                            SizedBox(width: 11,),
                            Text("1:1 문의 답변은 \n 마이쿠디 > 나의 쪽지함에서 확인 가능합니다.  ",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
                          ],
                        ),
                      )));

                    },
                    child: new Container(
                      padding: new EdgeInsets.all(16.0),
                      decoration: new BoxDecoration(
                        color:Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: new Text(
                          '질문 등록',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, child: dialog);
  }
  Widget firstLineOrderStateBtn(doc){
    return   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 교환 버튼
        Visibility(
          visible: doc['state'] == 'shipping'  || doc['state'] == 'completion'
              || doc['state'] == 'shippingEx' || doc['state'] == 'completionEx'
              || doc['state'] == 'shippingNoEx' || doc['state'] == 'completionNoEx' ,
          child: Expanded(
            child: RaisedButton(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),),
              child: Text("교환 신청",style: TextStyle(color: Colors.black,),),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ApplyForExchangeAndRefund(widget.user,"exchange",doc);
                }));
              },
            ),
          ),
        ),
        Visibility(
            visible: doc['state'] == 'standby' || doc['state'] == 'shippingNoCancel'||doc['state'] == 'completionNoCancel'?false:true,
            child: SizedBox(width: 10,)),
        // 반품 버튼
        Visibility(
          visible: doc['state'] == 'standby' ||doc['state'] == 'shipping'  || doc['state'] == 'completion'
              || doc['state'] == 'shippingEx' || doc['state'] == 'completionEx'
              || doc['state'] == 'shippingNoEx' || doc['state'] == 'completionNoEx' ,
          child: Expanded(
            child: RaisedButton(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),),
              child:
              doc['state'] == 'standby' ? Text("주문 취소",style: TextStyle(color: Colors.black)):Text("반품 신청",style: TextStyle(color: Colors.black)),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ApplyForExchangeAndRefund(widget.user,"refund",doc);
                }));
              },
            ),
          ),
        ),
        Visibility(
            visible: doc['state'] == 'standby'  || doc['state'] == 'shippingNoCancel' || doc['state'] == 'completionNoCancel'?false:true,
            child: SizedBox(width: 10,)),
        // 배송 조회
        Visibility(
          visible: doc['state'] == 'shipping'  || doc['state'] == 'completion'
              || doc['state'] == 'shippingNoCancel' || doc['state'] == 'completionNoCancel'
              || doc['state'] == 'shippingEx' || doc['state'] == 'completionEx'
              || doc['state'] == 'shippingNoEx' || doc['state'] == 'completionNoEx' ,
          child: Expanded(
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
        ),
      ],
    );
  }

  Widget thirdLineReviewWriteBtn(doc){
    return  Visibility(
      visible:
      doc['state'] == 'standby'  || doc['state'] == 'ongoing'
          || doc['state'] == 'shipping'  || doc['state'] == 'completion'
          || doc['state'] == 'shippingNoCancel' || doc['state'] == 'completionNoCancel'
          || doc['state'] == 'shippingEx' || doc['state'] == 'completionEx'
          || doc['state'] == 'shippingNoEx' || doc['state'] == 'completionNoEx' ,
      child: SizedBox(
        width: MediaQuery.of(context).size.width*1,
        child: RaisedButton(
          color: Colors.lightBlueAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("상품 후기 작성",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              Icon(Icons.brightness_1,color: Colors.red,size:7),
            ],
          ),
          onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ReviewPage(widget.user,doc,doc['productCode']);
            }));
          },
        ),
      ),
    );
  }
  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
}
