import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';


class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map<String, bool> values = {
    '브라우스': false,
    '원피스': false,
    '바지' : false,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Demo')),
          body: _buildbody()
      ),
    );

  }
  Map<String, bool> cityList = {
    '브라우스 ': false, '원피스': false, '바지': false, 'Chennai': false,
    'Delhi': false, 'Surat': false, 'Junagadh': false,
    'Porbander': false, 'Rajkot': false, 'Pune': false,
  };

  Future<Map<String, bool>> _categoryFilterAlert() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Preferred Location'),
                content: Container(
                  width: double.minPositive,
                  height: 600,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cityList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String _key = cityList.keys.elementAt(index);
                      return CheckboxListTile(
                        activeColor: Colors.blue,
                        value: cityList[_key],
                        title: Text(_key),
                        onChanged: (val) {
                          setState(() {
                            cityList[_key] = val;
                          });
                        },
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('닫기'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, cityList);
                    },
                    child: Text('완료'),
                  ),
                ],
              );
            },
          );
        });
  }

Widget _buildbody() {
    return Center(
      child: Column(
        children: [
      RaisedButton(
      child: Text("asds"),
      onPressed: (){
        _categoryFilterAlert();
      },
    ),

        ],
      ),
    );
}
}

