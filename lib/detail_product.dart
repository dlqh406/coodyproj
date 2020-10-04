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
      body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
  return ListView(
    children: [
      _buildfirstBody(context),
      _buildSecondBody(context)
    ],
  );
  }
 Widget _buildfirstBody(context) {
   Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          SizedBox(
            height: size.height *0.8,
            child: Row(
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
                Expanded(child: Column(),),
                Hero(
                  tag: document['thumbnail_img'],
                  child: Container(
                      height: size.height *0.8,
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
                )
              ],
            ),
          )
        ],
      );
 }
 //https://firebasestorage.googleapis.com/v0/b/coody-f21eb.appspot.com/o/data%2F4d30c8d845b4575d7333f2a65e76c232.png?alt=media&token=88bec133-210f-4f9b-a8bf-0e13598c4d9a

  Widget _buildSecondBody(BuildContext context) {
    return Scrollbar(
      child: Column(
        children: [
          Image.network(document['detail_img']),
        ],
           ),
    );
  }



}
