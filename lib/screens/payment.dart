import 'package:flutter/material.dart';
import 'package:coodyproj/models/iamport_payment.dart';
import 'package:coodyproj/models/payment_data.dart';
import 'package:coodyproj/models/index.dart';


class Payment extends StatelessWidget {
  String pg = 'html5_inicis'; // PG사
  String payMethod = 'card';  // 결제수단
  String cardQuota = "0";    // 할부개월수
  String vbankDue;            // 가상계좌 입금기한
  String bizNum;              // 사업자번호
  bool digital = false;       // 실물컨텐츠 여부
  bool escrow = false;        // 에스크로 여부
  String name="주문명 테스트";                // 주문명
  String amount="130";              // 결제금액
  String merchantUid ="주문번호 테스트";         // 주문번호
  String buyerName ="이보성";           // 구매자 이름
  String buyerTel ="01068276863";            // 구매자 전화번호
  String buyerEmail ="dlqh406@gmail.com";          // 구매자 이

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
    });
    data.appScheme = 'example';
    return IamportPayment(
      appBar: new AppBar(
        title: new Text('아임포트 결제'),
      ),
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/iamport-logo.png'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      userCode: 'imp05065178',
      /* [필수입력] 결제 데이터 */
      //userCode: Utils.getUserCodeByPg(data.pg),
      data: data,
      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(
          context,
          '/payment-result',
          arguments: result,
        );
      },
    );
  }
}