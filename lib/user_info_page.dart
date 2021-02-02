import 'package:coodyproj/screens/certification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class UserInfoPage extends StatefulWidget {
  int paymentValue = 1;
  var checkJob=false;
  final FirebaseUser user;
  var userData;
  UserInfoPage(this.user,this.userData);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final myControllerName = TextEditingController();
  final myControllerBirth = TextEditingController();
  final myControllerPhone = TextEditingController();
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

          )),
      body: _buildBody(),
    );
  }
  Widget _buildBody() {
    print(widget.userData);
    return Padding(
      padding: const EdgeInsets.only(left:30.0,top: 10,right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('고객님',style: TextStyle(fontSize: 35),),
              Text(' 정보',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
              SizedBox(width: 10,),
              Text('2/3',style: TextStyle(fontSize: 20,color: Colors.grey),),
            ],
          ),
          SizedBox(
            height: 13,
          ),
          Text('추천알고리즘의 필요한 고객님의 정보를 알려주세요'),
          SizedBox(
            height: 20,
          ),
          Text('체격'),

          Row(
            children: [
              Theme(
                data: new ThemeData(
                    primaryColor: Colors.blueAccent,
                    accentColor: Colors.orange,
                    hintColor: Colors.black
                ),
                child: SizedBox(
                  width: 130,
                  child: new TextField(
                    controller: myControllerName,
                    decoration: new InputDecoration(
                        hintText: "키",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.blueAccent
                            )
                        )
                    ),
                  ),
                ),
              ),
              Text("cm"),
              Spacer(),
              Theme(
                data: new ThemeData(
                    primaryColor: Colors.blueAccent,
                    accentColor: Colors.orange,
                    hintColor: Colors.black
                ),
                child: SizedBox(
                  width: 130,
                  child: new TextField(
                    controller: myControllerName,
                    decoration: new InputDecoration(
                        hintText: "체중",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.blueAccent
                            )
                        )
                    ),
                  ),
                ),
              ),
              Text("kg"),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: SizedBox(
                  height: 46,
                  width: MediaQuery.of(context).size.width*1,
                  child: RaisedButton(
                      child: const Text('휴대폰 인증',
                          style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold)),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),),
                      color: Colors.blueAccent,
                      onPressed: () {
                        var carrier;
                        if(widget.paymentValue ==1){
                          carrier = "SKT";
                        }
                        else if(widget.paymentValue ==2){
                          carrier = "KTF";
                        }
                        else if( widget.paymentValue ==3){
                          carrier = "LGT";
                        }
                        else{
                          carrier = "MVNO";
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                Certification(widget.user,carrier,myControllerName.text,myControllerPhone.text,myControllerBirth.text,)));

                      }))
          ),
        ],
      ),
    );
  }
}