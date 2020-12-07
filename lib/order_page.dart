import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:kopo/kopo.dart';

class OrderPage extends StatefulWidget {
  final FirebaseUser user;
  var tem_zoneCode = "";
  var tem_address = "";
  var orderList= [["레드", "medium", "1", "8pd6ugCTiOq5OidSGFry"], ["주황", "Large", "1", "8pd6ugCTiOq5OidSGFry"]];
  //final orderList;
  OrderPage(this.user);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final myController_Receiver = TextEditingController();
  final myController_PhoneNum = TextEditingController();
  final myController_Address = TextEditingController();
  final myController_AddressDetail = TextEditingController();
  final myController_Request = TextEditingController();
  final myController_alert = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController_Address.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      myController_Request.text = "문 앞에 놓아 주세요";
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: scaffoldKey,
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
          _orderInfo(context),
          SizedBox(height: 15),
          _orderView()
        ],
      ),
    );
  }
  Widget _orderInfo(context){

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("user_data").document(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }
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
                    snapshot.data.data["default_deliveryInfo"] == null
                    ?RaisedButton(
                      color: Colors.blueAccent,
                      onPressed: (){
                        // print(myController_Receiver.text);
                        // print(myController_PhoneNum.text);
                        // print(myController_Address.text);
                        // print(myController_AddressDetail.text);

                        if(
                        myController_Receiver.text != "" &&
                        myController_PhoneNum.text != "" &&
                        myController_Address.text != "" &&
                        myController_AddressDetail.text != "" &&
                        myController_Request.text != "")
                        {
                          print("pass");
                          final data = {
                            'default_deliveryInfo' :
                            [
                              myController_Receiver.text,
                              myController_PhoneNum.text,
                              widget.tem_zoneCode,
                              widget.tem_address,
                              myController_AddressDetail.text,
                              myController_Request.text
                            ],
                            'deliveryInfoList' :
                            [
                              myController_Receiver.text,
                              myController_PhoneNum.text,
                              widget.tem_zoneCode,
                              widget.tem_address,
                              myController_AddressDetail.text,
                              myController_Request.text
                            ],
                          };
                          // 댓글 추가
                          Firestore.instance
                              .collection('user_data')
                              .document(widget.user.uid)
                              .updateData(data);
                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(content:
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle,color: Colors.blueAccent,),
                                SizedBox(width: 14,),
                                Text("주소록 저장 완료",
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                              ],
                            ),
                          )));

                        }else{
                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(content:
                          Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle,color: Colors.blueAccent,),
                                    SizedBox(width: 14,),
                                    Text("배송정보의 빈칸을 모두 채워주세요",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                                  ],
                                ),
                              )));

                        }

                      },
                      child: Text("주소록 저장",style: TextStyle(color: Colors.white),),
                    )
                    :RaisedButton(
                      child: Text("주소록 관리",style: TextStyle(color: Colors.white),),
                    color: Colors.blueAccent,
                    onPressed: (){
                    _showAlert(snapshot.data.data);
                    }),
                    SizedBox(width: 20,)
                  ],
                ),
                SizedBox(height: 5,),
                snapshot.data.data['default_deliveryInfo'] == null
                ? _orderInfoInputData()
                : _orderInfoHasData(snapshot.data.data),
                  SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  Widget _orderInfoHasData(Map<String, dynamic> doc){
    return Column(
      children: [
        Row(
          children: [
            Text("수령인 : ",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("${doc['default_deliveryInfo'][0]}"),
            SizedBox(width: 20,),
            Text('연락처 : ',style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${doc['default_deliveryInfo'][1]}"),

          ],
        ),
        SizedBox(
          height:8,
        ),
        Row(
          children: [
            Text("주소 : ",style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Text("[${doc['default_deliveryInfo'][2]}] ${doc['default_deliveryInfo'][3]} ${doc['default_deliveryInfo'][4]} ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,softWrap: false),
            ),
          ],
        ),
        SizedBox(
          height:8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("요청 사항 : ",style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Text("${doc['default_deliveryInfo'][5]}",

                  maxLines: 3,
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
                        controller: myController_Receiver,
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
                          controller: myController_PhoneNum,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ' 휴대폰 번호 (-제외)',
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
                        controller: myController_Address,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),
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
                            widget.tem_zoneCode = model.zonecode;
                            widget.tem_address = '${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''}';
                          });
                        },
                          decoration: InputDecoration(
                            hintText: "  주소",
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
                          controller: myController_AddressDetail,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: ' 상세 주소',
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
                          controller: myController_Request,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '배송 요청 사항',
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

  Widget _showAlert(Map<String, dynamic> doc) {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 700.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            new Row(
              children: <Widget>[
                new Container(

                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: new Text(
                      '주소록 관리',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: GestureDetector(
                      onTap: (){
                        myController_alert.clear();
                        Navigator.pop(context, true);
                      },
                      child: Icon(Icons.clear)),
                )
              ],
            ),
            SizedBox(height: 15,),
            // dialog centre
            Expanded(
              child: new Container(
                child: Column(
                children: [
                      for(var i=0; i<2; i++)
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                          children: [
                          Row(
                          children: [
                              Text("수령인 : ",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
                              Text("${doc['default_deliveryInfo'][0]}",style: TextStyle(fontSize: 11),),
                              SizedBox(width: 20,),
                              Text('연락처 : ',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),
                              Text("${doc['default_deliveryInfo'][1]}",style: TextStyle(fontSize: 11)),

                          ],),
                          SizedBox(
                            height:7,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text("주소 : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11)),
                          Expanded(
                          child: Text("[${doc['default_deliveryInfo'][2]}] ${doc['default_deliveryInfo'][3]} ${doc['default_deliveryInfo'][4]} ",
                              style: TextStyle(fontSize: 11),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,softWrap: false),
                          ),
                          ],
                          ),
                            SizedBox(
                              height:7,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("배송 요청 사항 : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11)),
                                Expanded(
                                  child: Text("${doc['default_deliveryInfo'][5]}",
                                      style: TextStyle(fontSize: 11),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,softWrap: false),
                                ),
                              ],
                            ),
                          ],
                          ),
                        ),
                      ),
                ],
                ),

                  ),
            ),

            // dialog bottom
            GestureDetector(
              onTap: () async {
              },
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                decoration: new BoxDecoration(
                  color:Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: new Text(
                    '질문 등록',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, child: dialog);
  }
  Widget addressList(Map<String, dynamic> doc) {
    return Column(
      children: [
        Row(
          children: [
            Text("수령인 : ",style: TextStyle(fontWeight: FontWeight.bold),),
            Text("${doc['default_deliveryInfo'][0]}"),
            SizedBox(width: 20,),
            Text('연락처 : ',style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${doc['default_deliveryInfo'][1]}"),

          ],
        ),
        SizedBox(
          height:8,
        ),
        Row(
          children: [
            Text("주소 : ",style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Text("[${doc['default_deliveryInfo'][2]}] ${doc['default_deliveryInfo'][3]} ${doc['default_deliveryInfo'][4]} ",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,softWrap: false),
            ),
          ],
        ),
      ],
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


}
