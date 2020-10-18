import 'package:coodyproj/test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorite_analysis_page.dart';
import 'loading_page.dart';
import 'favorite.dart';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
//  List<String> images = ["https://firebasestorage.googleapis.com/v0/b/coody-f21eb.appspot.com/o/magazine%2F5.png?alt=media&token=b51cfea8-909e-41ce-98f2-2713447a155c", "https://firebasestorage.googleapis.com/v0/b/coody-f21eb.appspot.com/o/magazine%2F1.png?alt=media&token=c1beb195-ff65-4dcc-b49a-881dfb42e982", "https://firebasestorage.googleapis.com/v0/b/coody-f21eb.appspot.com/o/magazine%2F2.png?alt=media&token=f75a6b78-4df7-4486-8e73-540f86c5bcd9","https://firebasestorage.googleapis.com/v0/b/coody-f21eb.appspot.com/o/magazine%2F3.png?alt=media&token=874e93fc-c5ac-46a6-ad18-64484995ca13"];

//  var images=[];


  final FirebaseUser user;
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}


var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;


List<String> images2 = [
  "assets/images/1.png",
  "assets/images/newdelhi.jpg",
  "assets/images/newyork.jpg",
  "assets/images/paris.jpg",
];



List<String> contents = ["두번보는 쿠디사용설명서", "카디건 활용방법", "Hello World"];


class _HomePageState extends State<HomePage> {
  var images=[];
  var title = [];
  var currentPage=0.0;


