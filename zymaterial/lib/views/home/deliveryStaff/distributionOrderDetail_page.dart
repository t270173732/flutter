import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zymaterial/common/totast.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/data/model/even/event_model.dart';
import 'package:zymaterial/data/model/order/order_type_description.dart';
import 'package:zymaterial/event/event_bus.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/views/home/consume/consumeDetail.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionOperationDetail_page.dart';
import 'package:zymaterial/views/home/salesman/orderDetailMore_page.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';

class DistributionOrderDetailPage extends StatefulWidget {
  DistributionOrderDetailPage(
      {Key key,
      @required this.orderId,
      this.orderDeliverType,
      this.fromPage,
      this.opCls,
      this.upPage})
      : super(key: key);
  final int orderId;
  final int orderDeliverType; //订单类型
  final String fromPage;
  final int opCls;
  final String upPage; //这里主要区分 任务配送管理 和配送管理界面 为了显示在状态同时2的时候 显示不同的操作视图

  _DistributionOrderDetailPageState createState() =>
      _DistributionOrderDetailPageState();
}

class _DistributionOrderDetailPageState
    extends State<DistributionOrderDetailPage> {
  _DistributionOrderDetailPageState() {
    //全局事件
    // final eventBus = new EventBus();
    // ApplicationEvent.event = eventBus;
  }
  Map orderDetailMap = new Map();
  List orderDetailList = new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text("订单明细"),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "更多信息",
                style:
                    TextStyle(color: Colors.white, fontSize: Dimens.font_sp16),
              ),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => OrderDetailMorePage(
                          orderMap: this.orderDetailMap,
                        )));
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "订单号: ",
                        style: TextStyle(
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: ZYHelper().avoidNullString(
                            orderDetailMap["ordId"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
                      )
                    ]))),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: Text(
                    "状态",
                    style: TextStyle(color: Colours.app_text_one_color),
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
                    child: Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "客户 : ",
                        style: TextStyle(
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: ZYHelper().avoidNullString(
                            orderDetailMap["clientName"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
                      )
                    ]))),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Text(
                    orderStatus(orderDetailMap["status"]),
                    style: TextStyle(color: Colours.app_text_three_color),
                  ),
                ),
              ],
            ),
            orderStatusView(context, orderDetailMap["status"]),
            Container(
              color: Colours.app_line_color,
              height: 10,
            ),
            Flexible(
              child: orderDetailView(),
            ),
          ],
        ));
  }

  Widget orderDetailView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: orderDetailList.length,
      itemBuilder: (BuildContext content, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text.rich(TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "耗材名称 : ",
                    style: TextStyle(
                        color: Colours.app_text_one_color, fontSize: 14),
                  ),
                  TextSpan(
                    text: ZYHelper().avoidNullString(
                        this.orderDetailList[index]["mtlName"].toString()),
                    style: TextStyle(
                        color: Colours.app_text_three_color, fontSize: 14),
                  )
                ]))),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "厂商 : ",
                          style: TextStyle(
                              color: Colours.app_text_one_color, fontSize: 14),
                        ),
                        TextSpan(
                          text: ZYHelper().avoidNullString(this
                              .orderDetailList[index]["factoryName"]
                              .toString()),
                          style: TextStyle(
                              color: Colours.app_text_three_color,
                              fontSize: 14),
                        )
                      ])),
                    )),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "产品类型 : ",
                        style: TextStyle(
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: productType(index),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
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
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "规格 : ",
                          style: TextStyle(
                              color: Colours.app_text_one_color, fontSize: 14),
                        ),
                        TextSpan(
                          text: ZYHelper().avoidNullString(
                              this.orderDetailList[index]["spec"].toString()),
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
                          text: "单位 : ",
                          style: TextStyle(
                              color: Colours.app_text_one_color, fontSize: 14),
                        ),
                        TextSpan(
                          text: ZYHelper().avoidNullString(this
                              .orderDetailList[index]["unitName"]
                              .toString()),
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
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "下单数量 : ",
                          style: TextStyle(
                              color: Colours.app_text_one_color, fontSize: 14),
                        ),
                        TextSpan(
                          text: ZYHelper().avoidNullString(this
                              .orderDetailList[index]["planAmt"]
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
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text.rich(TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "响应数量 : ",
                          style: TextStyle(
                              color: Colours.app_text_one_color, fontSize: 14),
                        ),
                        TextSpan(
                          text: ZYHelper().avoidNullString(this
                              .orderDetailList[index]["responseAmt"]
                              .toString()),
                          style: TextStyle(
                              color: Colours.app_text_three_color,
                              fontSize: 14),
                        )
                      ]))),
                )
              ],
            ),
            Container(
              color: Colours.app_line_color,
              height: 1,
            )
          ],
        );
      },
    );
  }

  //送达视图
  Widget serviceView(BuildContext context) {
    //配送类型
    int orderDeliverType = orderDetailMap["orderDeliverType"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
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
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => DistributionOperationDeatailPage(
                          orderId: widget.orderId,
                          orderDeliverType: orderDeliverType,
                          orderData: orderDetailMap,
                        )));
              } else {
                showReceiptAlertDialog(context, orderDetailMap, "您确认送达吗?");
              }
            },
          ),
        ),
      ],
    );
  }

  //跟台清台视图
  Widget followerView(BuildContext context) {
    //手术时间是否过期
    var timeValue =
        DateTime.parse(orderDetailMap['opTime'].toString().substring(0, 10))
                .millisecondsSinceEpoch -
            DateTime.parse(DateTime.now().toString().substring(0, 10))
                .millisecondsSinceEpoch;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        timeValue <= 0 && orderDetailMap['status'] == 2
            ? GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 10),
                  padding: EdgeInsets.fromLTRB(22.0, 6.0, 22.0, 6.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(6.0))),
                  child: Text('清台', style: TextStyle(color: Colors.white)),
                ),
                onTap: () async {
                  await Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) =>
                          ConsumeDetailView(ordId: widget.orderId)));
                  requestData();
                },
              )
            : orderDetailMap['status'] != 3
                ? Container(
                    margin: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 10),
                    padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[400]),
                        borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child:
                        Text('未到时间', style: TextStyle(color: Colors.grey[400])),
                  )
                : Text('')
      ],
    );
  }

  //收货视图
  Widget receiptView(BuildContext context) {
    //配送类型
    int orderDeliverType = orderDetailMap["orderDeliverType"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
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
                showReceiptAlertDialog(context, orderDetailMap, "您确认收货吗?");
              } else {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => DistributionOperationDeatailPage(
                          orderId: widget.orderId,
                          orderDeliverType: orderDeliverType,
                          orderData: orderDetailMap,
                        )));
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
                    deliveryReceiptOrder(dataMap);
                  } else {
                    returnServiceOrder(dataMap);
                  }

                  Navigator.of(context).pop();
                },
              )
            ]));
  }

  //已分配视图
  Widget distributionView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 5, 10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                  color: Color(0xFF4b82fb),
                  height: 34,
                  width: 76,
                  child: Center(
                    child: Text(
                      "接受",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
            onTap: () {
              showAcceptAlertDialog(context, orderDetailMap);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                  color: Colors.red.shade300,
                  height: 34,
                  width: 76,
                  child: Center(
                    child: Text(
                      "拒绝",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
            onTap: () {
              showRejectDialog(context, orderDetailMap);
            },
          ),
        ),
      ],
    );
  }

  //已接受
  Widget acceptedView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                  color: Colors.grey,
                  height: 34,
                  width: 76,
                  child: Center(
                    child: Text(
                      "已接受",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )),
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }

