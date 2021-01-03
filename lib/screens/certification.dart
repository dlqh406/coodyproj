import 'package:coodyproj/models/Iamport_certification.dart';
import 'package:coodyproj/screens/certification_result.dart';
import 'package:coodyproj/user_info_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coodyproj/models/certification_data.dart';


class Certification extends StatelessWidget {
  final FirebaseUser user;
  var carrier,name,phone,YYMMDD;
  static const String userCode = 'imp10391932';
  Certification(this.user,this.carrier,this.name,this.phone,this.YYMMDD);

  @override
  Widget build(BuildContext context) {
    var userData ={
      'carrier' : carrier,
      'name': name,
      'phone': phone,
      'YYMMDD' : YYMMDD,
    };
    return IamportCertification(
      appBar: new AppBar(
        title: new Text('아임포트 본인인증'),
      ),
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/iamport-logo.png'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      userCode: userCode,
      data: CertificationData.fromJson({
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        'company': '(주)쿠디',                                            // 회사명 또는 URL
        'carrier': carrier,                                               // 통신사
        'name': name,                                                 // 이름
        'phone': phone,                                         // 전화번호
      }),
      callback: (Map<String, String> result) {
        // ignore: unrelated_type_equality_checks
        if(result['success'] == "true"){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (BuildContext context) => UserInfoPage(user,userData)));
        }
        else{
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  CertificationResult(result,user,userData)));
        }

      },
    );
  }
}