import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:kopo/kopo.dart';

class OrderPage extends StatefulWidget {
  final FirebaseUser user;
  var aa = "";
  var orderList= [["레드", "medium", "1", "8pd6ugCTiOq5OidSGFry"], ["주황", "Large", "1", "8pd6ugCTiOq5OidSGFry"]];
  //final orderList;
  OrderPage(this.user);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final myController_Address = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController_Address.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getColorFromHex("#f2f2f2"),
      appBar: PreferredSize(preferredSize: Size.fromHeight(40.0),
          child: AppBar(
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
      body:ListView(
        children: [
          _orderInfo(),
          SizedBox(height: 15),
          _orderView()
        ],
      ),
    );
  }
  Widget _orderInfo(){

    return Container(
      color: Colors.white,
      child:
      Padding(
        padding: const EdgeInsets.only(top:5,bottom:2.0,left: 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("배송 정보 ",style: TextStyle(fontWeight: FontWeight.bold, fontSize:20),),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: (){
                  },
                )
              ],
            ),
            SizedBox(height: 5,),
            _orderInfoInputData(),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
  Widget _orderInfoHasData(){
    return Column(
      children: [
        Row(
          children: [
            Text("수령인 : ",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("${widget.user.displayName}"),
            SizedBox(width: 20,),
            Text('연락처 : ',style: TextStyle(fontWeight: FontWeight.bold)),
            Text('010-6827-6863'),

          ],
        ),
        SizedBox(
          height:8,
        ),
        Row(
          children: [
            Text("주소 : ",style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Text('[08521]서울특별시 강남대로 107길 21 대능빌딩 2층',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,softWrap: false),
            ),
          ],
        ),
      ],
    );
  }
  Widget _orderInfoInputData(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Padding(
              padding: const EdgeInsets.only(right:18.0),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,bottom: 5),
                      child: TextField(
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '  받는 사람',

                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,bottom: 5),
                      child: TextField(
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ' 휴대폰 번호',
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,bottom: 1.5),
                      child: TextField(
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),
                        controller: myController_Address,
                        onTap: () async {
                          KopoModel model = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Kopo(),
                            ),
                          );
                          print(model.toJson());
                          setState(() {
                            myController_Address.text =
                            '[${model.zonecode}] ${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''}';
                          });
                        },
                          decoration: InputDecoration(
                            labelText: "  주소",
                            border: InputBorder.none,
                          ),

                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,bottom: 5),
                      child: TextField(
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ' 휴대폰 번호',
                          )
                      ),
                    ),
                  ),

                ],
              ),
            ),

      ],
    );
  }

  Widget _orderView(){

         return Container(
           color: Colors.white,
           child:
           Padding(
             padding: const EdgeInsets.only(top:10,bottom:2.0,left: 20),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(bottom: 10),
                   child: Text("주문 상품 ",style: TextStyle(fontWeight: FontWeight.bold, fontSize:20),),
                 ),
                 ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder:(BuildContext context, int index){
                          return Column(
                            children: [
                              for(var i=0; i<widget.orderList.length; i++)
                              StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance.collection("uploaded_product").document(widget.orderList[i][3]).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                    return _buildListView(context, snapshot.data.data,i);
                            },
                          ),
                            ],
                          );
                    }
        ),
               ],
             ),
           ),
         );
  }
  Widget _buildListView(context, doc, index){

    return Column(
      children: [

        Row(
          children: [
             ClipRRect(
                 borderRadius: BorderRadius.circular(12.0),
                 child: FadeInImage.assetNetwork(
                   placeholder:'assets/images/19.png',
                   image: doc['thumbnail_img'],width: 75,height:75,fit: BoxFit.cover,)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Column(
                  children: [
                   Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:5.0),
                              child: Container(
                                  width: 200,
                                  child: Text("${doc['productName']}",
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
                            child: Text("색상 : ${widget.orderList[index][0]} / 컬러 : ${widget.orderList[index][1]} / 수량 : ${widget.orderList[index][2]}개",
                              style: TextStyle(fontSize:14 ,color: Colors.black87,
                              ),maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false)),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child:doc['ODD_can']?
                              Image.asset('assets/icons/FD.png',width: 25,) :Container(),
                            ),
                            SizedBox(width: 10,),
                            Text("8/21(오늘) 배송 예정 ",style: TextStyle(fontWeight: FontWeight.bold),)
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
      // SizedBox(
      //   height: 10,
      // )
        opacityLine()
      ],
    );

  }

  Widget opacityLine (){
    return Opacity(
        opacity: 0.15,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 6.0, bottom: 6.0),
            child: Container(
              height: 1,
              color: Colors.black38,
            )));

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
}
