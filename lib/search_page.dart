import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/detail_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchPage extends StatefulWidget {
  bool filter = false;
  bool VisibiltyTriger=false;
  bool top_downbtn = false;
  bool bottom_downbtn = false;
  bool dress_downbtn = false;
  bool beachWear_downbtn = false;
  bool outer_downbtn = false;
  bool innerWear_downbtn = false;
  bool fitnessWear_downbtn = false;

  var stopTrigger = 1;
  var unchanging;

  var docId ="";

  int selectedCount =0;
  var selectedCategoryList=[];

  var keywordArrayLength =0;
  var productStream = [];


  final FirebaseUser user;
  SearchPage(this.user);


  @override
  _SearchPageState createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {

  var keywordLength =0;
  final TextEditingController _searchFilter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";


  _SearchPageState() {
    _searchFilter.addListener(() {
      setState(() {
        _searchText = _searchFilter.text;
        print(_searchText);
      });
    });
  }
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff142035),
        body: ListView(
          children: [
            _buildTitleBar(),
            _buildSearchBar(),
            _buildGridView(),
            _buildKeywordBar(),
            _buildBestSellingView(),
          ],
        )
    );
  }
  Widget _buildTitleBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back_ios,size: 19,color: Colors.white,),
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
            IconButton(
              icon: Icon(Icons.more_vert,color: Colors.white,),
              onPressed: (){
                setState(() {
                });
              },)
          ],
        ),
        Visibility(
          visible: _searchText != "" ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(top:15,left:20.0),
            child: Text("쿠디 트렌드 검색",
              style: TextStyle(
                fontSize: 37, fontWeight: FontWeight.bold,color: Colors.white, letterSpacing:-1,),),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding:EdgeInsets.only(left:16.0,right:16.0),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
                      cursorColor: Colors.white,
                      focusNode: focusNode,
                      style: TextStyle(
                          fontSize: 15
                      ),
                      controller: _searchFilter,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue,
                        prefixIcon: Icon(Icons.search, color: Colors.white60, size: 20,),
                        suffixIcon: focusNode.hasFocus
                            ? IconButton(
                          icon: Icon(Icons.cancel, size: 20),
                          onPressed: () {
                            setState(() {
                              _searchFilter.clear();
                              _searchText = "";
                              focusNode.unfocus();
                            });
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (BuildContext context) =>  SearchPage(widget.user)));
                          },)
                            : Container(),
                        hintText: '찾고싶은 키워드를 입력하세요',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Visibility(
      visible: _searchText != "" ? true : false,
      child: Container(
        height: 750,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('uploaded_product').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {return CircularProgressIndicator();}
            return _buildGridViewElement(context, snapshot.data.documents);
          },
        ),
      ),
    );
  }

  Widget _buildGridViewElement(BuildContext context, documents) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in documents) {
      if (d.data.toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top:4,left:16,right:16),
      child: Expanded(
        child: StaggeredGridView.countBuilder(
            crossAxisCount: 3,
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6.0,
            itemCount: searchResults.length,
            staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?1.2 : 1.8),
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(context,searchResults[index]);
            }
        )),
    );
  }

  Widget _buildListItem(context, doc) {
    return Hero(
      tag: doc['thumbnail_img'],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProductDetail(widget.user, doc);
              }));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                  doc['thumbnail_img'],
                  fit: BoxFit.cover),
            )
        ),
      ),
    );
  }

  Widget _buildKeywordBar() {
    return Visibility(
      visible: _searchText != "" ? false : true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20.0,top:5,bottom: 11),
            child: Row(
              children: [
                Text('추천 트렌드 키워드',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: Colors.white),),
              ],
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('keyword').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(child:  CircularProgressIndicator());
                  }
                  return CarouselSlider.builder(
                      height: 160,
                      enlargeCenterPage: true,
                      viewportFraction: 0.3,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder:(BuildContext context, int itemIndex){
                        return _buildListCarouseSlider(context, snapshot.data.documents[itemIndex]);
                      },
                    );
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCarouseSlider(context, document) {
    return ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Image.network(document['img'],fit: BoxFit.fill,),
        );
  }

  Widget _buildBestSellingView() {
    return Visibility(
      visible: _searchText != "" ? false : true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:25.0,top:20,bottom: 11),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.filter = true;
                    });
                  },
                  child: Text('베스트 셀링 TOP 25',style:
                  TextStyle(fontWeight: FontWeight.bold,fontSize: 15, color: Colors.white),),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top:5,right:36.0),
                  child: InkWell(
                    child: new Container(
                        width: 18,
                        child: (widget.selectedCategoryList.length>0)?Image.asset('assets/icons/active_filter.png'):Image.asset('assets/icons/Wfilter.png') ),
                    onTap: () => {
                      _categoryFilterAlert()
                    },
                  ),
                ),
              ],
            ),
          ),
           Container(
             child: StreamBuilder<QuerySnapshot>(
                stream: _productStream(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(child:  CircularProgressIndicator());
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 25,
                      itemBuilder: (BuildContext context, int index){
                        var items;
                        if(widget.filter == false){
                          items = snapshot.data.documents;
                        }
                        else if(widget.filter == true){
                          print("true");
                          items = snapshot.data.documents
                              .where((doc)=> doc['category'] == widget.selectedCategoryList[0])
                              .toList();
                        }
                        return _buildBestSelling(context, items[index], index);
                      }
                  );
                }
              ),
           )
        ]
      ),
    );
  }

  Stream<QuerySnapshot> _productStream() {
    return Firestore.instance.collection("uploaded_product").orderBy('soldCount', descending: true).snapshots();
  }
  Widget _buildBestSelling(context,doc,index){

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ProductDetail(widget.user, doc);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(left:25.0,top:10,right: 25),
        child: Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Image.network(doc['thumbnail_img'],
                      fit: BoxFit.cover,width: 100,height: 100,)),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0, right: 10.0),
                        child: Container(
                            width:45,
                            child: Center(child: Text("${index+1}",style: TextStyle(fontWeight: FontWeight.w100 ,fontSize: 35,fontStyle: FontStyle.italic),))),
                      ),
                      Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("캐주얼 노멀 하이퀄 니트",style: TextStyle(fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Padding(
                              padding: const EdgeInsets.only(top:2.0),
                              child: Text(doc['category'],style: TextStyle(fontWeight: FontWeight.w700,color: Colors.blue),),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/star/star1.png', width:70,),
                                Padding(
                                  padding: const EdgeInsets.only(top:3.0,left: 10),
                                  child: Text("₩12,900",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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
  _resetBox(){
    widget.filter = false;
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
    _resetBox();
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
                                          if(widget.selectedCategoryList.length==0){
                                            setState(() {
                                              top[_key] ? widget.selectedCategoryList.add(_key)
                                                  : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          else{
                                            setState(() {

                                              widget.selectedCategoryList =[];
                                              top[_key] ? widget.selectedCategoryList.add(_key) : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          print(widget.selectedCategoryList);
                                        });
                                        Navigator.pop(context,null);
                                        _getDelayForFilter();
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
                                widget.bottom_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                          if(widget.selectedCategoryList.length==0){
                                            setState(() {
                                              bottom[_key] ? widget.selectedCategoryList.add(_key)
                                                  : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          else{
                                            setState(() {

                                              widget.selectedCategoryList =[];
                                              bottom[_key] ? widget.selectedCategoryList.add(_key) : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          print(widget.selectedCategoryList);
                                        });
                                        Navigator.pop(context,null);
                                        _getDelayForFilter();
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
                                widget.outer_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                          if(widget.selectedCategoryList.length==0){
                                            setState(() {
                                              outer[_key] ? widget.selectedCategoryList.add(_key)
                                                  : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          else{
                                            setState(() {

                                              widget.selectedCategoryList =[];
                                              outer[_key] ? widget.selectedCategoryList.add(_key) : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          print(widget.selectedCategoryList);
                                        });
                                        Navigator.pop(context,null);
                                        _getDelayForFilter();
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
                                widget.dress_downbtn?Icon(Icons.keyboard_arrow_up,color: Colors.white,):Icon(Icons.keyboard_arrow_down,color: Colors.white)
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
                                          dress[_key] = val;
                                          if(widget.selectedCategoryList.length==0){
                                            setState(() {
                                              dress[_key] ? widget.selectedCategoryList.add(_key)
                                                  : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          else{
                                            setState(() {
                                              widget.selectedCategoryList =[];
                                              dress[_key] ? widget.selectedCategoryList.add(_key) : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          print(widget.selectedCategoryList);
                                          Navigator.pop(context);
                                          _getDelayForFilter();
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
                                widget.innerWear_downbtn = !widget.innerWear_downbtn ;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/bikini.png',width: 20,),
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
                                          if(widget.selectedCategoryList.length==0){
                                            setState(() {
                                              innerWear[_key] ? widget.selectedCategoryList.add(_key)
                                                  : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          else{
                                            setState(() {

                                              widget.selectedCategoryList =[];
                                              innerWear[_key] ? widget.selectedCategoryList.add(_key) : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          print(widget.selectedCategoryList);
                                        });
                                        Navigator.pop(context,null);
                                        _getDelayForFilter();
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
                                          if(widget.selectedCategoryList.length==0){
                                            setState(() {
                                              fitnessWear[_key] ? widget.selectedCategoryList.add(_key)
                                                  : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          else{
                                            setState(() {

                                              widget.selectedCategoryList =[];
                                              fitnessWear[_key] ? widget.selectedCategoryList.add(_key) : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          print(widget.selectedCategoryList);
                                        });
                                        Navigator.pop(context,null);
                                        _getDelayForFilter();
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
                                widget.beachWear_downbtn = !widget.beachWear_downbtn;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/swimwear.png',width: 20,),
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
                                      title: Text(_key,style: TextStyle(color: Colors.white),),
                                      onChanged: (val) {
                                        setState(() {
                                          beachWear[_key] = val;
                                          if(widget.selectedCategoryList.length==0){
                                            setState(() {
                                              beachWear[_key] ? widget.selectedCategoryList.add(_key)
                                                  : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          else{
                                            setState(() {
                                              widget.selectedCategoryList =[];
                                              beachWear[_key] ? widget.selectedCategoryList.add(_key) : widget.selectedCategoryList.remove(_key);
                                            });
                                          }
                                          print(widget.selectedCategoryList);
                                        });
                                        Navigator.pop(context,null);
                                        _getDelayForFilter();
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
          widget.VisibiltyTriger = true;
          widget.filter = true;
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
