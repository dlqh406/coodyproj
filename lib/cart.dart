import 'package:coodyproj/home.dart';
import 'package:coodyproj/order_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'detail_product.dart';


class CartPage extends StatefulWidget {
  final FirebaseUser user;
  var _documentIDList =[];
  var orderList =[];
  var temOrderList=[];
  var doclength=0;
  List<bool> checkboxList=[];
  List calculatePriceList=[];


  final ScrollController _controllerOne = ScrollController();

  CartPage(this.user);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  var cartCount;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
        title: Text('장바구니'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 70,
              child: RaisedButton(
                color: Color(0xFF5D70F8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)
                ),
                onPressed: () {

                  _deleteCart();
                  Navigator.pushReplacement(context, MaterialPageRoute(
                     builder: (BuildContext context) =>  CartPage(widget.user)));
                },
                child: Text("삭제",style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
          body: Column(
            children: [
              _buildCart(context),
              _calculationView(context),
            ],
          ),
        );
      }

  Widget _buildCart(context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
          top: 0.0, right: 10.0, left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          StreamBuilder<QuerySnapshot>(
            stream: _cartStream(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }
              else{
                return Padding(
                  padding: const EdgeInsets.only(top: 17.0, bottom: 10.0),
                );
              }
            }
          ),
          Container(
            height: size.height*0.56,
            child: StreamBuilder<QuerySnapshot>(
                stream: _cartStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                    widget.doclength =  snapshot.data.documents.length;
                  return snapshot.data.documents.length!=0
                      ?CupertinoScrollbar(
                    controller: widget._controllerOne,
                    isAlwaysShown: true,
                    child: ListView.builder(
                      controller: widget._controllerOne,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder:(BuildContext context, int index){
                        return _buildListView(context, snapshot.data.documents[index],index, snapshot.data.documents.length,);
                      },
                    ),
                  ):Center(child: Text("장바구니 비였음"));

                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(context, doc, index, length){
    if( widget.checkboxList.length != length){
      for(var i=0; i< length; i++){
        widget.checkboxList.add(true);
      }
    }
    //temOrderList(doc);


    return Column(
      children: [
        index == 0?Container():line(),
        Row(
          children: [
            StreamBuilder(
              stream: Firestore.instance.collection('uploaded_product')
                  .document("${doc['product']}").snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ProductDetail(widget.user, snapshot.data);
                    }));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.0),
                      child: FadeInImage.assetNetwork(
                        placeholder:'assets/images/19.png',
                          image: snapshot.data['thumbnail_img'],width: 90,height:90,fit: BoxFit.cover,)),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: Firestore.instance.collection('uploaded_product').document("${doc['product']}").snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        temOrderList(doc,snapshot.data);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 200,
                                child: Text("${snapshot.data['productName']}",
                                  style:TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(right:4.0),
                              child: Checkbox(
                                activeColor: Colors.blue,
                                value: widget.checkboxList[index],
                                onChanged: (val){
                                  setState(() {
                                   widget.checkboxList[index] = !widget.checkboxList[index];
                                   print(widget.checkboxList);
                                  });
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),

                    Text("옵션: ${doc['selectedColor']} / ${doc['selectedSize']}", style: TextStyle(fontSize:14 ,color: Colors.black87),),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom: 10),
                      child: Container(
                        child: Row(
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: Text('${doc['selectedQuantity']}개',style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right:20.0),
                              child: StreamBuilder(
                                stream: Firestore.instance.collection('uploaded_product').document("${doc['product']}").snapshots(),
                                builder: (context, snapshot){
                                  if(!snapshot.hasData){
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Text("₩ ${numberWithComma(int.parse(snapshot.data['price']))}",
                                      style:TextStyle(fontWeight: FontWeight.bold)
                                  );
                                },
                              ),
                            ),
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


  void _deleteCart(){

      Firestore.instance.collection('user_data').document("${widget.user.uid}")
          .collection('cart').orderBy('date', descending:true).getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((result){
          widget._documentIDList.add(result.documentID);
        });
        for(var i=0; i< widget.checkboxList.length; i++){
          if(widget.checkboxList[i] == true){
            Firestore.instance.collection('user_data').document(widget.user.uid)
                .collection('cart').document(widget._documentIDList[i]).delete();
          }
        }});


  }

  Stream<QuerySnapshot> _cartStream() {
    return Firestore.instance.collection('user_data')
        .document("${widget.user.uid}").collection('cart')
        .orderBy('date', descending: true).snapshots();
  }

  Widget _calculationView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:25,left:15.0,right:15.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('배송비',style: TextStyle(fontSize:19,fontWeight: FontWeight.bold),),
                Text('무료배송', style: TextStyle(fontSize:15, fontWeight: FontWeight.bold),)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('총 합계',style: TextStyle(fontSize:25,fontWeight: FontWeight.bold),),
                  Text('₩ ${_calculatePrice()}', style: TextStyle(fontSize:23, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Opacity(
                opacity: 0.15,
                child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      height: 1,
                      color: Colors.black38,
                    ))),
            Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width*1,
                child: RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),),
                  color: Colors.blueAccent,
                  onPressed: () {
                    setState(() {
                      widget.orderList = [];
                    });
                    var trueCount =0;
                    for(var i=0; i<widget.checkboxList.length; i++){
                      if( widget.checkboxList[i] == true){
                        trueCount +=1;
                      }
                    }

                    if(widget.doclength==0){
                      scaffoldKey.currentState
                          .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,color: Colors.blueAccent,),
                            SizedBox(width: 14,),
                            Text("장바구니가 비어 있습니다",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                          ],
                        ),
                      )));
                    }
                    else if(trueCount == 0){

                      scaffoldKey.currentState
                          .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle,color: Colors.blueAccent,),
                            SizedBox(width: 14,),
                            Text("구매할 상품을 체크해주세요",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                          ],
                        ),
                      )));
                    }
                    else{
                      for(var i=0; i<widget.temOrderList.length; i++){
                        if( widget.checkboxList[i] ==true){
                          widget.orderList.add(widget.temOrderList[i]);
                        }
                      }
                      print(widget.orderList);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                          OrderPage(widget.user, widget.orderList)
                          ));
                    }

                  },
                  child: const Text('바로 구매하기',
                      style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  String numberWithComma(int param){
    return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
  }

  String _calculatePrice(){
    int _totalPrice = 0;
      Firestore.instance.collection('user_data').document("${widget.user.uid}")
          .collection('cart').orderBy('date', descending: true).getDocuments().then((querySnapshot){
        querySnapshot.documents.forEach((result){
          Firestore.instance.collection('uploaded_product')
              .document(result.data["product"]).get().then((value) {
             setState(() {
               if( widget.calculatePriceList.length!=widget.checkboxList.length){
                 widget.calculatePriceList.add(int.parse(value.data['price']) * int.parse(result.data['selectedQuantity']));
               }
             });
          });
        });});
    if(widget.calculatePriceList.length==widget.checkboxList.length){
      for(var i=0; i< widget.checkboxList.length; i++){
        if(widget.checkboxList[i] == true){
            _totalPrice += widget.calculatePriceList[i];
        }
      }
    }
    return numberWithComma(_totalPrice);
  }

  Widget line(){
    return Opacity(
        opacity: 0.15,
        child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0),
            child: Container(
              height: 1,
              color: Colors.black38,
            )));
  }

  void temOrderList(doc,docs) {
    if(widget.temOrderList.length < widget.doclength){
      widget.temOrderList.add([doc['selectedColor'],doc['selectedSize'],doc['selectedQuantity'], docs.documentID,docs['price'],docs['sellerCode']]);
    }

  }
}
