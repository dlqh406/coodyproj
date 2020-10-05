import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProductDetail extends StatelessWidget {
  final DocumentSnapshot document;
  final FirebaseUser user;

  ProductDetail(this.user,this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top:16.0,left: 17,right: 17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular((29))),
                  boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.lightBlueAccent, Colors.blueAccent])
                      ),
              width: 270.0,
              height: 50.0,
              child: new RawMaterialButton(
                shape: new CircleBorder(),
                elevation: 0.0,
                child: Text("구매하기",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white),),
                onPressed: (){},
              )),

              Container(
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Image.asset('assets/icons/cart_blue.png',width: 30,),
                ),
              )
            ],
          ),
        )

    );
  }

  Widget _buildBody(BuildContext context) {
  return ListView(
    children: [
      _buildProdInfoBody(context),
      _buildfirstBody(context),
    ],
  );
  }

  Widget _buildProdInfoBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15,right: 20,left: 20,bottom:20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(document['category'],style: TextStyle(fontWeight: FontWeight.bold),),
              Container(
                  width: 220,
                  child: Text(document['productName'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:12.0),
            child: Row(
              children: [
                Text('₩ '),
                Text('39,000',style: TextStyle(fontWeight: FontWeight.w500,fontStyle:  FontStyle.italic,fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildfirstBody(context) {
   Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          SizedBox(
            height: size.height *0.8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width:93,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:6),
                    child: Padding(
                      padding: const EdgeInsets.only(top : 10.0),
                      child: Column(
                        // -  당일배송가능 여부// - 우수판매자 // 0핀매자 썸내일 // 소재 // 카테고리종류//- 무료배송
                        children: [

                          IconButton(icon : Icon(Icons.arrow_back_ios,color:Colors.black),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },),
                          Padding(
                            padding: const EdgeInsets.only(top:60.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:3.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.lightBlueAccent,
                                          backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/coody-f21eb.appspot.com/o/ml%2FblackB.png?alt=media&token=a457de59-01ef-4dc6-bbab-4ce47f8f9345"),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Text(''),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:4.0),
                                        child: Image.asset('assets/icons/free-shipping.png',width: 45,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('무료배송'),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:4.0),
                                        child: Image.asset('assets/icons/fast-delivery.png',width: 45,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('당일배송'),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:4.0),
                                        child: Image.asset('assets/icons/medal.png',width: 45,height: 40,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('우수셀러'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Hero(
                    tag: document['thumbnail_img'],
                    child:
                    Container(
                        height: size.height *0.7,
                        width: size.width *0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(63),
                                bottomLeft: Radius.circular(63)
                            ),
                            boxShadow: [BoxShadow(
                                offset:  Offset(0,10),
                                blurRadius: 60,
                                color: Colors.black38
                            )],
                            image: DecorationImage(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.cover,
                                image: NetworkImage(document['thumbnail_img'])
                            ))
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
 }



}
