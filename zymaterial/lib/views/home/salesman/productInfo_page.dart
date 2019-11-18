import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/res/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';

class ProductInfoPage extends StatefulWidget {
  ProductInfoPage({Key key, @required this.productId}) : super(key: key);
  final productId;
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  Map productDetailMap = new Map();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    //产品类型
    String productTppeString = productType();

    return Scaffold(
      appBar: GradientAppBar(
        title: Text("产品信息"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.white,
            width: ScreenUtil.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                  child: Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: "耗材名称 : ",
                      style: TextStyle(
                          color: Colours.app_text_one_color, fontSize: 16),
                    ),
                    TextSpan(
                      text: ZYHelper().avoidNullString(
                          this.productDetailMap["mtlName"].toString()),
                      style: TextStyle(
                          color: Colours.app_text_three_color, fontSize: 16),
                    )
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: "产品类型 : ",
                      style: TextStyle(
                          color: Colours.app_text_one_color, fontSize: 14),
                    ),
                    TextSpan(
                      text: productTppeString,
                      style: TextStyle(
                          color: Colours.app_text_three_color, fontSize: 14),
                    )
                  ])),
                ),
              ],
            ),
          ),
          Container(
            color: Colours.app_background_color,
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Text(
                        "厂商",
                        style: TextStyle(
                            color: Colours.app_text_one_color,
                            fontSize: Dimens.font_sp16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Text(
                        "规格",
                        style: TextStyle(
                            color: Colours.app_text_one_color,
                            fontSize: Dimens.font_sp16),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: Text(
                        ZYHelper().avoidNullString(
                            productDetailMap["factoryName"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color,
                            fontSize: Dimens.font_sp14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Text(
                        ZYHelper().avoidNullString(
                            productDetailMap["spec"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color,
                            fontSize: Dimens.font_sp14),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colours.app_line_color,
                  height: 1,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Text(
                        "包装单位",
                        style: TextStyle(
                            color: Colours.app_text_one_color,
                            fontSize: Dimens.font_sp16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Text(
                        "包装系数",
                        style: TextStyle(
                            color: Colours.app_text_one_color,
                            fontSize: Dimens.font_sp16),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: Text(
                        ZYHelper().avoidNullString(
                            productDetailMap["unitName"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color,
                            fontSize: Dimens.font_sp14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Text(
                        "",
                        style: TextStyle(
                            color: Colours.app_text_three_color,
                            fontSize: Dimens.font_sp14),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colours.app_line_color,
                  height: 1,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Text(
                        "库存数",
                        style: TextStyle(
                            color: Colours.app_text_one_color,
                            fontSize: Dimens.font_sp16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Text(
                        "售价",
                        style: TextStyle(
                            color: Colours.app_text_one_color,
                            fontSize: Dimens.font_sp16),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: Text(
                        stockNum(),
                        style: TextStyle(
                            color: Colours.app_text_three_color,
                            fontSize: Dimens.font_sp14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      child: Text(
                        "￥" +
                            ZYHelper().avoidNullString(
                                productDetailMap["salePrice"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color,
                            fontSize: Dimens.font_sp14),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colours.app_line_color,
                  height: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //随机库存
  String stockNum() {
    int random = Random.secure().nextInt(100);

    return random.toString();
  }

  //产品类型
  String productType() {
    String productTypeString = "";
    int productType = productDetailMap["mtlType"];

    switch (productType) {
      case 1:
        {
          productTypeString = "普通耗材";
        }
        break;

      case 2:
        {
          productTypeString = "高值耗材";
        }
        break;

      case 3:
        {
          productTypeString = "试剂";
        }
        break;

      case 4:
        {
          productTypeString = "设备";
        }
        break;

      default:
        {
          productTypeString = "器械";
        }
        break;
    }

    return productTypeString;
  }

  //请求商品数据
  void requestProductDetailData() {
    Map paramsMap = {"mtlId": widget.productId};

    HttpUtils.put(
      Api.API_productDetail_URL,
      params: paramsMap,
      success: (value) {
        if (value is Map && value.isNotEmpty) {
          productDetailMap = value["data"];
          if (mounted) {
            setState(() {});
          }
        }
      },
      showProgress: false,
    );
  }

  @override
  void initState() {
    super.initState();
    requestProductDetailData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
