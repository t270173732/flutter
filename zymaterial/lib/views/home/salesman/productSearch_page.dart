import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';
import 'productInfo_page.dart';

class ProductSearchPage extends StatefulWidget {
  ProductSearchPage({Key key, this.sourceType}) : super(key: key);
  final int sourceType;

  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  List productList = new List();

  final TextEditingController _textEditingController = TextEditingController();
  //设置防抖周期为1 秒
  Duration durationTime = Duration(milliseconds: 800);
  Timer timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: searchBackGround(),
          centerTitle: true,
        ),
        body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: productList.length,
              itemBuilder: (BuildContext content, int index) {
                String productString = productType(index);

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => ProductInfoPage(
                            productId: productList[index]["mtlId"])));
                  },
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
                                color: Colours.app_text_one_color,
                                fontSize: 16),
                          ),
                          TextSpan(
                            text: ZYHelper().avoidNullString(
                                productList[index]["mtlName"].toString()),
                            style: TextStyle(
                                color: Colours.app_text_three_color,
                                fontSize: 16),
                          )
                        ])),
                      ),
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
                                    text: ZYHelper().avoidNullString(
                                        productList[index]["factoryName"]
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
                                    text: "产品类型 : ",
                                    style: TextStyle(
                                        color: Colours.app_text_one_color,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: productString,
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
                                    text: "规格 : ",
                                    style: TextStyle(
                                        color: Colours.app_text_one_color,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: ZYHelper().avoidNullString(
                                        productList[index]["spec"].toString()),
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
                                    text: ZYHelper().avoidNullString(
                                        productList[index]["unitName"]
                                            .toString()),
                                    style: TextStyle(
                                        color: Colours.app_text_three_color,
                                        fontSize: 14),
                                  )
                                ]))),
                          )
                        ],
                      ),
                      Offstage(
                        offstage: widget.sourceType != 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 10),
                          child: FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, productList[index]);
                              },
                              child: Text('添加产品')),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        color: Colours.app_line_color,
                        height: 1,
                      ),
                    ],
                  ),
                );
              },
            )));
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
            timer = Timer(durationTime, () {
              requestProductData(string);
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
            hintText: "请搜索产品",
            hintStyle: TextStyle(fontSize: 14, color: Colors.white)),
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  //产品类型
  String productType(int index) {
    String productString = "";
    int productType = productList[index]["mtlType"];

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

  //请求商品数据
  void requestProductData(String keyWord) {
    print(keyWord);
    if (keyWord.isEmpty) {
      productList = new List();
      setState(() {});
      return;
    }
    Map paramsMap = {"keyword": keyWord};

    HttpUtils.put(
      Api.API_productSearch_URL,
      params: paramsMap,
      success: (value) {
        if (value is Map && value.isNotEmpty) {
          productList = value["rows"];
          setState(() {});
        }
      },
      showProgress: false,
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
