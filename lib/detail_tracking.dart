import 'package:coodyproj/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'detail_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class DetailTracking extends StatefulWidget {
  var trackingData;
  var trackingNum;
  final FirebaseUser user;
  var data;
  final ScrollController _controllerOne = ScrollController();

  DetailTracking(this.user,this.data);
  @override
  _DetailTrackingState createState() => _DetailTrackingState();
}

class _DetailTrackingState extends State<DetailTracking> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.trackingNum = widget.data['trackingNumber'];

    });

    void RestApi_Get() async {
      http.Response response = await http.get(
          Uri.encodeFull('https://apis.tracker.delivery/carriers/${shippingCompany(widget.data['shippingCompany'])}/tracks/${widget.trackingNum}'),
          headers: {"Accept": "application/json"});
      Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
      print(responseBodyMap["state"]['text']);
      setState(() {
        widget.trackingData = responseBodyMap;
      });
    }
    RestApi_Get();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  IconButton(
            icon: Icon(Icons.arrow_back_ios,size: 19,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text('배송 조회'),
        actions: [
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
      ),
    //body:ListView(
      body:widget.trackingData == null?Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(Colors.blue),),):ListView(
        children: [
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder:(BuildContext context, int index){
                  return Column(
                    children: [
                      myShippingState(),
                      myInfo(),
                      progresses()
                    ],
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(doc, index){
    print(index);
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('uploaded_product').document(doc['productCode']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              Container(
                                  width: 230,
                                  child: Text("${snapshot.data.data['productName']}",
                                    style:TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  )),
                            ],
                          ),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Expanded(
                                  child: Text("색상 : ${doc["orderColor"]} / 사이즈 : ${doc['orderSize']} / 수량 : ${doc['orderQuantity']}개",
                                      style: TextStyle(fontSize:12 ,color: Colors.black87,
                                      ),maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false)),
                            ],
                          ),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Text('₩ ${numberWithComma(int.parse(snapshot.data.data['price']))}',style: TextStyle(fontSize: 16),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: RaisedButton(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),),
                      child: Text("교환 신청",style: TextStyle(color: Colors.black,),),
                      onPressed:(){
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: RaisedButton(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),),
                      child: Text("반품 신청",style: TextStyle(color: Colors.black),),
                      onPressed:(){
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: RaisedButton(
                      color: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),),
                      child: Text("배송 조회",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      onPressed:(){

                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*1,
                child: RaisedButton(
                  color: Colors.orangeAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),),
                  child: Text("상품 후기 작성",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                  onPressed:(){
                  },
                ),
              )
            ],
          );
        }
    );

  }
  Widget myShippingState() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue,
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
            padding: const EdgeInsets.only(left:0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.trackingData['state']['text']=='배달완료'?Row(
                      children: [
                        Text('${_timeStampToString(widget.trackingData['to']['time'])}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25)),
                        SizedBox(width: 10,),
                      ],
                    ):Container(),
                    Text("${widget.trackingData['state']['text']}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 25)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 내용
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
      ),
    );
  }
  Widget myInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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
          Padding(
            padding: const EdgeInsets.only(left:70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                  ],
                ),
                Row(
                  children: [
                    Text("배송 회사:",style: TextStyle(fontSize: 18)),
                    Text("       ${shippingCompany2(widget.data['shippingCompany'])}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 3.5,
                ),
                Row(
                  children: [
                    Text("운송장 번호:",style: TextStyle(fontSize: 18)),
                    Text("    ${widget.trackingNum}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 3.5,
                ),
                Row(
                  children: [
                    Text("보내는 분:",style: TextStyle(fontSize: 18)),
                    Text("       ${widget.trackingData['from']['name']}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  ],
                ),SizedBox(
                  height: 3.5,
                ),
                Row(
                  children: [
                    Text("받는 분: ",style: TextStyle(fontSize: 18)),
                    Text("         ${widget.trackingData['to']['name']}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                  ],
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
      ),
    );
  }
  Widget progresses() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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
              Row(
                children: [
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left:30),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(var i =0; i< widget.trackingData['progresses'].length; i++)
                      progresses_step(i),
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

  Widget opacityLine (){
    return Opacity(
      opacity: 0.25,
      child: Padding(
          padding: const EdgeInsets.only(
              top: 1.0, bottom: 1.0),
          child: Container(
            height: 1,
            color: Colors.black38,
          )),
    );

  }
  Widget progresses_step(index) {
    return Column(
      children: [
        Row(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:11.5),
                  child: Container(
                    height: 140,
                    width: 1,
                    color: Colors.black38,
                  ),
                ),
                widget.trackingData['progresses'][index]['status']['text']=="배달완료"
                 ?Padding(
                    padding: const EdgeInsets.only(top:53.0),
                    child: Container(
                        color: Colors.white,
                        child: Icon(Icons.check_circle,color: Colors.green ))
                )
                :Padding(
                  padding: const EdgeInsets.only(top:53.0),
                  child: Container(
                    color: Colors.white,
                      child: Icon(Icons.room,color: Colors.blue ))
                ),

              ],

            ),
            SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.trackingData['progresses'][index]['status']['text']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                SizedBox(
                  height: 5,
                ),
                Text('${_timeStampToStringWithTime(widget.trackingData['progresses'][index]['time'])}'),
                SizedBox(
                  height: 5,
                ),
                Text('${widget.trackingData['progresses'][index]['location']['name']}'),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    child: Text('${widget.trackingData['progresses'][index]['description']}')),
              ],
            )
          ],
        ),
      ],
    );
 }
  String _timeStampToString(date) {
    print(date);
    var list = DateTime.parse(date).toString().replaceAll('-', '.').split(" ");
    return list[0];
  }
  String _timeStampToStringWithTime(date) {
    print(date);
    var list = DateTime.parse(date).toString().split(" ");
    return list[0].substring(0,10) +" "+list[1].substring(0,5);
    
  }
  Widget basic() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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
          Padding(
            padding: const EdgeInsets.only(left:18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                  ],
                ),
                Text("배송 완료",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 내용
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
      ),
    );
  }
  // Future<String> RestApi_Get() async {
  //   http.Response response = await http.get(
  //       Uri.encodeFull('https://apis.tracker.delivery/carriers/kr.cjlogistics/tracks/635972465074'),
  //       headers: {"Accept": "application/json"});
  //    Map<String, dynamic> responseBodyMap = jsonDecode(response.body);
  //    //return response.body;
  //   // 전체 API출력
  //   print(response.body);
  //   // //상품준비중
  //   print(responseBodyMap["state"]['text']);
  //   return responseBodyMap["state"]['text'];
  // }
  // // RestApi_Get();
  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
  shippingCompany(_shippingCompanyNumber) {
    switch (_shippingCompanyNumber) {
      case "1":
      //cj
        return "kr.cjlogistics";

      case "2":
      // 우체국 택배
        return "kr.epost";

      case "3":
      // 롯데 택배
        return "kr.lotte";

      case "4":
      // 한진 택배
        return "kr.hanjin";

      case "5":
      //cu 편의점 택배
        return "kr.cupost";

      case "6":
      // 로젠
        return "kr.logen";

      case "7":
      //대신택배
        return "kr.daesin";

      case "8":
      //경동택배
        return "kr.kdexp";

      case "9":
      //GS Postbox 택배
        return "kr.cvsnet";

      case "10":
      //천일택배
        return "kr.chunilps";

      case "11":
      //합동택배
        return "kr.hdexp";

      case "12":
      //DHL
        return "de.dhl";

      case "13":
      //홈픽택배
        return "kr.homepick";

      case "14":
      //ems
        return "un.upu.ems";
      case "15":
      //SLX택배
        return "kr.slx";

      case "16":
      //건영택배
        return "kr.kunyoung";
      case "17":
      //한서호남택배
        return "kr.honamlogis";
    }
  }
  shippingCompany2(_shippingCompanyNumber) {
    switch (_shippingCompanyNumber) {
      case "1":
      return "CJ대한통운";
      case "2":
      // 우체국 택배
        return "우체국 택배";

      case "3":
      // 롯데 택배
        return "롯데 택배";

      case "4":
      // 한진 택배
        return "한진 택배";

      case "5":
      //cu 편의점 택배
        return "cu 편의점 택배";

      case "6":
      // 로젠
        return "로젠";

      case "7":
      //대신택배
        return "대신 택배";

      case "8":
      //경동택배
        return "경동 택배";

      case "9":
      //GS Postbox 택배
        return "GS Postbox 택배";

      case "10":
      //천일택배
        return "천일 택배";

      case "11":
      //합동택배
        return "합동 택배";

      case "12":
      //DHL
        return "DHL";

      case "13":
      //홈픽택배
        return "홈픽 택배";

      case "14":
      //ems
        return "ems";
      case "15":
      //SLX 택배
        return "SLX 택배";

      case "16":
      //건영택배
        return "건영 택배";
      case "17":
      //한서호남택배
        return "한서호남택배";
    }
  }
}
