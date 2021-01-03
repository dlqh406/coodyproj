import 'package:coodyproj/screens/certification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PhoneCertificationPage extends StatefulWidget {
  int paymentValue = 1;
  final FirebaseUser user;
  PhoneCertificationPage(this.user);

  @override
  _PhoneCertificationPageState createState() => _PhoneCertificationPageState();
}

class _PhoneCertificationPageState extends State<PhoneCertificationPage> {
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
    return Padding(
      padding: const EdgeInsets.only(left:30.0,top: 10,right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('본인 인증',style: TextStyle(fontSize: 35),),
          SizedBox(
            height: 20,
          ),
          Text('성함'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              controller: myControllerName,
              decoration: new InputDecoration(
                  hintText: "고객님의 성함을 입력해주세요",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.blueAccent
                      )
                  )
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text('생년월일 (6자리)'),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: new TextField(
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: myControllerBirth,
              decoration: new InputDecoration(
                  hintText: "예) 941031",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.blueAccent
                      )
                  )
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text('휴대폰 번호'),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child: Container(
                  child: DropdownButton(
                      value: widget.paymentValue,
                      items: [
                        DropdownMenuItem(
                          child: Text("SKT",style: TextStyle(fontWeight: FontWeight.bold),),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("KT",style: TextStyle(fontWeight: FontWeight.bold),),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("LGU+",style: TextStyle(fontWeight: FontWeight.bold),),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Text("알뜰폰",style: TextStyle(fontWeight: FontWeight.bold),),
                          value: 4,
                        ),

                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.paymentValue = value;
                        });
                      }
                  ),
                ),
              ),

            ],
          ),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.blueAccent,
                accentColor: Colors.orange,
                hintColor: Colors.black
            ),
            child: TextField(
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: myControllerPhone,
              decoration: new InputDecoration(
                  hintText: "- 없이 번호만 입력해주세요",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                          color: Colors.blueAccent
                      )
                  )
              ),
            ),
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