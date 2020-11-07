import 'package:coodyproj/cart.dart';
import 'package:coodyproj/resent_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coodyproj/my_page.dart';



class DrawerScreen extends StatefulWidget {
  final FirebaseUser user;


  DrawerScreen(this.user);
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:  LinearGradient(
            colors: [
              Colors.lightBlue,
              Color(0xff0859c6)
            ],
        ),
      ),
      padding: EdgeInsets.only(top:20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50,right: 20),
            child: Row(
              children: [
                Spacer(),
                SizedBox(
                  width: 45,
                  height: 45,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.photoUrl),
                  ),
                ),
                SizedBox(width: 20,),
                Text('${widget.user.displayName}님 반가워요!',
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,fontSize: 25),),
                Padding(
                  padding: const EdgeInsets.only(right:18.0),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 150.0,right: 40),
              child: Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                        return MyPage(widget.user);
                      }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.shopping_cart,color: Colors.white,size: 30,),
                          SizedBox(width: 7),
                          Text('주문&배송',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                    ),
                    SizedBox(height: 45),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CartPage(widget.user);
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              width: 25,
                              child: Image.asset('assets/icons/bag.png',color: Colors.white,)),
                          SizedBox(width: 7),
                          Text('장바구니',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                    ),
                    SizedBox(height: 45),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return MyPage(widget.user);
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.chat,color: Colors.white,size: 30,),
                          SizedBox(width: 7),
                          Text('나의 1:1문의',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                    ),
                    SizedBox(height: 45),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return RecentPage(widget.user);
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.remove_red_eye,color: Colors.white,size: 30,),
                          SizedBox(width: 7),
                          Text('최근 본 상품',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                    ),
                    SizedBox(height: 45),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return RecentPage(widget.user);
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.person,color: Colors.white,size: 30,),
                          SizedBox(width: 7),
                          Text('나의 계정',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
//
//          Column(
//            children: drawerItems.map((element) =>
//                Padding(
//              padding: const EdgeInsets.only(top: 40.0,right: 40),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: [
//                  Icon(element['icon'],color: Colors.white,size: 30,),
//                  SizedBox(width: 10,),
//                  GestureDetector(
//                    onTap: (){
//                      Navigator.push(context, MaterialPageRoute(builder: (context){
//                        return element['push'](widget.user);
//                      }));
//                    },
//                    child: Text(element['title'],style:
//                    TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
//                  )
//                ],
//
//              ),
//            )).toList(),
//          ),

//          SizedBox(
//            height: 100,
//          )
        ],
      ),

    );
  }
}