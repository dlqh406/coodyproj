import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'detail_product.dart';

class SearchPage extends StatefulWidget {
  final FirebaseUser user;
  SearchPage(this.user);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
            _buildSearchBar(),
            _buildGridView()
          ],
        )

    );
  }

  Widget _buildSearchBar() {
    return Center(
      child: Column(
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    focusNode: focusNode,
                    style: TextStyle(
                        fontSize: 15
                    ),
                    controller: _searchFilter,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      prefixIcon: Icon(Icons.search, color: Colors.white60,
                        size: 20,),
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
                      hintText: '검색',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Container(
      height: 750,
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('uploaded_product').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {return CircularProgressIndicator();}
          return _buildGridViewElement(context, snapshot.data.documents);
        },
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
}