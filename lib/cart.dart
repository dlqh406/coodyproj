import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  final FirebaseUser user;


  final ScrollController _controllerOne = ScrollController();

  CartPage(this.user);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var cartCount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: _buildHasCart(context),
        );
      }

  Widget _buildHasCart(context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
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
                  child: Text("장바구니",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _cartStream(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Padding(
                     padding: const EdgeInsets.only(right: 8.0, left: 20),
                     child: Text("장바구니가 비어있습니다*여기에 회색일러스트 넣기",
                              style: TextStyle(fontSize: 13, color: Colors.grey))
                        );
                }
                else{
                  return Padding(
                    padding: const EdgeInsets.only(top: 17.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      ],
                    ),
                  );
                }

              }
            ),
            Container(
              height: size.height*0.55,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _cartStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return snapshot.data.documents.length!=0 ? Scrollbar(
                      controller: widget._controllerOne,
                      isAlwaysShown: true,
                      child: ListView(
                        controller: widget._controllerOne,
                        children: snapshot.data.documents.map((doc) {
                          return ListTile(
                            title: Row(
                              children: [
                                StreamBuilder(
                                  stream: Firestore.instance.collection('uploaded_product').document("${doc['product']}").snapshots(),
                                  builder: (context, snapshot){
                                    if(!snapshot.hasData){
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return ClipRRect(
                                        borderRadius: BorderRadius.circular(18.0),
                                        child: Image.network(snapshot.data['thumbnail_img'],width: 90,height: 90,fit: BoxFit.cover,));
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:8.0),
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
                                          return Container(
                                              width: 200,
                                              child: Text("${snapshot.data['productName']}",
                                                style:TextStyle(fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                              ));
                                        },
                                      ),
                                      Text("옵션: ${doc['selectedColor']} / ${doc['selectedSize']}", style: TextStyle(fontSize:14 ,color: Colors.black87),),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Container(
                                          width:size.width*0.6,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                  child: Icon(Icons.arrow_drop_down),
                                                  onTap:(){
                                                  }),
                                              Text('${doc['selectedQuantity']}',style: TextStyle(fontWeight: FontWeight.bold)),
                                              GestureDetector(child: Icon(Icons.arrow_drop_up),
                                                  onTap:(){
                                                  }
                                              ),
                                              Spacer(),
                                              StreamBuilder(
                                                stream: Firestore.instance.collection('uploaded_product').document("${doc['product']}").snapshots(),
                                                builder: (context, snapshot){
                                                  if(!snapshot.hasData){
                                                    return Center(
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  return Text("₩ ${snapshot.data['price']}",
                                                    style:TextStyle(fontWeight: FontWeight.bold)
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            subtitle: Opacity(
                              opacity: 0.15,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 5.0),
                                child: Container(
                                  width: size.width * 0.8,
                                  height: 1,
                                  color: Colors.black38,
                                ),
                              ),
                            ),

                          );
                        }).toList(),
                      ),
                    ):Center(child: Text("장바구니 비였음"));
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
  Stream<QuerySnapshot> _cartStream() {
    return Firestore.instance.collection('user_data')
        .document("${widget.user.uid}").collection('cart')
        .orderBy('date', descending: true).snapshots();
  }
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }
}
