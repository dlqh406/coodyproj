import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  final FirebaseUser user;
  var _documentIDList =[];
  List<bool> checkboxList=[];
  List calculatePriceList=[];

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 30.0, right: 10.0, left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: (){
                        Navigator.pop(context);
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("장바구니",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: SizedBox(
                    width: 60,
                    height: 30,
                    child: RaisedButton(
                      color: Color(0xFF5D70F8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)
                      ),
                      onPressed: () {
                        _deleteCart();

                      },
                      child: Text("삭제",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                )

              ],
            ),
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
              height: size.height*0.52,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _cartStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return snapshot.data.documents.length!=0
                        ?Scrollbar(
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
      ),
    );
  }
  Widget _buildListView(context, doc, index, length){
    if( widget.checkboxList.length != length){
      for(var i=0; i< length; i++){
        widget.checkboxList.add(true);
      }
    }
    return Column(
      children: [
        Row(
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
                        return Row(
                          children: [
                            Container(
                                width: 200,
                                child: Text("${snapshot.data['productName']}",
                                  style:TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                )),
                            Checkbox(
                              activeColor: Colors.blue,
                              value: widget.checkboxList[index],
                              onChanged: (val){
                                setState(() {
                                 widget.checkboxList[index] = !widget.checkboxList[index];
                                 print(widget.checkboxList);
                                });
                              },
                            )
                          ],
                        );
                      },
                    ),
                    Text("옵션: ${doc['selectedColor']} / ${doc['selectedSize']}", style: TextStyle(fontSize:14 ,color: Colors.black87),),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: Container(
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
                                  return Text("₩ ${snapshot.data['price']}",
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
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context) =>  CartPage(widget.user)));

  }
  Stream<QuerySnapshot> _cartStream() {
    return Firestore.instance.collection('user_data')
        .document("${widget.user.uid}").collection('cart')
        .orderBy('date', descending: true).snapshots();
  }
  Widget _calculationView(BuildContext context) {

    Firestore.instance.collection('user_data').document("${widget.user.uid}")
        .collection('cart')
        .orderBy('date', descending: true).getDocuments().then((querySnapshot){
         querySnapshot.documents.forEach((result){
          Firestore.instance.collection('uploaded_product').document(result.data["product"]).get().then((value) {
            widget.calculatePriceList.add(value.data['productName']);
          });
        });});


    return Padding(
      padding: const EdgeInsets.only(left:15.0,right:15.0),
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
                  Text('₩ 48,000', style: TextStyle(fontSize:23, fontWeight: FontWeight.bold),)
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => null));
                  },
                  child: const Text('바로 구매하기',
                      style: TextStyle(color: Colors.white, fontSize: 13,fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
  //TODO Price 데이터 필드 결정빨리하고 콤마 , 알고리즘 구현 해야하고 아래 함수의 리턴 값으로 총합계보여주면 됨 /// 장바구니 삭제기능 해야함
//  int _calculatePrice(){
//    int totalPrice = 0;
//    for(var i=0; i< widget.checkboxList.length; i++){
//      if(widget.checkboxList[i] == true){
//        totalPrice += widget.calculatePriceList[i];
//      }
//    }
//    return totalPrice;
//  }
}
