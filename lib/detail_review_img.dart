import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DetailReviewImg extends StatelessWidget {

  var imgList;

  DetailReviewImg(this.imgList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              actions: <Widget>[

              ],

            )),
      body: Center(
        child: CarouselSlider.builder(
          height: 500,
          viewportFraction: 1.0,
          itemCount: imgList.length,
          itemBuilder:(BuildContext context, int itemIndex){
            return _buildListCarouseSlider(context,  imgList[itemIndex]);
          },
        ),
      )
    );
  }
  Widget _buildListCarouseSlider(context, doc) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(3.0),
      child:
      Stack(
          fit: StackFit.expand,
        children:[
          Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),),
          FadeInImage.assetNetwork(
              placeholder: 'assets/images/loading.png',
              image: doc),
        ]
      ),
    );
  }
}
