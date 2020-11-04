import 'package:coodyproj/cart.dart';
import 'package:coodyproj/resent_page.dart';
import 'package:coodyproj/search_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorite_analysis_page.dart';
import 'loading_page.dart';
import 'favorite.dart';
import 'package:transparent_image/transparent_image.dart';


class HomePage extends StatefulWidget {
  final FirebaseUser user;
  var productStream = [];

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen= false;

  @override
  HomePage(this.user,);

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


class _HomePageState extends State<HomePage> {

  var images=[];
  var title = [];
  var currentPage=0.0;

  @override
  void initState() {
       Firestore.instance.collection('magazine')
           .orderBy('date', descending: true)
           .getDocuments().then((querySnapshot) =>
            querySnapshot.documents.forEach((result) {
            setState(() {
              images.add(result.data['thumbnail_img']);
              title.add(result.data['shortTitile']);
              currentPage = images.length - 1.0;
            });
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
      stream: Firestore.instance.collection("user_data").document(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data.data == null){
            return FavoriteAnalysisPage(widget.user);
          }else{
            return widget.isDrawerOpen?
            AnimatedContainer(
                transform: Matrix4.translationValues(widget.xOffset, widget.yOffset, 0)
                  ..scale(widget.scaleFactor)..rotateY(widget.isDrawerOpen? -0.5:0),
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.isDrawerOpen?40:0.0)
                ),child:
            GestureDetector(
              onTap: (){
                setState(() {
                  widget.xOffset=0;
                  widget.yOffset=0;
                  widget.scaleFactor=1;
                  widget.isDrawerOpen=false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [kDefaultShadow],
                ),
                child: Scaffold(
                    backgroundColor:widget.isDrawerOpen?Colors.transparent:Colors.white,
                    appBar: appBarBuild(),
                    body: bodyBuild()
                ),
              ),
            )) :AnimatedContainer(
                    transform: Matrix4.translationValues(widget.xOffset, widget.yOffset, 0)
                      ..scale(widget.scaleFactor)..rotateY(widget.isDrawerOpen? -0.5:0),
                    duration: Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.isDrawerOpen?40:0.0)
                    ),child:
                Scaffold(
                    backgroundColor:widget.isDrawerOpen?Colors.transparent:Colors.white,
                    appBar: appBarBuild(),
                    body: bodyBuild()
               ));
          }}
        else{
          return LoadingPage();
        }}
        );
    }
    Widget bodyBuild(){
    return Container(
      decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular( widget.isDrawerOpen?27:0.0),
              bottomLeft: Radius.circular( widget.isDrawerOpen?27:0.0))
      ),
      child: ListView(
        children: [
          magazineView(),
          divideTag(),
          AI_recommendationView(),
          recommendationView(),
          _gridBuilder(),
        ],
      ),
    );
    }
    Widget magazineView(){
    return SingleChildScrollView(
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
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top:18),
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
                      padding: const EdgeInsets.only(left:15.0),
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
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return RecentPage(widget.user);
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
                          for(var i=0; i< images.length; i++)

                            ContentsCard(
                                  image: "${images[i]}",
                                  title: "${title[i]}",
                                  country: "Russia",
                                  price: 440,
                                  press: (){}
                              ,
                            ),
                        ])])),
        ],
      ),
    );
  }
    Widget divideTag(){
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
                  padding: const EdgeInsets.only(left:15.0),
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
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 25.0,
                    color: Colors.black,
                  ),
                  onPressed: () {

                  },
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
    Widget AI_recommendationView(){
    Size size = MediaQuery.of(context).size;
    return   Container(
      margin: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      // color: Colors.blueAccent,
      height: 160,
      child: InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Favorite(widget.user)));
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Those are our background
            Container(
              height: 120,
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
                boxShadow: [
                  BoxShadow(
                  offset: Offset(0, 20),
              blurRadius: 20,
              color: Colors.black12,
            ),
          ],
              ),
            ),
            // our product image
            Positioned(
              top: 0,
              right: 0,
              child: Container(

                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: 160,
                // image is square but we add extra 20 + 20 padding thats why width is 200
                width: 200,
                child: Image.asset("assets/images/giphy.gif", fit: BoxFit.cover,),
              ),
            ),
            // Product title and price
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
                      child: Text("A.I 맞춤 스타일 추천", style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
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
                        "Custom",
                        style: TextStyle(color:Colors.white),
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
    Widget recommendationView(){
      Size size = MediaQuery.of(context).size;

    return   Container(
      margin: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      // color: Colors.blueAccent,
      height: 160,
      child: InkWell(
        onTap: (){},
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Those are our background
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.lightBlueAccent,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    _getColorFromHex("#FFE53B"),
                    _getColorFromHex("#FF2525"),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 20),
                    blurRadius: 20,
                    color: Colors.black12,
                  ),
                ],
              ),
            ),
            // our product image
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: 100,
                // image is square but we add extra 20 + 20 padding thats why width is 200
                width: 330,
                child: Padding(
                  padding: const EdgeInsets.only(left:100.0),
                  child: Image.asset("assets/images/giphy2.gif",fit: BoxFit.cover, ),
                ),
              ),
            ),
            // Product title and price
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
                      child: Text(
                        "product.title",
                        style: Theme.of(context).textTheme.button,
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        "price",
                        style: Theme.of(context).textTheme.button,
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
    Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(40.0),
        child:AppBar(
          titleSpacing: 6.0,
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular( widget.isDrawerOpen?27:0.0),
            )
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              child: GestureDetector(
                  child: Image.asset('assets/logo/blacklogo.png'),
                  onTap: (){

                  }),
            ),
          ),
          title: Container(
            child: Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10,left: 5),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SearchPage(widget.user)));
                      },
                      child: Container(
                          height: 40,
                          child: Image.asset('assets/icons/bar.png')),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:11.0),
                    child: Row(
                      children: <Widget>[

                        Padding(
                          padding: const EdgeInsets.only(left:27.0),
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
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage(widget.user)))
              },
            ),
            widget.isDrawerOpen ?IconButton(
              icon: Icon(Icons.more_vert,),
              onPressed: (){
                setState(() {
                  widget.xOffset=0;
                  widget.yOffset=0;
                  widget.scaleFactor=1;
                  widget.isDrawerOpen=false;
                });
              },)
                :IconButton( icon: new Icon(Icons.more_vert,size: 28,),
                onPressed: () => {
                  setState(() {
                    widget.xOffset = -60;
                    widget.yOffset = 170;
                    widget.scaleFactor = 0.6;
                    widget.isDrawerOpen=true;
                  })
                })
          ],
        )
    );
  }

  Widget _gridBuilder() {

    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('user_data')
            .document(widget.user.uid).collection('recent')
            .orderBy('date',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child:Text("최근본 상품이 없습니다",style: TextStyle(color: Colors.grey),));
          }
          for(var i= snapshot.data.documents.length-1; i>0; i--){
            for(var j=0; j<i; j++){
              if(snapshot.data.documents[i]["docID"] == snapshot.data.documents[j]['docID']){
                Firestore.instance.collection('user_data').document(widget.user.uid)
                    .collection('recent').document(snapshot.data.documents[i].documentID).delete();
              }
            }
          }
          //30개
          //31개~
          for(var i=30; i< snapshot.data.documents.length; i++) {
              Firestore.instance.collection('user_data').document(widget.user.uid)
                  .collection('recent').document(snapshot.data.documents[i].documentID).delete();
            }

          return Container();
        }
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
    this.country,
    this.price,
    this.press,
  }) : super(key: key);

  final String image, title, country;
  final int price;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
                  placeholder:'assets/images/19.png',
              image : image,fit: BoxFit.cover,
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
    );
  }
}

