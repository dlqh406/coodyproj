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
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class Favorite extends StatefulWidget {
  var bool_list_each_GridSell = [];
  bool categoryfilter = false;
  bool filter = false;

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

  var _visible = true;

  var fF;
  var sF;
  var tF;

  int selectedCount =0;
  var selectedCategoryList=[];
  var selectedPrice=999;

  final FirebaseUser user;
  Favorite(this.user);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite>  {

  var stopTrigger = 1;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:PreferredSize(preferredSize: Size.fromHeight(45.0),
           child: AppBar(
                titleSpacing:2.0,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    child: GestureDetector(
                        child:
                        Image.asset('assets/logo/P21.png'),
                        onTap: (){
                          Navigator.pop(context);

                        }),
                  ),
                ),
                title: Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:27.0),
                        child: InkWell(
                          child: new Container(
                              width: 25,
                              child: (widget.selectedCategoryList.length>0)?Image.asset('assets/icons/hanger.png',color: Colors.blue):Image.asset('assets/icons/hanger.png',color: Colors.black,) ),
                          onTap: () => {
                            _categoryFilterAlert()
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:33.0),
                        child: InkWell(
                          child: new Container(
                              width: 25,
                              child: (widget.selectedCategoryList.length>0)
                                  ?Image.asset('assets/icons/tag.png',color: Colors.blue,):Image.asset('assets/icons/tag.png',color: Colors.black,) ),
                          onTap: () => {
                            _priceFilterAlert()
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:33.0),
                        child: InkWell(
                          child: new Container(
                              width: 25,
                              child: (widget.selectedCategoryList.length>0)
                                  ? Image.asset('assets/icons/painter.png',color: Colors.blue,):Image.asset('assets/icons/painter.png',color: Colors.black) ),
                          onTap: () => {
                            _categoryFilterAlert()
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:33.0),
                        child: InkWell(
                          child: new Container(
                              width: 29,
                              child: (widget.selectedCategoryList.length>0)
                                  ?Image.asset('assets/icons/FD.png'):Image.asset('assets/icons/FD.png',color: Colors.black,) ),
                          onTap: () => {
                            _categoryFilterAlert()
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:33.0),
                        child: InkWell(
                          child: new Container(
                              width: 23,
                              child: (widget.selectedCategoryList.length>0)
                                  ?Image.asset('assets/icons/refresh.png'):Image.asset('assets/icons/refresh.png') ),
                          onTap: () => {
                            _categoryFilterAlert()
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
        body: _bodyBuilder(),
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
        child: StreamBuilder (
          stream:Firestore.instance.collection("uploaded_product").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return Center(child:  CircularProgressIndicator());
            }
            //if(stopTrigger == 1 ){
              if(widget.filter == false){
                  widget.fF = snapshot.data.documents.where((doc)=> doc['style'] == "오피스룩").toList();
                  widget.sF = snapshot.data.documents.where((doc)=> doc['style'] == "로맨틱").toList();
                  widget.tF = snapshot.data.documents.where((doc)=> doc['style'] == "캐주얼").toList();
                  widget.fF.addAll(widget.sF);
                  widget.fF.addAll(widget.tF);
                  widget.fF.shuffle();
                }

             if(widget.filter == true){
                if(widget.categoryfilter == true){
                 for(var i=0; i<widget.selectedCategoryList.length; i++){
                   if(i==0){
                     widget.fF= snapshot.data.documents.where((doc)=> doc['category'] == widget.selectedCategoryList[i]).toList();
                   }else{
                     widget.fF.addAll( snapshot.data.documents.where((doc)=> doc['category'] == widget.selectedCategoryList[i]).toList());
                   }
                }}
                if(widget.pricefilter == true) {
                  var minPriceRange =int.parse(widget.selectedPrice.toString()+"0000");
                  var maxPriceRange;
                  if(widget.selectedPrice == 7){
                    maxPriceRange =int.parse(widget.selectedPrice.toString()+"0000")+999999;
                  }
                  else{
                    maxPriceRange =int.parse(widget.selectedPrice.toString()+"0000")+10000;
                  }
                  widget.fF = widget.fF.where((doc)=>  int.parse(doc['price']) >= minPriceRange && int.parse(doc['price']) <= maxPriceRange ).toList();
                }


             }
            //}
            stopTrigger+=1;
            widget.fF.shuffle();


            // 경우에 수 마다 if 중첩
            return Padding(
              padding: const EdgeInsets.only(top:4,left:4,right:4),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  // 아래 여백
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 6.0,
                  itemCount: widget.fF.length,
                  staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?2.2: 2.9),
                  itemBuilder: (BuildContext context, int index) {
                    for(var i=0; i<widget.fF.length; i++ ){
                        widget.bool_list_each_GridSell.add(false);
                    }
                    //if(int.parse(widget.fF[index]['price'])>15000){
                    return

                      _buildListItem(context,widget.fF[index],index);
                  //}
            }

              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildListItem(context,document,index) {
    return
      Visibility(
        visible: true,
        child: StreamBuilder(
          stream: Firestore.instance.collection('uploaded_product').document(document.documentID).collection('review').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child:CircularProgressIndicator());
            }
            double _total =0.0;
            var averageRating =0.0;
            for(var i=0; i<snapshot.data.documents.length; i++ ){
              _total += double.parse(snapshot.data.documents[i]['rating']);
            }
            var _lengthDouble = snapshot.data.documents.length.toDouble();
            averageRating = _total / _lengthDouble;

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
                        final data = {
                          'docID' : document.documentID,
                          'date' : DateTime.now()};
                        // 댓글 추가
                        Firestore.instance
                            .collection('user_data')
                            .document(widget.user.uid)
                            .collection('like')
                            .add(data);
                      },
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ProductDetail(widget.user, document);
                        }));
                      },
                        //https://www.flaticon.com/free-icon/delivery_876079?term=delivery&page=5&position=21&related_item_id=876079/
                        child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: new BorderRadius.circular(8.0),
                                    child: Container(
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70))),
                                            FadeInImage.assetNetwork(
                                                  placeholder: 'assets/images/loading.png',
                                                  image: document['thumbnail_img'],
                                                  fit : BoxFit.cover),
                                            Positioned(
                                                top:4,
                                                right: 6,
                                                child: widget.bool_list_each_GridSell[index]?Icon(Icons.favorite,size:25,color: Colors.red,):Container())
                                          ],
                                        ),
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text("${document['productName']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,softWrap: false),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("${numberWithComma(int.parse(document['price']==null?"120000":document['price']))}"
                                        ,style: TextStyle(height:1.3,fontSize: 16.5,fontWeight: FontWeight.w700,
                                          fontFamily: 'Pacifico')),
                                    Spacer(),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:3.0),
                                      child: document['ODD_can']?Image.asset('assets/icons/FD.png',width:20,):Container(),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top:2.7),
                                      child: Visibility(
                                        visible: averageRating.isNaN?false:true,
                                        child: Row(
                                          children: [
                                            Image.asset('assets/star/star11.png', width: 14,),
                                            Text("$averageRating",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            )
                        ),
                      ),
                    );
          }
        ),
      );
  }
  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('카테고리 필터 적용',style:TextStyle(fontWeight:FontWeight.w700,color: Colors.white),),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('가격 필터 적용',style:TextStyle(fontWeight:FontWeight.w700,color: Colors.white),),
                    Text("${widget.selectedCategoryList.length}개 선택됨"
                        ,style:TextStyle(fontWeight:FontWeight.w300,fontSize:15,color: Colors.white))
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
                            color: widget.selectedPrice ==0 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(0);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('0 ~ 9,999원', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:widget.selectedPrice ==1 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(1);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('10,000원 대', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:widget.selectedPrice ==2 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(2);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('20,000원 대', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:widget.selectedPrice ==3 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(3);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('30,000원 대', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:widget.selectedPrice ==4 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(4);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('40,000원 대', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:widget.selectedPrice ==5 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {

                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(5);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('50,000원 대', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:widget.selectedPrice ==6 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {

                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(6);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('60,000원 대', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 600,
                          child: RaisedButton(
                            color:widget.selectedPrice ==7 ? Colors.deepOrange:Colors.blue,
                            onPressed: (){
                              setState(() {
                                Navigator.pop(context,null);
                                _getDelayForPriceFilter(7);
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('70,000원 ~', style: TextStyle(fontSize: 15,color: Colors.white)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _getDelayForReset('price');
                      Navigator.pop(context,null);

                    },
                    child: Text('적용 해체',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
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



  Future _getDelayForFilter() {
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

  Future _getDelayForReset(String param) {
    return Future.delayed(Duration(milliseconds: 1))
        .then((onValue) =>
        setState((){
          stopTrigger = 1;
          if( param == "category"){
          widget.selectedCategoryList=[];
          }
          else if(param == "price"){
            widget.selectedPrice = 999;
          }

          widget.filter = false;
          _reset();
        })
    );
  }
}

