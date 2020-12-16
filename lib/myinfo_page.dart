import 'package:coodyproj/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_product.dart';
import 'package:intl/intl.dart';
import 'package:kopo/kopo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
class MyinfoPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;

  final FirebaseUser user;
  MyinfoPage(this.user);

  var tem_zoneCode = "";
  var tem_address = "";
  //var orderList= [["레드", "medium", "1", "8pd6ugCTiOq5OidSGFry","100","CyP3n6K9OnOW45uqkInPXQIUFHx2"], ["주황", "Large", "1", "8pd6ugCTiOq5OidSGFry","50","CyP3n6K9OnOW45uqkInPXQIUFHx2"],["주황", "Large", "1", "8pd6ugCTiOq5OidSGFry","50","CyP3n6K9OnOW45uqkInPXQIUFHx2"]];
  var orderList;
  var receiver,phoneNum,zoneCode,address,addressDetail,request = "";
  var triger = true;
  var addAddress  = false;
  var addAddress2  = true;
  var firstName;
  bool checkPrivacy = false;
  var totalPrice_String = "";
  var rewardTotal = 0;
  var totalReward;

  int _totalPrice=0;
  int _totalDiscount = 0;
  int _finalPirce =0;
  bool stopTriger =true;
  int paymentValue = 1;


  @override
  _MyinfoPageState createState() => _MyinfoPageState();
}

