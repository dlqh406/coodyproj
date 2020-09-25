import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:coodyproj/bloc/state_bloc.dart';
import 'package:coodyproj/bloc/state_provider.dart';
import 'model/car.dart';

var currentCar = carList.cars[0];

class FavoriteAnalysisPage extends StatefulWidget {
  var stopTrigger = 1;
  var unchanging ;
  List<bool>bool_list_each_GridSell =[];
  List<String> styleList = [];
  var tf_copy = [];
  final FirebaseUser user;
  FavoriteAnalysisPage(this.user);

  @override
  _FavoriteAnalysisPageState createState() => _FavoriteAnalysisPageState();
}

class _FavoriteAnalysisPageState extends State<FavoriteAnalysisPage> {

@override
  void initState() {
    super.initState();
    if(widget.stopTrigger == 1){
      setState(() {
       widget.unchanging = Firestore.instance.collection("uploaded_product").snapshots();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      backgroundColor: Colors.blue,
      body:  LayoutStarts(),
    );
  }

  Widget _StreamBuilder() {
    return StreamBuilder <QuerySnapshot>(
      stream: _commentStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(child:  CircularProgressIndicator());
        }
        var items =  snapshot.data?.documents ??[];
        var fF = items.where((doc)=> doc['style'] == "오피스룩").toList();
        var sF = items.where((doc)=> doc['style'] == "로맨틱").toList();
        var tF = items.where((doc)=> doc['style'] == "캐주얼").toList();
        fF.addAll(sF);
        fF.addAll(tF);
        widget.tf_copy.addAll(fF);
        if(widget.stopTrigger == 2 ){
          fF.shuffle();
          widget.unchanging = fF;
        }
        return Container(
          margin: EdgeInsets.all(16),
          child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              itemCount: fF.length,
              staggeredTileBuilder: (index) => StaggeredTile.count(1,index.isEven?1.2 : 1.8),
              itemBuilder: (context,index) {
                for(var i=0; i<fF.length; i++){
                  widget.bool_list_each_GridSell.add(false);
                }
                return _buildListItem(context,widget.unchanging[index],index);
              }
              ),
        );


      },
    );
  }
  Widget _buildListItem(context,document,index) {

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            image: DecorationImage(
              image : NetworkImage(document['thumbnail_img']),
              fit : BoxFit.cover,
            )
        ),
        child: widget.bool_list_each_GridSell[index]?Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.black54,
          ),   alignment: Alignment.center,

            child:Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(60))
                ),
                child:Icon(Icons.check,color: Colors.white,size: 30,)
            )
        ):Container(),
      ),
      onTap: (){
        setState(() {
          var count = 0;
          var daily =0;
          var casual =0;
          var feminine =0;
          widget.bool_list_each_GridSell[index] = !widget.bool_list_each_GridSell[index];

          for(var i=0; i<widget.bool_list_each_GridSell.length; i++){
            if(widget.bool_list_each_GridSell[i] == true){
              count +=1;

              if(count == 10) {
                for(var i=0; i< widget.bool_list_each_GridSell.length; i++){
                  if(widget.bool_list_each_GridSell[i] == true){
                      widget.styleList.add(widget.tf_copy[i]["style"]);
                  }
                }
              }
            }
          }
          if(widget.styleList.length == 10){
             for(var i =0; i< widget.styleList.length; i++){
                if(widget.styleList[i] == "오피스룩"){
                  feminine +=1;
                }else if(widget.styleList[i] == "로맨틱"){
                  casual +=1;
                }
                else{
                  daily += 1;
                }
             }
            print("페미닌: ${feminine}, 데일리: ${daily}, 캐주얼: ${casual},");
            var styleCodeTep = [feminine,casual,daily];
//            var final_styleCode = [];
            var final_styleCode;
            styleCodeTep.sort();
            print(styleCodeTep);

            if(styleCodeTep[2] == feminine ){
              if(styleCodeTep[1] == daily){
                final_styleCode="FDC";
              }else{
                final_styleCode="FCD";
              }

            }else if(styleCodeTep[2] == daily ){
               if(styleCodeTep[1] == feminine){
                 final_styleCode="DFC";
               }else{
                 final_styleCode="DCF";
               }
             }else if(styleCodeTep[2] == casual){
              if(styleCodeTep[1] == feminine){
                final_styleCode="CFD";
              }else{
                final_styleCode="CDF";
              }
            }
             print(final_styleCode);
            _showMyDialog();
            final _updateData = {
              'userStyleCode': final_styleCode,
            };

            Firestore.instance
                .collection('user_data')
                .document(widget.user.email)
                .setData(_updateData);

          };
          print("count: ${count}");
          print("styleCode: ${widget.styleList}");
        });
      },
    );
  }

  Stream<QuerySnapshot> _commentStream() {
    widget.stopTrigger +=1;
    if(widget.stopTrigger == 2 ){
      return widget.unchanging;
    }

  }

Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text("🎊 스타일 데이터 저장완료 🎊"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('${widget.user.displayName}님 반가워요💙'),
              Text('쿠디에 오신걸 환영해요'),

            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
}
class LayoutStarts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarDetailsAnimation(),
        CustomBottomSheet(),
        RentButton(),
      ],
    );
  }
}


class RentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
    );
  }
}

class CarDetailsAnimation extends StatefulWidget {
  @override
  _CarDetailsAnimationState createState() => _CarDetailsAnimationState();
}

class _CarDetailsAnimationState extends State<CarDetailsAnimation>
    with TickerProviderStateMixin {
  AnimationController fadeController;
  AnimationController scaleController;

  Animation fadeAnimation;
  Animation scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fadeController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);

    scaleController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
    scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  forward() {
    scaleController.forward();
    fadeController.forward();
  }

  reverse() {
    scaleController.reverse();
    fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: StateProvider().isAnimating,
        stream: stateBloc.animationStatus,
        builder: (context, snapshot) {
          snapshot.data ? forward() : reverse();

          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: CarDetails(),
            ),
          );
        });
  }
}

class CarDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30),
              child: _carTitle(),
            ),
          ],
        ));
  }

  _carTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 38),
              children: [
                TextSpan(text: "고객님 취향에 맞는",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700)),
                TextSpan(text: "\n"),
                TextSpan(
                    text: "스타일을 탭해주세요!!",
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700)),
              ]),
        ),
        SizedBox(height: 10),
        // 이미지 파일
        Container(child: Image.asset('assets/favorite_Analysis_page/illustration_FApage.png',width: 300),
            // 가운데 일러스트 위치 조절
            padding: EdgeInsets.only(top:20 ,left: 2, right: 25, bottom: 1))
      ],
    );
  }
}

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  double sheetTop = 500;
  double minSheetTop = 30;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: sheetTop, end: minSheetTop)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      });
  }

  forwardAnimation() {
    controller.forward();
    stateBloc.toggleAnimation();
  }

  reverseAnimation() {
    controller.reverse();
    stateBloc.toggleAnimation();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
          controller.isCompleted ? reverseAnimation() : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          //upward drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
            controller.forward();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            //downward drag
            reverseAnimation();
          } else {
            return;
          }
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 110;
    return Container(
      padding: EdgeInsets.only(top: 5),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Colors.white),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                offerDetails(sheetItemHeight),
                SizedBox(height: 220),
              ],
            ),
          )
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xffd9dbdb)),
    );
  }

// streambuilder가 들어갈곳
  offerDetails(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 20,right:20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Offer Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            height: sheetItemHeight,
            // 여기에 스트림 빌더
            child: Text("Text")
          )
        ],
      ),
    );
  }
}

