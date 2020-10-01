import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';


class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);
  bool top_downbtn = false;
  bool bottom_downbtn = false;
  bool dress_downbtn = false;
  bool beachWear_downbtn = false;
  bool outer_downbtn = false;
  bool innerWear_downbtn = false;
  bool fitnessWear_downbtn = false;

  int selectedCount =0;
  var selectedCategoryList=[];
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Demo')),
          body: _buildbody()
      ),
    );
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


Map<String, bool> top = {
    '니트': false, '긴팔': false, '카디건': false, '후드&맨투맨': false,
    '브라우스': false, '셔츠': false,'반팔': false,
    '민소매': false,
  };
Map<String, bool> bottom = {
    '롱&미디 스커트': false, '숏 스커트': false, '데님': false, '슬랙스': false,
    '팬츠': false,
  };
Map<String, bool> outer = {
    '코트': false, '패딩': false, '자켓': false, '퍼 자켓': false,
    '래더': false,
  };
Map<String, bool> dress = {
    '롱,미디': false, '숏': false
  };
  Map<String, bool> beachWear = {
    '비키니': false, '모노키니': false, '로브': false,
  };
  Map<String, bool> innerWear = {
    '파운데이션': false, '란제리': false,
  };
  Map<String, bool> fitnessWear = {
    '트레이닝': false, '레깅스': false, '탑': false,
  };

  Future<Map<String, bool>> _categoryFilterAlert() async {


    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('필터 적용'),
                content: SingleChildScrollView(
                  child: Container(
                    width: double.minPositive,
                    height: 2000,
                    child: Column(
                      children: [
                   // TODO : 상의 //////////////////////////////////////////////////////////////////////////////////
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                              widget.top_downbtn = !widget.top_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text('👚 상의', style: TextStyle(fontSize: 15)),
                                widget.top_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.top_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: top.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = top.keys.elementAt(index);
                                  return CheckboxListTile(
                                    activeColor: Colors.blue,
                                    value: top[_key],
                                    title: Text(_key),
                                    onChanged: (val) {
                                      setState(() {
                                        top[_key] = val;
                                        setState(() {
                                          top[_key] ? widget.selectedCategoryList.add(_key)
                                              : widget.selectedCategoryList.remove(_key);
                                        });
                                        print(widget.selectedCategoryList);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                widget.bottom_downbtn = !widget.bottom_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('👖 하의', style: TextStyle(fontSize: 15)),
                                widget.bottom_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.bottom_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: bottom.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = bottom.keys.elementAt(index);
                                  return CheckboxListTile(
                                    activeColor: Colors.blue,
                                    value: bottom[_key],
                                    title: Text(_key),
                                    onChanged: (val) {
                                      setState(() {
                                        bottom[_key] = val;
                                        setState(() {
                                          bottom[_key] ? widget.selectedCategoryList.add(_key)
                                              : widget.selectedCategoryList.remove(_key);
                                        });
                                        print(widget.selectedCategoryList);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                widget.outer_downbtn = !widget.outer_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('🧥 아우터', style: TextStyle(fontSize: 15)),
                                widget.outer_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.outer_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: outer.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = outer.keys.elementAt(index);
                                  return CheckboxListTile(
                                    activeColor: Colors.blue,
                                    value: outer[_key],
                                    title: Text(_key),
                                    onChanged: (val) {
                                      setState(() {
                                        outer[_key] = val;
                                        setState(() {
                                          outer[_key] ? widget.selectedCategoryList.add(_key)
                                              : widget.selectedCategoryList.remove(_key);
                                        });
                                        print(widget.selectedCategoryList);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                widget.dress_downbtn = !widget.dress_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('👗 원피스', style: TextStyle(fontSize: 15)),
                                widget.dress_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.dress_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: dress.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = dress.keys.elementAt(index);
                                  return CheckboxListTile(
                                    activeColor: Colors.blue,
                                    value: dress[_key],
                                    title: Text(_key),
                                    onChanged: (val) {
                                      setState(() {
                                        dress[_key] = val;
                                        setState(() {
                                          dress[_key] ? widget.selectedCategoryList.add(_key)
                                              : widget.selectedCategoryList.remove(_key);
                                        });
                                        print(widget.selectedCategoryList);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                widget.innerWear_downbtn = !widget.innerWear_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('👙 이너웨어', style: TextStyle(fontSize: 15)),
                                widget.innerWear_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.innerWear_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: innerWear.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = innerWear.keys.elementAt(index);
                                  return CheckboxListTile(
                                    activeColor: Colors.blue,
                                    value: innerWear[_key],
                                    title: Text(_key),
                                    onChanged: (val) {
                                      setState(() {
                                        innerWear[_key] = val;
                                        setState(() {
                                          innerWear[_key] ? widget.selectedCategoryList.add(_key)
                                              : widget.selectedCategoryList.remove(_key);
                                        });
                                        print(widget.selectedCategoryList);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                widget.fitnessWear_downbtn = !widget.fitnessWear_downbtn;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('🏃‍♀ 피트니스', style: TextStyle(fontSize: 15)),
                                widget.fitnessWear_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.fitnessWear_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: fitnessWear.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = fitnessWear.keys.elementAt(index);
                                  return CheckboxListTile(
                                    activeColor: Colors.blue,
                                    value: fitnessWear[_key],
                                    title: Text(_key),
                                    onChanged: (val) {
                                      setState(() {
                                        fitnessWear[_key] = val;
                                        setState(() {
                                          fitnessWear[_key] ? widget.selectedCategoryList.add(_key)
                                              : widget.selectedCategoryList.remove(_key);
                                        });
                                        print(widget.selectedCategoryList);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),


                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
                                widget.beachWear_downbtn = !widget.beachWear_downbtn;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('🏊‍♀ 비치웨어', style: TextStyle(fontSize: 15)),
                                widget.beachWear_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.beachWear_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: beachWear.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = beachWear.keys.elementAt(index);
                                  return CheckboxListTile(
                                    activeColor: Colors.blue,
                                    value: beachWear[_key],
                                    title: Text(_key),
                                    onChanged: (val) {
                                      setState(() {
                                        beachWear[_key] = val;
                                        setState(() {
                                          beachWear[_key] ? widget.selectedCategoryList.add(_key)
                                              : widget.selectedCategoryList.remove(_key);
                                        });
                                        print(widget.selectedCategoryList);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Text("${widget.selectedCategoryList.length}개 선택됨"),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('닫기'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, top);
                    },
                    child: Text('완료'),
                  ),
                ],
              );
            },
          );
        });
  }

}