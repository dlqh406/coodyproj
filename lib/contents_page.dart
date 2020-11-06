import 'package:carousel_slider/carousel_slider.dart';
import 'package:coodyproj/detail_contents.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/detail_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';

class ContentsPage extends StatefulWidget {

  final FirebaseUser user;
  ContentsPage(this.user);


  @override
  _ContentsPageState createState() => _ContentsPageState();
}
class _ContentsPageState extends State<ContentsPage> {

  var keywordLength =0;
  final TextEditingController _searchFilter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";


  _ContentsPageState() {
    _searchFilter.addListener(() {
      setState(() {
        _searchText = _searchFilter.text;
        print("_searchFilter: ${_searchFilter.text}");
        print('_searchText: ${_searchText}');
      });
    });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kopup',
      ),
      home:

      Container(
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              _getColorFromHex("79f1a4"),
              _getColorFromHex("0396ff"),
            ],
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading:  IconButton(
                  icon: Icon(Icons.arrow_back_ios,size: 19,color: Colors.white,),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom:5.0),
                  child: new IconButton( icon: new Icon(Icons.more_vert,size: 28,color: Colors.white,),
                      onPressed: () => {
                      }),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                _buildTitleBar(),
                _buildBestSellingView(),
              ],
            )),
      ),
    )
    ;
  }
  Widget _buildTitleBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: _searchText != "" ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(left:20.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4,right:10.0),
                  child: Image.asset('assets/icons/3d.png',width: 35,),
                ),
                Text(" Magazine",
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Montserrat',
                    letterSpacing: -1.3,
                    color: Colors.redAccent,
                  ),),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBestSellingView() {
    return Visibility(
      visible: _searchText != "" ? false : true,
      child:
      Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:25.0,top:20,bottom: 0),
              child: Row(
                children: [
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _contentsStream(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(child:  CircularProgressIndicator());
                  }
                  return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index){
                        return _buildContents(context, snapshot.data.documents[index]);
                      }
                  );
                }
            )
          ]
      ),
    );
  }

  Stream<QuerySnapshot> _contentsStream() {
    return Firestore.instance.collection("magazine").orderBy('date', descending: true).snapshots();
  }


  Widget _buildContents(context,doc){

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return DetailContents(doc['title'],doc['date'],doc['detail_img']);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(left:18.0,top:15,right:18),
        child: Container(
          child: Column(
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                    color: Colors.transparent
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${doc['title']}",style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 12,),
                        onPressed: (){
                        }
                    )
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(10,23),
                      blurRadius: 40,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: FadeInImage.assetNetwork(
                    placeholder:'assets/images/loading.png',
                    image: doc['wide_thumbnail_img'],
                    fit: BoxFit.cover,width: 400,height: 200,),
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0,top:6),
                    child: Text("${_timeStampToString(doc['date'])}",style: TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

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
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }



}
