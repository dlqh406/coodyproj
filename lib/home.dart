import 'package:coodyproj/cart.dart';
import 'package:coodyproj/my_page.dart';
import 'package:coodyproj/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'home_page.dart';
import 'dart:io' show Platform;


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
        initialPage: 1 , keepPage: true,
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

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(

            appBar: appBarBuild(),
            body: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  children: pageList,
                  physics: NeverScrollableScrollPhysics()
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: bottomNavigationBar,
                ),
              ],
            ),
          ),
    );


  }

  Future<bool> _onBackPressed() {
      if( currentIndex !=1){
        changePage(1);
      }
      else{
        return  showDialog(
            context: context,
            builder: (_) => NetworkGiffyDialog(
              image: Container(
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.7),
                ),
                child: Image.asset(
                  "assets/icons/giphy.gif",
                ),
              ),
              entryAnimation: EntryAnimation.TOP_LEFT,
              title: Text(
                '쿠디를 종료할까요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.w700),
              ),
              description: Text(
                '다음에 또 만나요!',
                textAlign: TextAlign.center,
              ),
              buttonOkColor: Colors.blue,
              buttonCancelColor: Colors.redAccent,
              onOkButtonPressed: (){
                Navigator.pop(context);
              },
              onCancelButtonPressed: (){
                SystemNavigator.pop();
              },
              buttonOkText:Text("조금 더 둘러 볼께요!",style: TextStyle(color: Colors.white),) ,
              buttonCancelText: Text("앱 종료 (단호)",style: TextStyle(color: Colors.white),),


            ));
        }
      }



   Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(45.0),
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
                      child: SizedBox(
                          child: Image.asset('assets/logo/P21.png')),
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
                        padding: Platform.isAndroid? const EdgeInsets.only(left:5,right: 0):const EdgeInsets.only(left:5,right: 15),
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
                Padding(
                  padding: const EdgeInsets.only(right:25.0),
                  child: InkWell(
                    child: new Container(
                        child: Icon(Icons.shopping_cart,color: currentIndex ==0? Colors.white:Colors.black,size: 26,)
                        //Image.asset('assets/icons/bag.png',color: currentIndex ==0? Colors.white:Colors.black)
                    ),
                    onTap: () =>
                    {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(widget.user)))
                    },
                  ),
                ),
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
        print(currentIndex);
        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }

}