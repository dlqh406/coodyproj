import 'package:coodyproj/detail_order.dart';
import 'package:coodyproj/detail_orderList.dart';
import 'package:coodyproj/heart_page.dart';
import 'package:coodyproj/letter_page.dart';
import 'package:coodyproj/myInfo_page.dart';
import 'package:coodyproj/resent_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


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
      body: _bodyBuilder(),
    );
  }

  Widget _bodyBuilder() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('user_data').document(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Container();
        }
        return ListView(
          children: [
            SizedBox(height: 15),
            _buildHeader(snapshot.data.data),
            SizedBox(height: 15),
            _buildOrderList(),
            SizedBox(height: 15),
            customerCenter(),
            SizedBox(height: 15),
            like(),
            SizedBox(height: 15),
            recent(),
            SizedBox(height: 15),
            myInfo(),
            SizedBox(height: 80),

          ],
        );
      }
    );
  }

  Widget _buildHeader(Map<String, dynamic> doc) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 26.0),
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("${widget.user.photoUrl}"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${widget.user.displayName}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            Text('님 반가워요!',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w100),),
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
            _eventElement(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 7,
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
                        Text('${numberWithComma(int.parse(doc['reward']))} p',style: TextStyle(height:1.3,fontSize: 16.5,fontWeight: FontWeight.w900,
                            fontFamily: 'metropolis')),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                     InkWell(
                          onTap: () async{
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                              return  LetterPage(widget.user);}));
                          },
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/icons/paper-plane.png',width: 20,),
                              SizedBox(
                                width: 7,
                              ),
                              StreamBuilder(
                                  stream: Firestore.instance.collection('inquiry_data').snapshots(),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData){
                                      return Center(child: CircularProgressIndicator(),);
                                    }
                                    var _list = snapshot.data.documents.where((doc) => doc['userID'] == widget.user.uid && doc['state'] == 'completion').toList();


                                    return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('나의 쪽지함',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 5,),
                                      _list.length==0?Container():Icon(Icons.brightness_1,size:6,color: Colors.red)
                                    ],
                                  );
                                }
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios,size: 15,),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
              SizedBox(
                height: 20,
              )
          ],
        ),
      ),
    );
 }
  Widget _eventElement(){
    return Padding(
      padding: const EdgeInsets.only(left:26.0),
      child: Column(
        children: [
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
                    child: Text("이벤트 1",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text("포토 리뷰 작성 시 결제 금액의 2% 적립",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.redAccent),),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Text("이벤트 2",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text("구매만 해도 결제 금액의 2% 적립 (구매 확정 시)",
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.blue),),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Text("이벤트 3",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text("신규 가입만 해도 5,000 p 적립",
                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.orange),),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildOrderList() {
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
              child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("최근 주문 목록",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      SizedBox(
                        width: 15,
                      ),
                      Text("최근 주문 3건 까지만 목록에 보여집니다",
                        style: TextStyle(color: Colors.grey, fontSize: 10),),
                    ],
                  ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('order_data').orderBy('orderDate',descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData){
                  return Container();
                }
               var list = snapshot.data.documents.where((doc)=> doc['userID'] == "${widget.user.uid}").toList();
               return Padding(
                 padding: const EdgeInsets.only(left:20,right: 20,top:10),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     SizedBox(
                       height: 6,
                     ),
                     ListView.builder(
                       shrinkWrap: true,
                       itemCount: 1,
                       physics: NeverScrollableScrollPhysics(),
                         itemBuilder:(BuildContext context, int index){


                         int dataLength = 0;
                         if(list.length > 3){
                           dataLength = 3;
                         } else{
                           dataLength = list.length;
                         }
                         return Column(
                           children: [
                             for(var i=0; i<dataLength; i++)
                               _buildListView(context,list[i],i),
                           ],
                         );
                         }
                     ),
                     SizedBox(
                       height: 6,
                     ),
                     SizedBox(
                       width: MediaQuery.of(context).size.width*1,
                       child: RaisedButton(
                         color: Colors.blue,
                         elevation: 0,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),),
                         child: Text("주문 목록 전체 보기",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                         onPressed:(){
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context) =>
                                   DetailOrderList(widget.user,list)));

                         },
                       ),
                     )
                   ],
                 ),
               );
              }
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(context, doc, index){
    return InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                DetailOrder(widget.user,doc)));
      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('uploaded_product').document(doc['productCode']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return Column(
            children: [
              index==0?Container():opacityLine(),
              Row(

                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: FadeInImage.assetNetwork(
                        placeholder:'assets/images/19.png',
                        image: snapshot.data.data['thumbnail_img'],width: 75,height:75,fit: BoxFit.cover,)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:14.0),
                                child: Container(
                                    width: 200,
                                    child: Text("${snapshot.data.data['productName']}",
                                      style:TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Expanded(
                                  child: Text("색상 : ${doc["orderColor"]} / 사이즈 : ${doc['orderSize']} / 수량 : ${doc['orderQuantity']}개",
                                      style: TextStyle(fontSize:11 ,color: Colors.black87,
                                      ),maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false)),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:5.0,bottom: 10),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   state(doc['state']),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),


            ],
          );
        }
      ),
    );

  }

  Widget customerCenter() {
    return InkWell(
      onTap: (){
        launchURL() {
          launch('http://pf.kakao.com/_JxoxexnK/chat');
        }
        launchURL();
      },
      child: Padding(
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

            children: [
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child:
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Image.asset('assets/images/live.png',width: 50,),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0,left:10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('라이브 1:1 채팅 고객센터',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('운영시간 09:00~18:00 (월~금,공휴일 휴무)',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Icon(Icons.arrow_forward_ios,size: 17,),
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget like() {
    return InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
              return HeartPage(widget.user);
            }));

      },
      child: Padding(
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
                height: 17,
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child:
                Row(
                  children: [
                    Icon(Icons.favorite,color:Colors.red),
                    SizedBox(width: 7),
                    Text("누른 상품",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios,size: 17,),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 17,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget recent() {
    return InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context){
          return RecentPage(widget.user);
            }));

      },
      child: Padding(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("최근 본 상품",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(width: 8,),
                    Text('(최대 30개)',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 12)),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom:2.0),
                      child: Icon(Icons.arrow_forward_ios,size: 17,),
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget myInfo() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                MyinfoPage(widget.user)));

      },
      child: Padding(
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
                Row(
                  children: [
                    Text("계정 정보",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios,size: 17,),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget state(data) {
     if(data == "standby"){
     return Row(
       children: [
         Padding(
         padding: const EdgeInsets.only(left: 1,right: 7),
         child: Image.asset('assets/icons/list.png',width: 20,)
         ),
     Text('주문 확인 중' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
       ],
     );
   }

     else if(data == "ongoing"){
     return Row(
       children: [
         Padding(
             padding: const EdgeInsets.only(left: 1,right: 7),
             child: Image.asset('assets/icons/box.png',width: 20,)
         ),
         Text('발송 준비 중' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
       ],
     );
     }

     else if(data== "shipping"){
     return Row(
       children: [
         Padding(
             padding: const EdgeInsets.only(left: 1,right: 7),
             child: Image.asset('assets/icons/truck.png',width: 25,)
         ),
         Text('배송 중' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
       ],
     );
     }

     else if (data == "completion"){
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 1,right: 7),
              child:Icon(Icons.check_circle,size: 19,color: Colors.green,)
          ),
          Text('배송 완료' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
        ],
      );
     }

     else if(data == 'reviewEnd'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
               Text('후기 작성완료(구매확정)' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
             ],
           );
         }

     else if(data == 'completionEnd'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('자동 구매 확정' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }

     // 반품
     else if(data == 'standbyCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.green,)
           ),
           Text('주문 취소 완료' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'wishToCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.orangeAccent,)
           ),
           Text('반품 요청' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'approvalToCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.orangeAccent,)
           ),
           Text('반품 승인' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'completionCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.orangeAccent,)
           ),
           Text('반품 완료' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'shippingNoCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child: Image.asset('assets/icons/truck.png',width: 25,)
           ),
           Text('배송 중(반품 불가)' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'completionNoCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.green,)
           ),
           Text('배송 완료' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'reviewEndNoCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('리뷰 작성 완료(구매확정)' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'completionEndNoCancel'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('자동 구매 확정' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }

     // 교환
     else if(data == 'wishToEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.orangeAccent,)
           ),
           Text('교환 요청' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'approvalToEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.orangeAccent,)
           ),
           Text('교환 승인' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'shippingEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child: Image.asset('assets/icons/truck.png',width: 25,)
           ),
           Text('배송 중(교환 상품)' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'completionEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('배송 완료' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'reviewEndEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('리뷰 작성 완료(구매 확정)' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'completionEndEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('자동 구매 확' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'shippingNoEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child: Image.asset('assets/icons/truck.png',width: 25,)
           ),
           Text('배송 중(교환 불가)' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'completionNoEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('배송 완료' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'reviewEndNoEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('리뷰 작성 완료(구매 확정)' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     else if(data == 'completionEndNoEx'){
       return Row(
         children: [
           Padding(
               padding: const EdgeInsets.only(left: 1,right: 7),
               child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
           ),
           Text('자동 구매 확정' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
         ],
       );
     }
     // repeat
     else{
       return Row(
           children: [
           Padding(
           padding: const EdgeInsets.only(left: 1,right: 7),
    child:Icon(Icons.check_circle,size: 19,color: Colors.blue,)
    ),
    Text('주문데이터 확인 중' ,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blueAccent),),
    ],
    );

     }

       }

  Widget opacityLine (){
    return Opacity(
        opacity: 0.15,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0),
            child: Container(
              height: 1,
              color: Colors.black38,
            )));

  }

  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }

}

