import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_plugin.dart';


class rootPage extends StatefulWidget {
  @override
  _rootPageState createState() => _rootPageState();
}

class _rootPageState extends State<rootPage> {
  @override
  Widget build(BuildContext context) {
    return loginPage();
  }
}
