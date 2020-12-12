import 'package:coodyproj/screens/payment_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coodyproj/models/iamport_payment.dart';
import 'package:coodyproj/models/payment_data.dart';


class Payment extends StatelessWidget {
  final FirebaseUser user;

  String pg = 'html5_inicis'; // PG사
  String payMethod;  // 결제수단
  String cardQuota = "0";    // 할부개월수
  bool digital = false;       // 실물컨텐츠 여부
  bool escrow = false;        // 에스크로 여부
  String name;                // 주문명
  String amount;              // 결제금액
  String merchantUid ="주문번호 테스트";         // 주문번호
  String buyerName;           // 구매자 이름
  String buyerTel;            // 구매자 전화번호
  String buyerEmail;          // 구매자 이메일
  int reward;
  var orderList;
  String zoneCode;
  String address;
  String addressDetail;
  String request;
  Payment(this.user,this.orderList, this.name, this.reward ,this.payMethod, this.amount, this.merchantUid,
  this.zoneCode,this.address,this.addressDetail,this.request,
      this.buyerTel,this.buyerName,this.buyerEmail);

  @override
  Widget build(BuildContext context) {

    //PaymentData data = ModalRoute.of(context).settings.arguments;
    PaymentData data = PaymentData.fromJson({
      'pg': pg,
      'payMethod': payMethod,
      'escrow': escrow,
      'name': name,
      'amount': int.parse(amount),
      'merchantUid': merchantUid,
      'buyerName': buyerName,
      'buyerTel': buyerTel,
      'buyerEmail': buyerEmail,
      'orderList' : orderList,
      'reward' : reward,
      'zoneCode': zoneCode,
      'address' : address,
      'addressDetail': addressDetail,
      'request':request
    });
    data.appScheme = 'example';
    return IamportPayment(
        initialChild: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: Text(' ', style: TextStyle(fontSize: 20.0)),

                ),
              ],
            ),
          ),
        ),
        userCode: 'imp05065178',
        /* [필수입력] 결제 데이터 */
        data: data,
        callback: (Map<String, String> result) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            //return PaymentResult();
            return PaymentResult(result,user);
          },
         ));
        });
  }
}