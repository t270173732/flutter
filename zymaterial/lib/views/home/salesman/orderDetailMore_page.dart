import 'package:flukit/flukit.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';

class OrderDetailMorePage extends StatefulWidget {
  OrderDetailMorePage({Key key, this.orderMap}) : super(key: key);
  final Map orderMap;

  _OrderDetailMorePageState createState() => _OrderDetailMorePageState();
}

class _OrderDetailMorePageState extends State<OrderDetailMorePage> {
  List orderHistoryList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text("更多信息"),
          centerTitle: true,
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            bannerView(),
            Container(
              color: Colours.app_background_color,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                "手术信息",
                style: TextStyle(
                    color: Colours.app_text_three_color,
                    fontSize: Dimens.font_sp16),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "患者姓名: ",
                                style: TextStyle(
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
                              ),
                              TextSpan(
                                text: ZYHelper().avoidNullString(
                                    widget.orderMap["patient"].toString()),
                                style: TextStyle(
                                    color: Colours.app_text_three_color,
                                    fontSize: 14),
                              )
                            ]))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "患者性别: ",
                                style: TextStyle(
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
                              ),
                              TextSpan(
                                text: sex(widget.orderMap["gender"]),
                                style: TextStyle(
                                    color: Colours.app_text_three_color,
                                    fontSize: 14),
                              )
                            ]))),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "手术名称: ",
                                style: TextStyle(
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
                              ),
                              TextSpan(
                                text: ZYHelper().avoidNullString(
                                    widget.orderMap["opName"].toString()),
                                style: TextStyle(
                                    color: Colours.app_text_three_color,
                                    fontSize: 14),
                              )
                            ]))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "手术部位: ",
                                style: TextStyle(
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
                              ),
                              TextSpan(
                                text: ZYHelper().avoidNullString(
                                    widget.orderMap["opSite"].toString()),
                                style: TextStyle(
                                    color: Colours.app_text_three_color,
                                    fontSize: 14),
                              )
                            ]))),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "手术时间: ",
                          style: TextStyle(
                              color: Colours.app_text_one_color, fontSize: 14),
                        ),
                        TextSpan(
                          text: DateUtil.formatDate(
                              DateUtil.getDateTime(ZYHelper().avoidNullString(
                                  widget.orderMap["opTime"].toString())),
                              format: "yyyy-MM-dd"),
                          style: TextStyle(
                              color: Colours.app_text_three_color,
                              fontSize: 14),
                        )
                      ]))),
                ],
              ),
            ),
            Container(
              color: Colours.app_background_color,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                "地址信息",
                style: TextStyle(
                    color: Colours.app_text_three_color,
                    fontSize: Dimens.font_sp16),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text.rich(TextSpan(children: <TextSpan>[
                TextSpan(
                  text: "地址: ",
                  style: TextStyle(
                      color: Colours.app_text_one_color, fontSize: 14),
                ),
                TextSpan(
                  text: ZYHelper()
                      .avoidNullString(widget.orderMap["address"].toString()),
                  style: TextStyle(
                      color: Colours.app_text_three_color, fontSize: 14),
                )
              ])),
            ),
            Container(
              color: Colours.app_background_color,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                "订单进度",
                style: TextStyle(
                    color: Colours.app_text_three_color,
                    fontSize: Dimens.font_sp16),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: orderHistoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: ClipOval(
                                child: Container(
                                  color: Colors.grey,
                                  width: 16,
                                  height: 16,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
                            child: lineView(index),
                          ),
                        ],
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text(
                          description(ZYHelper().avoidNullString(
                              orderHistoryList[index]["description"]
                                  .toString())),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colours.app_text_three_color,
                              fontSize: 12),
                        ),
                      )),
                    ],
                  );
                })
          ],
        ));
  }

  //线
  Widget lineView(int index) {
    if (index + 1 != orderHistoryList.length) {
      return Container(
        color: Colors.grey,
        width: 2,
        height: 50,
      );
    }
    return SizedBox();
  }

  //轮播
  Widget bannerView() {
    //consumeFiles  deliverFiles
    List imageList;
    if (widget.orderMap["fromPage"] == 'consume') {
      imageList = widget.orderMap["consumeFiles"];
    } else if (widget.orderMap["fromPage"] == 'home') {
      if (widget.orderMap["opCls"] == 0) {
        imageList = widget.orderMap["orderFile"];
      } else if (widget.orderMap["opCls"] == 1) {
        imageList = widget.orderMap["fileDetails"];
      } else if (widget.orderMap["opCls"] == 2) {
        imageList = widget.orderMap["deliverFiles"];
      } else if (widget.orderMap["opCls"] == 3) {
        imageList = widget.orderMap["consumeFiles"];
      } else if (widget.orderMap["opCls"] == 4) {
        imageList = widget.orderMap["returnFiles"];
      }
    } else {
      imageList = widget.orderMap["deliverFiles"];
    }
    if (imageList.isNotEmpty) {
      return AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: Swiper.builder(
            childCount: imageList.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                Api.BASE_IMAGE_URL + imageList[index]["filename"],
                fit: BoxFit.cover,
              );
            },
            indicator: CircleSwiperIndicator(),
          ));
    }

    return SizedBox();
  }

  //描述详情
  String description(String string) {
    String descriptionString = string.replaceAll("<br>", "\n");
    return descriptionString;
  }

  //性别
  String sex(int type) {
    if (type == 1) {
      return "男";
    }
    return "女";
  }

  //请求商品数据
  void requestData() {
    Map paramsMap = {"ordId": widget.orderMap["ordId"]};

    HttpUtils.put(Api.API_orderHistory_URL, params: paramsMap,
        success: (value) {
      if (value is Map && value.isNotEmpty) {
        orderHistoryList = value["rows"];
        print(value);

        if (mounted) {
          setState(() {});
        }
      }
    }, showProgress: true, context: context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      requestData();
    });
  }
}
