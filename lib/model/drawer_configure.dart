import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];

List<Map> categories = [
  {'name': 'Cats', 'iconPath': 'images/cat.png'},
  {'name': 'Dogs', 'iconPath': 'images/dog.png'},
  {'name': 'Bunnies', 'iconPath': 'images/rabbit.png'},
  {'name': 'Parrots', 'iconPath': 'images/parrot.png'},
  {'name': 'Horses', 'iconPath': 'images/horse.png'}
];

List<Map> drawerItems=[
  {
    'icon': FontAwesomeIcons.paw,
    'title' : '주문&배송'
  },
  {
    'icon': Icons.mail,
    'title' : '장바구니'
  },
  {
    'icon': FontAwesomeIcons.plus,
    'title' : '나의 1:1 문의'
  },
  {
    'icon': Icons.favorite,
    'title' : '매거진'
  },
  {
    'icon': Icons.mail,
    'title' : '최근 본 상품'
  },
  {
    'icon': FontAwesomeIcons.userAlt,
    'title' : '계정 설정'
  },
];