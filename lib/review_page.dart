import 'package:coodyproj/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'detail_product.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ReviewPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;

  final FirebaseUser user;
  var data;

  ReviewPage(this.user,this.data);

  var tem_zoneCode = "";
  var tem_address = "";
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
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Asset> imageList = List<Asset>();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  final myController_Receiver = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();
  FocusNode focusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _rewardText = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
//    myController_Address.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.data);
    setState(() {
      //myController_Request.text = "문 앞에 놓아 주세요";
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
              title: Text('후기 작성'),
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
        productInfo(),
        SizedBox(
          height: 15,
        ),
        // imgArea(),
        SizedBox(
          height:20,
        ),
        //textArea(),
        // SizedBox(
        //   height:50,
        // ),
        Container(
          width: 500,
          height: 400,
          child: Column(
            children: [
              imageList.isEmpty
                  ? Container()
                  : Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Asset asset = imageList[index];
                      return AssetThumb(
                          asset: asset, width: 300, height: 300);
                    }),
              ),
              OutlineButton(
                borderSide: BorderSide(color: Colors.blue[200], width: 3),
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 250,
                  child: Text(
                    '갤러리',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onPressed: () {
                  getImage();
                },
              )
            ],
          ),
        ),

      ],
    );
  }

  Widget productInfo() {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('user_data')
            .document(widget.user.uid).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
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
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left:18.0),
                    child:
                    Row(
                      children: [
                        Text('나의 평점',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20,top: 10,bottom: 10,right: 20),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 6,
                              ),
                              Text("4.5",style: TextStyle(fontSize: 40),),

                              SizedBox(
                                width: 20,
                              ),
                              RatingBar.builder(
                                initialRating: 3,
                                minRating: 0,
                                itemSize: 40,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                          _buildListView(widget.data),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget textArea() {
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
              Row(
                children: [
                  Text('상품에 대한 솔직한 후기를 남겨주세요',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Spacer(),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.all(
                            Radius.circular(20.0) //                 <--- border radius here
                        ),
                      ),
                        width: 320,
                        height: 300,
                        child: new TextField(

                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          // controller: myController,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: new EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                            hintText: '질문을 남겨주시면 셀러가 확인 후 답을 드립니다',
                            hintStyle: new TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12.0,
                            ),
                          ),
                        )),

                  ],
                ),
              ),
            ),
            SizedBox(
              height: 23,
            )
          ],
        ),
      ),
    );
  }

  Widget imgArea() {
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
                    InkWell(
                      onTap: (){
                        print('a');
                      },
                        child: Icon(Icons.arrow_forward_ios,size: 17,)),
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
                      Container(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: [

                            ],
                          ))
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

  Widget _buildListView(doc){

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
                              Text('₩ ${numberWithComma(int.parse(snapshot.data.data['price']))}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
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
            ],
          );
        }
    );

  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }
  getImage() async {
    List<Asset> resultList = List<Asset>();
    resultList =
    await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);
    setState(() {
      imageList = resultList;
    });
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