//拒绝弹框
  Future showRejectDialog(BuildContext context, Map dataMap) {
    var reason = '';
    FocusNode _focusNodeInput = new FocusNode();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String validateInput(value) {
      if (value.isEmpty) {
        return '原因不能为空';
      } else if (value.trim().length > 50) {
        return '最多只能输入50字';
      }
      return null;
    }

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("拒绝需要注明原因"),
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNodeInput,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "拒绝原因：",
                        ),
                        validator: validateInput,
                        onSaved: (String value) {
                          reason = value;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消", style: TextStyle(color: Colours.text_gray)),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("拒绝"),
              onPressed: () {
                //关闭对话框并返回true
                // Navigator.of(context).pop(true);
                _focusNodeInput.unfocus();
                if (_formKey.currentState.validate()) {
                  //只有输入通过验证，才会执行这里
                  _formKey.currentState.save();

                  int orderDeliverType = dataMap["orderDeliverType"];
                  // 1配送 2 返仓 3 跟台
                  if (orderDeliverType == 1) {
                    deliveryOrder(dataMap, 0, reason);
                  } else if (orderDeliverType == 2) {
                    returnOrder(dataMap, 0, reason);
                  } else {
                    followerOrder(dataMap, 0, reason);
                  }

                  Navigator.of(context).pop();
                  print("$reason");
                }
              },
            ),
          ],
        );
      },
    );
  }

