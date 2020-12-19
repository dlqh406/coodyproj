import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:coodyproj/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
class ReviewPage extends StatefulWidget {
  bool more_Btn = true;
  bool cancel_Btn = false;
  var image;
  var starRating =5.0;
  var isProgressing = false;
  final FirebaseUser user;
  var data;
  var nickName;
  var productCode;
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
  bool stopTriger =true;
  int sizing = 3;

  ReviewPage(this.user,this.data,this.productCode);
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  List<Asset> imageList = List<Asset>();


  final myController_Receiver = TextEditingController();
  final TextEditingController textEditingConteroller = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
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

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isProgressing == true){
      return Container(color: Colors.white,
          child: Center(child:
          Scaffold(
            body:
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('잠시만 기다려주세요',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                  SizedBox(height: 7),
                  Text('후기정보를 저장하고 있습니다',style: TextStyle(fontSize: 15),),
                  SizedBox(height: 30),
                  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),),
                ],
              ),
            ),
          )));
    }
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
        pleaseImg(),
        imageList.isEmpty?Container()
        :SizedBox(
          height: 15,
        ),
        imgArea(),
        SizedBox(
          height:15,
        ),
        custmerInfo(),
        SizedBox(
          height:15,
        ),
        textArea(),
        SizedBox(
          height:15,
        ),
        aboutEvent(),
        SizedBox(
          height:15
        ),
        btn()
      ],
    );
  }
  Widget imgArea(){

    return Column(
      children: [
        imageList.isEmpty
            ? Container()
            : Padding(
          padding: const EdgeInsets.only(left:17.0),
          child: Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageList.length,
                itemBuilder: (BuildContext context, int index) {
                  Asset asset = imageList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right:9.0),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: AssetThumb(
                          asset: asset, width: 250, height: 250),
                    ),
                  );
                }),
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
                              Text("${widget.starRating}",style: TextStyle(fontSize: 40),),

                              SizedBox(
                                width: 20,
                              ),
                              RatingBar.builder(
                                initialRating: 5,
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
                                  setState(() {
                                    widget.starRating =rating;
                                  });
                                  print(widget.starRating);
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
                        height: 180,
                        child: new TextField(
                          controller: textEditingConteroller,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          // controller: myController,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: new EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                            hintText: '고객님만의 스타일링 팁 및 상품 착용 후기를 공유해주세요 ',
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

  Widget pleaseImg() {
    return InkWell(
      onTap: (){
        getImage();
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
                    Icon(Icons.image,color:Colors.blue,size: 40,),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("고객님의 스타일링 이미지를 공유해주세요!",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),

                        SizedBox(
                          height: 4,
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
                            Text("포토리 작성 시 1% 구매 적립",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.redAccent),),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.add),
                    SizedBox(
                      width: 23,
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
  Widget custmerInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("user_data").document(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        widget.nickName = snapshot.data.data['nickName'];
        heightController.text = snapshot.data.data['height'];
        weightController.text = snapshot.data.data['weight'];

        return InkWell(
          onTap: (){

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
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child:
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("고객님의 체격 정보",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                SizedBox(width: 20,),
                                Text('미 공개',style: TextStyle(color: Colors.black),),
                                Checkbox(
                                  activeColor: Colors.blue,
                                  value:  widget.checkPrivacy,
                                  onChanged: (val) {
                                    setState(() {
                                      widget.checkPrivacy =!widget.checkPrivacy;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Text('체격 정보는 다른 고객님에게는 대략적으로 보여집니다 예)160후반,60초반',style: TextStyle(fontSize: 10),),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Text('키 : '),
                                Container(
                                  width: 100,
                                  height: 26,
                                  child: TextField(
                                      focusNode: focusNode,
                                      controller: heightController,
                                      cursorColor: Colors.black38,
                                      textAlign: TextAlign.right,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                        focusedBorder:const OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                                        ),
                                        // hintText: 'Hint',
                                      )
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text('체중 : '),
                                Container(
                                  width: 100,
                                  height: 26,
                                  child: TextField(
                                      keyboardType: TextInputType.number,
                                      focusNode: focusNode,
                                      controller: weightController,
                                      cursorColor: Colors.black38,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                        ),
                                        focusedBorder:const OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                                        ),

                                        // hintText: 'Hint',
                                      )
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:10
                            ),
                            Row(
                              children: [
                                Text("상품 착용감",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                SizedBox(
                                    width: 50,
                                ),
                                DropdownButton(
                                    value: widget.sizing,
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("작아요",style: TextStyle(),),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("살짝 작아요",style: TextStyle(),),
                                        value: 2,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("적당해요",style: TextStyle(),),
                                        value: 3,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("살짝 커요",style: TextStyle(),),
                                        value: 4,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("커요",style: TextStyle(),),
                                        value: 5,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        widget.sizing = value;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
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
    );
  }
  Widget aboutEvent() {
    return InkWell(
      onTap: (){

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('포토 리뷰 이벤트 관련 안내 사항',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        SizedBox(
                          height: 20,
                        ),
                        Text('적립금 지급 기준 : ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text('상품 착용 이미지 및 상품을 활용한 스타일링 이미지를 \n한 개 이상 업로드한 리뷰',style: TextStyle(fontSize: 13),),

                        SizedBox(
                          height: 10,
                        ),
                        Text('적립금 지급 불가 기준 : ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5,),
                        Text('1) 구매 상품과 관련없는 사진을 업로드 한 경우',style: TextStyle(fontSize: 13),),
                        SizedBox(height: 5,),
                        Text('2) 구매 상품인것으로 식별하기 힘든 경우',style: TextStyle(fontSize: 13),),
                        SizedBox(height: 5,),
                        Text('3) 착용 사진이 아닐 경우',style: TextStyle(fontSize: 13),),
                        SizedBox(
                          height: 10,
                        ),
                        Text('작성된 리뷰는 해당 상품 리뷰란에 바로 노출되며, \n적립금 지급은 영업일 2일 내로 처리됩니다.',style: TextStyle(fontSize: 15,),),
                        SizedBox(
                          height: 8,
                        ),
                        Text('위 적립금 지급 기준에 부합하지 않은 \n후기일 경우 적립금 지급이 거절될 수 있습니다',style: TextStyle(fontSize: 15),),
                      ],
                    ),
                    Spacer(),
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

  Widget btn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: SizedBox(
        height: 46,
        width: MediaQuery.of(context).size.width*1,
        child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),),
          color: Colors.blueAccent,
          onPressed: () async {
            if( textEditingConteroller.text != "")  {

              setState(() {
                widget.isProgressing = true;
              });
              replace(value){
                var finalValue ;
                var tem_weight = value.replaceRange( value.length-1, value.length, "0");
                int _val =  int.parse(value) - int.parse(tem_weight);

                if(_val > 5){
                  finalValue = tem_weight.toString()+'후반';
                }
                else if( _val == 5){
                  finalValue = tem_weight.toString()+'중반';
                }
                else if(_val <5){
                  finalValue = tem_weight.toString()+'초반';
                }
                print(finalValue);
                return finalValue;
              }
              _sizing(val){
                var finalValue;
                if(widget.sizing ==1) {
                  return "작아요";
                }
                else if( widget.sizing == 2){
                  return "살짝 작아요";
                }
                else if( widget.sizing == 3){
                  return "적당해요";
                }
                else if( widget.sizing == 4){
                  return "살짝 커요";
                }
                else{
                  return "커요";
                }
              }

              var imgList = [];

              createImgList() async{
                if( imageList.length !=0){
                  Future<dynamic> postImage(Asset imageFile) async {
                    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
                    StorageReference reference = FirebaseStorage.instance.ref().child('reviewImg').child(fileName);

                    StorageUploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List(), StorageMetadata(contentType: 'image/png'));
                    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
                    final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
                    return downloadUrl;
                  }

                  for(var i=0; i<imageList.length; i++){
                    await postImage(imageList[i]).then((value) => imgList.add(value.toString()));
                  }
                }
                else{
                  print("nothing");
                }
              }

              await createImgList();

              final data = {
                'rating' : widget.starRating.toString(),
                'userID' : widget.user.uid,
                'date' : DateTime.now(),
                'imgList' :imgList,
                'review' : textEditingConteroller.text,
                'writer' : widget.nickName,
                'height' :  widget.checkPrivacy?"non-public":replace(heightController.text),
                'weight' : widget.checkPrivacy?"non-public":replace(weightController.text),
                'sizing' : _sizing(widget.sizing)
              };
              // 댓글 추가
              final data2 = {
                'state' : 'reviewEnd',
              };
              Firestore.instance
                  .collection('order_data')
                  .document(widget.data.documentID)
                  .updateData(data2);


              Firestore.instance
                  .collection('uploaded_product')
                  .document(widget.productCode)
                  .collection('review')
                  .add(data).then((value) =>
                  setState(() {
                    widget.isProgressing = false;
                    Navigator.pop(context);
                    scaffoldKey.currentState
                        .showSnackBar(SnackBar(duration: const Duration(seconds:2),content:
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,color: Colors.blueAccent,),
                          SizedBox(width: 13,),
                          Text("리뷰가 정상적으로 저장되었습니다.",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize:16),),
                        ],
                      ),
                    )));
                  })
              );



            }
            else{
              scaffoldKey.currentState
                  .showSnackBar(SnackBar(duration: const Duration(seconds:2),content:
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,color: Colors.blueAccent,),
                    SizedBox(width: 13,),
                    Text("후기를 입력해주세요.",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16),),
                  ],
                ),
              )));
            }


          },
          child: const Text('리뷰 등록',
              style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
        ),
      ),
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
