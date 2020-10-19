import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coodyproj/detail_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_html/flutter_html.dart';


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

  final DocumentSnapshot document;
  final FirebaseUser user;

  ProductDetail(this.user, this.document);

  final ScrollController _controllerOne = ScrollController();

  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: buildBottomSheet
            );
          },
          backgroundColor: Colors.blue,
          child: Image.asset('assets/icons/cart.png',width: 34),
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
                Text(widget.document['price'], style: TextStyle(fontWeight: FontWeight.w500,
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
    Size size = MediaQuery
        .of(context)
        .size;
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
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 3.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(
                                          "https://lh3.googleusercontent.com/FK8EcHV1SJGHeTUJCsUhCQl0hmQu-QbC4wG6bM59S0v-rLv-jQl16YC3LQ4x-ZpPwS1cUs_4Idap57kYgcTCOQFB"),
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
                                    padding: const EdgeInsets.only(
                                        right: 4.0),
                                    child: Image.asset(
                                      'assets/icons/free-shipping.png',
                                      width: 45,),
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
                                      'assets/icons/fast-delivery.png',
                                      width: 45,),
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
                                      'assets/icons/medal.png', width: 45,
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
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0),
                                    child: Image.asset(
                                      'assets/icons/medal.png', width: 45,
                                      height: 40,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('1:1문의'),
                                  )
                                ],
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

    if(widget.document['relatedProduct'] == null || widget.document['relatedProduct'][0] == "null"){
      _visible = false;
    }else{
      _visible = true;
    }

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
                                     price:  "12,900",
                                     press: () {
      //                                    Navigator.push(context,
      //                                        MaterialPageRoute(builder: (context){
      //                                      return ProductDetail(widget.user,snapshot.data);
      //                                    }));
                                          },);}
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
                      ? Text("4.7", style: TextStyle(fontSize: 38))
                      : Text("아직 후기가 없습니다",
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ),
                if(reviewCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Column(
                      // ignore: sdk_version_ui_as_code, sdk_version_ui_as_code
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('총 ${reviewCount}개 리뷰'),
                        Image.asset('assets/star/star1.png', width: 110,)
                      ],
                    ),
                  )
              ],
            ),
          ),
          Visibility(
            visible: reviewCount > 0 ? true : false,
            child: Container(
              height: 280,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _commentStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Scrollbar(
                      controller: widget._controllerOne,
                      isAlwaysShown: true,
                      child: ListView(
                        controller: widget._controllerOne,
                        children: snapshot.data.documents.map((doc) {
                          return ListTile(

                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doc['writer'], style: TextStyle(
                                    fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/star/star1.png', width: 75),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0),
                                        child: Text(
                                          _timeStampToString(doc['date']),
                                          style: TextStyle(fontSize: 12),),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [

                                      doc['img'] == null
                                          ? Visibility(
                                        visible: false, child: Text(""),)
                                          : Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10),
                                        child: Container(
                                            width: 60,
                                            height: 60,
                                            child: Image.network(
                                              doc['img'], fit: BoxFit.cover,)),
                                      ),
                                      SizedBox(
                                          width: doc['img'] == null ? size
                                              .width * 0.77 : size.width * 0.58,
                                          height: 60,
                                          child: Text(doc['review'],
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Opacity(
                              opacity: 0.3,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 5.0),
                                child: Container(
                                  width: size.width * 0.8,
                                  height: 1,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Container(
                                  child: Icon(
                                    Icons.arrow_forward_ios, size: 10,)
                              ),
                            ),
                            dense: true,
                          );
                        }).toList(),
                      ),
                    );
                  }
              ),
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
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ),
            ),
          ),
        ],
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
        .document(widget.document.documentID).collection('review').orderBy(
        'date', descending: true)
        .snapshots();
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
                      child: Scrollbar(
                        child: Column(
                          children: [
                            Visibility(
                                visible: widget.modalVisible,
                                child: Padding(
                                  padding: const EdgeInsets.only(top:25.0),
                                  child: Text("옵션을 모두 선택해주세요",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.pinkAccent),),
                                )),
                            if(widget.selectedList.length >=1)
//                            for (var i=0; i< widget.selectedList.length; i++)
                              _cleanArray(),
                              for (var index=0; index< widget.selectedList.length; index++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom :13.0),
                                    child: Row(
                                      children: [
                                          Text('${widget.selectedList[index][0]}',style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(','),
                                          Text('${widget.selectedList[index][1]}',style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(','),
                                          Text('${widget.selectedList[index][2]}',style: TextStyle(fontWeight: FontWeight.bold)),
                                          Spacer(),
                                          GestureDetector(child: Icon(Icons.close,color: Colors.grey,), onTap:(){
                                             setState((){
                                              widget.selectedList.removeAt(index);
                                                print(widget.selectedList);
                                          });
                                         }),
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
//                            _writeComment();
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
                            print(widget.selectedList);
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
      print("widget.selectedList: ${widget.selectedList}");
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
        print("widget.selectedList: ${widget.selectedList}");

      }
  }

  Widget _cleanArray(){
    if(widget.selectedList.length>=2){
      print("a");
      // i=1
     for(var i=widget.selectedList.length-1; i>1; i--){
       for(var j=0; j<widget.selectedList.length-1; j++){
                              // 1                        // 0
         if(widget.selectedList[i][0]==widget.selectedList[j][0] &&
                               // 1                         // 0
             widget.selectedList[i][1]==widget.selectedList[j][1]){
             print("same");
             widget.selectedList[j].setAll(2,["${int.parse(widget.selectedList[j][2])+1}"]);
             widget.selectedList.removeAt(i);
             print(widget.selectedList);
           _cleanArray();
         }
       }
    }
    }else{
      print("else");
    }
    return Container();
  }


  void _writeComment(String text) {
    final data = {
      'writer' : widget.user.email,
      'comment' : text,};
    // 댓글 추가
    Firestore.instance
        .collection('post')
        .document(widget.document.documentID)
        .collection('comment')
        .add(data);
    // lastComment와 commentCount 최산화
    final _updataData ={
      'lastComment' : text,
      'commentCount' : (widget.document['commentCount']??0)+1
    };
    Firestore.instance
        .collection('post')
        .document(widget.document.documentID)
        .updateData(_updataData);
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
      width: size.width * 0.36,
      child: Column(
        children: <Widget>[
          SizedBox(
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(image)),
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
                                Text('$category',style: TextStyle(fontSize: 13, color:Colors.blue, fontWeight: FontWeight.bold)),
                                Text('\￦$price', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 12,color: Colors.black)),
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
}


