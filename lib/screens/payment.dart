import 'package:flutter/material.dart';
import 'package:coodyproj/models/iamport_payment.dart';
import 'package:coodyproj/models/payment_data.dart';
import 'package:coodyproj/models/index.dart';


class Payment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PaymentData data = ModalRoute.of(context).settings.arguments;
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