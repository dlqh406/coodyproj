import 'package:coodyproj/screens/certification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('본인 인증',style: TextStyle(fontSize: 35),),
              SizedBox(width: 10,),
              Text('1/3',style: TextStyle(fontSize: 20,color: Colors.grey),),
            ],
          ),
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
          Text('생년월일 (8자리)'),
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
                  hintText: "예) 19941031",
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
                        if(myControllerName.text=="" || myControllerPhone.text ==""|| myControllerBirth.text ==""){


                          scaffoldKey.currentState
                              .showSnackBar(SnackBar(duration: const Duration(seconds: 1),content:
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle,color: Colors.blueAccent,),
                                SizedBox(width: 14,),
                                Text("모든 정보를 입력해주세요.",
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                              ],
                            ),
                          )));
                        }
                        else{
                          if(myControllerBirth.text.length == 8 ){
                            var date = new DateTime.now().toString();
                            var dateParse = DateTime.parse(date);
                            var formattedDate = dateParse.year.toString();
                            var userBirth =  myControllerBirth.text;
                            var currentY = formattedDate;
                            var equalY = int.parse(currentY) - int.parse(userBirth[0]+userBirth[1]+userBirth[2]+userBirth[3]);
                            var currentM = dateParse.month.toString();
                            var currentD = dateParse.day.toString();
                            var userMM= userBirth[4]+userBirth[5];
                            var userDD= userBirth[6]+userBirth[7];
                            if(int.parse(currentM)-int.parse(userMM) >0 == false){
                              if(int.parse(currentD)-int.parse(userDD) >0  == false){
                                equalY=equalY-1;
                              }}
                            print(equalY);

                            if( equalY >= 14){
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
                            }
                            else{
                              alert();
                            }

                          }else{
                            scaffoldKey.currentState
                                .showSnackBar(SnackBar(duration: const Duration(seconds: 3),content:
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,color: Colors.blueAccent,size: 40,),
                                  SizedBox(width: 14,),
                                  Text("생년 월일을 8자리로 입력해주세요 \n예시)19941031",
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:17),),
                                ],
                              ),
                            )));
                          }
                          }





                      }))
          ),
        ],
      ),
    );
 }
  Future<bool> alert() {

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
              '만 14세 미만 고객님입니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.0, fontWeight: FontWeight.w700),
            ),
            description: Text(
              '만 14세 미만 아동의 개인정보를 처리하기 \n 위해서는 법정대리인의 동의서가 필요합니다.\n 자세한 사항은 고객센터 문의 바랍니다.',
              textAlign: TextAlign.center,
            ),
            buttonOkColor: Colors.blue,
            onOkButtonPressed: (){
              Navigator.pop(context);
            },
            onlyOkButton: true,
            buttonOkText:Text("네 알겠습니다",style: TextStyle(color: Colors.white),) ,


          ));
    }
  }

