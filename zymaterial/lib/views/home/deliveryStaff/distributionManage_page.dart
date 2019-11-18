import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/common/totast.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:flustars/flustars.dart';
import 'package:zymaterial/data/model/even/event_model.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionOperationDetail_page.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionOrderDetail_page.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';

class DistributionMangePage extends StatefulWidget {
  DistributionMangePage({Key key}) : super(key: key);

  _DistributionMangePageState createState() => _DistributionMangePageState();
}

class _DistributionMangePageState extends State<DistributionMangePage> {
  _DistributionMangePageState() {
    //全局事件
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }
  //配送数据
  List distributionList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("配送管理"),
        centerTitle: true,
      ),
      body: distributionTaskManageContent(),
    );
  }

//配送布局
  Widget distributionTaskManageContent() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: distributionList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              text: distributionList[index]["ordId"].toString(),
                              style: TextStyle(
                                  color: Colours.app_text_three_color,
                                  fontSize: 14),
                            )
                          ])),
                        )
                      ],
                    ),
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
                              text: "创建人: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: ZYHelper().avoidNullString(
                                  distributionList[index]["deliverUser"]
                                      .toString()),
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
                              text: "配送类型: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: orderType(
                                  distributionList[index]["orderDeliverType"]),
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
                          padding: EdgeInsets.fromLTRB(24, 10, 10, 0),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "客户: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: ZYHelper().avoidNullString(
                                  distributionList[index]["clientName"]
                                      .toString()),
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
                              text: "是否加急: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: needExpedited(int.parse(
                                  distributionList[index]["isUrgent"]
                                      .toString())),
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
                                  distributionList[index]["opName"].toString()),
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
                                  distributionList[index]["opSite"].toString()),
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
                          padding: EdgeInsets.fromLTRB(24, 10, 0, 0),
                          child: Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "到货时间: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: DateUtil.formatDate(
                                  DateUtil.getDateTime(ZYHelper()
                                      .avoidNullString(distributionList[index]
                                              ["expectTime"]
                                          .toString())),
                                  format: "yyyy-MM-dd"),
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
                              text: "创建时间: ",
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: DateUtil.formatDate(
                                  DateUtil.getDateTime(ZYHelper()
                                      .avoidNullString(distributionList[index]
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 0, 10),
                  child: Text(
                    distributionMessage(distributionList[index]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colours.app_text_three_color,
                        fontSize: Dimens.font_sp14),
                  ),
                ),
                orderStatusView(context, index),
                Container(
                  color: Colours.app_background_color,
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  //送达视图
  Widget serviceView(BuildContext context, int index) {
    //配送类型
    int orderDeliverType = distributionList[index]["orderDeliverType"];
    int orderId = distributionList[index]["ordId"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                  color: Color(0xFFedf2ff),
                  height: 34,
                  width: 76,
                  child: Center(
                    child: Text(
                      "查看明细",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF3a72ff), fontSize: 14),
                    ),
                  )),
            ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => DistributionOrderDetailPage(
                        orderId: distributionList[index]["ordId"],
                        orderDeliverType: orderDeliverType,
                        upPage: "",
                      )));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                  color: Color(0xFF4b82fb),
                  height: 34,
                  width: 76,
                  child: Center(
                    child: Text(
                      "确认送达",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
            onTap: () async {
              if (orderDeliverType == 1) {
                var result =
                    await Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => DistributionOperationDeatailPage(
                              orderId: orderId,
                              orderDeliverType: orderDeliverType,
                              orderData: distributionList[index],
                            )));
                if (result == "success") {
                  requestData();
                }
              } else {
                showReceiptAlertDialog(
                    context, distributionList[index], "您确认送达吗?");
              }
            },
          ),
        ),
      ],
    );
  }

  //收货视图
  Widget receiptView(BuildContext context, int index) {
    //配送类型
    int orderDeliverType = distributionList[index]["orderDeliverType"];
    int orderId = distributionList[index]["ordId"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                  color: Color(0xFFedf2ff),
                  height: 34,
                  width: 76,
                  child: Center(
                    child: Text(
                      "查看明细",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF3a72ff), fontSize: 14),
                    ),
                  )),
            ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => DistributionOrderDetailPage(
                        orderId: distributionList[index]["ordId"],
                        orderDeliverType: orderDeliverType,
                        upPage: "",
                      )));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                  color: Color(0xFF4b82fb),
                  height: 34,
                  width: 76,
                  child: Center(
                    child: Text(
                      "确认收货",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
            onTap: () async {
              if (orderDeliverType == 1) {
                showReceiptAlertDialog(
                    context, distributionList[index], "您确认收货吗?");
              } else {
                var result =
                    await Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => DistributionOperationDeatailPage(
                              orderId: orderId,
                              orderDeliverType: orderDeliverType,
                              orderData: distributionList[index],
                            )));
                if (result == "success") {
                  requestData();
                }
              }
            },
          ),
        ),
      ],
    );
  }