class _MyinfoPageState extends State<MyinfoPage> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();

  final myController_Receiver = TextEditingController();
  final myController_PhoneNum = TextEditingController();
  final myController_Address = TextEditingController();
  final myController_AddressDetail = TextEditingController();
  final myController_Request = TextEditingController();
  final myController_alert = TextEditingController();
  final TextEditingController _rewardController = TextEditingController(
  );
  FocusNode focusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _rewardText = "";

  _OrderPageState() {
    _rewardController.addListener(() {

      if(widget.rewardTotal < int.parse(_rewardController.text)){

        _rewardController.clear();
        setState(() {
          widget._totalDiscount = 0;
        });
        FocusScope.of(context).unfocus();
        scaffoldKey.currentState
            .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
        Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,color: Colors.blueAccent,),
              SizedBox(width: 14,),
              Text("입력한 값이 적립금보다 많아요",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
            ],
          ),
        )));
      }
      else{
        setState(() {
          _rewardText = _rewardController.text;
        });
      }
    }
    );
  }

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
    return Container(
      child: Scaffold(
        key: scaffoldKey,
        appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),
            child:
            AppBar(
              centerTitle: true,
              title: Text('내 정보'),
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
        SizedBox(
          height: 15,
        ),
        myInfo(),
        SizedBox(
          height: 15,
        ),
        _orderInfo(context),
        SizedBox(
          height:50,
        ),
        logout()
      ],
    );
  }


  Widget myInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('user_data')
          .document(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        return InkWell(
          onTap: () {

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
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20,top: 20,bottom: 20,right: 20),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Row(
                          children: [
                            Text('고객 명 : '),
                            Text('${widget.user.displayName}',style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                          SizedBox(height: 7,),
                          Row(
                            children: [
                              Text('이메일 : '),
                              Text('${widget.user.email}',style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 7,),
                          Row(
                            children: [
                              Text('연락처 : '),
                              Text('${snapshot.data.data['phoneNum']}',style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget logout() {
    return InkWell(
      onTap: () {
        print("aa");
        FirebaseAuth.instance.signOut();
        _googleSignIn.signOut();
        facebookLogin.logOut();
        Navigator.pop(context);
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
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 10,),
                    Text("로그아웃 하기",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Spacer(),
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
  Widget myInfo2() {
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


  Widget _orderInfo(context){

    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection("user_data").document(widget.user.uid).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          var _doc = snapshot.data.data;
          widget.rewardTotal = int.parse(_doc['reward']);
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
              Padding(
                padding: const EdgeInsets.only(top:5,bottom:2.0,left: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("나의 주소록 ",style: TextStyle(fontWeight: FontWeight.bold, fontSize:20),),
                        Spacer(),
                        snapshot.data.data["default_deliveryInfo"] == null
                            ?RaisedButton(
                          color: Colors.blueAccent,
                          onPressed: (){
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
                                [{
                                  "0" : myController_Receiver.text,
                                  "1" : myController_PhoneNum.text,
                                  "2" : widget.tem_zoneCode,
                                  "3" : widget.tem_address,
                                  "4" : myController_AddressDetail.text,
                                  "5" : myController_Request.text
                                }
                                ],
                              };
                              // 댓글 추가
                              Firestore.instance
                                  .collection('user_data')
                                  .document(widget.user.uid)
                                  .updateData(data);



                              scaffoldKey.currentState
                                  .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
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
                                  .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
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
                            :Visibility(
                          visible:widget.addAddress2,
                          child: RaisedButton(
                              child: Text("주소록 관리",style: TextStyle(color: Colors.white),),
                              color: Colors.blueAccent,
                              onPressed: (){
                                _showAlert(snapshot.data.data);
                              }),
                        ),
                        Visibility(
                          visible: widget.addAddress,
                          child: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: RaisedButton(
                              color: Colors.grey,
                              onPressed: (){
                                setState(() {
                                  widget.addAddress=false;
                                  widget.addAddress2=true;
                                });
                              },
                              child: Text("취소 ",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.addAddress,
                          child: RaisedButton(
                            color: Colors.blueAccent,
                            onPressed: (){

                              if(
                              myController_Receiver.text != "" &&
                                  myController_PhoneNum.text != "" &&
                                  myController_Address.text != "" &&
                                  myController_AddressDetail.text != "" &&
                                  myController_Request.text != "") {
                                Map<String, dynamic> data = new Map();
                                data['0'] = myController_Receiver.text;
                                data['1'] = myController_PhoneNum.text;
                                data['2'] = widget.tem_zoneCode;
                                data['3'] = widget.tem_address;
                                data['4'] = myController_AddressDetail.text;
                                data['5'] = myController_Request.text;

                                _doc['deliveryInfoList'].add(data);
                                var data0 = {"deliveryInfoList": _doc['deliveryInfoList']};

                                Firestore.instance
                                    .collection('user_data')
                                    .document(widget.user.uid)
                                    .updateData(data0);
                                setState(() {
                                  widget.addAddress = false;
                                  widget.addAddress2 = true;
                                  myController_Receiver.clear();
                                  myController_PhoneNum.clear();
                                  myController_Address.clear();
                                  myController_AddressDetail.clear();
                                });


                                scaffoldKey.currentState
                                    .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
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

                              }
                              else{
                                scaffoldKey.currentState
                                    .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
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
                          ),
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:6.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 17.0, vertical: 6.0),
                                child: Text("기본 주소",
                                    style: TextStyle(color: Colors.white,fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    snapshot.data.data['default_deliveryInfo'] == null
                        ? _orderInfoInputData()
                        : _orderInfoHasData(snapshot.data.data),
                    _orderInfoInputData_from_Alert(),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _orderInfoHasData(Map<String, dynamic> doc){
    if(widget.triger == true){
      widget.receiver = doc['default_deliveryInfo'][0];
      widget.phoneNum = doc['default_deliveryInfo'][1];
      widget.zoneCode = doc['default_deliveryInfo'][2];
      widget.address = doc['default_deliveryInfo'][3];
      widget.addressDetail = doc['default_deliveryInfo'][4];
      widget.request = doc['default_deliveryInfo'][5];
      widget.triger = false;
    }

    return Visibility(
      visible: widget.addAddress2,
      child: Column(
        children: [
          Row(
            children: [
              Text("수령인 : ",style: TextStyle(fontWeight: FontWeight.bold),),
              Text("${widget.receiver}"),
              SizedBox(width: 20,),
              Text('연락처 : ',style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${widget.phoneNum}"),

            ],
          ),
          SizedBox(
            height:8,
          ),
          Row(
            children: [
              Text("주소 : ",style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text("[${widget.zoneCode}] ${widget.address} ${widget.addressDetail} ",
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
              Text("배송 요청 사항 : ",style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text("${widget.request}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,softWrap: false),
              ),
            ],
          ),
        ],
      ),
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
                      maxLength: 1,
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

  Widget _orderInfoInputData_from_Alert(){

    return Visibility(
      visible: widget.addAddress,
      child: Column(
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
      ),
    );
  }

  Widget alert_orderInfoInputData(){

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
                          fontSize: 10,
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
                          fontSize: 10,
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
                        fontSize: 10,
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
                          fontSize: 10,
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
                          fontSize: 10,
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

  Widget _showAlert(Map<String, dynamic> doc) {

    //AlertDialog dialog =

    AlertDialog _dialog = AlertDialog(
      content:  Container(
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
            // 주소록 관리
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
            SizedBox(height: 5,),
            // dialog centre
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: 2000,
                  child: Column(
                    children: [
                      //for(var i=0; i<7; i++)
                      for(var i=0; i<doc['deliveryInfoList'].length; i++)
                        alert_addressList(i,doc),
                    ],
                  ),
                ),
              ),
            ),

            // dialog bottom
            alert_addAddressList(doc)
          ],
        ),
      ),
    );


    showDialog(context: context, child: _dialog);
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

  Widget alert_addressList(int i, Map<String, dynamic> doc) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          i ==0? Container():opacityLine(),
          alert_addressListHeader(i,doc),
          alert_addressListBody(i,doc),

        ],
      ),
    );
  }

  Widget alert_addAddressList(Map<String, dynamic> doc) {
    return  InkWell(
      onTap: () async {
        // 0: 받는사람 , 1: 핸드폰 번호, 2: 우편번호, 3: 주소, 4: 상세주소, 5:배송 요청 사항
        setState(() {
          widget.addAddress = true;
          widget.addAddress2 = false;
        });
        Navigator.pop(context);
      },
      child: new Container(
        padding: new EdgeInsets.all(16.0),
        decoration: new BoxDecoration(
          color:Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:5.0),
          child: new Text(
            '주소 추가',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget alert_addressListHeader(int i, var doc) {
    return Row(
      children: [
        Visibility(
          child: Container(

            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 4.0),
                child: Text("기본주소",
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ),
          ),
          visible: i==0?true:false,
        ),
        // 기본 주소 변경
        Visibility(
          visible: i==0?false:true,
          child: InkWell(
            onTap: (){
              //var _doc =  doc['deliveryInfoList'];
              // deliveryInfoList 순서 변경 : default가 0에 와야함
              var tem = doc['deliveryInfoList'][0];
              doc['deliveryInfoList'][0] = doc['deliveryInfoList'][i];
              doc['deliveryInfoList'][i] = tem;
              var data0 = {"deliveryInfoList" : doc['deliveryInfoList']};
              Firestore.instance
                  .collection('user_data')
                  .document(widget.user.uid)
                  .updateData(data0);
              // default 변경됨
              final data = {
                'default_deliveryInfo' :
                [
                  doc['deliveryInfoList'][0]["0"],
                  doc['deliveryInfoList'][0]["1"],
                  doc['deliveryInfoList'][0]["2"],
                  doc['deliveryInfoList'][0]["3"],
                  doc['deliveryInfoList'][0]["4"],
                  doc['deliveryInfoList'][0]["5"]
                ],
              };
              Firestore.instance
                  .collection('user_data')
                  .document(widget.user.uid)
                  .updateData(data);

              setState(() {
                widget.receiver = doc['deliveryInfoList'][0]["0"];
                widget.phoneNum = doc['deliveryInfoList'][0]["1"];
                widget.zoneCode = doc['deliveryInfoList'][0]["2"];
                widget.address = doc['deliveryInfoList'][0]["3"];
                widget.addressDetail = doc['deliveryInfoList'][0]["4"];
                widget.request = doc['deliveryInfoList'][0]["5"];
              });

              Navigator.pop(context);
              _showAlert(doc);
            },
            child: Container(
              width: 110,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  child: Text("기본주소로 변경하기",
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 10)),
                ),
              ),
            ),
          ),
        ),
        Spacer(),

        // 주소 삭제
        i==0?IconButton(
            icon: Icon(Icons.cancel,color: Colors.white,size: 15,))
            : IconButton(
          onPressed: (){
            doc['deliveryInfoList'].removeAt(i);
            final data = {
              'deliveryInfoList': doc['deliveryInfoList']
            };
            Firestore.instance
                .collection('user_data')
                .document(widget.user.uid)
                .updateData(data);

            Navigator.pop(context);
            _showAlert(doc);

          },
          icon: Icon(Icons.cancel,color: Colors.grey,size: 15,) ,
        )
      ],
    );

  }

  Widget alert_addressListBody(int i, var doc) {
    return  InkWell(
      // onTap: (){
      //   // setState(() {
      //   //   widget.receiver = doc['deliveryInfoList'][i]["0"];
      //   //   widget.phoneNum = doc['deliveryInfoList'][i]["1"];
      //   //   widget.zoneCode = doc['deliveryInfoList'][i]["2"];
      //   //   widget.address = doc['deliveryInfoList'][i]["3"];
      //   //   widget.addressDetail = doc['deliveryInfoList'][i]["4"];
      //   //   widget.request = doc['deliveryInfoList'][i]["5"];
      //   //   Navigator.pop(context);
      //   // });
      // },
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text("수령인 : ",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),),
                Text("${doc['deliveryInfoList'][i]["0"]}",style: TextStyle(fontSize: 11),),
                SizedBox(width: 20,),
                Text('연락처 : ',style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),
                Text("${doc['deliveryInfoList'][i]["1"]}",style: TextStyle(fontSize: 11)),

              ],),
            SizedBox(
              height:7,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("주소 : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11)),
                Expanded(
                  child: Text("[${doc['deliveryInfoList'][i]["2"]}] ${doc['deliveryInfoList'][i]["3"]} ${doc['deliveryInfoList'][i]["4"]} ",
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
                  child: Text("${doc['deliveryInfoList'][i]["5"]}",
                      style: TextStyle(fontSize: 11),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,softWrap: false),
                ),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget paymentMethod(){


    return Container(
      color: Colors.white,
      child:
      Padding(
          padding: const EdgeInsets.only(top:0,bottom:0,left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("결제 수단 ",style: TextStyle(fontWeight: FontWeight.bold, fontSize:20),),
                  Spacer(),
                  Container(
                    child: DropdownButton(

                        value: widget.paymentValue,
                        items: [
                          DropdownMenuItem(
                            child: Text("카드 결제",style: TextStyle(fontWeight: FontWeight.bold),),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("실시간 계좌이체",style: TextStyle(fontWeight: FontWeight.bold),),
                            value: 2,
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            widget.paymentValue = value;
                          });
                        }),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),

            ],
          )
      ),
    );
  }


  String merchantUid() {
    return "P${DateTime.now().millisecondsSinceEpoch}";
  }

  cal_totalPrice(){
    if(widget.stopTriger){
      setState(() {
        widget._totalPrice = 0;
      });
      for(var i =0; i<widget.orderList.length; i++){
        setState(() {
          widget._totalPrice += int.parse(widget.orderList[i][4]) * int.parse(widget.orderList[i][2]);
        });}
    }
  }
  final_price(){
    setState(() {
      widget._finalPirce= widget._totalPrice - widget._totalDiscount;
    });
    return numberWithComma(widget._totalPrice - widget._totalDiscount);
  }
  orderName(){
    var merchantUid;
    if(widget.orderList.length>=2){
      merchantUid = "${widget.firstName} 외 ${widget.orderList.length-1}";
    }
    else{
      merchantUid = widget.firstName;
    }
    return merchantUid;
  }
  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
  cal_data(){
    var aa = "8/21(오늘)";
    var _data;
    if(DateTime.now().hour < 15){
      _data = "${DateTime.now().month}/${DateTime.now().day} (오늘)";
    }
    else{
      _data = "내일";
    }
    return _data;
  }
  rewardOutput(var data){
    widget.totalReward = data['reward'];
    return numberWithComma(int.parse(data['reward']));
  }
  totalPrice(int filter) {

    widget._totalPrice =0;
    for(var i =0; i<widget.orderList.length; i++){
      setState(() {
        widget._totalPrice += int.parse(widget.orderList[i][4]);
      });}
    setState(() {
      widget._totalPrice -= int.parse(_rewardText==""?"0":_rewardText);
    });
    return numberWithComma(widget._totalPrice);

  }



}
