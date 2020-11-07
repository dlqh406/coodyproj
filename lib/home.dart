import 'package:coodyproj/cart.dart';
import 'package:coodyproj/favorite.dart';
import 'package:coodyproj/my_page.dart';

import 'package:coodyproj/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'drawer_screen.dart';
import 'home_page.dart';

class Home extends StatefulWidget {




  final FirebaseUser user;
  var index;
  Home(this.user,[this.index]);

  @override
  _HomeState createState() => _HomeState();
}


  class _HomeState extends State<Home> {
    var currentIndex;
    List<Widget> pageList;


    final PageController _pageController = PageController(
        initialPage: 1 , keepPage: true
    );

    @override
    void initState() {
      super.initState();
        currentIndex = 1;
        pageList =[
          SearchPage(widget.user,0),
          HomePage(widget.user),
          MyPage(widget.user),
        ];

    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: appBarBuild(),
          body: Stack(
            children: [
              DrawerScreen(widget.user),
              PageView(
                controller: _pageController,
                children: pageList,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: bottomNavigationBar,
              ),
            ],
          ),
        );

  }
   Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(40.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: currentIndex ==0?LinearGradient(
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
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  child: GestureDetector(
                      child: Image.asset('assets/logo/darkblue.png',color: currentIndex ==0? Colors.white:Colors.black,),
                      onTap: (
                          ) {
                        changePage(1);
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
                            setState(() {
                              changePage(0);
                            });
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
                      child: Image.asset('assets/icons/bag.png',color: currentIndex ==0? Colors.white:Colors.black)),
                  onTap: () =>
                  {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => CartPage(widget.user)))
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert,color: currentIndex ==0? Colors.white:Colors.black),
                  onPressed: () {
//
                  },)
              ],
            ),
          )
      );
  }
    Widget get bottomNavigationBar {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('검색')),
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('쿠디 홈')),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('마이 쿠디')),
          ],
          elevation: 0,
          currentIndex: currentIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blueAccent,
          showUnselectedLabels: true,
          onTap:changePage,
        ),
      );
    }
    void changePage(int index) {
      setState(() {
        currentIndex = index;
        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }

}