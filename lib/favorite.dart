import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'detail_product.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Favorite extends StatefulWidget {
  var stopTrigger = 1;
  var unchanging ;
  List<bool>bool_list_each_GridSell =[];
  List<String> styleList = [];
  var tf_copy = [];

  final FirebaseUser user;
  Favorite(this.user);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  // 여기서
  @override
  void initState() {
    super.initState();
    if(widget.stopTrigger == 1){
      setState(() {
        widget.unchanging = Firestore.instance.collection("uploaded_product").snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),
           child:AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
//                Center(child: Image.asset('assets/loading.gif',width: 100, fit: BoxFit.cover)),
                title: Center(child: SizedBox(width: 100, height: 8,),),
                leading: IconButton(icon : Icon(Icons.arrow_back_ios,color:Colors.black),
                  onPressed: (){
                    Navigator.of(context).pop();
                },),
                actions: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(right: 13),
                    width: 240,
                    child: Stack(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top:3.0),
                           child: Image.asset('assets/icons/bar.png'),
                         ),
                         Center(
                           child: Row(
                           children: <Widget>[
                             SizedBox(
                               width: 20.0,
                               height: 100.0,
                             ),
                             Icon(Icons.search,color:Colors.black),
                             SizedBox(
                               width: 10.0,
                               height: 100.0,
                             ),
                             RotateAnimatedTextKit(
                               onTap: () {
                                 print("Tap Event");
                               },
                               isRepeatingAnimation: true,
                               totalRepeatCount: 300,
                               text: ["두번보는 쿠디사용설명서", "카디건 활용,잘입는 방법", "Hello World"],
                               // alignment: Alignment(1.0, 0.5),
                               textStyle: TextStyle(fontSize: 15.0,color: Colors.white),
                             ),
                           ],
                         ),)
                       ],
                        ),),
                  InkWell(
                    child: new Container(
                      width: 20,
                      child: Image.asset('assets/icons/filter.png'),)
                    ,onTap: () => {print("click")},
                  ),
                  new IconButton( icon: new Icon(Icons.more_vert,size: 28,),
                      onPressed: () => {}),
                ],

            )
        ),
        body: _bodyBuilder(),
        floatingActionButton: FloatingActionButton(
         backgroundColor: Colors.blue,
         child: Image.asset('assets/icons/cart.png',width: 34),
          onPressed: (){
           // cart page
          },
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
        height: 760,
        child: StreamBuilder <QuerySnapshot>(
          stream: _commentStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return Center(child:  CircularProgressIndicator());
            }
            var items =  snapshot.data?.documents ??[];
            var fF = items.where((doc)=> doc['style'] == "오피스룩").toList();
            var sF = items.where((doc)=> doc['style'] == "로맨틱").toList();
            var tF = items.where((doc)=> doc['style'] == "캐주얼").toList();
            fF.addAll(sF);
            fF.addAll(tF);
            widget.tf_copy.addAll(fF);
            if(widget.stopTrigger == 2 ){
              fF.shuffle();
              widget.unchanging = fF;
            }
            return StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                itemCount: fF.length,
                staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?1.2 : 1.8),
                itemBuilder: (BuildContext context, int index) {
                  for(var i=0; i<fF.length; i++){
                    widget.bool_list_each_GridSell.add(false);
                  }
                  return _buildListItem(context,widget.unchanging[index]);
                }
            );


          },
        ),
      ),
    );
  }

  Widget _buildListItem(context, document) {
    return
      InkWell(
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
      );

  }

  Stream<QuerySnapshot> _commentStream() {
    widget.stopTrigger +=1;
    if(widget.stopTrigger == 2 ){
      return widget.unchanging;
    }
  }


}
