import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class OrderPage extends StatefulWidget {
  final FirebaseUser user;
  var orderList= [["레드", "medium", "1", "8pd6ugCTiOq5OidSGFry"], ["주황", "Large", "1", "8pd6ugCTiOq5OidSGFry"]];
  //final orderList;
  OrderPage(this.user);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.cyanAccent,
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
          _orderInfo(),
          _orderView()
        ],
      ),
    );
  }
  Widget _orderInfo(){
    return Text("주문");
  }
  Widget _orderView(){
         return ListView.builder(
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
        );
  }
  Widget _buildListView(context, doc,index){

    return Column(
      children: [
        Row(
          children: [
             ClipRRect(
                 borderRadius: BorderRadius.circular(12.0),
                 child: FadeInImage.assetNetwork(
                   placeholder:'assets/images/19.png',
                   image: doc['thumbnail_img'],width: 70,height:70,fit: BoxFit.cover,)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 200,
                                child: Text("${doc['productName']}",
                                  style:TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                )),

                          ],
                    ),
                    Text("옵션 : ${widget.orderList[index][0]} / ${widget.orderList[index][1]}", style: TextStyle(fontSize:14 ,color: Colors.black87),),
                    Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: Text('${widget.orderList[index][2]}개',style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Spacer(),
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
                    top: 6.0, bottom: 6.0),
                child: Container(
                  height: 1,
                  color: Colors.black38,
                ))),
      ],
    );
  }

  // Widget _items() {
  //   return
  // }
}
