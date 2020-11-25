import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'detail_product.dart';
import 'dart:io' show Platform;

class MyPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;

  final FirebaseUser user;
  MyPage(this.user);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        elevation: 0,
//        leading:  IconButton(
//            icon: Icon(Icons.arrow_back_ios,size: 19,color: Colors.black,),
//            onPressed: (){
//              Navigator.pop(context);
//            }
//        ),
//        title :  Text("마이페이지"),
//        actions: [
//          Padding(
//            padding: const EdgeInsets.only(bottom:5.0),
//            child: new IconButton( icon: new Icon(Icons.more_vert,size: 28,color: Colors.black,),
//                onPressed: () => {
//                }),
//          ),
//        ],
//      ),


      body: _bodyBuilder(),
    );
  }
  Widget _bodyBuilder() {
    return ListView(
      children: [
        SizedBox(height: 15),
        _buildHeader(),
        SizedBox(height: 20),
        _buildOrder(),
        SizedBox(height: 20),
        _buildOrder2(),
        SizedBox(height: 20),
        _buildOrder3()
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("${widget.user.photoUrl}"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${widget.user.displayName}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            Text('님 반가워요',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w100),),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFff6e6e),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  child: Text("이벤트",
                                      style: TextStyle(
                                        fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text("포토후기 500원 적립",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.redAccent),),
                            Text(" | ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.redAccent)),
                            Text('구매 적립 2%',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.redAccent))
                          ],
                        ),
                      ],
                    ),

                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/icons/coin2.png',width: 20,),
                        SizedBox(
                          width: 7,
                        ),
                        Text('나의 포인트',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Spacer(),
                        Text('12,000 ',style:TextStyle(fontWeight: FontWeight.bold),),
                        Text('p'),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset('assets/icons/discount.png',width: 20,),
                        SizedBox(
                          width: 7,
                        ),
                        Text('나의 쿠폰',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Spacer(),
                        Text('10 ',style:TextStyle(fontWeight: FontWeight.bold),),
                        Text('장'),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),
              SizedBox(
                height: 20,
              )
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: Opacity(
//                  opacity: 0.15,
//                  child: Padding(
//                      padding: const EdgeInsets.only(
//                         top: 35, bottom: 10.0),
//                      child: Container(
//                        height: 1,
//                        color: Colors.black38,
//                      ))),
//            ),
          ],
        ),
      ),
    );
 }
  Widget _buildOrder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child: Text("주문배송 현황",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('결제 완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_ios, size: 15,color: Colors.grey,

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송준비중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('구매확정',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),


                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: Opacity(
//                  opacity: 0.15,
//                  child: Padding(
//                      padding: const EdgeInsets.only(
//                         top: 35, bottom: 10.0),
//                      child: Container(
//                        height: 1,
//                        color: Colors.black38,
//                      ))),
//            ),
          ],
        ),
      ),
    );
  }
  Widget _buildOrder2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child:
              Text("후기를 남겨주세요",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),


            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('결제 완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_ios, size: 15,color: Colors.grey,

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송준비중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('구매확정',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),


                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: Opacity(
//                  opacity: 0.15,
//                  child: Padding(
//                      padding: const EdgeInsets.only(
//                         top: 35, bottom: 10.0),
//                      child: Container(
//                        height: 1,
//                        color: Colors.black38,
//                      ))),
//            ),
          ],
        ),
      ),
    );
  }
  Widget _buildOrder3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child:
              Text("나의 1:1 문의",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),


            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('결제 완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                            Icons.arrow_forward_ios, size: 15,color: Colors.grey,

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송준비중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송중',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('배송완료',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 7),
                          child: Icon(
                              Icons.arrow_forward_ios, size: 15,color: Colors.grey

                          ),
                        ),
                        Column(
                          children: [
                            Text('0',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),),
                            SizedBox(height: 10,),
                            Text('구매확정',style: TextStyle(fontSize: 11),),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),


                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10),
//              child: Opacity(
//                  opacity: 0.15,
//                  child: Padding(
//                      padding: const EdgeInsets.only(
//                         top: 35, bottom: 10.0),
//                      child: Container(
//                        height: 1,
//                        color: Colors.black38,
//                      ))),
//            ),
          ],
        ),
      ),
    );
  }


}
