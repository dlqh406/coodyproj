import 'package:coodyproj/cart.dart';
import 'package:coodyproj/my_page.dart';
import 'package:coodyproj/resent_page.dart';
import 'package:coodyproj/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'drawer_screen.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'home_page.dart';

class Home extends StatefulWidget {

  bool isDrawerOpen = false;

  final FirebaseUser user;

  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}


  class _HomeState extends State<Home> {
    var currentIndex;
    List<Widget> pageList;

    GlobalKey _bottomNavigationKey = GlobalKey();

    final PageController _pageController = PageController(
        initialPage: 0, keepPage: true
    );

    @override
    void initState() {
      super.initState();
      currentIndex = 0;
       pageList =[
        HomePage(widget.user),
        RecentPage(widget.user),
        SearchPage(widget.user),
        MyPage(widget.user),
      ];
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBarBuild() ,
      body: Stack(
        children: [
          DrawerScreen(widget.user),
          PageView(
            controller: _pageController,
            children: pageList,
            ),
        ],
      ),
      bottomNavigationBar: SnakeNavigationBar(
//        showUnselectedLabels: true,
        selectedIconColor: Colors.white,
        selectionColor: Colors.blueAccent,
        currentIndex: currentIndex,
        onTap:changePage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
        ],
      ),
    );
  }
  Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(40.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: currentIndex ==2?LinearGradient(
                colors: [
//              Colors.blue,
                  Colors.deepPurple[700],
                  Colors.purple[500]
                ],
              ):null
            ),
//            color: Colors.black,
            child: AppBar(
              titleSpacing: 6.0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(widget.isDrawerOpen ? 27 : 0.0),
                  )
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  child: GestureDetector(
                      child: Image.asset('assets/logo/darkblue.png',color: currentIndex ==2? Colors.white:Colors.black,),
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
                                    SearchPage(widget.user)));
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
                      child: Image.asset('assets/icons/bag.png',color: currentIndex ==2? Colors.white:Colors.black)),
                  onTap: () =>
                  {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => CartPage(widget.user)))
                  },
                ),
                widget.isDrawerOpen ? IconButton(
                  icon: Icon(Icons.more_vert,color: currentIndex ==2? Colors.white:Colors.black),
                  onPressed: () {
//                  setState(() {
//                    widget.xOffset = 0;
//                    widget.yOffset = 0;
//                    widget.scaleFactor = 1;
//                    widget.isDrawerOpen = false;
//                  });
                  },)
                    : IconButton(icon: new Icon(Icons.more_vert,color: currentIndex ==2? Colors.white:Colors.black, size: 28,),
                    onPressed: () =>
                    {
//                    setState(() {
//                      widget.xOffset = -60;
//                      widget.yOffset = 170;
//                      widget.scaleFactor = 0.6;
//                      widget.isDrawerOpen = true;
//                    })
                    })
              ],
            ),
          )
      );
  }
    void changePage(int index) {
      setState(() {
        currentIndex = index;
        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }

}