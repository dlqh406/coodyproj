import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // TODO: implement initState
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
      appBar: AppBar(title: Text("favorite Analysis Page")),
      body:  _bodyBuilder(),
    );
  }

  Widget _bodyBuilder() {
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



        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0),
            itemCount: fF.length,
            itemBuilder: (BuildContext context, int index) {
              for(var i=0; i<fF.length; i++){
                widget.bool_list_each_GridSell.add(false);
              }
              return _buildListItem(context,fF[index],index);
            });
      },
    );
  }
  Widget _buildListItem(context,document,index) {

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image : NetworkImage(document['thumbnail_img']),
              fit : BoxFit.cover,
            )
        ),
        child: widget.bool_list_each_GridSell[index]?Container(
            alignment: Alignment.center,
            color: Colors.black54,
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

            final _updateData = {
              'userStyleCode': final_styleCode,
            };

            Firestore.instance
                .collection('user_data')
                .document(widget.user.email)
                .setData(_updateData);

          }
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
}


