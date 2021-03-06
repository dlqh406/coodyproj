import 'package:coodyproj/home.dart';
import 'package:coodyproj/search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'detail_product.dart';
import 'dart:io' show Platform;

import 'package:coodyproj/test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailSeller extends StatefulWidget {

  bool filter = false;
  bool VisibiltyTriger=false;
  bool top_downbtn = false;
  bool bottom_downbtn = false;
  bool dress_downbtn = false;
  bool beachWear_downbtn = false;
  bool outer_downbtn = false;
  bool innerWear_downbtn = false;
  bool fitnessWear_downbtn = false;
  bool accessory_downbtn = false;


  var fF;
  var sF;
  var tF;

  int selectedCount =0;
  var selectedCategoryList=[];

  final FirebaseUser user;
  final sellerCode;
  DetailSeller(this.user,this.sellerCode);

  @override
  _DetailSellerState createState() => _DetailSellerState();
}

class _DetailSellerState extends State<DetailSeller> {
  var stopTrigger = 1;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),
            child:

            AppBar(
              titleSpacing: 6.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 00.0),
                child: Container(
                  child: GestureDetector(
                      child: Icon(Icons.arrow_back_ios,size: 18,),

                      onTap: (){
                        Navigator.pop(context);

                      }),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right:15.0),
                  child: InkWell(
                    child: new Container(
                        width: 20,
                        child: (widget.selectedCategoryList.length>0)?Image.asset('assets/icons/active_filter.png'):Image.asset('assets/icons/filter.png') ),
                    onTap: () => {
                      _categoryFilterAlert()
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:10.0),
                  child: new IconButton( icon: new Icon(Icons.home,size: 23,),
                      onPressed: () => {

                      }),
                ),
              ],

            )),
        body: _bodyBuilder(),
      ),
    );

  }

  Widget _buildHeader() {
    return StreamBuilder<DocumentSnapshot>(
      stream:  Firestore.instance.collection('seller_data')
          .document(widget.sellerCode).snapshots(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(10,23),
                  blurRadius: 40,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(snapshot.data.data['thumbnail_img']),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${snapshot.data.data['companyName']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                                SizedBox(
                                  width: 20,
                                ),
                                Image.asset('assets/icons/medal.png',width: 30,),
                                SizedBox(
                                  width: 7,
                                ),
                                Text('우수 셀러',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("고객센터 :",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                                SizedBox(width: 10),

                                Padding(
                                  padding: const EdgeInsets.only(top:2.0),
                                  child: Text("${snapshot.data.data['phoneNum']}",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(top:2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 2.0),
                                        child: Text("전화 걸기",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  Widget _bodyBuilder() {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height:20),
        _gridBuilder()
      ],
    );
  }
  Widget _gridBuilder() {
    return Expanded(
      child: Container(
        child: StreamBuilder (
          stream:Firestore.instance.collection("uploaded_product").snapshots(),
          //_productStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return Center(child:  CircularProgressIndicator());
            }

            if(stopTrigger == 1 ){
              if(widget.filter == false){
                widget.fF = snapshot.data.documents.where((doc)=> doc['sellerCode'] == widget.sellerCode).toList();
                print("stopTrigger111: ${stopTrigger}");
                print('in');
                widget.fF.shuffle();
              }
              stopTrigger+=1;
              print("stopTrigger222: ${stopTrigger}");
              print("--------------------------------");
            }

            else if(widget.filter == true){
              for(var i=0; i<widget.selectedCategoryList.length; i++){
                if(i==0){
                  widget.fF= snapshot.data.documents.where((doc)=> doc['category'] == widget.selectedCategoryList[i]).toList();
                }else{
                  widget.fF.addAll( snapshot.data.documents.where((doc)=> doc['category'] == widget.selectedCategoryList[i]).toList());
                }

              }
              widget.fF.shuffle();

            }

            return Padding(
              padding: const EdgeInsets.only(top:4,left:15,right:15),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  mainAxisSpacing: 6.0,
                  crossAxisSpacing: 6.0,
                  itemCount: widget.fF.length,
                  staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?1.2 : 1.8),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildListItem(context,widget.fF[index]);
                  }
              ),
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
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ProductDetail(widget.user, document);
                }));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage.assetNetwork(
                    placeholder:'assets/images/loading.png',
                    image: document['thumbnail_img'],
                    fit : BoxFit.cover),
              ),
            )
        ),
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
    '파운데이션': false, '란제리': false,
  };
  Map<String, bool> fitnessWear = {
    '트레이닝': false, '레깅스': false,
  };
  Map<String, bool> accessory = {
    '전체' : false
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
      '파운데이션': false, '란제리': false,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('필터 적용',style:TextStyle(fontWeight:FontWeight.w700,color: Colors.white),),
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
                                Text('이너웨', style: TextStyle(fontSize: 15,color: Colors.white)),
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
                        _getDelayForReset();
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
                        _getDelayForReset();
                      }else{
                        _getDelayForFilter();
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


  Future _getDelayForFilter() {
    return Future.delayed(Duration(milliseconds: 1))
        .then((onValue) =>
        setState((){
          stopTrigger = 1;
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
          stopTrigger = 1;
          widget.selectedCategoryList=[];
          widget.filter = false;
          _reset();
        })
    );
  }
}

