import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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


  @override
  Widget build(BuildContext context) {
    _SearchPageState(){
    _searchFilter.addListener(() {
      setState(() {
        _searchText = _searchFilter.text;
      });
    });
  }


  return Scaffold(
      body:_buildSearch(context)
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Container(
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
                      autofocus: true,
                      controller: _searchFilter,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: Icon(Icons.search,color: Colors.white60 ,
                        size: 20,),
                        suffixIcon: focusNode.hasFocus
                            ?IconButton(
                             icon: Icon(Icons.cancel,size:20),
                              onPressed: (){
                                  setState(() {
                                    _searchFilter.clear();
                                    _searchText ="";
                                  });
                              },)
                            :Container(),
                        hintText: '검색',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide:  BorderSide(color:Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(color:Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide:  BorderSide(color:Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                  focusNode.hasFocus
                      ?Expanded(
                            child: FlatButton(
                              child: Text("취소",style: TextStyle(color:Colors.white),),
                              onPressed: (){
                                setState(() {
                                  _searchFilter.clear();
                                  _searchText = "";
                                  focusNode.unfocus();

                                });
                              },
                            ),)
                      :Expanded(
                            flex: 0,
                            child:Container(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
