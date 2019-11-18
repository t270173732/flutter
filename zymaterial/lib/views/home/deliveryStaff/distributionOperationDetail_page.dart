import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zymaterial/common/totast.dart';
import 'package:zymaterial/data/model/even/event_model.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';
import 'package:zymaterial/widgets/photo_view_pager.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

// import 'package:amap_base_map/amap_base_map.dart';

class DistributionOperationDeatailPage extends StatefulWidget {
  DistributionOperationDeatailPage(
      {Key key, this.orderId, this.orderDeliverType, this.orderData})
      : super(key: key);

  final int orderId;
  final int orderDeliverType; //订单类型
  final Map orderData; //订单数据 接口要求带上...

  _DistributionOperationDeatailPageState createState() =>
      _DistributionOperationDeatailPageState();
}

class _DistributionOperationDeatailPageState
    extends State<DistributionOperationDeatailPage> {
  Map orderDetailMap = new Map();

  List orderDetailList = new List(); //商品数据

  List<Asset> selectedList = List(); //图片选择

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
        appBar: GradientAppBar(
          title: Text("操作明细"),
          centerTitle: true,
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text(
          //       "刷新定位",
          //       style:
          //           TextStyle(color: Colors.white, fontSize: Dimens.font_sp16),
          //     ),
          //     onPressed: () {
          //       print("刷新定位");
          //     },
          //   )
          // ],
        ),
        body: distributionOperationDeatailContent(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FlatButton(
            color: Colors.blue,
            child: Container(
              width: MediaQuery.of(context).size.width - 80,
              child: Text(
                "确认收货",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontSize: Dimens.font_sp16),
              ),
            ),
            onPressed: () {
              uploadFile();
            },
          ),
        ));
  }

  Widget distributionOperationDeatailContent() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        // AMapView(
        //           onAMapViewCreated: (controller) {
        //             _controller = controller;
        //           },
        //           amapOptions: AMapOptions(
        //             compassEnabled: false,
        //             zoomControlsEnabled: true,
        //             logoPosition: LOGO_POSITION_BOTTOM_CENTER,
        //             camera: CameraPosition(
        //               target: LatLng(41.851827, 112.801637),
        //               zoom: 4,
        //             ),
        //           ),
        // )
        PhotoGrid(
          selectedList,
          (v) {
            setState(() {
              selectedList = v;
            });
          },
          maxCount: 9,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: orderDetailList.length,
          itemBuilder: (BuildContext content, int index) {
            return GestureDetector(
              onTap: () {},
              child: Column(
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
                          text: ZYHelper().avoidNullString(this
                              .orderDetailList[index]["mtlName"]
                              .toString()),
                          style: TextStyle(
                              color: Colours.app_text_three_color,
                              fontSize: 14),
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
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
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
                                  color: Colours.app_text_one_color,
                                  fontSize: 14),
                            ),
                            TextSpan(
                              text: productType(index),
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
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "规格 : ",
                                style: TextStyle(
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
                              ),
                              TextSpan(
                                text: ZYHelper().avoidNullString(this
                                    .orderDetailList[index]["spec"]
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "单位 : ",
                                style: TextStyle(
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
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
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
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
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: widget.orderDeliverType == 1
                                    ? "配送数量 : "
                                    : "返仓数量 : ",
                                style: TextStyle(
                                    color: Colours.app_text_one_color,
                                    fontSize: 14),
                              ),
                              TextSpan(
                                text: ZYHelper().avoidNullString(this
                                    .orderDetailList[index][
                                        widget.orderDeliverType == 1
                                            ? "deliverAmt"
                                            : "returnAmt"]
                                    .toString()),
                                style: TextStyle(
                                    color: Colours.app_text_three_color,
                                    fontSize: 14),
                              )
                            ]))),
                      ),
                    ],
                  ),
                  Container(
                    color: Colours.app_line_color,
                    height: 1,
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
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

  // 上传图片
  void uploadFile() async {
    if (selectedList.isNotEmpty) {
      HttpUtils.uploadFile(Api.API_UPLOAD_FILE, assetList: selectedList,
          success: (value) {
        if (widget.orderDeliverType == 1) {
          confirmService(value["rows"]);
        } else {
          confirmReceipt(value["rows"]);
        }
      }, failure: (error) {
        HelperToast().showCenterToast(error.toString());
      }, showProgress: true, context: context);
    } else {
      if (widget.orderDeliverType == 1) {
        confirmService([]);
      } else {
        confirmReceipt([]);
      }
    }
  }

  //返仓订单确认收货
  void confirmReceipt(List imageList) async {
    Map paramsMap = {
      "fileInfos": imageList,
      "ordId": widget.orderId,
      "details": widget.orderData
    };
    ApplicationEvent.event.fire(OrderConfirmEvent());

    HttpUtils.post(Api.API_returnConfirmMtl_URL, params: paramsMap,
        success: (value) {
      HelperToast().showCenterToast("确认成功");
      ApplicationEvent.event.fire(OrderConfirmEvent());
      //延迟1秒返回刷新数据
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, "success");
      });
    }, failure: (error) {
      HelperToast().showCenterToast(error);
    }, showProgress: false);
  }

  //配送订单确认送达
  void confirmService(List imageList) {
    Map paramsMap = {
      "opFiles": imageList,
      "ordId": widget.orderId,
      "details": widget.orderData
    };

    HttpUtils.post(Api.API_deliverConfirmArrive_URL, params: paramsMap,
        success: (value) {
      HelperToast().showCenterToast("确认成功");
      ApplicationEvent.event.fire(OrderConfirmEvent());

      //延迟1秒返回刷新数据
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, "success");
      });
    }, failure: (error) {
      HelperToast().showCenterToast(error);
    }, showProgress: false);
  }

  //请求商品数据
  void requestData() {
    Map paramsMap = {
      "ordId": widget.orderId,
      "orderDeliverType": widget.orderDeliverType
    };

    HttpUtils.put(Api.API_deliverOrderDetail_URL, params: paramsMap,
        success: (value) {
      if (value is Map && value.isNotEmpty) {
        orderDetailMap = value["data"];
        orderDetailList = orderDetailMap["details"];
        if (mounted) {
          setState(() {});
        }
      }
    }, showProgress: false);
  }

  @override
  void initState() {
    super.initState();
    requestData();
  }
}
