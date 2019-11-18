import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/data/model/order/create_order_model.dart';
import 'package:zymaterial/res/colors.dart';
import 'package:zymaterial/res/dimens.dart';
import 'package:zymaterial/views/home/salesman/productSearch_page.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';
import 'package:zymaterial/widgets/line.dart';
import 'package:zymaterial/widgets/num_edit.dart';
import 'package:zymaterial/common/totast.dart';

import '../../../main.dart';

class CreateOrderAddPage extends StatefulWidget {
  CreateOrderAddPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateOrderAddPageState();
}

class CreateOrderAddPageState extends State<CreateOrderAddPage> {
  final List items = List();
  List<int> numList = List();

  CreateOrderModel model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('添加产品'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Card(
                margin: EdgeInsets.all(2),
                child: FlatButton.icon(
                  icon: Icon(Icons.add),
                  label: Text(
                    '添加产品',
                    style: TextStyle(
                        fontSize: Dimens.font_sp16, color: Colors.black87),
                  ),
                  onPressed: () async {
                    var result = await Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) {
                      return ProductSearchPage(
                        sourceType: 1, //跳转搜索页，传参sourceType=1
                      );
                    }));
                    if (result != null) {
                      items.add(result);
                      numList.add(1);
                    }
                  },
                )),
          ),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) {
                return Line();
              },
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (_) {
                    //参数暂时没有用到，则用下划线表示
                    items.removeAt(index);
                    numList.removeAt(index);
                  },
                  movementDuration: Duration(milliseconds: 100),
                  key: Key(items[index]["mtlId"].toString()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: "耗材名称："),
                            TextSpan(
                              text: '${items[index]["mtlName"]}',
                              style: TextStyle(
                                  color: Colours.app_text_one_color,
                                  fontSize: Dimens.font_sp16),
                            ),
                          ]))),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "厂商："),
                                  TextSpan(
                                    text: '${items[index]["factoryName"]}',
                                    style: TextStyle(
                                        color: Colours.app_text_two_color,
                                        fontSize: Dimens.font_sp14),
                                  ),
                                ]))),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "产品类型："),
                                  TextSpan(
                                    text:
                                        '${productType(items[index]["mtlType"])}',
                                    style: TextStyle(
                                        color: Colours.app_text_two_color,
                                        fontSize: Dimens.font_sp14),
                                  ),
                                ]))),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 4),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "规格："),
                                  TextSpan(
                                    text: '${items[index]["spec"]}',
                                    style: TextStyle(
                                        color: Colours.app_text_two_color,
                                        fontSize: Dimens.font_sp14),
                                  ),
                                ]))),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 4),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "单位："),
                                  TextSpan(
                                    text: '${items[index]["unitName"]}',
                                    style: TextStyle(
                                        color: Colours.app_text_two_color,
                                        fontSize: Dimens.font_sp14),
                                  ),
                                ]))),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "售价："),
                                  TextSpan(
                                    text: '¥ ${items[index]["salePrice"]}',
                                    style: TextStyle(
                                        color: Colours.app_text_two_color,
                                        fontSize: Dimens.font_sp14),
                                  ),
                                ]))),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Text("计划数："),
                                  NumberEditText(
                                    (i) {
                                      setState(() {
                                        numList[index] = i;
                                      });
                                    },
                                    num: numList[index],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  background: Container(
                    child: Center(
                      child: Text('继续滑动以删除',
                          style: TextStyle(
                              fontSize: Dimens.font_sp16,
                              color: Colors.black87)),
                    ),
                    color: Colours.app_background_color,
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colours.app_background_color,
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: new RaisedButton(
              color: Colors.blueAccent,
              child: Text(
                '提交订单',
                style:
                    TextStyle(fontSize: Dimens.font_sp16, color: Colors.white),
              ),
              // 设置按钮圆角
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                postForm();
              },
            ),
          )
        ],
      ),
    );
  }

  //产品类型
  String productType(int productType) {
    switch (productType) {
      case 1:
        return '普通耗材';
      case 2:
        return '高值耗材';
      case 3:
        return '试剂';
      case 4:
        return '设备';
      default:
        return '器械';
    }
  }

  void postForm() {
    if ((model.assets == null || model.assets.length == 0) &&
        items.length == 0) {
      Fluttertoast.showToast(msg: '未上传图片时必须添加产品！');
      return;
    }

    HttpUtils.uploadFile(Api.API_UPLOAD_FILE,
        assetList: model.assets,
        showProgress: true,
        context: context, success: (v) {
      if (v['code'] == '200') {
        List list = v['rows'];
        model.files = list;

        for (int i = 0; i < numList.length; i++) {
          items[i]['planAmt'] = numList[i];
        }

        model.details = items;
        var json = model.toJson();

        HttpUtils.post(Api.API_CREATE_ORDER, params: json, success: (value) {
          if (value['code'] == '200') {
            // Fluttertoast.showToast(msg: '成功！');
            HelperToast().showCenterToast('成功!');
            // 延时后跳转 到根目录
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => BottomNavigationWidget()),
              (route) => route == null,
            );
          }
        }, showProgress: true, context: context);
      }
    });
  }
}