  @override
  void initState() {
       Firestore.instance.collection('magazine').orderBy('date', descending: false).getDocuments().then((querySnapshot) =>
          querySnapshot.documents.forEach((result) {
            setState(() {
              images.add(result.data['thumbnail_img']);
              title.add(result.data['title']);
              currentPage = images.length - 1.0;
            });
            print(result.data['thumbnail_img']);
            print(images);
          })
      );
    print(images);
    super.initState();
  }


  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin facebookLogin = FacebookLogin();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("user_data").document(widget.user.email).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data.data == null){
            return FavoriteAnalysisPage(widget.user);

          }else{
            return Scaffold(
                body: _buildBody(context)
            );
          }
        }else{
          return LoadingPage();
        }

      }
    );
    }

  Widget _buildBody(context) {

    PageController controller = PageController(initialPage: images.length);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      decoration: BoxDecoration(
      color: Colors.white
      ),
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(40.0),
            child:AppBar(
              titleSpacing: 6.0,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  child: GestureDetector(
                      child: Image.asset('assets/logo/blacklogo.png'),
                      onTap: (){Navigator.of(context).pop();}),
                ),
              ),
              title: Container(
                child: Container(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:1.5,right: 10,left: 5),
                        child: GestureDetector(
                          onTap: (){print("Tap GTD");},
                          child: Image.asset('assets/icons/bar.png',height: 40,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:11.0),
                        child: Row(
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.only(left:27.0),
                              child: RotateAnimatedTextKit(
                                onTap: () {
                                  // 위 GestureDetector 랑 똑같이 구현 해야함
                                  print("Tap Event");
                                },
                                isRepeatingAnimation: true,
                                totalRepeatCount: 60000,
                                text: contents,
                                textStyle: TextStyle(fontSize: 13.0,color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                      ),
//                      if(widget.images.length == 0)
//                        StreamBuilder<QuerySnapshot>(
//                            stream: Firestore.instance.collection('magazine').orderBy('date', descending: true).snapshots(),
//                            builder:(context, snapshot){
//                              print('init3');
//                              if(!snapshot.hasData){
//                                return  Center(child: CircularProgressIndicator());
//                              }else{
//                                widget.images =[];
//                                for(var i=0; i<4; i++){
//                                  widget.images.setAll(i, snapshot.data.documents[i]['thumbnail_img']);
//                                  print(snapshot.data.documents[i]['thumbnail_img']);
//                                }
//                                print(widget.images);
//                                return Container();
//                              }
//                            }),
                    ],
                  ),),
              ),
              actions: <Widget>[

                InkWell(
                  child: new Container(
                      width: 25,
                      child: Image.asset('assets/icons/cart2.png')),
                  onTap: () => {

                  },
                ),
                new IconButton( icon: new Icon(Icons.more_vert,size: 28,),
                    onPressed: () => {
                    }),

              ],

            )
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(
//                    left: 12.0, right: 12.0, top: 39.0, bottom: 8.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    IconButton(
//                      icon: Icon(
//                        Icons.close,
//                        color: Colors.black,
//                        size: 10.0,
//                      ),
//                      onPressed: () {
//                        FirebaseAuth.instance.signOut();
//                        _googleSignIn.signOut();
//                        facebookLogin.logOut();
//                      },
//                    ),
//                    IconButton(
//                      icon: Icon(
//                        Icons.brightness_1,
//                        color: Colors.black,
//                        size: 10.0,
//                      ),
//                      onPressed: () {
//                        Navigator.push(context,
//                            MaterialPageRoute(builder: (context) => TestPage()));
//                      },
//                    ),
//                    IconButton(
//                      icon: Icon(
//                        Icons.more_vert,
//                        color: Colors.black,
//                        size: 30.0,
//                      ),
//                      onPressed: () {},
//                    )
//                  ],
//                ),
//              ),
              Padding(
                padding: EdgeInsets.only(top:15),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("패션 컨텐츠",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            letterSpacing: 0.1,
                          )),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 25.0,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Favorite(widget.user)));
                        },
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5,left: 20.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFff6e6e),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0),
                          child: Text("Magazine",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text("25+ Stories",
                        style: TextStyle(color: Colors.black)),
                    Spacer(),

                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  CardScrollWidget(currentPage, images),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top:20),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("A.I 스타일추천",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 30.0,
                            letterSpacing: 0.1,
                          )),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 25.0,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Favorite(widget.user)));
                        },
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0,left: 20.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0),
                          child: Text("Store",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text("1235+",
                        style: TextStyle(color: Colors.black)),
                    Spacer(),

                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(18.0),
                    child: ClipRRect(

                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/images/newyork.jpg",fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.width*0.6,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget CardScrollWidget(currentPage,imagesList){
    var padding = 20.0;
    var verticalInset = 20.0;
    print("@@@@@@@@imagesList.length::${imagesList.length}, currentPage: ${currentPage} ");
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < imagesList.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(imagesList[i], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
//                            Padding(
//                              padding: EdgeInsets.symmetric(
//                                  horizontal: 16.0, vertical: 8.0),
//                              child: Text(title[i],
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 25.0,
//                                  )),
//                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );

  }


}
//
//class CardScrollWidget extends StatelessWidget {
//
//  var currentPage;
//  var padding = 20.0;
//  var verticalInset = 20.0;
//  var imagesList;
//
//  CardScrollWidget(this.currentPage, this.imagesList);
//
//  @override
//  Widget build(BuildContext context) {
//    print("imagesList.length:  ${imagesList.length}");
//    return new AspectRatio(
//      aspectRatio: widgetAspectRatio,
//      child: LayoutBuilder(builder: (context, contraints) {
//        var width = contraints.maxWidth;
//        var height = contraints.maxHeight;
//
//        var safeWidth = width - 2 * padding;
//        var safeHeight = height - 2 * padding;
//
//        var heightOfPrimaryCard = safeHeight;
//        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;
//
//        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
//        var horizontalInset = primaryCardLeft / 2;
//
//        List<Widget> cardList = new List();
//
//        for (var i = 0; i < imagesList.length; i++) {
//          var delta = i - currentPage;
//          bool isOnRight = delta > 0;
//
//          var start = padding +
//              max(
//                  primaryCardLeft -
//                      horizontalInset * -delta * (isOnRight ? 15 : 1),
//                  0.0);
//
//          var cardItem = Positioned.directional(
//            top: padding + verticalInset * max(-delta, 0.0),
//            bottom: padding + verticalInset * max(-delta, 0.0),
//            start: start,
//            textDirection: TextDirection.rtl,
//            child: ClipRRect(
//              borderRadius: BorderRadius.circular(16.0),
//              child: Container(
//                decoration: BoxDecoration(color: Colors.white, boxShadow: [
//                  BoxShadow(
//                      color: Colors.black12,
//                      offset: Offset(3.0, 6.0),
//                      blurRadius: 10.0)
//                ]),
//                child: AspectRatio(
//                  aspectRatio: cardAspectRatio,
//                  child: Stack(
//                    fit: StackFit.expand,
//                    children: <Widget>[
//                      Image.network(imagesList[i], fit: BoxFit.cover),
//                      Align(
//                        alignment: Alignment.bottomLeft,
//                        child: Column(
//                          mainAxisSize: MainAxisSize.min,
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Padding(
//                              padding: EdgeInsets.symmetric(
//                                  horizontal: 16.0, vertical: 8.0),
//                              child: Text(title[i],
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 25.0,
//                                  )),
//                            ),
//
//                            Padding(
//                              padding: const EdgeInsets.only(
//                                  left: 12.0, bottom: 12.0),
//                            )
//                          ],
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          );
//          cardList.add(cardItem);
//        }
//        return Stack(
//          children: cardList,
//        );
//      }),
//    );
//  }
//}