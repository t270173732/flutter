import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';
import 'orderDetailMore_page.dart';

 class OrderDetailPage extends StatefulWidget {
   OrderDetailPage({Key key}) : super(key: key);
 
   _OrderDetailPageState createState() => _OrderDetailPageState();
 }
 
 class _OrderDetailPageState extends State<OrderDetailPage> {
   @override
   Widget build(BuildContext context) {
     
       return  Scaffold(
          appBar: GradientAppBar(title: Text("订单明细"),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text("更多信息",style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp16),),
              onPressed: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context) => OrderDetailMorePage()));
              },
            )
           
          ],
          ),
          body:Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Text(
                      "订单号: 1227217171",
                      style: TextStyle(color: Colours.app_text_one_color),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                    child: Text(
                      "状态",
                      style: TextStyle(color: Colours.app_text_three_color),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(
                      "客户: 李果",
                      style: TextStyle(color: Colours.app_text_one_color),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Text(
                      "到货期限",
                      style: TextStyle(color: Colours.app_text_three_color),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colours.app_line_color,
                height: 10,
              ),
              Flexible(
                child: orderDetail,
              ),
            ],
          ));
  }
}


 Widget orderDetail = ListView.builder(
   physics: BouncingScrollPhysics(),
   
   itemCount: 5,
       itemBuilder: (BuildContext content, int index) {
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,

           children: <Widget>[
             Padding(
               padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
               child: Text("耗材名称",style: TextStyle(color: Colours.app_text_one_color,fontSize: Dimens.font_sp16),),
             ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:  Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text("厂商:某某某",style: TextStyle(color: Colours.app_text_three_color,fontSize: Dimens.font_sp14),)
                  
                ),
                ),
              
               Expanded(
                 flex: 1,
                 child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("产品类型:某某某",style: TextStyle(color: Colours.app_text_three_color,fontSize: Dimens.font_sp14),)
                ),
               )
                
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:  Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text("规格:某某某",style: TextStyle(color: Colours.app_text_three_color,fontSize: Dimens.font_sp14),)
                  
                ),
                ),
              
               Expanded(
                 flex: 1,
                 child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("单位:某某某",style: TextStyle(color: Colours.app_text_three_color,fontSize: Dimens.font_sp14),)
                ),
               )
                
              ],
            ),
             Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:  Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text("下单数量:某某某",style: TextStyle(color: Colours.app_text_three_color,fontSize: Dimens.font_sp14),)
                  
                ),
                ),
              
               Expanded(
                 flex: 1,
                 child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("响应数量:某某某",style: TextStyle(color: Colours.app_text_three_color,fontSize: Dimens.font_sp14),)
                ),
               )
                
              ],
            ),
             Padding(
               padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
               child: Text("备注:某某某",style: TextStyle(color: Colours.app_text_three_color,fontSize: Dimens.font_sp14),),
             ),
             Container(
               color: Colours.app_line_color,
               height: 1,
             )
           ],
         );
       },
 );



/*
 class ListViewcontent extends State <OrderDetailPage> {

    @override
    void initState() { 
      super.initState();
      
    }
   @override
   Widget build(BuildContext context) {
     return ListView.builder(
       itemCount: 5,
       itemBuilder: (BuildContext content, int index) {
         return Column(
           children: <Widget>[
             Padding(
               padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
               child: Text("耗材名称",style: TextStyle(color: Colours.app_text_one_color,fontSize: Dimens.font_sp16),),
             )
           ],
         );
       },
     );
   }

 }*/
