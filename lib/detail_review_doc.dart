import 'package:coodyproj/detail_review_img.dart';
import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class DetailReviewDoc extends StatefulWidget {

  final DocumentSnapshot document;

  final ScrollController _controllerOne = ScrollController();
  DetailReviewDoc(this.document);

  @override
  _DetailReviewDocState createState() => _DetailReviewDocState();
}

class _DetailReviewDocState extends State<DetailReviewDoc>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            ],

          )),
      body: Padding(
        padding: const EdgeInsets.only(top:28.0),
        child: _buildListView(widget.document),
      ),
    );
  }


  Widget _buildListView( doc) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left:15.0,right: 15),
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
                )
              ],
            ),
          ),
          doc['imgList'].length == 0 ? Visibility(
            visible: false, child: Text(""),) : Padding(
            padding: const EdgeInsets.only(right: 10,top:15,bottom: 15),
            child: Container(
                width: size.width*1,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0),
                  itemCount: doc['imgList'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => DetailReviewImg(doc['imgList'])),
                        );
                      },
                      child: Stack(
                          fit: StackFit.expand,
                          children:[
                            Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey)),),
                            Image.network(doc['imgList'][index], fit: BoxFit.cover),
                          ]
                      ),
                    );

                  },
                )


              // Image.network(
              //   doc['imgList'][0], fit: BoxFit.cover,)

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: SizedBox(
                width: size.width * 1,
                child: Text(doc['review'],style: TextStyle(fontSize: 14),)),
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
    );
  }
  String _timeStampToString(date) {
    Timestamp t = date;
    DateTime d = t.toDate();
    var list = d.toString().replaceAll('-', '.').split(" ");
    return list[0];
  }
}
