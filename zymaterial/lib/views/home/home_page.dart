import 'package:flustars/flustars.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zymaterial/common/global.dart';
import 'package:zymaterial/common/totast.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/data/model/even/event_model.dart';
import 'package:zymaterial/data/model/order/order_type_description.dart';
import 'package:zymaterial/res/index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionOrderDetail_page.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionTaskManage_page.dart';
import 'package:zymaterial/views/home/salesman/createOrder_page.dart';
import 'package:zymaterial/views/home/salesman/orderLookMore_page.dart';
import 'package:zymaterial/views/home/salesman/productSearch_page.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionManage_page.dart';
import 'package:zymaterial/views/home/consume/consumeTake.dart';
import 'package:zymaterial/views/home/consume/consumeMgt.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';

final double spaceWidth = 20; //距离

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageWidgetState();
  }
}

class HomePageWidgetState extends State<HomePageWidget>
    with AutomaticKeepAliveClientMixin {
  HomePageWidgetState() {
    //全局事件
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }
  List orderList = new List(); //订单数据
  Map messageMap = new Map(); //消息数据

  //底部安全高 px
  final double bottomSafeHeight =
      ScreenUtil().scaleHeight * ScreenUtil.bottomBarHeight;

  //业务员
  Widget salesManContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: salesManTopView(),
          height: 230,
        ),
        centerViewContent(),
        Flexible(
          child: homePageListContent(),
        )
      ],
    );
  }

  // 配送员
  Widget deliveryStaff() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: messageMap.isNotEmpty ? 280 : 220,
          child: newMessageView(1),
        ),
        messageMap.isNotEmpty ? topDeliveryStaffView() : SizedBox(),
        Container(
          child: Container(
            color: Colours.app_background_color,
            height: ScreenUtil().setHeight(20),
          ),
        ),
        centerViewContent(),
        Flexible(
          child: homePageListContent(),
        )
      ],
    );
  }

  //跟台员
  Widget follower() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: messageMap.isNotEmpty ? 280 : 220,
          child: newMessageView(2),
        ),
        messageMap.isNotEmpty ? consumeTopViewContent() : SizedBox(),
        Container(
          child: Container(
            color: Colours.app_background_color,
            height: ScreenUtil().setHeight(20),
          ),
        ),
        centerViewContent(),
        Flexible(
          child: homePageListContent(),
        )
      ],
    );
  }

  //顶部跟台消息
  Widget noticeTopView() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        '您有新的跟台任务',
                        style: TextStyle(
                            color: Colors.black, fontSize: Dimens.font_sp16),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Container(
                          width: 220,
                          child: Text(messageMap["opName"].toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Dimens.font_sp14,
                                color: Colors.black45,
                              )),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 10, 5, 0),
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  )),
                            ),
                            onTap: () {
                              showAcceptAlertDialog(context, messageMap);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  )),
                            ),
                            onTap: () {
                              showRejectDialog(context, messageMap);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                      style: TextStyle(
                                          color: Color(0xFF3a72ff),
                                          fontSize: 14),
                                    ),
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) =>
                                      DistributionOrderDetailPage(
                                        orderId: messageMap["ordId"],
                                        orderDeliverType:
                                            messageMap["orderDeliverType"],
                                        fromPage: 'consume',
                                      )));
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  //顶部配送消息
  Widget deliveryStaffTopNoticeView() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        '您有新的配送任务',
                        style: TextStyle(
                            color: Colors.black, fontSize: Dimens.font_sp16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Container(
                        width: 200,
                        child: Text(
                            "由仓库配送至" + messageMap["address"].toString() + "的订单",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Dimens.font_sp14,
                              color: Colors.black45,
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 10, 5, 0),
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  )),
                            ),
                            onTap: () {
                              showAcceptAlertDialog(context, messageMap);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  )),
                            ),
                            onTap: () {
                              showRejectDialog(context, messageMap);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                      style: TextStyle(
                                          color: Color(0xFF3a72ff),
                                          fontSize: 14),
                                    ),
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) =>
                                      DistributionOrderDetailPage(
                                          orderId: messageMap["ordId"],
                                          orderDeliverType:
                                              messageMap["orderDeliverType"])));
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

