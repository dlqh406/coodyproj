import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'detail_product.dart';

class SearchPage extends StatefulWidget {
  var keywordArrayLength =0;
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
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            _buildTitleBar(),
            _buildSearchBar(),
            _buildKeywordBar(),
            _buildGridView()
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
                icon: Icon(Icons.arrow_back_ios,size: 19,),
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
            IconButton(
              icon: Icon(Icons.more_vert,),
              onPressed: (){
                setState(() {
                });
              },)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top:15,left:20.0),
          child: Text("쿠디 트렌드 검색",
            style: TextStyle(fontSize: 37, fontWeight: FontWeight.bold, letterSpacing:-1,),),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left:20.0,right:20.0),
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
      padding: const EdgeInsets.only(top:4,left:4,right:4),
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
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text('추천 키워드'),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('keyword').snapshots(),
              builder: (context, snapshot) {

                print( "aaa: ${snapshot.data.documents.length}");
                if(!snapshot.hasData){
                  return Center(child:  CircularProgressIndicator());
                }
              return CarouselSlider.builder(
                    height: 400,
                    viewportFraction: 0.8,
                    aspectRatio: 2.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder:(BuildContext context, int itemIndex){
                      return _buildListCarouseSlider(context, snapshot.data.documents[itemIndex]);
                    },
                  );
              }
          ),
        ],
      ),
    );
  }

  Widget _buildListCarouseSlider(context, document) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(document['img'],fit: BoxFit.fill,),
      ),
    );


  }

}