//接受弹框
  void showAcceptAlertDialog(BuildContext context, Map dataMap) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(content: Text("您确定接受的此订单吗?"), actions: <Widget>[
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
                  // 1配送 2 返仓 3 跟台
                  if (orderDeliverType == 1) {
                    deliveryOrder(dataMap, 2, "");
                  } else if (orderDeliverType == 2) {
                    returnOrder(dataMap, 2, "");
                  } else {
                    followerOrder(dataMap, 2, "");
                  }

                  Navigator.of(context).pop();
                },
              )
            ]));
  }

  //根据不同的订单 和不同状态 显示不同的视图
  Widget orderStatusView(BuildContext context, int status) {
    if (widget.opCls == 3 || widget.fromPage == 'consume') {
      //跟台订单
      switch (status) {
        case 1:
          return distributionView(context);
          break;
        case 2: //清台管理 清台没有查看明细 所以显示跟台任务管理状态
          // if (widget.fromPage == "consume") {
          //   return followerView(context);
          // }
          return acceptedView(context);
          break;
        case 3:
          break;
        case 4:
          break;

        default:
      }
    } else if (widget.opCls == 2 ||
        widget.opCls == 4 ||
        widget.fromPage == null) {
      //配送订单 或 返仓订单
      switch (status) {
        case 1:
          return distributionView(context);
          break;
        case 2: //从配送管理 和 主页订单 进去 显示的视图不一样
          if (widget.fromPage == null && widget.upPage == null) {
            return acceptedView(context);
          }
          return receiptView(context);
          break;
        case 3:
          return serviceView(context);
          break;
        default:
      }
    }

    //业���员订单没有操作 只有显示状态
    return SizedBox();
  }

  //订单状态 0-待分配 1-已分配 2-接受任务 3-发货确认 4-送达
  String orderStatus(int status) {
    switch (status) {
      case 0:
        return widget.opCls == 0 ? OrderType().salesManOrder(status) : "待分配";
        break;
      case 1:
        return widget.opCls == 0 ? OrderType().salesManOrder(status) : "已分配";
        break;
      case 2:
        return widget.opCls == 0 ? OrderType().salesManOrder(status) : "已接受任务";
        break;
      case 3:
        return widget.fromPage == 'consume' || widget.opCls == 3
            ? '确认消耗'
            : "发货已确认";
        break;
      case 4:
        return widget.fromPage == 'consume' || widget.opCls == 3
            ? '提交返仓'
            : "已送达";
        break;
      default:
    }
    return "";
  }

