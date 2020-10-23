import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'detail_product.dart';
import 'dart:io' show Platform;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coodyproj/test.dart';

class Favorite extends StatefulWidget {

  bool filter = false;
  bool VisibiltyTriger=false;
  bool top_downbtn = false;
  bool bottom_downbtn = false;
  bool dress_downbtn = false;
  bool beachWear_downbtn = false;
  bool outer_downbtn = false;
  bool innerWear_downbtn = false;
  bool fitnessWear_downbtn = false;

  int selectedCount =0;
  var selectedCategoryList=[];

  final FirebaseUser user;
  Favorite(this.user);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),
           child:AppBar(
               titleSpacing: 6.0,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    child: GestureDetector(
                        child: Image.asset('assets/logo/blacklogo.png'),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                            return TestPage(widget.user);
                          }));

                        }),
                  ),
                ),
                title: Container(
                  child: Container(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:2.3,right: 10,left: 5),
                          child: GestureDetector(
                            onTap: (){print("Tap GTD");},
                            child: Image.asset('assets/icons/bar.png',height: 40,),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:11.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left:27.0),
                                child: RotateAnimatedTextKit(
                                  onTap: () {
                                    // 위 GestureDetector 랑 똑같이 구현 해야함
                                    print("Tap Event");
                                  },
                                  isRepeatingAnimation: true,
                                  totalRepeatCount: 60000,
                                  text: ["두번보는 쿠디사용설명서", "카디건 활용방법", "Hello World"],
                                  textStyle: TextStyle(fontSize: 13.0,color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),),
                ),
                actions: <Widget>[
                  InkWell(
                    child: new Container(
                      width: 25,
                      child: (widget.selectedCategoryList.length>0)?Image.asset('assets/icons/active_filter.png'):Image.asset('assets/icons/filter.png') ),
                      onTap: () => {
                      _categoryFilterAlert()
                      },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:5.0),
                    child: new IconButton( icon: new Icon(Icons.more_vert,size: 28,),
                        onPressed: () => {
                        }),
                  ),
                ],

            )
        ),
        body: _bodyBuilder(),
        floatingActionButton:
        Visibility(
          visible: !Platform.isAndroid,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:31.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                  backgroundColor: Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
  Widget _bodyBuilder() {
    return Column(
        children: [
          SizedBox(height:10,
          child: Container(color: Colors.white)),
          _gridBuilder()
        ],
      );
  }
  Widget _gridBuilder() {
    return Expanded(
      child: Container(
        child: StreamBuilder <QuerySnapshot>(
          stream: _productStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return Center(child:  CircularProgressIndicator());
            }
            var items;
            var fF;
            var sF;
            var tF;
            print("passed");

            if(widget.filter == false){
              items =  snapshot.data?.documents ??[];
              fF = items.where((doc)=> doc['style'] == "오피스룩").toList();
              sF = items.where((doc)=> doc['style'] == "로맨틱").toList();
              tF = items.where((doc)=> doc['style'] == "캐주얼").toList();
              fF.addAll(sF);
              fF.addAll(tF);
              fF.shuffle();
            }
            else if(widget.filter == true){
              items =  snapshot.data?.documents??[];
              for(var i=0; i<widget.selectedCategoryList.length; i++){
                if(i==0){
                  fF=items.where((doc)=> doc['category'] == widget.selectedCategoryList[i]).toList();
                }else{
                  fF.addAll(items.where((doc)=> doc['category'] == widget.selectedCategoryList[i]).toList());
                }

              }
              fF.shuffle();
            }
            return StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                itemCount: fF.length,
                staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?1.2 : 1.8),
                itemBuilder: (BuildContext context, int index) {
                  return _buildListItem(context,fF[index]);
                }
            );


          },
        ),
      ),
    );
  }

  Widget _buildListItem(context, document) {
    return
      Hero(
        tag: document['thumbnail_img'],
        child: Material(
          child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ProductDetail(widget.user, document);
                }));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                    document['thumbnail_img'],
                    fit : BoxFit.cover),
              )
          ),
        ),
      );

  }

  Stream<QuerySnapshot> _productStream() {
    return Firestore.instance.collection("uploaded_product").snapshots();
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
    '롱&미디': false, '숏': false
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

  _reset(){
    widget.filter = false;
    widget.VisibiltyTriger=false;
    widget.top_downbtn = false;
    widget.bottom_downbtn = false;
    widget.dress_downbtn = false;
    widget.beachWear_downbtn = false;
    widget.outer_downbtn = false;
    widget.innerWear_downbtn = false;
    widget.fitnessWear_downbtn = false;
    top = {
      '니트': false, '긴팔': false, '카디건': false, '후드&맨투맨': false,
      '브라우스': false, '셔츠': false,'반팔': false,
      '민소매': false,
    };
     bottom = {
      '롱&미디 스커트': false, '숏 스커트': false, '데님': false, '슬랙스': false,
      '팬츠': false,
    };
     outer = {
      '코트': false, '패딩': false, '자켓': false, '퍼 자켓': false,
      '래더': false,
    };
     dress = {
      '롱&미디': false, '숏': false
    };
     beachWear = {
      '비키니': false, '모노키니': false, '로브': false,
    };
     innerWear = {
      '파운데이션': false, '란제리': false,
    };
     fitnessWear = {
      '트레이닝': false, '레깅스': false, '탑': false,
    };
  }

  Future<Map<String, bool>> _categoryFilterAlert() async {


    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('필터 적용',style:TextStyle(fontWeight:FontWeight.w700),),
                    Text("${widget.selectedCategoryList.length}개 선택됨",style:TextStyle(fontWeight:FontWeight.w300))
                  ],
                ),
                content: SingleChildScrollView(
                  child: Container(
                    width: double.minPositive,
                    height: 2000,
                    child: Column(
                      children: [

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
                  Visibility(
                    visible: widget.VisibiltyTriger?true:false,
                    child: FlatButton(
                      onPressed: () {
                        _getDelayForReset();
                        Navigator.pop(context, null);
                      },
                      child:Text('필터 해제'),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState((){
                        _reset();
                        widget.selectedCategoryList=[];
                      });
                      Navigator.pop(context, null);
                    },
                    child:Text('취소'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context,null);
                      _getDelayForFilter();
                    },
                    child: Text('완료'),
                  ),
                ],
              );
            },
          );
        });
  }
  Future _getDelayForFilter() {
    return Future.delayed(Duration(milliseconds: 1))
        .then((onValue) =>
        setState((){
        widget.VisibiltyTriger = true;
        widget.filter = true;
        _gridBuilder();
         })
    );
  }
  Future _getDelayForReset() {
    return Future.delayed(Duration(milliseconds: 1))
        .then((onValue) =>
        setState((){
          widget.selectedCategoryList=[];
          widget.filter = false;
          _reset();
        })
    );
  }
}

