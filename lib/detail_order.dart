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
                      bill(),
                      orderView(),
                      widget.data['state'] =='standby'|| widget.data['state'] =='ongoing'?Container():myShippingState(),
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
  Widget myShippingState() {
    return GestureDetector(
      onTap: (){
        if(widget.data['state'] != "standby" && widget.data['state'] != "ongoing"){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  DetailTracking(widget.user,widget.data)));
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
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
              padding: const EdgeInsets.only(left:0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("배송 조회 하기",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25)),
                    ],
                  ),
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
      ),
    );
  }


  Widget bill() {
    return GestureDetector(
      onTap: (){
        _showAlert();
      },
      child: Padding(
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
              padding: const EdgeInsets.only(left:18.0,right:18),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("판매자에게 1:1 문의 남기기",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 15,),
                            Image.asset(
                              'assets/icons/paper-plane.png', width: 30,
                              height: 40,),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('합계',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),),
                      Text('₩ ${ numberWithComma( widget.totalPrice)}', style: TextStyle(fontSize:15, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('적립금 사용 합계',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color:Colors.redAccent),),
                      Text('- ₩ ${ numberWithComma( widget.totalDiscount)}', style: TextStyle(fontSize:15, fontWeight: FontWeight.bold,color:Colors.redAccent),)
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top:5.0,bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('최종 합계',style: TextStyle(fontSize:19,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
                        Text('₩ ${numberWithComma(widget.totalPrice-widget.totalDiscount)}', style: TextStyle(fontSize:19, fontWeight: FontWeight.w900,color:Colors.blueAccent),)
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
  Widget basic() {
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
                  ],
                ),
                Text("배송 완료",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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

  Widget _showAlert() {

    AlertDialog dialog = new AlertDialog(


      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            new Expanded(
              child: new Row(
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
            ),

            // dialog centre
            new Expanded(
              child: new Container(
                  height: 100,
                  child: new TextField(
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
              flex: 2,
            ),

            // dialog bottom
            new Expanded(
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
                    'date' : DateTime.now()
                  };
                  Firestore.instance
                      .collection('seller_data')
                      .document(widget.data['sellerCode'])
                      .collection('inquiry')
                      .add(_addData);


                  //
                  // final Email email = Email(
                  //   body: "hi ",
                  //   subject: 'Email subject',
                  //   recipients: ['boseong.lee@coody.cool'],
                  //   isHTML: false,
                  // );
                  // String platformResponse;
                  // try {
                  //   await FlutterEmailSender.send(email);
                  //   platformResponse = 'success';
                  // } catch (error) {
                  //   platformResponse = error.toString();
                  // }
                  // print(platformResponse);
                  // if (!mounted) return;
                  // _scaffoldKey.currentState.showSnackBar(SnackBar(
                  //   content: Text(platformResponse),
                  // ));

                  myController.clear();
                  Navigator.pop(context, true);
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
      ),
    );
    showDialog(context: context, child: dialog);
  }

  // Widget _showAlert() {
  //
  //   AlertDialog dialog = new AlertDialog(
  //
  //
  //     content: new Container(
  //       width: 260.0,
  //       height: 230.0,
  //       decoration: new BoxDecoration(
  //         shape: BoxShape.rectangle,
  //         color: const Color(0xFFFFFF),
  //         borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
  //       ),
  //       child: new Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           // dialog top
  //           new Expanded(
  //             child: new Row(
  //               children: <Widget>[
  //                 new Container(
  //                   // padding: new EdgeInsets.all(10.0),
  //                   decoration: new BoxDecoration(
  //                     color: Colors.white,
  //                   ),
  //                   child: new Text(
  //                     '1:1 문의',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                       fontSize: 18.0,
  //                       fontFamily: 'helvetica_neue_light',
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 GestureDetector(
  //                     onTap: (){
  //                       myController.clear();
  //                       Navigator.pop(context, true);
  //                     },
  //                     child: Icon(Icons.clear))
  //               ],
  //             ),
  //           ),
  //
  //           // dialog centre
  //           new Expanded(
  //             child: new Container(
  //                 height: 100,
  //                 child: new TextField(
  //                   controller: myController,
  //                   decoration: new InputDecoration(
  //                     border: InputBorder.none,
  //                     filled: false,
  //                     contentPadding: new EdgeInsets.only(
  //                         left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
  //                     hintText: '질문을 남겨주시면 셀러가 확인 후 답을 드립니다',
  //                     hintStyle: new TextStyle(
  //                       color: Colors.grey.shade500,
  //                       fontSize: 12.0,
  //                     ),
  //                   ),
  //                 )),
  //             flex: 2,
  //           ),
  //
  //           // dialog bottom
  //           new Expanded(
  //             child: GestureDetector(
  //               onTap: () async {
  //                 print(myController.text);
  //                 print(widget.document['sellerCode']);
  //                 final _addData = {
  //                   'answer': "",
  //                   'P_Code' : "",
  //                   'I_Code' : "",
  //                   'name' : widget.user.displayName,
  //                   'productCode' : widget.document.documentID,
  //                   'question' : myController.text,
  //                   'state' : "ongoing",
  //                   'date' : DateTime.now()
  //                 };
  //                 Firestore.instance
  //                     .collection('seller_data')
  //                     .document(widget.document['sellerCode'])
  //                     .collection('inquiry')
  //                     .add(_addData);
  //
  //
  //                 //
  //                 // final Email email = Email(
  //                 //   body: "hi ",
  //                 //   subject: 'Email subject',
  //                 //   recipients: ['boseong.lee@coody.cool'],
  //                 //   isHTML: false,
  //                 // );
  //                 // String platformResponse;
  //                 // try {
  //                 //   await FlutterEmailSender.send(email);
  //                 //   platformResponse = 'success';
  //                 // } catch (error) {
  //                 //   platformResponse = error.toString();
  //                 // }
  //                 // print(platformResponse);
  //                 // if (!mounted) return;
  //                 // _scaffoldKey.currentState.showSnackBar(SnackBar(
  //                 //   content: Text(platformResponse),
  //                 // ));
  //
  //                 myController.clear();
  //                 Navigator.pop(context, true);
  //               },
  //               child: new Container(
  //                 padding: new EdgeInsets.all(16.0),
  //                 decoration: new BoxDecoration(
  //                   color:Colors.blue,
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(top:5.0),
  //                   child: new Text(
  //                     '질문 등록',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.white,
  //                       fontSize: 17.0,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(context: context, child: dialog);
  // }

  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
}