//顶部业务员视图
  Widget salesManTopView() {
    // 图片宽度
    final double imageWidth =
        (MediaQuery.of(context).size.width - 3 * spaceWidth) / 2;
    //图片高度 根据原图片 比例 适配
    final double imageHeight = imageWidth * 88 / 168;

    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: Image.asset(
            "images/home/bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.of(context).padding.top,
          child: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text("主页",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => OrderLookMorePage()));
                  },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(30, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Image.asset(
                            "images/home/icon_search.png",
                            width: 14,
                            height: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            "搜索订单",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ProductSearchPage()));
                  },
                  child: Image.asset(
                    "images/home/icon_home_Inquire.png",
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CreateOrderPage()));
                  },
                  child: Image.asset(
                    "images/home/icon_home_create.png",
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

//配送员顶部视图
  Widget topDeliveryStaffView() {
    // 图片宽度
    final double imageWidth =
        (MediaQuery.of(context).size.width - 3 * spaceWidth) / 2;
    //图片高度 根据原图片 比例 适配
    final double imageHeight = imageWidth * 88 / 168;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => DistributionTaskManagePage()));
            },
            child: Image.asset(
              "images/home/icon_home_distribution.png",
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => DistributionMangePage()));
            },
            child: Image.asset(
              "images/home/icon_home_delivery.png",
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    );
  }

  //跟台人员顶部视图
  Widget consumeTopViewContent() {
    // 图片宽度
    final double imageWidth =
        (MediaQuery.of(context).size.width - 3 * spaceWidth) / 2;
    //图片高度 根据原图片 比例 适配
    final double imageHeight = imageWidth * 88 / 168;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => ConsumeTake()));
            },
            child: Image.asset(
              "images/home/icon_home_followerTask.png",
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => ConsumeMgtView()));
              },
              child: Image.asset(
                "images/home/icon_home_management.png",
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
              )),
        ),
      ],
    );
  }

