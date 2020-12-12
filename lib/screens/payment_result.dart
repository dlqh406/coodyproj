import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentResult extends StatelessWidget {
  static const Color successColor = Color(0xff52c41a);
  static const Color failureColor = Color(0xfff5222d);

  var result;
  final FirebaseUser user;
  PaymentResult(this.result,this.user);

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
  String merchantUid_S() {
    return "S${DateTime.now().millisecondsSinceEpoch}";
  }
  String merchantUid_I() {
    return "I${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    //Map<String, String> result = ModalRoute.of(context).settings.arguments;
    bool isSuccessed = getIsSuccessed(result);
    // bool isSuccessed = true;
    String message;

    if (isSuccessed) {
      message = '결제에 성공하였습니다';
      // 파이어베이스코드
      // I 코드 단위로 저장해야함
      //[["레드", "medium", "1", "8pd6ugCTiOq5OidSGFry","100","CyP3n6K9OnOW45uqkInPXQIUFHx2"]

      for(var i=0; i<result['orderList'].length; i++ ){
        var data = {
          // orderList에서 개별적으로 저장
          'orderColor' : result['orderList'][i][0],
          'orderSize' : result['orderSize'][i][1],
          'orderQuantity' : result['orderQuantity'][i][2],
          'productCode': result['productCode'][i][3],
          'totalPrice' : result['totalPrice'][i][4],  // I코드 단위로 개별 가격
          'sellerCode' : result['sellerCode'][i][5],

          // 완료
          'P_code' : result['merchantUid'],
          'zoneCode' : result['zoneCode'],
          'address' :  result['address'],
          'addressDetail' : result['addressDetail'],
          'request' : result['request'],
          'etc' : result['etc'],
          'name': result['name'],
          'orderDate' : DateTime.now(),
          'phone':result['phone'],
          'state' : 'standby',
          'trackingNumber' : 0,
          'userID' : user.uid,
        };
        Firestore.instance
            .collection('order_data').document(result['merchantUid'])
            .collection(merchantUid_S()).document(merchantUid_I()).updateData(data);

      }

      // 중요!!!!!!!!!
      // result['reward'] 차감 코드 작성 : for문 밖에


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
                      // 테스트 끝나면 아래 풀어
                      Text('에러 메시지', style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold)),
                      Text("result['error_msg'] ?? '-'")
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