//收货弹框
  void showReceiptAlertDialog(BuildContext context, Map dataMap, String text) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(content: Text(text), actions: <Widget>[
              FlatButton(
                child: Text("取消", style: TextStyle(color: Colours.text_gray)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  int orderDeliverType = dataMap["orderDeliverType"];
                  if (orderDeliverType == 1) {
                    deliveryOrder(dataMap);
                  } else {
                    returnOrder(dataMap);
                  }

                  Navigator.of(context).pop();
                },
              )
            ]));
  }

  //状态不同显示不同的视图
  Widget orderStatusView(BuildContext context, int index) {
    int status = distributionList[index]["status"];
    switch (status) {
      case 2:
        {
          return receiptView(context, index);
        }
        break;
      case 3:
        {
          return serviceView(context, index);
        }
        break;

      default:
    }
    return SizedBox();
  }

  //是否加急
  String needExpedited(int expedited) {
    if (expedited == 1) {
      return "是";
    }
    return "否";
  }

  //订单类型
  String orderType(int type) {
    if (type == 1) {
      return "配送订单";
    }

    return "返仓订单";
  }

  //
  String distributionMessage(Map dataMap) {
    String message = "";
    String address = ZYHelper().avoidNullString(dataMap["address"]);
    if (dataMap["orderDeliverType"] == 1) {
      message = "由仓库配送至$address的订单";
    } else {
      message = "由$address返仓的订单";
    }
    return message;
  }

  //提示信息
  void toastMsg(String msg) {
    HelperToast().showCenterToast(msg);
  }

  //返仓订单操作
  void returnOrder(
    Map dataMap,
  ) {
    Map paramsMap = {"ordId": dataMap["ordId"], "details": dataMap};
    HttpUtils.post(Api.API_returnConfirmArrive_URL, params: paramsMap,
        success: (value) {
      requestData();
      toastMsg("送达成功");
    }, failure: (error) {
      HelperToast().showCenterToast(error);
    });
  }

  //配送订单操作
  void deliveryOrder(Map dataMap) {
    Map paramsMap = {
      "ordId": dataMap["ordId"],
      "details": dataMap,
    };
    HttpUtils.post(Api.API_deliverConfirmMtl_URL, params: paramsMap,
        success: (value) {
      requestData();
      toastMsg("收货成功");
      print(value);
    }, failure: (error) {
      HelperToast().showCenterToast(error.toString());
    });
  }

  //请求商品数据
  void requestData() {
    Map paramsMap = {"deliverUser": SpUtil.getString("account")};

    HttpUtils.put(Api.API_distributionMange_URL, params: paramsMap,
        success: (value) {
      if (value is Map && value.isNotEmpty) {
        List dataList = value["rows"];
        distributionList = new List();
        //这边只显示已分配和已经接受的订单
        for (var item in dataList) {
          int status = item["status"];
          if (status == 2 || status == 3) {
            distributionList.add(item);
          }
        }

        if (mounted) {
          setState(() {});
        }
      }
    }, showProgress: true, context: context);
  }

  @override
  void initState() {
    super.initState();

    //监听订单刷新事件
    ApplicationEvent.event.on<OrderRefreshEvent>().listen((event) {
      Future.delayed(Duration(seconds: 1), () {
        requestData();
      });
    });

    Future.delayed(Duration(milliseconds: 100), () {
      requestData();
    });
  }
}
