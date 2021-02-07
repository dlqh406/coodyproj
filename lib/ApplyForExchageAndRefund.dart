import 'package:coodyproj/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'dart:ui';

import 'home_page.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class ApplyForExchangeAndRefund extends StatefulWidget {

  var defaultAddress = true;
  var selectedIssueForExchange= 0;
  var selectedIssueForRefund= 0;
  var selectedValForExchange;
  var selectedValForRefund;
  var selectedIssueForExchangeList=[
    '단순 변심',
    '사이즈 변경',
    '색상 변경',
    '포장 분량',
    '상품 하자',
    '상품 품절',
    '상품 정보 상이',
    '잘못 주문',
    '재 주문'
        '상품 잘못 배송 됨',
  ];
  var selectedIssueForRefundList=[
    '구매의사 취소',
    '포장 분량',
    '상품 하자',
    '상품 파손',
    '사이즈',
    '색상',
    '배송 누락',
    '배송 지연',
    '상품 정보 상이',
    '서비스 및 상품 불 만족',
    '재 주문',
    '상품 잘못 배송 됨'
  ];


  var data;
  var doc;
  final FirebaseUser user;

  ApplyForExchangeAndRefund(this.user,this.data,this.doc);

  @override
  _ApplyForExchangeAndRefundState createState() => _ApplyForExchangeAndRefundState();
}


