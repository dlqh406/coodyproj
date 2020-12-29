import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coodyproj/models/payment_data.dart';


class PaymentResult extends StatelessWidget {
  static const Color successColor = Color(0xff52c41a);
  static const Color failureColor = Color(0xfff5222d);
  bool stopTriger = true;
  var result;
  var payData;
  final FirebaseUser user;
  PaymentResult(this.result,this.user,this.payData);

  bool getIsSuccessed(Map<String, String> _result) {
    if (_result['imp_success'] == 'true') {
      return true;
    }
    if (_result['success'] == 'true') {
      return true;
    }
    else{
      return false;
    }
  }
  String merchantUid_I() {
    return "I${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    bool isSuccessed = getIsSuccessed(result);
    String message;

    if (isSuccessed && stopTriger) {
      message = '결제에 성공하였습니다';
      print("@@@@@@: ${payData['zoneCode']}");

      for(var i=0; i<payData['orderList'].length; i++ ){

        var _ICode = merchantUid_I();
        var data = {
          // orderList에서 개별적으로 저장
          'orderColor' : payData['orderList'][i][0],
          'orderSize' : payData['orderList'][i][1],
          'orderQuantity' : payData['orderList'][i][2],
          'productCode': payData['orderList'][i][3],
          'totalPrice' : payData['orderList'][i][4],
          'sellerCode' : payData['orderList'][i][5],
          'orderProductName' : payData['orderList'][i][6],
          'P_code' : payData['merchantUid'],
          'I_code' : _ICode,
          'zoneCode' : payData['zoneCode'],
          'address' :  payData['address'],
          'addressDetail' : payData['addressDetail'],
          'request' : payData['request'],
          'orderName': payData['name'],
          'orderDate' : DateTime.now(),
          'buyerTel':payData['buyerTel'],
          'buyerEmail': payData['buyerEmail'],
          'buyerName' : payData['buyerName'],
          'usedReward' : payData['usedReward'],
          'beforeReward' : payData['beforeReward'],
          'state' : 'standby',
          'trackingNumber' : "0",
          'userID' : user.uid,
          'shippingCompany': "0",

        };
        Firestore.instance.collection('order_data').add(data);
      }
      if (result['reward'] != 0) {
       var currentReward = int.parse(payData['beforeReward']) - int.parse(payData['usedReward']);
       var data ={
         'reward' : currentReward.toString()
       };
       Firestore.instance.collection('user_data').document(user.uid).updateData(data);
      }

      stopTriger = false;
    } else {
      message = '결제에 실패하였습니다';
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSuccessed?Image.asset('assets/images/suc.png')
              :Image.asset('assets/images/fal.png'),
          SizedBox(
            height: 15,
          ),
          Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          isSuccessed?Text("상세 주문 상태는 마이 쿠디에서 확인 해주세요 :) ",style: TextStyle(
            fontSize: 15
          ),):Container(),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: <Widget>[
                isSuccessed ? Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    ],
                  ),
                ) : Container(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('에러 메시지', style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold)),
                      Text("${result['error_msg'] ?? '-'}")
                    ],
                  ),
                ),
              ],
            ),
          ),
          isSuccessed?RaisedButton(
            onPressed: () {
              print("suc");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Home(user);
              },
              ));
              print(payData['merchantUid']);
            },
            child: Text('확인', style: TextStyle(fontSize: 16.0)),
            color: Colors.blueAccent,
            textColor: Colors.white,
          ):RaisedButton(
            onPressed: () {
              print("fal");
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('확인', style: TextStyle(fontSize: 16.0)),
            color: Colors.redAccent,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}