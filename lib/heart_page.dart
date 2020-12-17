import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_product.dart';
import 'package:intl/intl.dart';

class HeartPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;

  final FirebaseUser user;
  HeartPage(this.user);

  @override
  _HeartPageState createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                  padding: const EdgeInsets.only(right:10.0),
                  child: new IconButton( icon: new Icon(Icons.home,size: 23,),
                    onPressed: () => {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return Home(widget.user);
                      }))
                    },
                  ),
                ),
              ],

            )),
        body: _bodyBuilder(),
      ),
    );
  }
  Widget _bodyBuilder() {
    return ListView(
      children: [
        _buildTitleBar(),
        _gridBuilder(),
      ],
    );
  }
  Widget _buildTitleBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top:5,left:20.0,bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.favorite,color:Colors.red,size: 45,),
              SizedBox(width: 7),
              Text("누른 상품",
                style: TextStyle(
                  fontSize: 37, fontWeight: FontWeight.bold,color: Colors.black, letterSpacing:-1,),),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,bottom:3),
                child: Text('최대 30개',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _gridBuilder() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('user_data')
              .document(widget.user.uid).collection('like')
              .orderBy('date',descending: true).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child:Text("하트를 누른 상품이 없습니다",style: TextStyle(color: Colors.grey),));
            }
            var Doc_length;
            for(var i= snapshot.data.documents.length-1; i>0; i--){
              for(var j=0; j<i; j++){
                if(snapshot.data.documents[i]["docID"] == snapshot.data.documents[j]['docID']){
                  Firestore.instance.collection('user_data').document(widget.user.uid)
                      .collection('like').document(snapshot.data.documents[i].documentID).delete();
                }
              }
            }
            //30개
            if(snapshot.data.documents.length < 30){
              Doc_length=snapshot.data.documents.length;
            }
            //31개~
            else{
              Doc_length=30;
              for(var i=30; i< snapshot.data.documents.length; i++) {
                Firestore.instance.collection('user_data').document(widget.user.uid)
                    .collection('like').document(snapshot.data.documents[i].documentID).delete();
              }
            }
            return Column(
              children: [
                for(var i=0; i< Doc_length; i++)
                  StreamBuilder(
                      stream: Firestore.instance.collection('uploaded_product')
                          .document("${snapshot.data.documents[i]['docID']}").snapshots(),
                      builder: (context, _snapshot) {
                        if(!_snapshot.hasData){
                          return Center(child: CircularProgressIndicator());
                        }
                        return _buildBestSelling(_snapshot.data,i);
                      }
                  ),
              ],
            );
          }
      ),
    );
  }

  Widget _buildBestSelling(doc,index){

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ProductDetail(widget.user, doc);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(left:18.0,top:10,right:18),
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
            children: [
              Container(
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: FadeInImage.assetNetwork(
                              placeholder:'assets/images/19.png',
                              image: doc['thumbnail_img'],
                              fit: BoxFit.cover,width: 80,height: 80),
                        )),
                    Expanded(
                      child: Container(
                        height: 75,
                        child: Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Container(
                            width: 150,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${doc['productName']}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    Text(doc['category'],style: TextStyle(fontWeight: FontWeight.w700,color: Colors.blue)),
                                    Padding(
                                      padding: const EdgeInsets.only(top:3.0),
                                      child: Text("₩ ${ numberWithComma(int.parse(doc['price']==null?"0":doc['price']))}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                    icon: Icon(Icons.cancel,color: Colors.grey,size: 15,),
                                    onPressed: (){
                                      print(doc.documentID);
                                      Firestore.instance.collection('user_data').document(widget.user.uid).collection('like')
                                          .orderBy('date',descending: true).getDocuments().then((value) {
                                        Firestore.instance.collection('user_data').document(widget.user.uid)
                                            .collection('like').document(value.documents[index].documentID).delete();
                                      });
                                    }
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
//                Opacity(
//                    opacity: 0.15,
//                    child: Padding(
//                        padding: const EdgeInsets.only(
//                            top: 15.0, bottom: 5.0),
//                        child: Container(
//                          height: 1,
//                          color: Colors.black38,
//                        ))),

            ],
          ),
        ),
      ),
    );

  }
  String numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
  Widget _clearBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 46,
        width: MediaQuery.of(context).size.width*1,
        child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),),
          color: Colors.blueAccent,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => null));
          },
          child: const Text('바로 구매하기',
              style: TextStyle(color: Colors.white, fontSize: 13,fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }


}