class _ApplyForExchangeAndRefundState extends State<ApplyForExchangeAndRefund> {
  final TextEditingController textEditingController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            centerTitle: true,
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
            title:widget.data == "exchange" ? Text("교환 신청") : Text("반품 신청"),
          )),
      body:  ListView(
        children: [
          buildOrderInfo(),
          buildChoiceBox(),
          buildDefualtAddress(),
          textArea(),
          SizedBox(
            height: 15,
          ),
          btn()
        ],
          ),

    );
  }
  Widget buildOrderInfo() {
    return Padding(
      padding: const EdgeInsets.only(top:15,bottom: 15),
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
                _buildOrderInfoBody(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('uploaded_product').document(widget.doc['productCode']).snapshots(),
      builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("${_timeStampToString(widget.doc['orderDate'])} 주문",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Spacer(),
                  Column(
                    children: [
                      Text("주문번호: ${widget.doc['P_code']}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 12)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
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
                                  child: Text("색상 : ${widget.doc["orderColor"]} / 사이즈 : ${widget.doc['orderSize']} / 수량 : ${widget.doc['orderQuantity']}개",
                                      style: TextStyle(fontSize:12 ,color: Colors.black87,
                                      ),maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false)),
                            ],
                          ),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Text('${numberWithComma(int.parse(widget.doc['totalPrice']))}' ,style: TextStyle(height:1.3,fontSize: 16.5,fontWeight: FontWeight.w900,
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildChoiceBox() {

    return Padding(
      padding: const EdgeInsets.only(bottom:15),
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
            padding: const EdgeInsets.only(left:15.0,right: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                widget.data  =="exchange"?Text(" 교환 사유",style: TextStyle(fontWeight: FontWeight.bold, fontSize:20))
                    :Text(" 반품 사유",style: TextStyle(fontWeight: FontWeight.bold, fontSize:20)),
                widget.data  =="exchange" ? checkboxListForExchange() : checkboxListForRefund(),
                SizedBox(
                  height: 10,
                ),
                  ],
                ),
          )
            ),
          ),
        );

  }
  Widget buildDefualtAddress() {
    return Visibility(
      visible: widget.doc['state'] == 'standby'?false:true,
      child: Padding(
        padding: const EdgeInsets.only(bottom:15),
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
                padding: const EdgeInsets.only(left:10.0,right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blue,
                          value: widget.defaultAddress,
                          onChanged: (val){
                            setState(() {
                              widget.defaultAddress = !widget.defaultAddress;
                            });
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('해당 상품의 배송지로 택배 수거 자동 접수',style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 4,),
                            Text('(아닐 경우 아래 상세 사유에 주소를 입력해주세요)',style: TextStyle(fontSize: 11),),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
  Widget textArea() {
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
              Row(
                children: [
                  Text('상세 사유',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Spacer(),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0) //                 <--- border radius here
                          ),
                        ),
                        width: 320,
                        height: 100,
                        child: new TextField(
                          controller: textEditingController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          // controller: myController,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: new EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                            hintText: '교환 및 반품 사유를 상세히 입력해주세요 ',
                            hintStyle: new TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12.0,
                            ),
                          ),
                        )),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 26,
            )
          ],
        ),
      ),
    );
  }
  Widget checkboxListForExchange(){
    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                  isExpanded: true,
                  value: widget.selectedIssueForExchange,
                  items: [
                    DropdownMenuItem(
                      child: Text("교환 사유를 선택해주세요",style: TextStyle(fontWeight: FontWeight.bold),),
                      value: 0,
                    ),
                    for( var i=0; i<widget.selectedIssueForExchangeList.length; i++)
                    DropdownMenuItem(
                      child: Text("${widget.selectedIssueForExchangeList[i]}",style: TextStyle(fontWeight: FontWeight.bold),),
                      value: i+1,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      widget.selectedIssueForExchange = value;
                      widget.selectedValForExchange = widget.selectedIssueForExchangeList[value-1];
                      print(widget.selectedValForExchange);
                    });
                  }
              ),
              // SizedBox(
              //   height: 10,
              // )
            ],
          ),
        ),
      );
  }

  Widget checkboxListForRefund(){
    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                  isExpanded: true,
                  value: widget.selectedIssueForRefund,
                  items: [
                    DropdownMenuItem(
                      child: Text("반품 사유를 선택해주세요",style: TextStyle(fontWeight: FontWeight.bold),),
                      value: 0,
                    ),
                    for( var i=0; i<widget.selectedIssueForRefundList.length; i++)
                      DropdownMenuItem(
                        child: Text("${widget.selectedIssueForRefundList[i]}",style: TextStyle(fontWeight: FontWeight.bold),),
                        value: i+1,
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      widget.selectedIssueForRefund = value;
                      widget.selectedValForRefund = widget.selectedIssueForRefundList[value-1];
                      print(widget.selectedValForRefund);
                    });
                  }
              ),
              // SizedBox(
              //   height: 10,
              // )
            ],
          ),
        ),
      );
  }

  Widget btn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: SizedBox(
        height: 46,
        width: MediaQuery.of(context).size.width*1,
        child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),),
          color: Colors.blueAccent,
          onPressed: ()  {
            //TODO 여기 아래는 교환
            if(widget.data == "exchange"){
              if( widget.selectedIssueForExchange == 0){
                scaffoldKey.currentState
                    .showSnackBar(SnackBar(duration: const Duration(seconds:2),content:
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,color: Colors.blueAccent,),
                      SizedBox(width: 13,),
                      Text("교환 사유를 선택 해주세요.",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize:16),),


                    ],
                  ),
                )));
              }
              else{
                print( "${widget.selectedValForExchange}");
                print( "${textEditingController.text}");
                print(widget.doc.documentID);
                final data = {
                'state' : 'wishToEx',
                'reasonForExchange' : '${widget.selectedValForExchange}',
                'detailReasonForExchange' : '${textEditingController.text}',
                'defaultAddress': widget.defaultAddress
                };
                Firestore.instance
                    .collection('order_data')
                    .document(widget.doc.documentID)
                    .updateData(data);

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Home(widget.user)), (route) => false);

                _onBackPressedForExchange();
              }
            }
            //TODO 여기 아래는 Refund
            else{
              if( widget.selectedIssueForRefund == 0){
                scaffoldKey.currentState
                    .showSnackBar(SnackBar(duration: const Duration(seconds:2),content:
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,color: Colors.blueAccent,),
                      SizedBox(width: 13,),
                      Text("반품 사유를 선택 해주세요.",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize:16),),
                    ],
                  ),
                )));
              }
              else{
                if( widget.doc['state'] == "standby"){
                  final data = {
                    'state' : 'standbyCancel',
                    'reasonForRefund' : '${widget.selectedValForRefund}',
                    'detailReasonForRefund' : '${textEditingController.text}',
                  };
                  Firestore.instance
                      .collection('order_data')
                      .document(widget.doc.documentID)
                      .updateData(data);

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Home(widget.user)), (route) => false);

                  _onBackPressedForStandbyCancel();
                }
                else{
                  final data = {
                    'state' : 'wishToCancel',
                    'reasonForRefund' : '${widget.selectedValForRefund}',
                    'detailReasonForRefund' : '${textEditingController.text}',
                    'defaultAddress': widget.defaultAddress
                  };
                  Firestore.instance
                      .collection('order_data')
                      .document(widget.doc.documentID)
                      .updateData(data);

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Home(widget.user)), (route) => false);
                  _onBackPressedForCancel();
                }
              }
            }
          },
          child: const Text('신청',
              style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
        ),
      ),
    );


  }
  Future<bool> _onBackPressedForExchange() {

    return  showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
          onlyCancelButton: true,
          image: Container(
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.7),
            ),
            child: Image.asset(
              "assets/icons/giphy.gif",
            ),
          ),
          entryAnimation: EntryAnimation.TOP_LEFT,
          title: Text(
            '상품 교환 접수 완료',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22.0, fontWeight: FontWeight.w700),
          ),
          description: Text(
            '상품 교환 관련 안내사항을\n문자로 발송 예정입니다.\n추가 문의 사항은\n[마이쿠디>라이브 1:1 채팅 고객센터]을\n이용해주세요',
            textAlign: TextAlign.center,
          ),
          buttonOkColor: Colors.blue,
          buttonCancelColor: Colors.blue,

          buttonCancelText:Text("확인",style: TextStyle(color: Colors.white),) ,


        ));

  }
  Future<bool> _onBackPressedForStandbyCancel() {

      return  showDialog(
          context: context,
          builder: (_) => NetworkGiffyDialog(
            onlyCancelButton: true,
            image: Container(
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.7),
              ),
              child: Image.asset(
                "assets/icons/giphy.gif",
              ),
            ),
            entryAnimation: EntryAnimation.TOP_LEFT,
            title: Text(
              '주문 취소 완료',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
            description: Text(
              '결제금액은 영업일 3~5일 내로\n환불 될 예정입니다.\n추가 문의 사항은 \n[마이쿠디>라이브 1:1 채팅 고객센터]을\n이용해주세요',
              textAlign: TextAlign.center,
            ),
            buttonOkColor: Colors.blue,
            buttonCancelColor: Colors.blue,

            buttonCancelText:Text("확인",style: TextStyle(color: Colors.white),) ,


          ));

  }
  Future<bool> _onBackPressedForCancel() {

    return  showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
          onlyCancelButton: true,
          image: Container(
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.7),
            ),
            child: Image.asset(
              "assets/icons/giphy.gif",
            ),
          ),
          entryAnimation: EntryAnimation.TOP_LEFT,
          title: Text(
            '반품 요청 완료',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22.0, fontWeight: FontWeight.w700),
          ),
          description: Text(
            '반품 접수 관련 안내사항을\n문자로 발송 예정입니다.\n추가 문의 사항은\n[마이쿠디>실시간 채팅 상담]을\n이용해주세요',
            textAlign: TextAlign.center,
          ),
          buttonOkColor: Colors.blue,
          buttonCancelColor: Colors.blue,

          buttonCancelText:Text("확인.",style: TextStyle(color: Colors.white),) ,


        ));

  }


  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }

}