//中间查询更多
  Widget centerViewContent() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => OrderLookMorePage()));
      },
      child: Container(
        color: Colours.app_background_color,
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "images/common/icon_rectangle.png",
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text('订单查询',
                      style: TextStyle(
                          fontSize: Dimens.font_sp16,
                          color: Colours.app_text_one_color,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(
                    "MORE",
                    style: TextStyle(
                        color: Colours.app_text_one_color, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Image.asset("images/common/icon_right.png"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //底部列表视图
  Widget homePageListContent() {
    if (orderList.isEmpty) {
      return Center(
        child: Text("您还没有订单哦!"),
      );
    }
    String fillChar = DateTime.now().minute < 10 ? "0" : "";

    return EasyRefresh(
      onRefresh: () async {
        requestData();
      },
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
      child: ListView.builder(
        // shrinkWrap: true,
        padding: EdgeInsets.only(top: 0),
        physics: BouncingScrollPhysics(),
        itemCount: orderList.length,
        itemBuilder: (BuildContext content, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(content).push(CupertinoPageRoute(
                  builder: (context) => DistributionOrderDetailPage(
                      orderId: orderList[index]['ordId'],
                      opCls: OrderType()
                          .opCls(orderList[index]['orderDeliverType']),
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
                            child: Image.asset(
                                "images/common/icon_rectangle1.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
                                          color: Color(0xFF3a72ff),
                                          fontSize: 14),
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
                            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "创建人 : ",
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
                            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
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
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
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
      ),
    );
  }

  //已接受
  Widget acceptedView(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0),
            padding: EdgeInsets.fromLTRB(8.0, 5, 8.0, 5.0),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: Text('查看明细',
                style: TextStyle(color: Colors.blue, fontSize: 14)),
          ),
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => DistributionOrderDetailPage(
                      orderId: messageMap["ordId"],
                      orderDeliverType: messageMap["orderDeliverType"],
                    )));
          },
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0),
            padding: EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: Text('已接受',
                style: TextStyle(color: Colors.white, fontSize: 14)),
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

  //根据不同的订单显��不同的消息视图
  Widget newMessageView(int type) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: Image.asset(
            "images/home/bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.of(context).padding.top,
          child: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text("主页",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => OrderLookMorePage()));
                  },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(30, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Image.asset(
                            "images/home/icon_search.png",
                            width: 14,
                            height: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            "搜索订单",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 110,
          child: stackView(type),
        ),
        messageMap.isNotEmpty
            ? Positioned(
                left: 24,
                top: 105,
                child: type == 1
                    ? Image.asset(
                        "images/home/icon_delivery.png",
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "images/home/icon_home_follower.png",
                        fit: BoxFit.contain,
                      ),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: roleDistribution(),
    );
  }

  //根据不同的角色 和不同的状态 显示不同的层叠视图
  Widget stackView(int type) {
    if (messageMap.isNotEmpty) {
      //订单类型
      int orderDeliverType = messageMap["orderDeliverType"];
      if (orderDeliverType != 3) {
        return deliveryStaffTopNoticeView();
      } else {
        return noticeTopView();
      }
    } else {
      // 1配送 2 跟台
      if (type == 1) {
        return topDeliveryStaffView();
      } else {
        return consumeTopViewContent();
      }
    }
  }

  //根据不同的角色显示不同的视图
  Widget roleDistribution() {
    // 角色类型
    List roleList = prefix0.SpUtil.getObject(Global.accountInfo)["role"];
    if (roleList.isNotEmpty) {
      int role = roleList[0]["roleId"];
      switch (role) {
        case 4:
          {
            return follower(); //跟台员
          }
          break;

        case 5:
          {
            return deliveryStaff(); //配送员
          }
          break;

        default:
          {
            return salesManContent(); //业务员
          }
          break;
      }
    }
    return salesManContent();
  }

  //根据不同订单类型显示��同的描述
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

  //提示信息
  void toastMsg(int status) {
    if (status == 2) {
      HelperToast().showCenterToast("您已接受");
    } else {
      HelperToast().showCenterToast("您已拒绝");
    }
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
      requestData();
      getNewJobData();
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
      requestData();
      getNewJobData();
      toastMsg(status);

      print(value);
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
      requestData();
      getNewJobData();
      toastMsg(status);
    }, failure: (error) {
      HelperToast().showCenterToast(error.toString());
    });
  }

  //消息数据
  Future<void> getNewJobData() async {
    HttpUtils.put(Api.API_homeGetNewJob_URL, params: {}, success: (value) {
      if (value is Map && value.isNotEmpty) {
        if (value.containsKey("data")) {
          messageMap = value["data"];
        } else {
          messageMap.clear();
        }
        print(value);

        if (mounted) {
          setState(() {});
        }
      }
    }, showProgress: true);
  }

  //请求数据
  void requestData() {
    HttpUtils.put(Api.API_homeOrderIndex_URL, params: {}, success: (value) {
      if (value is Map && value.isNotEmpty) {
        //最多显示5条数据
        orderList.clear();
        List dataList = value["rows"];
        for (var i = 0; i < dataList.length; i++) {
          if (i <= 4) {
            Map dataMap = dataList[i];
            if (dataMap.isNotEmpty) {
              orderList.add(dataMap);
            } else {
              break;
            }
          }
        }
        if (mounted) {
          setState(() {});
        }
      }
    }, showProgress: true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    requestData();
    getNewJobData();

    //监听订单刷新事件
    ApplicationEvent.event.on<OrderRefreshEvent>().listen((event) {
      requestData();
      getNewJobData();
    });
  }
}
