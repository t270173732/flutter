import 'dart:async';
import 'package:flustars/flustars.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/data/model/even/event_model.dart';
import 'package:zymaterial/data/model/order/order_type_description.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionOrderDetail_page.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class OrderLookMorePage extends StatefulWidget {
  OrderLookMorePage({Key key}) : super(key: key);

  @override
  _OrderLookMorePageState createState() => _OrderLookMorePageState();
}

class _OrderLookMorePageState extends State<OrderLookMorePage>
    with TickerProviderStateMixin {
  _OrderLookMorePageState() {
    //全局事件
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }
  List orderList = new List();

  String searchString = "";
  final TextEditingController _textEditingController = TextEditingController();
  //设置防抖周期为1 秒
  Duration durationTime = Duration(milliseconds: 800);
  Timer timer;

  @override
  Widget build(BuildContext context) {
    String fillChar = DateTime.now().minute < 10 ? "0" : "";

    return Scaffold(
      appBar: GradientAppBar(
        title: searchBackGround(),
        centerTitle: true,
      ),
      body: EasyRefresh(
        child: listViewContent(),
        onRefresh: () async {},
        onLoad: () async {},
        header: ClassicalHeader(
          refreshedText: "刷新完成",
          refreshingText: "正在刷新",
          refreshText: "下拉刷新",
          refreshFailedText: "刷新失败",
          refreshReadyText: "释放刷新",
          infoText:
              "更新于 ${DateTime.now().hour}:$fillChar${DateTime.now().minute}",
          infoColor: Color(0xFF3a72ff),
        ),
        footer: ClassicalFooter(
          loadText: "上拉加载更多",
          loadReadyText: "释放加载",
          loadFailedText: "加载失败",
          loadingText: "正在加载",
          loadedText: "加载完成",
          noMoreText: "没有更多数据",
          infoText:
              "更新于 ${DateTime.now().hour}:$fillChar${DateTime.now().minute}",
          infoColor: Color(0xFF3a72ff),
        ),
     
      ),
    );
  }

  //底部列表视图
  Widget listViewContent() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      physics: BouncingScrollPhysics(),
      itemCount: orderList.length,
      itemBuilder: (BuildContext content, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(content).push(CupertinoPageRoute(
                builder: (context) => DistributionOrderDetailPage(
                    orderId: orderList[index]['ordId'],
                    opCls:
                        OrderType().opCls(orderList[index]['orderDeliverType']),
                    fromPage: 'home')));
          },
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child:
                              Image.asset("images/common/icon_rectangle1.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Image.asset("images/home/icon_order.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "订单号 : ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: orderList[index]["ordId"].toString(),
                              style: TextStyle(
                                  color: Colours.app_text_three_color,
                                  fontSize: 14),
                            )
                          ])),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        orderType(orderList[index]),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                color: Color(0xFFedf2ff),
                                height: 30,
                                width: 70,
                                child: Center(
                                  child: Text(
                                    orderTypeDescription(orderList[index]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF3a72ff), fontSize: 14),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 10, 10, 0),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "订单号 : ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: orderList[index]["ordId"].toString(),
                              style: TextStyle(
                                  color: Colours.app_text_three_color,
                                  fontSize: 14),
                            )
                          ])),
                        )),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Text.rich(TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "客户 : ",
                            style: TextStyle(
                                color: Colours.app_text_one_color,
                                fontSize: 14),
                          ),
                          TextSpan(
                            text: ZYHelper().avoidNullString(
                                orderList[index]["clientName"].toString()),
                            style: TextStyle(
                                color: Colours.app_text_three_color,
                                fontSize: 14),
                          )
                        ])),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 10, 10, 0),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "手术名称: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: ZYHelper().avoidNullString(
                                  orderList[index]["opName"].toString()),
                              style: TextStyle(
                                  color: Colours.app_text_three_color,
                                  fontSize: 14),
                            )
                          ]))),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "手术部位: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: ZYHelper().avoidNullString(
                                  orderList[index]["opSite"].toString()),
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
                          padding: EdgeInsets.fromLTRB(24, 10, 10, 10),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "创建人: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: ZYHelper().avoidNullString(
                                  orderList[index]["username"].toString()),
                              style: TextStyle(
                                  color: Colours.app_text_three_color,
                                  fontSize: 14),
                            )
                          ]))),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "创建时间: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: prefix0.DateUtil.formatDate(
                                  prefix0.DateUtil.getDateTime(ZYHelper()
                                      .avoidNullString(orderList[index]
                                              ["createTime"]
                                          .toString())),
                                  format: "yyyy-MM-dd"),
                              style: TextStyle(
                                  color: Colours.app_text_three_color,
                                  fontSize: 14),
                            )
                          ]))),
                    )
                  ],
                ),
                Container(
                  color: Colours.app_background_color,
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //搜索背景
  Widget searchBackGround() {
    return Container(
      // 修饰搜索框, 白色背景与圆角
      decoration: BoxDecoration(
        color: Color.fromARGB(30, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      alignment: Alignment.center,
      height: 36,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: buildTextField(),
    );
  }

  //搜索栏
  Widget buildTextField() {
    // theme设置局部主题
    return Theme(
      data: ThemeData(primaryColor: Colors.grey),
      child: TextField(
        cursorColor: Colors.grey, // 光标颜色
        onChanged: (String string) {
          setState(() {
            timer?.cancel();
            timer = Timer(durationTime, () async {
              this.searchString = string;
              requestData();
            });
          });
        },
        controller: _textEditingController,
        // 默认设置
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
            border: InputBorder.none,
            icon: Image.asset(
              "images/home/icon_search.png",
              width: 14,
              height: 14,
            ),
            hintText: "输入订单号",
            hintStyle: TextStyle(fontSize: 14, color: Colors.white)),
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  //根据不同订单类型显示不同的描述
  String orderTypeDescription(Map orderMap) {
    int orderDeliverType = orderMap["orderDeliverType"]; //订单类型
    int status = orderMap["status"]; //订单状态

    switch (orderDeliverType) {
      case 1:
        return OrderType().deliveryOrder(status);
        break;
      case 2:
        return OrderType().returnOrder(status);
        break;
      case 3:
        return OrderType().followerOrder(status);
        break;
      case 4:
        return OrderType().salesManOrder(status);
        break;
      default:
        return "";
        break;
    }
  }

  //配送 返仓 类型
  Widget orderType(Map orderMap) {
    int orderDeliverType = orderMap["orderDeliverType"]; //订单类型

    if (orderDeliverType == 1 || orderDeliverType == 2) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: Colors.red[200],
              height: 30,
              width: 50,
              child: Center(
                child: Text(
                  orderDeliverType == 1 ? "配送" : "返仓",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              )),
        ),
      );
    }

    return Container();
  }

  //请求商品数据
  void requestData() {
    Map paramsMap = {"idSearch": this.searchString};
    HttpUtils.put(Api.API_homeOrderIndex_URL, params: paramsMap,
        success: (value) {
      if (value is Map && value.isNotEmpty) {
        orderList = value["rows"];

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
    // 监听订单刷新事件
    ApplicationEvent.event.on<OrderRefreshEvent>().listen((event) {
      Future.delayed(Duration(seconds: 1), () {
        requestData();
      });
    });
  }
}