//产品类型
  String productType(int index) {
    String productString = "";
    int productType = orderDetailList[index]["mtlType"];

    switch (productType) {
      case 1:
        {
          productString = "普通耗材";
        }
        break;

      case 2:
        {
          productString = "高值耗材";
        }
        break;

      case 3:
        {
          productString = "试剂";
        }
        break;

      case 4:
        {
          productString = "设备";
        }
        break;

      default:
        {
          productString = "器械";
        }
        break;
    }

    return productString;
  }

  //提示信息
  void toastMsg(int status) {
    ApplicationEvent.event.fire(OrderRefreshEvent());

    if (status == 2) {
      HelperToast().showCenterToast("您已接受");
    } else {
      HelperToast().showCenterToast("您已拒绝");
    }
  }

  //提示信息
  void toastMssage(String msg) {
    ApplicationEvent.event.fire(OrderRefreshEvent());

    HelperToast().showCenterToast(msg);
  }

  void refuseOrAccept(int status) async {
    //订单详情里面 拒绝的订单 app端已经不存在，所以 返回上一页 ,(拒绝的订单在数据库里还存在)
    if (status == 0) {
      ApplicationEvent.event.fire(OrderRefreshEvent());
      //延迟1秒返回刷新数据
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } else {
      requestData();
    }
  }

  //返仓订单送达操作
  void returnServiceOrder(
    Map dataMap,
  ) {
    Map paramsMap = {"ordId": dataMap["ordId"], "details": dataMap};
    HttpUtils.post(Api.API_returnConfirmArrive_URL, params: paramsMap,
        success: (value) {
      requestData();
      toastMssage("送达成功");
    }, failure: (error) {
      HelperToast().showCenterToast(error);
    });
  }

  //配送订单收货成功操作
  void deliveryReceiptOrder(Map dataMap) {
    Map paramsMap = {
      "ordId": dataMap["ordId"],
      "details": dataMap,
    };

    HttpUtils.post(Api.API_deliverConfirmMtl_URL, params: paramsMap,
        success: (value) {
      requestData();
      toastMssage("收货成功");
      print(value);
    }, failure: (error) {
      HelperToast().showCenterToast(error.toString());
    });
  }

//返仓订单操作
  void returnOrder(Map dataMap, int status, String reason) {
    Map paramsMap = {
      "ordId": dataMap["ordId"],
      "reason": reason,
      "status": status, //2 接受 0 拒绝
    };
    HttpUtils.post(Api.API_returnRefuse_URL, params: paramsMap,
        success: (value) {
      refuseOrAccept(status);
      toastMsg(status);
    }, failure: (error) {
      HelperToast().showCenterToast(error);
    });
  }

  //配送订单操作
  void deliveryOrder(Map dataMap, int status, String reason) {
    Map paramsMap = {
      "ordId": dataMap["ordId"],
      "reason": reason,
      "status": status, //2 接受 0 拒绝
    };
    HttpUtils.post(Api.API_deliverResponse_URL, params: paramsMap,
        success: (value) {
      refuseOrAccept(status);
      toastMsg(status);
    }, failure: (error) {
      HelperToast().showCenterToast(error.toString());
    });
  }

  //跟台订单操作
  void followerOrder(Map dataMap, int status, String reason) {
    Map paramsMap = {
      "ordId": dataMap["ordId"],
      "reason": reason,
      "status": status, //2 接受 0 拒绝
    };
    HttpUtils.post(Api.API_CONSUME_RECEPT_TAKE, params: paramsMap,
        success: (value) {
      refuseOrAccept(status);
      toastMsg(status);
    }, failure: (error) {
      HelperToast().showCenterToast(error.toString());
    });
  }

  //请求数据
  void requestData() {
    Map paramsMap = {"ordId": widget.orderId};
    if (widget.fromPage == null) {
      paramsMap['orderDeliverType'] = widget.orderDeliverType;
    }
    var url = Api.API_deliverOrderDetail_URL;
    if (widget.fromPage == 'consume') {
      url = Api.API_CONFIRM_DETAIL;
    } else if (widget.fromPage == 'home') {
      url = Api.API_homeOrderDetail_URL;
      paramsMap['opCls'] = widget.opCls;
    }

    HttpUtils.put(url, params: paramsMap, success: (value) {
      if (value is Map && value.isNotEmpty) {
        orderDetailMap = value["data"];
        if (widget.fromPage == 'consume') {
          orderDetailMap["fromPage"] = 'consume';
        }
        if (widget.fromPage == 'home') {
          orderDetailMap["fromPage"] = 'home';
          orderDetailMap["opCls"] = widget.opCls;
        }
        orderDetailList = orderDetailMap["details"];
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
    //监听订单确认发货/送达
    ApplicationEvent.event.on<OrderConfirmEvent>().listen((event) {
      requestData();
      Future.delayed(Duration(seconds: 1), () {
        ApplicationEvent.event.fire(OrderRefreshEvent());
      });
    });
  }
}
