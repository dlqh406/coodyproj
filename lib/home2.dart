import 'package:flutter/material.dart';

import './screens/home.dart';
import './screens/payment_test.dart';
import './screens/payment.dart';
import './screens/payment_result.dart';
import './screens/certification_test.dart';
import './screens/certification.dart';
import './screens/certification_result.dart';

void main() => runApp(new Home2());

class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  static const Color primaryColor = Color(0xff344e81);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        primaryColor: primaryColor,
        buttonColor: primaryColor,
      ),
      routes: {
        // '/': (context) => Home(),
        // '/payment-test': (context) => PaymentTest(),
        // '/payment': (context) =>PaymentResult(),
        // '/payment-result': (context) => PaymentResult(),
        '/certification-test': (context) => CertificationTest(),
        '/certification': (context) => Certification(),
        '/certification-result': (context) => CertificationResult(),
      },
    );
  }
}
