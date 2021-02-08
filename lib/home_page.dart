import 'package:coodyproj/cart.dart';
import 'package:coodyproj/contents_page.dart';
import 'package:coodyproj/detail_contents.dart';
import 'package:coodyproj/search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorite_analysis_page.dart';
import 'loading_page.dart';
import 'favorite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  var productStream = [];

  @override
  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 30,
  color: Colors.black38, // Black color with 12% opacity
);
const kPrimaryColor = Color(0xFF0C9869);
const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFF9F8FD);
const double kDefaultPadding = 20.0;



class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Firestore.instance.collection('magazine')
        .orderBy('date', descending: true)
        .getDocuments().then((querySnapshot) =>
        querySnapshot.documents.forEach((result) {
          setState(() {
            images.add(result.data['thumbnail_img']);
            title.add(result.data['shortTitle']);
            detail_img.add(result.data['detail_img']);
            date.add(result.data['date']);
            currentPage = images.length - 1.0;
          });
        })
    );
    super.initState();

  }


    var images=[];
    var title = [];
    var detail_img = [];
    var date =[];
    var currentPage=0.0;


    @override
    Widget build(BuildContext context) {
    return Scaffold(
        body:bodyBuild(),
    );
  }
    Widget bodyBuild() {
      return ListView(
        cacheExtent: 9999,
        children: [
          magazineView(),
          divideTag(),
          recommendationView_1(),
          recommendationView_2(),
          recommendationView_3(),
          SizedBox(height: 70),
        ],
      );
    }
    Widget magazineView() {

      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 18),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Magazine",
                        style: TextStyle(
                          color: Colors.black,
//                        fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          letterSpacing: -1.3,
                          fontSize: 27.0,
                        ),),

                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFff6e6e),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 6.0),
                              child: Text("Contents",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 25.0,
                          color: Colors.black,
                        ),
                        onPressed:
                          () {
                            //고객센터

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return ContentsPage(widget.user);
                              }));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: <Widget>[
                      Row(
                          children: [
                            for(var i = 0; i < images.length; i++)

                              ContentsCard(
                                image: "${images[i]}",
                                title: "${title[i]}",
                                detail_img: "${detail_img[i]}",
                                date: "${date[i]}",
                                press: () {}
                                ,
                              ),
                          ])
                    ])),
          ],
        ),
      );
    }
    Widget divideTag() {
      return Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Recommend",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      letterSpacing: -1.3,
                      fontSize: 27.0,
                    ),),

                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0),
                          child: Text("Store",
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),

          ],
        ),
      );
    }
    Widget recommendationView_1() {
      Size size = MediaQuery
          .of(context)
          .size;
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(10, 23),
              blurRadius: 28,
              color: Colors.black12,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 8,
        ),
        // color: Colors.blueAccent,
        height: 120,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Favorite(widget.user)));
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              // Those are our background
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xff00ffa9),
                      Color(0xff0d4dff),
                    ],
                  ),
                ),
              ),
              // our product image
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: Container(
              //     height: 160,
              //     width: 250,
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 100.0),
              //       child: Image.asset(
              //         "assets/logo/AI2.png", fit: BoxFit.cover,),
              //     ),
              //   ),
              // ),

              // Product title and price
              Positioned(
                bottom: 0,
                left: 0,
                child: SizedBox(
                  height: 136,
                  // our image take 200 width, thats why we set out total width - 200
                  width: size.width - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Row(
                          children: [
                            Text("A.I", style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 26,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),),
                            Text(" 맞춤 스타일 추천", style: TextStyle(fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      // it use the available space
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 1.5, // 30 padding
                          vertical: kDefaultPadding / 4, // 5 top and bottom
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            topRight: Radius.circular(60),
                          ),
                        ),
                        child: Text(
                          "사용자 맞춤형",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    Widget recommendationView_2() {
      Size size = MediaQuery
          .of(context)
          .size;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 6,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(10, 23),
                blurRadius: 28,
                color: Colors.black12
            ),
          ],
        ),
        // color: Colors.blueAccent,
        height: 110,
        child: InkWell(
          onTap: () {},
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              // Those are our background
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.lightBlueAccent,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      _getColorFromHex("#F9d423"),
                      _getColorFromHex("FC8884"),
                      // _getColorFromHex("#939597"),
                       //_getColorFromHex("#F5dF4D"),
                    ],
                  ),

                ),
              ),
              Positioned(
                top: 0,
                right: -9,
                child: Container(
                  height: 135,
                  // image is square but we add extra 20 + 20 padding thats why width is 200
                  width: 265,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70.0),
                    child: Image.asset(
                      "assets/images/thisYearColor.png", fit: BoxFit.cover,),
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                child: SizedBox(
                  height: 136,
                  // our image take 200 width, thats why we set out total width - 200
                  width: size.width - 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Padding(
                          padding: const EdgeInsets.only(top:30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("올해의 컬러 컬렉션", style: TextStyle(fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,),),
                              SizedBox(height: 10,),
                              Text("#얼티메이트 그레이", style: TextStyle(fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),),
                              Text("#일루미네이팅", style: TextStyle(fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100),),
                            ],
                          ),
                        ),
                      ),
                      // it use the available space
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    Widget recommendationView_3() {
    Size size = MediaQuery
        .of(context)
        .size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 6,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              offset: Offset(10, 23),
              blurRadius: 28,
              color: Colors.black12
          ),
        ],
      ),
      // color: Colors.blueAccent,
      height: 110,
      child: InkWell(
        onTap: () {},
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Those are our background
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.lightBlueAccent,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    _getColorFromHex("#F9d423"),
                    _getColorFromHex("FC8884"),
                    // _getColorFromHex("#939597"),
                    //_getColorFromHex("#F5dF4D"),
                  ],
                ),

              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 175,
                // image is square but we add extra 20 + 20 padding thats why width is 200
                width: 185,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    "assets/images/activity.png", fit: BoxFit.cover,),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 136,
                // our image take 200 width, thats why we set out total width - 200
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Padding(
                        padding: const EdgeInsets.only(top:30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("올해의 컬러 컬렉션", style: TextStyle(fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,),),
                            SizedBox(height: 10,),
                            Text("#얼티메이트 그레이", style: TextStyle(fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w100),),
                            Text("#일루미네이팅", style: TextStyle(fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w100),),
                          ],
                        ),
                      ),
                    ),
                    // it use the available space
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget appBarBuild() {
      return
        PreferredSize(preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              titleSpacing: 6.0,
              backgroundColor: Colors.white,
              elevation: 0,

              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  child: GestureDetector(
                      child: Image.asset('assets/logo/darkblue.png'),
                      onTap: () {

                      }),
                ),
              ),
              title: Container(
                child: Container(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    SearchPage(widget.user,0)));
                          },
                          child: Container(
                              height: 40,
                              child: Image.asset('assets/icons/bar.png')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Row(
                          children: <Widget>[

                            Padding(
                                padding: const EdgeInsets.only(left: 27.0),
                                child: Text("")
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),),
              ),
              actions: <Widget>[
                InkWell(
                  child: new Container(
                      width: 25,
                      child: Image.asset('assets/icons/bag.png')),
                  onTap: () =>
                  {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => CartPage(widget.user)))
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert,),
                  onPressed: () {
                    setState(() {
                    });
                  },)

              ],
            )
        );
    }

    Color _getColorFromHex(String hexColor) {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF" + hexColor;
      }
      if (hexColor.length == 8) {
        return Color(int.parse("0x$hexColor"));
      }
    }

  }

class ContentsCard extends StatelessWidget {
  const ContentsCard({
    Key key,
    this.image,
    this.title,
    this.press,
    this.date,
    this.detail_img
  }) : super(key: key);
  final String image, title,date, detail_img;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        print(title);
        print(date);
        print(detail_img);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                DetailContents(title, detail_img)));
      },
      child: Container(

        margin: EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 1,
          bottom: kDefaultPadding * 1.5,
        ),
        width: size.width * 0.4,
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius:BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: FadeInImage.assetNetwork(
                    placeholder:'assets/images/loading.png',
                image : image,fit: BoxFit.cover,width: size.width * 0.4,height: size.height*0.26,
                )
            ),
            GestureDetector(
              onTap: press,
              child: Container(
                padding: EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 18,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   Text("$title",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

