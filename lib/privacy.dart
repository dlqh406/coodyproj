import 'package:coodyproj/home.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  bool finance_downbtn = false;
  bool info_downbtn = false;
  bool info2_downbtn = false;


  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            centerTitle: true,
            titleSpacing: 6.0,
            backgroundColor: Colors.white,
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
            title: Text("쿠디 이용약관"),


          )),
      body:  _buildTermsInfoBody(context),

    );
  }

  Widget _buildTermsInfoBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(
                        color: Colors.black.withOpacity(0.08)
                    )

                )
            ),
            child: SizedBox(
              width: size.width*1,
              child: RaisedButton(
                color: Colors.white,
                elevation: 0,
                onPressed: (){
                  setState(() {
                    widget.info_downbtn = false;
                    widget.info2_downbtn =false ;
                    widget.finance_downbtn = !widget.finance_downbtn ;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('전자금융거래 이용약관', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                    widget.finance_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.finance_downbtn,
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: deliveryTerm.length,
                itemBuilder: (BuildContext context, int index) {
                  String _key = deliveryTerm.keys.elementAt(index);
                  return ListTile(
                    title: Text(_key),
                  );
                },
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.08)
                  )
              )
          ),
          child: SizedBox(
            width: size.width*1,
            child: RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: (){
                setState(() {
                  widget.info_downbtn = !widget.info_downbtn ;

                  widget.finance_downbtn = false;
                  widget.info2_downbtn =false ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('개인정보 수집 및 동의', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                  widget.info_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.info_downbtn,
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: changeTerm.length,
                itemBuilder: (BuildContext context, int index) {
                  String _key = changeTerm.keys.elementAt(index);
                  return ListTile(
                    title: Text(_key),
                  );
                },
              ),
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(

              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.black.withOpacity(0.08)
                  )
              )
          ),
          child: SizedBox(
            width: size.width*1,
            child: RaisedButton(
              elevation: 0,
              color: Colors.white,
              onPressed: (){
                setState(() {
                  widget.info_downbtn = false ;
                  widget.finance_downbtn = false;
                  widget.info2_downbtn = !widget.info2_downbtn ;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('개인정보 제공 및 위탁 동의', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                  widget.info2_downbtn?Icon(Icons.keyboard_arrow_up):Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.info2_downbtn,
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: refundTerm.length,
                itemBuilder: (BuildContext context, int index) {
                  String _key = refundTerm.keys.elementAt(index);
                  return ListTile(
                    title: Text(_key),
                  );
                },
              ),
            ),
          ),
        ),
        


      ],
    );
  }
  Map<String, bool> deliveryTerm = {
    "industry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been try. Lorem Ipsum has been thndustry. Lorem Ipsum hasry. Lorem Ipsum has been thndustry. Lorem Ipsum hasry. Lorem Ipsum has been thndustry. Lorem Ipsum hasry. Lorem Ipsum has been thndustry. Lorem Ipsum hashndustry. Lndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsundustry. Lorem Ipsum has been then thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. en thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. LoremLoremen thndustry. Lorem Ipsum has been thndustry. Loremen thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been thndustry. Lorem Ipsum has been the industry's standard dumma the industry's standard dumma the industry's standard dumma the industry's standard dumma the industry's standard dumma the industry's standard dumma the industry's standard dumma PageMaker including versions of Lorem Ipsumustry. L Lorem Ipsum."
        : false,

  };
  Map<String, bool> changeTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };
  Map<String, bool> refundTerm = {
    '1. 쿠디의 전 제품은 100% 무료배송입니다.': false,
    '2. 구매한 상품은 입점 업체(쇼핑몰 업체)에서 배송합니다': false,
    '3. 결제 확인후 1~3일 정도 소요됩니다.(주문 폭주시 배송이 지연될 수 있습니다)': false,
  };

}
