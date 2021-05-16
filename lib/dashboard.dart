
import 'package:coodyproj/my_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'detail_product.dart';
import 'dart:io' show Platform;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';
import 'dart:ui';


class DashBoard extends StatefulWidget {
  var bool_list_each_GridSell = [];
  bool categoryfilter = false;
  bool filter = false;
  bool oddfilter =false;
  bool colorfilter =false;
  bool pricefilter = false;
  bool VisibiltyTriger=false;
  bool top_downbtn = false;
  bool bottom_downbtn = false;
  bool dress_downbtn = false;
  bool beachWear_downbtn = false;
  bool outer_downbtn = false;
  bool innerWear_downbtn = false;
  bool fitnessWear_downbtn = false;
  bool accessory_downbtn = false;
  bool resetData = true;

  var fF;
  var sF;
  var tF;

  int selectedCount =0;
  var selectedCategoryList=[];
  var selectedPrice=999;
  var selectedColor="999";

  final FirebaseUser user;
  DashBoard(this.user);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>{

  var stopTrigger = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:PreferredSize(preferredSize: Size.fromHeight(37.0),
           child: AppBar(
                titleSpacing:2.0,
                backgroundColor: Colors.white,
                elevation: 0,
                leading:
                GestureDetector(
                    onTap: (){
                      _getDelayForReset('refresh');
                    },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          child: Image.asset('assets/logo/FULLBB.png')
                        ),
                      ),
                    ),
                  ),
                ),
                title:
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left:33.0),
                        child: InkWell(
                          child: new Container(
                              child:
                              Icon(Icons.add,size: 30,) ),
                          onTap: () => {
                          FirebaseAuth.instance.signOut()
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:30.0,right:25),
                        child: InkWell(
                          child: new Container(
                              child: Icon(Icons.account_circle,size:30) ),
                          onTap: () => {

                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return MyPage(widget.user);
                            }))

                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[


                ],

            )
        ),
        body: _gridBuilder(),
      ),
    );
  }

  Widget _gridBuilder() {
    return Column(
      children: [
        SizedBox(height: 5,),

        Expanded(
          child: StreamBuilder (
            // .where('state',isEqualTo: true)
            stream:Firestore.instance.collection("uploaded_product").snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(!snapshot.hasData){
                return Center(child:  CircularProgressIndicator());
              }
              //if(stopTrigger == 1 ){
              widget.fF = snapshot.data.documents.toList();

              //}
              stopTrigger+=1;
              widget.fF.shuffle();


              // 경우에 수 마다 if 중첩
              return Padding(
                padding: const EdgeInsets.only(top:4,left:4,right:4),
                child: StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 6.0,
                    itemCount: widget.fF.length,
                    //staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?2.2: 2.9),
                    staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?2.4: 2.9),
                    itemBuilder: (BuildContext context, int index) {
                      for(var i=0; i<widget.fF.length; i++ ){
                        widget.bool_list_each_GridSell.add(false);
                      }
                      //if(int.parse(widget.fF[index]['price'])>15000){
                      return _buildListItem(context,widget.fF[index],index);
                      //}
                    }

                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildListItem(context,document,index) {
    return
      StreamBuilder(
        stream: Firestore.instance.collection('uploaded_product').document(document.documentID).collection('review').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator());
          }

          return Hero(
              tag: document['thumbnail_img'],
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onDoubleTap: (){
                      Vibration.vibrate(duration: 100, amplitude: 58);
                      // 찜 데이터
                      setState(() {
                        widget.bool_list_each_GridSell[index] = !widget.bool_list_each_GridSell[index];
                      });
                    },
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ProductDetail(widget.user, document);
                      }));
                    },
                      child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(12.0),
                                  child: Container(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Center(child: RotationTransition(
                                              turns: new AlwaysStoppedAnimation(45/ 360),
                                              child: Image.asset('assets/images/DNA.gif',width: 60))),
                                          //Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange.withOpacity(0.5)))),
                                          FadeInImage.assetNetwork(
                                                fadeInDuration: Duration(milliseconds: 650),
                                                placeholder: 'assets/images/loading.png',
                                                image: widget.colorfilter == true?document['${widget.selectedColor}']:document['thumbnail_img'],
                                                fit : BoxFit.cover),
                                          Positioned(
                                              top:4,
                                              right: 6,
                                              child: widget.bool_list_each_GridSell[index]?Icon(Icons.favorite,size:25,color: Colors.red,):Container()),

                                          // Positioned (
                                          //   top:4,
                                          //   left:6,
                                          //   child: document['ODD_can']?Image.asset('assets/icons/FD.png',width:20,):Container(),
                                          // ),
                                          //
                                          // Positioned (
                                          //   bottom:4,
                                          //   left:6,
                                          //   child: Container(
                                          //     decoration: BoxDecoration(
                                          //       color: Color(0xFFff6e6e),
                                          //       borderRadius: BorderRadius.circular(20.0),
                                          //     ),
                                          //     child: Center(
                                          //       child: Padding(
                                          //         padding: EdgeInsets.symmetric(
                                          //             horizontal: 7.0, vertical: 2.0),
                                          //         child: Text("자체 제작",
                                          //             style: TextStyle(
                                          //                 fontSize: 10,
                                          //                 color: Colors.white,
                                          //                 fontWeight: FontWeight.bold)),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),

                                      ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  );
        }
      );
  }

  Map<String, bool> top = {
    '니트&스웨터': false, '긴팔': false, '카디건': false, '후드&맨투맨': false,
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
    '롱&미디': false, '숏': false, '원피스': false
  };
  Map<String, bool> beachWear = {
    '비키니': false, '모노키니': false, '로브': false,
  };
  Map<String, bool> innerWear = {
    '파운데이션': false, '란제리': false, '파자마' : false
  };
  Map<String, bool> fitnessWear = {
    '트레이닝': false, '레깅스': false,
  };
  Map<String, bool> accessory = {
  '전체' : false
  };

  _reset(){
    widget.categoryfilter = false;
    widget.VisibiltyTriger=false;
    widget.top_downbtn = false;
    widget.bottom_downbtn = false;
    widget.dress_downbtn = false;
    widget.beachWear_downbtn = false;
    widget.outer_downbtn = false;
    widget.innerWear_downbtn = false;
    widget.fitnessWear_downbtn = false;
    widget.accessory_downbtn = false;

    top = {
      '니트&스웨터': false, '긴팔': false, '카디건': false, '후드&맨투맨': false,
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
      '롱&미디': false, '숏': false, '원피스': false
    };
     beachWear = {
      '비키니': false, '모노키니': false, '로브': false,
    };
     innerWear = {
      '파운데이션': false, '란제리': false, '파자마' : false
    };
     fitnessWear = {
      '스포츠': false, '레깅스': false,
    };
    accessory = {
      '전체' : false
    };
  }

  Future<Map<String, bool>> _categoryFilterAlert() async {


    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Color(0xff142035),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Container(
                        width: 25,
                        child: Image.asset('assets/icons/hanger.png',color: Colors.blue,)),
                    SizedBox(width: 10,),
                    Text('카테고리 필터',style:TextStyle(fontWeight:FontWeight.w700,color: Colors.white),),
                    Spacer(),
                    Text("${widget.selectedCategoryList.length}개 선택됨",style:TextStyle(fontWeight:FontWeight.w300,fontSize:15,color: Colors.white))
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
                            color:Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.top_downbtn = !widget.top_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(FontAwesomeIcons.tshirt,size: 15,color: Colors.white,),
                                SizedBox(width: 14),
                                Text('상의', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.top_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.top_downbtn,
                          child: Container(
                            height: 600,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: top.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = top.keys.elementAt(index);
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor: Colors.blue,
                                      value: top[_key],
                                      title: Text(_key,style: TextStyle(color: Colors.white),),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.bottom_downbtn = !widget.bottom_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/jeans.png',width: 20,),
                                SizedBox(width: 14),
                                Text('하의', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.top_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      value: bottom[_key],
                                      title: Text(_key,style: TextStyle(color: Colors.white),),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.outer_downbtn = !widget.outer_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/coat.png',width: 20,),
                                SizedBox(width: 14),
                                Text('아우터', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.top_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      value: outer[_key],
                                      title: Text(_key,style: TextStyle(color: Colors.white),),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.dress_downbtn = !widget.dress_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/dress.png',width: 20,),
                                SizedBox(width: 14),
                                Text('원피스', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.top_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      value: dress[_key],
                                      title: Text(_key,style: TextStyle(color: Colors.white),),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.beachWear_downbtn = !widget.beachWear_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/bikini.png',width: 20,),
                                SizedBox(width: 14),
                                Text('비치웨어', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.beachWear_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      value: beachWear[_key],
                                      title: Text(_key,style: TextStyle(color:Colors.white),),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.innerWear_downbtn = !widget.innerWear_downbtn;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/yoga.png',width: 20,),
                                SizedBox(width: 14),
                                Text('이너웨어', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.innerWear_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      value: innerWear[_key],
                                      title: Text(_key,style: TextStyle(color:Colors.white),),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),




                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.fitnessWear_downbtn = !widget.fitnessWear_downbtn;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/yoga.png',width: 20,),
                                SizedBox(width: 14),
                                Text('피트니스', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.fitnessWear_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      value: fitnessWear[_key],
                                      title: Text(_key,style: TextStyle(color:Colors.white),),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),


                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.blue,
                            onPressed: (){
                              setState(() {
                                widget.accessory_downbtn = !widget.accessory_downbtn;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/swimwear.png',width: 20,),
                                SizedBox(width: 14),
                                Text('악세서리', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                widget.accessory_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.accessory_downbtn,
                          child: Container(
                            height: 500,
                            child: Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: accessory.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String _key = accessory.keys.elementAt(index);
                                  return Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white, // Your color
                                    ),
                                    child: CheckboxListTile(
                                      activeColor: Colors.blue,
                                      value: accessory[_key],
                                      title: Text(_key,style: TextStyle(color: Colors.white),),
                                      onChanged: (val) {
                                        setState(() {
                                          accessory[_key] = val;
                                          setState(() {
                                            accessory[_key] ? widget.selectedCategoryList.add(_key)
                                                : widget.selectedCategoryList.remove(_key);
                                          });
                                          print(widget.selectedCategoryList);
                                        });
                                      },
                                    ),
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
                        _getDelayForReset('category');
                        Navigator.pop(context, null);
                      },
                      child:Text('필터 해제',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
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
                    child:Text('취소',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context,null);
                      if(widget.selectedCategoryList.length == 0){
                        _getDelayForReset('category');
                      }else{
                        _getDelayForCategoryFilter();
                      }
                    },
                    child: Text('적용',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                ],
              );
            },
          );
        });
  }

  Future<Map<String, bool>> _priceFilterAlert() async {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Color(0xff142035),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Container(
                        width: 25,
                        child: Image.asset('assets/icons/tag.png',color: Colors.blue,)),
                    SizedBox(width: 10,),
                    Text('가격 필터',style:TextStyle(fontWeight:FontWeight.w700,color: Colors.white),),

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
                            color:_getColorFromHex('#65baf6'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(0);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('0 ~ 9,999원', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 0 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('53aaeb'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(1);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('10,000원 대', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 1 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('#3d93e4'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(2);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('20,000원 대', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 2 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('#3c94fc'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(3);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('30,000원 대', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 3 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('#3189fe'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(4);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('40,000원 대', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 4 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('#1b74ff'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(5);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('50,000원 대', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 5 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('#0961ff'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(6);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('60,000원 대', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 6 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('#055dff'),
                            onPressed: (){
                              setState(() {
                                _getPriceFilter(7);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('70,000원 ~', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white)),
                                Spacer(),
                                Visibility(
                                    visible: widget.selectedPrice == 7 ? true: false,
                                    child: Icon(Icons.brightness_1,color: Colors.pink,size: 13,)),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Visibility(
                    visible: widget.pricefilter?true:false,
                    child: FlatButton(
                      onPressed: () {
                        _getDelayForReset('price');
                        Navigator.pop(context, null);
                      },
                      child:Text('필터 해제',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState((){
                      });
                      Navigator.pop(context, null);
                    },
                    child:Text('닫기',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ],
              );
            },
          );
        });
  }

  Future<Map<String, bool>> _colorFilterAlert() async {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Color(0xff142035),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 25,
                        child: Image.asset('assets/icons/painter.png',color: Colors.blue,)),
                    SizedBox(width: 10,),
                    Text('컬러 필터',style:TextStyle(fontWeight:FontWeight.w700,color: Colors.white),),
                    Spacer(),
                    Visibility(
                      visible: widget.selectedColor != "999"?true : false,
                        child: Text('적용 : ${widget.selectedColor}',style:TextStyle(fontWeight:FontWeight.w700,color: Colors.white,fontSize: 13),)),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Container(
                    width: double.minPositive,
                    height: 700,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color: Colors.red,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('red');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('레드', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.pinkAccent,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('pink');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('핑크', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex("800020"),
                            onPressed: (){
                              setState(() {
                                _getColorFilter('wine');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('버건디 와인', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.purple,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('puple');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('퍼플', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.yellow,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('yellow');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('옐로우', style: TextStyle(fontSize: 15,color: Colors.black)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex("F5F5DC"),
                            onPressed: (){
                              setState(() {
                                _getColorFilter('beige');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('베이지', style: TextStyle(fontSize: 15,color: Colors.black)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.green,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('green');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('그린', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('964B00'),
                            onPressed: (){
                              setState(() {
                                _getColorFilter('brown');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('브라운', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex("000080"),
                            onPressed: (){
                              setState(() {
                                _getColorFilter('blue');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('블루', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.lightBlueAccent,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('sky');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('스카이', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.white,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('white');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('화이트', style: TextStyle(fontSize: 15,color: Colors.black)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.grey,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('grey');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('그레이', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:Colors.black,
                            onPressed: (){
                              setState(() {
                                _getColorFilter('black');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('블랙', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:_getColorFromHex('3E5F40'),
                            onPressed: (){
                              setState(() {
                                _getColorFilter('khaki');
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('카키', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Visibility(
                    visible: widget.colorfilter?true:false,
                    child: FlatButton(
                      onPressed: () {
                        _getDelayForReset('color');
                        Navigator.pop(context, null);
                      },
                      child:Text('필터 해제',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState((){
                      });
                      Navigator.pop(context, null);
                    },
                    child:Text('닫기',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ],
              );
            },
          );
        });
  }

  Future _getDelayForCategoryFilter() {
    return Future.delayed(Duration(milliseconds: 1))
        .then((onValue) =>
        setState((){
        stopTrigger = 1;
        widget.VisibiltyTriger = true;
        widget.filter = true;
        widget.categoryfilter = true;
        _gridBuilder();
         })
    );
  }

  Future _getDelayForPriceFilter(int num) {
    return Future.delayed(Duration(milliseconds: 1))
        .then((onValue) =>
        setState((){
          widget.selectedPrice = num;
          widget.filter = true;
          stopTrigger = 1;
          widget.pricefilter = true;
          _gridBuilder();
        })
    );
  }

  Future _getDelayForColorFilter(String selectedColor) {
    return Future.delayed(Duration(milliseconds: 1))
        .then((onValue) =>
        setState((){
          widget.selectedColor = selectedColor;
          widget.filter = true;
          stopTrigger = 1;
          widget.colorfilter = true;
          _gridBuilder();
        })
    );
  }

  Future _getPriceFilter(int num,{int num0}){
    var _temCategory = widget.selectedCategoryList;
    var _temColor = widget.selectedColor;

    if(widget.pricefilter == true){
      // 두번째 클릭
      if( widget.categoryfilter == true){
        var colorfilter2 = widget.colorfilter;
        _getDelayForReset('price');
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          widget.selectedCategoryList=_temCategory;
        });
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          _getDelayForCategoryFilter();
        });
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) =>_getDelayForPriceFilter(num));

        if(colorfilter2 == true){
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) =>_getDelayForColorFilter(_temColor));
        }
      }
      else {
        print( "ad");
        var _temColor2 = widget.colorfilter;
        _getDelayForReset('price');
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) => _getDelayForPriceFilter(num));
        if(_temColor2 == true){
          print( "cd");
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) =>_getDelayForColorFilter(_temColor));
        }
      }
    }
    else{
      // price 처음 클릭
      if( widget.categoryfilter == true){
        var colorfilter2 = widget.colorfilter;
        _getDelayForReset('price');
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          widget.selectedCategoryList=_temCategory;
        });
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          _getDelayForCategoryFilter();
        });
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) =>_getDelayForPriceFilter(num));

        if(colorfilter2 == true){
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) =>_getDelayForColorFilter(_temColor));
        }
      }
      else {
        // 바로 처음 또는 컬러 필터
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) => _getDelayForPriceFilter(num));
        if(widget.colorfilter == true){
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) =>_getDelayForColorFilter(_temColor));
        }
      }

     // _getDelayForPriceFilter(num);
    }
    if(num0 != 0){
      Navigator.pop(context,null);
    }
  }

  Future _getColorFilter(String selectedColor,{int num}){
    var _temCategory = widget.selectedCategoryList;
    var _temPrice = widget.selectedPrice;

    if(widget.colorfilter == true){
      if(widget.categoryfilter == true){
        var pricefilter2 = widget.pricefilter;
        _getDelayForReset('color');
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          widget.selectedCategoryList=_temCategory;
        });
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          _getDelayForCategoryFilter();
        });
        if(pricefilter2 == true) {
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) => _getDelayForPriceFilter(_temPrice));
        }
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) =>_getDelayForColorFilter(selectedColor));
      }
      else{
        var _temPrice2 = widget.pricefilter;
        _getDelayForReset('color');
        if(_temPrice2 == true) {
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) => _getDelayForPriceFilter(_temPrice));
        }

        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) =>_getDelayForColorFilter(selectedColor));
      }
    }
    else{
      if(widget.categoryfilter == true){
        var pricefilter2 = widget.pricefilter;
        _getDelayForReset('color');
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          widget.selectedCategoryList=_temCategory;
        });
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) {
          _getDelayForCategoryFilter();
        });
        if(pricefilter2 == true) {
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) => _getDelayForPriceFilter(_temPrice));
        }
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) =>_getDelayForColorFilter(selectedColor));
      }
      else{
        if(widget.pricefilter == true) {
          Future.delayed(Duration(milliseconds: 50))
              .then((onValue) => _getDelayForPriceFilter(_temPrice));
        }
        Future.delayed(Duration(milliseconds: 50))
            .then((onValue) =>_getDelayForColorFilter(selectedColor));
      }
      _getDelayForColorFilter(selectedColor);
    }

      if(num != 0){
        Navigator.pop(context,null);
      }


  }

  Future _getODDFilter(bool ODD){
    var _temCategory = widget.selectedCategoryList;
    var _temPrice = widget.selectedPrice;
      Future.delayed(Duration(milliseconds: 50))
          .then((onValue) {
        setState(() {
        widget.filter = true;
        widget.oddfilter = ! widget.oddfilter;
        });
      });


  }

  Future _getDelayForReset(String filter) {
      setState(() {
        _reset();
          stopTrigger = 1;
          widget.selectedCategoryList=[];
          widget.categoryfilter = false;
          widget.oddfilter = false;
          widget.selectedPrice = 999;
          widget.selectedColor = "999";
          widget.pricefilter = false;
          widget.colorfilter = false;
          widget.filter = false;

      });
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }

}

