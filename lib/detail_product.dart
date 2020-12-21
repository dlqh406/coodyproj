import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/cart.dart';
import 'package:coodyproj/detail_review.dart';
import 'package:coodyproj/detail_review_doc.dart';
import 'package:coodyproj/home.dart';
import 'package:coodyproj/order_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'detail_seller.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetail extends StatefulWidget {


  bool deliveryTerm_downbtn = false;
  bool changeTerm_downbtn = false;
  bool refundTerm_downbtn = false;
  bool sellerInfoTerm_downbtn = false;
  bool productInfoTerm_downbtn = false;
  bool useTerm_downbtn = false;

  var selectedList =[];
  var temSelectedList = ["","",""];

  int _selectedSize = 0;
  int _selectedColor = 0;
  bool modalVisible =false;

  DocumentSnapshot document;
  final FirebaseUser user;

  ProductDetail(this.user, this.document);

  final ScrollController _controllerOne = ScrollController();

  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final myController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final data = {
      'docID' : widget.document.documentID,
      'date' : DateTime.now()};
    // 댓글 추가
    Firestore.instance
        .collection('user_data')
        .document(widget.user.uid)
        .collection('recent')
        .add(data);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        key: _scaffoldKey,
        appBar:PreferredSize(preferredSize: Size.fromHeight(40.0),
            child:
            AppBar(
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
      body: _buildBody(context),
        floatingActionButton: SizedBox(
          width: 65,
          height: 65,
          child: RaisedButton(
            color: Colors.blueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            ),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: buildBottomSheet
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right : 2.0),
              child: Image.asset('assets/icons/cart.png',width: 34),
            ),
          ),
        )

    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        _buildPriceInfoBody(context),
        _buildFirstBody(context),
        _buildRelatedBody(context),
        _buildReviewBody(context),
        _buildMainInfoBody(context),
        _buildTermsInfoBody(context),
        _buildPravacy(context)
      ],
    );
  }

  Widget _buildPriceInfoBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.document['category'],
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
              Container(
                  width: 220,
                  child: Text(widget.document['productName'], style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Text('₩ '),
                Text("${numberWithComma(int.parse(widget.document['price']))}", style: TextStyle(fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFirstBody(context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.75,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 93,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            sellerInfo(),
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0),
                                    child: Image.asset(
                                      'assets/icons/delivered.png',
                                      width: 30,),
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
                                    padding: const EdgeInsets.only(
                                        right: 4.0),
                                    child: Image.asset(
                                      'assets/icons/FD.png',
                                      width: 30,),
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
                                    padding: const EdgeInsets.only(
                                        right: 4.0),
                                    child: Image.asset(
                                      'assets/icons/tick.png', width: 30,
                                      height: 40,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('우수셀러'),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: GestureDetector(
                                onTap: (){
                                  print("hi");
                                  _showAlert();
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0),
                                      child: Image.asset(
                                        'assets/icons/paper-plane.png', width: 30,
                                        height: 40,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('1:1문의'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Hero(
                  tag: widget.document['thumbnail_img'],
                  child:
                  Container(
                      height: size.height * 0.70,
                      width: size.width * 0.75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(63),
                              bottomLeft: Radius.circular(63)
                          ),
                          boxShadow: [BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 60,
                              color: Colors.black38
                          )
                          ],
                          image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.document['thumbnail_img'])
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

  Widget _buildRelatedBody(context) {

    bool _visible;

    if(widget.document['relatedProduct'][0] == "null"){
      _visible = false;
      print("false");
      print(widget.document['relatedProduct'][0]);
    }else{
      _visible = true;
      print("true");
      print(widget.document['relatedProduct'][0]);
    }
    print(_visible);
      return Visibility(
          visible: _visible,
          child: Padding(
            padding: const EdgeInsets.only(bottom:20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17.0,bottom: 22),
                  child: Text("연결 상품",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      
                      children: <Widget>[
                        for(var i =0; i< widget.document['relatedProduct'].length; i++)
                        StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance.collection('uploaded_product').document(widget.document['relatedProduct'][i]).snapshots(),
                            builder: (context, snapshot) {
                              if(!snapshot.hasData){
                                return Center(child:  CircularProgressIndicator());
                                    }
                              else{
                                return ReleatedCard(
                                     image:  snapshot.data.data['thumbnail_img'],
                                     category: snapshot.data.data['category'],
                                     productName: snapshot.data.data['productName'],
                                     price:  snapshot.data.data['price'],
                                     press: () {
                                         Navigator.push(context,
                                             MaterialPageRoute(builder: (context){
                                           return ProductDetail(widget.user,snapshot.data);
                                         }));
                                          },);
                              }
                              }
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

  Widget _buildReviewBody(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('uploaded_product').document(
          widget.document.documentID).collection('review').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildHasReview(context, snapshot.data.documents.length);
        } else {
          return _buildNoReview();
        }
      },
    );
  }

  Widget _buildNoReview() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("실사용 리뷰",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("아직 후기가 없습니다",
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHasReview(context, length) {
    Size size = MediaQuery.of(context).size;
    var reviewCount = length;

    return Container(

      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('uploaded_product').document(widget.document.documentID).
        collection('review').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          double _total =0.0;
          for(var i=0; i<snapshot.data.documents.length; i++ ){
            _total += double.parse(snapshot.data.documents[i]['rating']);
          }
          var _lengthDouble = snapshot.data.documents.length.toDouble();
          var averageRating = _total / _lengthDouble;

          return Padding(
            padding: const EdgeInsets.only(
                top: 30.0, right: 10.0, left: 10.0, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("실사용 리뷰",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 17.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 20),
                        child: reviewCount > 0
                            ? Text("$averageRating", style: TextStyle(fontSize: 38))
                            : Text("아직 후기가 없습니다",
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ),
                      if(reviewCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('총 $reviewCount개 리뷰'),
                              RatingBarIndicator(
                                rating: averageRating,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                Visibility(
                  visible: reviewCount > 0 ? true : false,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.1))
                      ),
                    height: 280,
                    child: Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: CupertinoScrollbar(
                              controller: widget._controllerOne,
                              isAlwaysShown: true,
                              child: ListView(
                                controller: widget._controllerOne,
                                children: [
                                  for(var i=0; i< snapshot.data.documents.length; i++)
                                  _buildListView(snapshot.data.documents[i],i)
                                ],
                          )
                      ),
                    )
                  ),
                ),
                Visibility(
                  visible: reviewCount > 0 ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: SizedBox(
                      width: size.width * 1,
                      child: RaisedButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),),
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DetailReview(widget.user,widget.document,length)));
                        },
                        child: const Text('후기 전체 보기',
                            style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildListView(doc,index) {
    Size size = MediaQuery.of(context).size;
       return InkWell(
         onTap: (){
           Navigator.push(context,
               MaterialPageRoute(builder: (context){
                 //return OrderPage(widget.user);
                 return DetailReviewDoc(doc);

               }));

         },
         child: Padding(
            padding: const EdgeInsets.only(left:18.0,right:18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(doc['writer'], style: TextStyle(
                        fontWeight: FontWeight.bold),),
                    Spacer(),
                    Visibility(
                      visible: doc['height'] == 'non-public'?false:true,
                      child: Row(
                        children: [
                          Text('[${doc['height']} ', style: TextStyle(
                          ),),
                          Text('${doc['weight']} ', style: TextStyle(
                              ),),
                          Text('${doc['sizing']}]', style: TextStyle(
                              fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      RatingBarIndicator(
                        rating: double.parse(doc['rating']),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 17.0,
                        direction: Axis.horizontal,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0),
                        child: Text(
                          _timeStampToString(doc['date']),
                          style: TextStyle(fontSize: 12),),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      doc['imgList'].length == 0
                          ? Visibility(visible: false, child: Text(""),)
                          : Padding(
                            padding: const EdgeInsets.only(
                            right: 6),
                            child: Container(
                                width: 95,
                                height: 95,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      doc['imgList'][0], fit: BoxFit.cover,),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      child: doc['imgList'].length==1?Container():Text(' +${doc['imgList'].length-1} ',style: TextStyle(backgroundColor: Colors.grey.withOpacity(0.5)),),
                                    )
                                  ],
                                )),
                            ),
                      Expanded(
                        child: SizedBox(
                            child: Text(doc['review'],
                              maxLines: doc['imgList'].length==0?3:6,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            )),
                      ),
                    ],
                  ),
                ),
                Opacity(
                    opacity: 0.15,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15.0),
                        child: Container(
                          height: 1,
                          color: Colors.black38,
                        ))),
              ],
            ),
          ),
       );
  }

  Widget _buildMainInfoBody(BuildContext context) {
    final htmlData = """${widget.document['productDecription']}""";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 17.0, top: 30),
          child: Text("상세 소개",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),
        Padding(
            padding: const EdgeInsets.all(18.0),
            child: htmlData == "null" ? Text('') : Html(data: htmlData)
        ),
        for(var i = 0; i < widget.document['detail_img'].length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Image.network(widget.document['detail_img'][i]),
          ),
      ],
    );
  }

  Widget _buildTermsInfoBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.black.withOpacity(0.08)
              )

            )
          ),
          child: SizedBox(
            width: size.width*1,
            child: RaisedButton(
              color: Colors.white,
              elevation: 0,
              onPressed: (){
                setState(() {
                  widget.deliveryTerm_downbtn = !widget.deliveryTerm_downbtn ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('배송 안내', style: TextStyle(fontSize: 15)),
                  widget.deliveryTerm_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.deliveryTerm_downbtn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: deliveryTerm.length,
            itemBuilder: (BuildContext context, int index) {
              String _key = deliveryTerm.keys.elementAt(index);
              return ListTile(
                title: Text(_key),
              );
            },
          ),
        ),

        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.08)
                  )
              )
          ),
          child: SizedBox(
            width: size.width*1,
            child: RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: (){
                setState(() {
                  widget.changeTerm_downbtn = !widget.changeTerm_downbtn ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('교환/반품 안내', style: TextStyle(fontSize: 15)),
                  widget.changeTerm_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.changeTerm_downbtn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: changeTerm.length,
            itemBuilder: (BuildContext context, int index) {
              String _key = changeTerm.keys.elementAt(index);
              return ListTile(
                title: Text(_key),
              );
            },
          ),
        ),

        Container(
          decoration: BoxDecoration(

              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.08)
                  )
              )
          ),
          child: SizedBox(
            width: size.width*1,
            child: RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: (){
                setState(() {
                  widget.refundTerm_downbtn = !widget.refundTerm_downbtn ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('취소/환불 안내', style: TextStyle(fontSize: 15)),
                  widget.refundTerm_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.refundTerm_downbtn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: refundTerm.length,
            itemBuilder: (BuildContext context, int index) {
              String _key = refundTerm.keys.elementAt(index);
              return ListTile(
                title: Text(_key),
              );
            },
          ),
        ),



        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.08)
                  )
              )
          ),
          child: SizedBox(
            width: size.width*1,
            child: RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: (){
                setState(() {
                  widget.sellerInfoTerm_downbtn = !widget.sellerInfoTerm_downbtn ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('판매자정보 안내', style: TextStyle(fontSize: 15)),
                  widget.sellerInfoTerm_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.sellerInfoTerm_downbtn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sellerInfoTerm.length,
            itemBuilder: (BuildContext context, int index) {
              String _key = sellerInfoTerm.keys.elementAt(index);
              return ListTile(
                title: Text(_key),
              );
            },
          ),
        ),

        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.08)
                  )
              )
          ),
          child: SizedBox(
            width: size.width*1,
            child: RaisedButton(
              color: Colors.white,
              elevation: 0,
              onPressed: (){
                setState(() {
                  widget.productInfoTerm_downbtn = !widget.productInfoTerm_downbtn ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('상품정보 제공공시', style: TextStyle(fontSize: 15)),
                  widget.productInfoTerm_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.productInfoTerm_downbtn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productInfoTerm.length,
            itemBuilder: (BuildContext context, int index) {
              String _key = productInfoTerm.keys.elementAt(index);
              return ListTile(
                title: Text(_key),
              );
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.08)
                  ),
                bottom: BorderSide(
                    color: Colors.black.withOpacity(0.08)
                ),
              )
          ),
          child: SizedBox(

            width: size.width*1,
            child: RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: (){
                setState(() {
                  widget.useTerm_downbtn = !widget.useTerm_downbtn ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('이용약관', style: TextStyle(fontSize: 15)),
                  widget.useTerm_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.useTerm_downbtn,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productInfoTerm.length,
            itemBuilder: (BuildContext context, int index) {
              String _key = productInfoTerm.keys.elementAt(index);
              return ListTile(
                title: Text(_key),
              );
            },
          ),
        ),



      ],
    );
  }
  Map<String, bool> deliveryTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };
  Map<String, bool> changeTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };
  Map<String, bool> refundTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };
  Map<String, bool> sellerInfoTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };
  Map<String, bool> productInfoTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };
  Map<String, bool> useTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };

  Stream<QuerySnapshot> _commentStream() {
    return Firestore.instance.collection('uploaded_product')
        .document(widget.document.documentID).collection('review').orderBy('date', descending: true).snapshots();
  }

  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }

  Widget buildBottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState ){
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:25.0,right:25.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(child: Icon(Icons.close,),
                          onTap:(){Navigator.pop(context);
                      }),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top:10.0),
                      width: 300,
                      child:
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                            icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.blue,
                                size: 20
                            ),
                            value: widget._selectedColor,
                            items: [
                              DropdownMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                        Icons.color_lens,
                                        color: Colors.pinkAccent,
                                        size: 20
                                    ),
                                    Text("  컬러를 선택해주세요"),
                                  ],
                                ),
                                value: 0,
                              ),
                              for(var i=0; i<widget.document['colorList'].length; i++)
                                DropdownMenuItem(
                                  child: Text("${widget.document['colorList'][i]}"),
                                  value: i+1,
                                ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                widget._selectedColor = value;
                                _selectedColorMethod(value);
                              });
                            }),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    width: 300,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.blue,
                            size: 20
                          ),
                          isExpanded: true,
                          value: widget._selectedSize,
                          hint:Text("  사이즈를 선택해주세요"),
                          items: [
                              DropdownMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                      Icons.accessibility_new,
                                      color: Colors.pinkAccent,
                                      size: 20
                                  ),
                                  Text("  사이즈를 선택해주세요"),
                                ],
                              ),
                              value: 0,
                              ),
                              for(var i=0; i<widget.document['sizeList'].length; i++)
                                DropdownMenuItem(
                                child: Text("${widget.document['sizeList'][i]}"),
                                value: i+1,
                                ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              widget._selectedSize = value;
                              _selectedSizeMethod(value);
                            });
                          }),
                      )
                      ),
                  Container(
                    // TODO 선택되어 보여지는곳
                    width: size.width*0.78,
                    height: size.height*0.3,
                    child: SingleChildScrollView(
                      child: CupertinoScrollbar(
                        child: Column(
                          children: [
                            Visibility(
                                visible: widget.modalVisible,
                                child: Padding(
                                  padding: const EdgeInsets.only(top:25.0),
                                  child: Text("옵션을 모두 선택해주세요",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.pinkAccent),),
                                )),
                            if(widget.selectedList.length >=1)
                              _cleanArray(),
                              for (var index=0; index< widget.selectedList.length; index++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom :13.0),
                                    child: Row(
                                      children: [
                                          Text('${widget.selectedList[index][0]}',style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(','),
                                          Text('${widget.selectedList[index][1]}',style: TextStyle(fontWeight: FontWeight.bold)),
                                          Spacer(),
                                          GestureDetector(
                                              child: Icon(Icons.arrow_drop_down),
                                              onTap:(){
                                                setState((){
                                                  widget.selectedList[index].setAll(2,
                                                      ["${int.parse(widget.selectedList[index][2])-1==0
                                                          ?widget.selectedList.removeAt(index)
                                                          :int.parse(widget.selectedList[index][2])-1}"]);
                                                  print(widget.selectedList);
                                                });
                                              }),
                                          Text('${widget.selectedList[index][2]}',style: TextStyle(fontWeight: FontWeight.bold)),
                                          GestureDetector(child: Icon(Icons.arrow_drop_up),
                                              onTap:(){
                                                setState((){
                                                  widget.selectedList[index].setAll(2,["${int.parse(widget.selectedList[index][2])+1}"]);
                                                  print(widget.selectedList);
                                                });
                                              }
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left:20.0),
                                            child: GestureDetector(child: Icon(Icons.cancel,color: Colors.grey,), onTap:(){
                                               setState((){
                                                widget.selectedList.removeAt(index);
                                                  print(widget.selectedList);
                                            });
                                         }),
                                          ),
                                     ],
                                    ),
                                    ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: SizedBox(
                        width: size.width * 0.85,
                        height: size.height*0.065,
                        child: RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),),
                          color: Colors.pinkAccent,
                          onPressed: () {
                            if(widget.selectedList.length == 0){
                              setState((){
                                widget.modalVisible = true;
                              });
                            }else{
                              print(widget.selectedList);
                              _addToCart(widget.selectedList);
                              Navigator.pop(context);
                              _showMyDialog();
                            }

                          },
                          child: const Text('장바구니 넣기',
                              style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: SizedBox(
                      width: size.width * 0.85,
                      height: size.height*0.065,
                      child: RaisedButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),),
                        color: Colors.blueAccent,
                        onPressed: () {
                          if(widget.selectedList.length == 0){
                            setState((){
                              widget.modalVisible = true;
                            });
                          }else{
                            for( var i=0; i<widget.selectedList.length; i++){
                              if( widget.selectedList[i].length <= 3){
                                widget.selectedList[i].add(widget.document.documentID);
                                widget.selectedList[i].add(widget.document['price']);
                                widget.selectedList[i].add(widget.document['sellerCode']);
                              }
                            }
                            print("구매하기 : ${widget.selectedList}");
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context){

                                  //return OrderPage(widget.user);
                                  return OrderPage(widget.user, widget.selectedList);

                                }));


                          }
                        },
                        child: const Text('구매하기',
                            style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                      )),
                  ),
                ],
      )
        ],
          ),
        ),
      );
  }
    );
  }


  void _selectedColorMethod(index) {
    var selectedColor = widget.document['colorList'][index-1];
    widget.temSelectedList.setAll(0,["$selectedColor"]);
    widget.temSelectedList.setAll(2,["1"]);

    print("widget.temSelectedList: ${widget.temSelectedList}");

    if (widget.temSelectedList[0] != "" && widget.temSelectedList[1] != "") {
      // 만약 두개조건을 충족 안하여 경고메세지가 뜨면 다시 제대로 골랐을떄 없애는 코드
      widget.modalVisible = false;
      // 선택하고 hint처럼 떠있게
      widget._selectedColor = 0;
      widget._selectedSize = 0;

      widget.selectedList.addAll([widget.temSelectedList]);
      widget.temSelectedList = ["","",""];
      print("#widget.selectedList: ${widget.selectedList}");
    }
  }

  void _selectedSizeMethod(index) {
      var selectedSize = widget.document['sizeList'][index-1];
      widget.temSelectedList.setAll(1,["$selectedSize"]);
      print("widget.temSelectedList: ${widget.temSelectedList}");

      if (widget.temSelectedList[0] != "" && widget.temSelectedList[1] != ""){
        widget.modalVisible = false;

        widget._selectedColor = 0;
        widget._selectedSize = 0;

        widget.selectedList.addAll([widget.temSelectedList]);

        widget.temSelectedList = ["","",""];
        print("@widget.selectedList: ${widget.selectedList}");

      }
  }

  Widget _cleanArray(){
    if(widget.selectedList.length>=2){
     for(var i=widget.selectedList.length-1; i>0; i--){
       for(var j=0; j<i; j++){
         if(widget.selectedList[i][0]==widget.selectedList[j][0] && widget.selectedList[i][1]==widget.selectedList[j][1]){
             widget.selectedList[j].setAll(2,["${int.parse(widget.selectedList[j][2])+1}"]);
             widget.selectedList.removeAt(i);
             break;
         }
       }
    }
    }else{
      print("else");
    }
    return Container();
  }
  void _addToCart(List selectedList) {

    // [[color, size, quantity],[color, size, quantity]]

    if(selectedList.length > 1){
      for( var i=0; i< selectedList.length; i++){
        final data = {
          'product': widget.document.documentID,
          'selectedColor' : selectedList[i][0],
          'selectedSize' : selectedList[i][1],
          'selectedQuantity' : selectedList[i][2],
          'date' : DateTime.now()
        };
        // 댓글 추가
        Firestore.instance.collection('user_data')
            .document(widget.user.uid)
            .collection('cart')
            .add(data);
      }

    }
    else{
      // [[color, size, quantity]]
      final data = {
        'product': widget.document.documentID,
        'selectedColor' : selectedList[0][0],
        'selectedSize' : selectedList[0][1],
        'selectedQuantity' : selectedList[0][2],
        'date' : DateTime.now()
      };
      // 댓글 추가
      Firestore.instance.collection('user_data')
          .document(widget.user.uid)
          .collection('cart')
          .add(data);
    }

  }
  Future<void> _showMyDialog() async {
    return  showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
          image: Image.network(
            "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
            fit: BoxFit.cover,
          ),
          entryAnimation: EntryAnimation.TOP_LEFT,
          title: Text(
            '장바구니에 담았습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22.0, fontWeight: FontWeight.w700),
          ),
          description: Text(
            '장바구니에 성공적으로 저장되었습니다',
            textAlign: TextAlign.center,
          ),
          buttonOkColor: Colors.blue,
          buttonCancelColor: Colors.redAccent,
          onOkButtonPressed: (){
            Navigator.pop(context);
          },
          onCancelButtonPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) =>  CartPage(widget.user)));
          },
          buttonOkText:Text("Yes",style: TextStyle(color: Colors.white),) ,
          buttonCancelText: Text("장바구니 바로가기",style: TextStyle(color: Colors.white),),


        ));
  }
  String numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }

  Widget _showAlert() {

    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 350.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          children: <Widget>[
            // dialog top
            new Row(
              children: <Widget>[
                new Container(
                  // padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: new Text(
                    '1:1 문의',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: 'helvetica_neue_light',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                GestureDetector(
                    onTap: (){
                      myController.clear();
                      Navigator.pop(context, true);
                    },
                    child: Icon(Icons.clear))
              ],
            ),
            // dialog centre
            SizedBox(
              height: 10,
            ),
            new Container(
                height: MediaQuery.of(context).size.height*0.3,
                child: new TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: myController,
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

            // dialog bottom
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      print(myController.text);
                      print(widget.document['sellerCode']);
                      final _addData = {
                        'answer': "",
                        'P_Code' : "",
                        'I_Code' : "",
                        'name' : widget.user.displayName,
                        'productCode' : widget.document.documentID,
                        'question' : myController.text,
                        'state' : "ongoing",
                        'date' : DateTime.now(),
                        'userID': widget.user.uid,
                        'sellerCode' :widget.document['sellerCode'],
                      };
                      Firestore.instance
                          .collection('inquiry_data')
                          .add(_addData);
                      myController.clear();
                      Navigator.pop(context, true);


                      _scaffoldKey.currentState
                          .showSnackBar(SnackBar(duration: const Duration(seconds: 3),content:
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,color: Colors.blueAccent,),
                            SizedBox(width: 11,),
                            Text("1:1 문의 답변은 \n 마이쿠디 > 나의 쪽지함에서 확인 가능합니다.  ",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize:15),),
                          ],
                        ),
                      )));

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
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, child: dialog);
  }

  Widget sellerInfo(){


    return  GestureDetector(
      onTap: (){
        Navigator.push(context,
        MaterialPageRoute(builder: (context){
           return DetailSeller(widget.user,widget.document['sellerCode']);
        }));

      },
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('seller_data')
                .document(widget.document['sellerCode']).snapshots(),
        builder: (context, snapshot) {
          if( !snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 3.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(snapshot.data.data['thumbnail_img']),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Text('${snapshot.data.data['companyName']}'),
                )
              ],
            ),
          );
        }
      ),
    );

  }

  Widget _buildPravacy(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:18.0,bottom: 20,left:20),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주식회사 쿠디'),
            SizedBox(height: 10,),
            Text('대표자 : 이보성  사업자등록번호 : 790-81-02018'),
            SizedBox(height: 10,),
            Text('통신판매업 신고 번호 제 2020-서울서초-4253 호'),
            SizedBox(height: 10,),
            Text('배송 기간 : 7일이내 '),
            SizedBox(height: 10,),
            Text('주소 : 서울특별시 서초구 강남대로 107길 21, 대능빌딩 2 '),SizedBox(height: 10,),
            Text('대표번호 : 02-862-6869   개인정보보호책임자 이보성'),SizedBox(height: 10,),
            Text('홈페이지 : www.coody.cool'),SizedBox(height: 10,),

          ],
        ),
      ),
    );

  }
}
class ReleatedCard extends StatelessWidget {
  const ReleatedCard({
    Key key,
    this.image,
    this.category,
    this.productName,
    this.price,
    this.press,
  }) : super(key: key);

  final String image, category, productName;
  final String price;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: 14),
      width: size.width * 0.375,
      child: Column(
        children: <Widget>[
          SizedBox(
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: FadeInImage.assetNetwork(
                    placeholder:'assets/images/19.png',
                    image: image)),
          ),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //$category $price
                                Text('$category',style: TextStyle(fontSize: 11, color:Colors.blue, fontWeight: FontWeight.bold)),
                                Text('￦${numberWithComma(int.parse(price==null?"120000":price))}',
                                    style: TextStyle(fontWeight:FontWeight.bold,fontSize: 12,color: Colors.black)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:3.0),
                              child: Container(
                                child: Text('$productName',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Colors.black,),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            )

                          ],
                        );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }


  numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }
}
