import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/data/model/order/create_order_model.dart';
import 'package:zymaterial/res/colors.dart';
import 'package:zymaterial/res/dimens.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';
import 'package:zymaterial/widgets/line.dart';
import 'package:zymaterial/widgets/photo_view_pager.dart';

import 'createOrderAdd_page.dart';

class CreateOrderPage extends StatefulWidget {
  CreateOrderPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateOrderPageState();
}

class CreateOrderPageState extends State<CreateOrderPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();

  var gender = 0, operationTime;

  var client, clientId, address, addressId, taker, phone;

  var deadline, urgent = 0;

  List<Asset> selectedList = List(); //图片选择

  CreateOrderModel model = CreateOrderModel(); //提交的内容

  List addressList;
  List clientList;

  TextEditingController patientController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController operationController = TextEditingController();
  TextEditingController operationSiteController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("创建订单"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                          '1.患者的信息为选填。\n\n'
                          '2.配送信息先选择客户，再根据客户选择地址，选择地址后将自动带出收货人和联系电话。\n\n'
                          '3.订单信息必填，其中加急状态默认为否。\n\n'
                          '4.如果填写过手术信息和图片，可以不添加产品，由后台响应时添加。如果没有填写则必须选择对应产品',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.left),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '我知道了',
                              style: TextStyle(color: Colors.lightBlue),
                            ))
                      ],
                    );
                  });
            },
          )
        ],
      ),
      resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
      body: SingleChildScrollView(
        child: Form(
            key: _formKey, //设置globalKey，用于后面获取FormState
            autovalidate: true, //开启自动校验
            child: Column(
              children: <Widget>[
                createClassTitle('手术信息'),
                createFormItem('患者姓名', controller: patientController),
                createLine(),
                createFormItem(
                  '患者年龄',
                  controller: ageController,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  formatter: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3) //限制长度
                  ], //设置只能录入数字[0-9]
                ),
                createLine(),
                createFormItem('患者性别',
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: 0,
                            groupValue: gender,
                            onChanged: (v) {
                              setState(() {
                                gender = v;
                              });
                            }),
                        Text(
                          "未知",
                          style: TextStyle(color: Colours.text_normal),
                        ),
                        Radio(
                            value: 1,
                            groupValue: gender,
                            onChanged: (v) {
                              setState(() {
                                gender = v;
                              });
                            }),
                        Text(
                          "男",
                          style: TextStyle(color: Colours.text_normal),
                        ),
                        Radio(
                            value: 2,
                            groupValue: gender,
                            onChanged: (v) {
                              setState(() {
                                gender = v;
                              });
                            }),
                        Text("女", style: TextStyle(color: Colours.text_normal)),
                      ],
                    )),
                createLine(),
                createFormItem('手术名称', controller: operationController),
                createLine(),
                createFormItem('手术部位',
                    isRequired: true, controller: operationSiteController),
                createLine(),
                createFormItem(
                  '手术时间',
                  isRequired: true,
                  child: GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          onConfirm: (date) {
                        setState(() {
                          operationTime =
                              DateUtil.formatDate(date, format: 'yyyy-MM-dd');
                        });
                      },
                          minTime: DateTime.now(),
                          currentTime: operationTime != null
                              ? DateUtil.getDateTime(operationTime)
                              : DateTime.now(),
                          locale: LocaleType.zh);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        operationTime == null ? "点击选择时间" : operationTime,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            color: operationTime == null
                                ? Colours.text_gray
                                : Colours.text_normal),
                      ),
                    ),
                  ),
                ),
                createLine(),
                createFormItem(
                  "备注",
                  controller: remarkController,
                ),
                PhotoGrid(
                  selectedList,
                  (v) {
                    setState(() {
                      selectedList = v;
                    });
                  },
                  maxCount: 3,
                ),
                createClassTitle('配送信息'),
                createFormItem(
                  '客户',
                  isRequired: true,
                  child: GestureDetector(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(client == null ? "点击选择客户" : client,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: client == null
                                    ? Colours.text_gray
                                    : Colours.text_normal))),
                    onTap: () {
                      showClient();
                    },
                  ),
                ),
                createLine(),
                createFormItem(
                  '收货地址',
                  isRequired: true,
                  child: GestureDetector(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(address == null ? "点击选择地址" : address,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color: address == null
                                    ? Colours.text_gray
                                    : Colours.text_normal))),
                    onTap: () {
                      showAddress();
                    },
                  ),
                ),
                createLine(),
                createFormItem('收货人',
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(taker == null ? '选择地址后自动填充' : taker,
                            style: TextStyle(
                                fontSize: 16,
                                color: taker == null
                                    ? Colours.text_gray
                                    : Colours.text_normal)))),
                createLine(),
                createFormItem('联系电话',
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(phone == null ? '选择地址后自动填充' : phone,
                            style: TextStyle(
                                fontSize: 16,
                                color: phone == null
                                    ? Colours.text_gray
                                    : Colours.text_normal)))),
                createClassTitle('订单信息'),
                createFormItem(
                  '到货期限',
                  isRequired: true,
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        deadline == null ? "点击选择时间" : deadline,
                        style: TextStyle(
                            fontSize: 16,
                            color: deadline == null
                                ? Colours.text_gray
                                : Colours.text_normal),
                      ),
                    ),
                    onTap: () {
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          onConfirm: (date) {
                        setState(() {
                          deadline =
                              DateUtil.formatDate(date, format: 'yyyy-MM-dd');
                        });
                      },
                          minTime: DateTime.now(),
                          currentTime: deadline != null
                              ? DateUtil.getDateTime(deadline)
                              : DateTime.now(),
                          locale: LocaleType.zh);
                    },
                  ),
                ),
                createLine(),
                createFormItem('是否加急',
                    isRequired: true,
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: 1,
                            groupValue: urgent,
                            onChanged: (v) {
                              setState(() {
                                urgent = v;
                              });
                            }),
                        Text("是", style: TextStyle(color: Colours.text_normal)),
                        Radio(
                            value: 0,
                            groupValue: urgent,
                            onChanged: (v) {
                              setState(() {
                                urgent = v;
                              });
                            }),
                        Text("否", style: TextStyle(color: Colours.text_normal)),
                      ],
                    )),
                Container(
                  color: Colours.app_background_color,
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: new RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      '下一步',
                      style: TextStyle(
                          fontSize: Dimens.font_sp16, color: Colors.white),
                    ),
                    // 设置按钮圆角
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      var result = validator();
                      if (result != '200') {
                        Fluttertoast.showToast(msg: result);
                        return;
                      }
                      model.clientId = clientId;
                      model.patient = patientController.text;
                      model.addressId = addressId;
                      model.gender = gender;
                      if (ageController.text != null &&
                          ageController.text.isNotEmpty)
                        model.age = int.parse(ageController.text);
                      model.expectTime = deadline;
                      model.isUrgent = urgent;
                      model.opName = operationController.text;
                      model.opSite = operationSiteController.text;
                      model.opTime = operationTime;
                      model.remark = remarkController.text;
                      model.assets = selectedList;

                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => CreateOrderAddPage(),
                          settings: RouteSettings(arguments: model)));
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }

  ///创建form类别抬头
  Widget createClassTitle(String text) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity, //宽度尽可能大
      ),
      color: Colours.app_background_color,
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Text(
        text,
        style: TextStyle(
            color: Colours.app_text_three_color, fontSize: Dimens.font_sp16),
      ),
    );
  }

  ///创建form子项
  Widget createFormItem(String title,
      {String hint,
      readOnly = false,
      isRequired = false,
      TextEditingController controller,
      FormFieldValidator<String> validator,
      List<TextInputFormatter> formatter,
      TextInputType keyboardType,
      Widget child}) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: Dimens.font_sp16)),
            Offstage(
              offstage: !isRequired,
              child: Text(
                '\t*',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Container(
                      height: 37,
                      alignment: AlignmentDirectional.center,
                      child: child == null
                          ? TextFormField(
                              controller: controller != null
                                  ? controller
                                  : TextEditingController(),
                              keyboardType:
                                  keyboardType != null ? keyboardType : null,
                              textInputAction: TextInputAction.done,
                              readOnly: readOnly,
                              style: TextStyle(color: Colours.text_normal),
                              decoration: InputDecoration.collapsed(
                                  hintText: hint != null && hint.isNotEmpty
                                      ? hint
                                      : "请输入",
                                  hintStyle:
                                      TextStyle(color: Colours.text_gray)),
                              //折叠模式
                              validator: validator,
                              inputFormatters: formatter,
                            )
                          : child)),
            )
          ],
        ));
  }

  ///构建间隔线
  Line createLine() {
    return Line(lineColor: Colours.text_dark);
  }

  ///选择客户
  showClient() async {
    if (clientList == null) {
      await HttpUtils.put(Api.API_GET_CLIENT, params: Map(), success: (value) {
        if (value['code'] == '200') {
          clientList = value['rows'];
        }
      }, showProgress: true, context: context, showError: true);
    }

    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: clientList.length,
          separatorBuilder: (BuildContext context, int index) {
            return createLine();
          },
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(clientList[index]['clientName']),
              onTap: () {
                setState(() {
                  client = clientList[index]['clientName'];

                  //切换客户不同则清空地址
                  if (clientId != clientList[index]['clientId']) {
                    address = null;
                    addressId = null;
                    taker = null;
                  }

                  clientId = clientList[index]['clientId'];

                  Navigator.of(context).pop(index);
                });
              },
            );
          },
        );
      },
    );
  }

  ///地址选择弹窗
  showAddress() async {
    if (clientId == null) {
      Fluttertoast.showToast(msg: '请选择客户');
      return null;
    }

    Map map = Map();
    map['clientId'] = clientId;

    await HttpUtils.put(Api.API_CLIENT_SHIP_ADDRESS, params: map,
        success: (value) {
      if (value['code'] == '200') {
        addressList = value['rows'];
      }
    }, showProgress: true, context: context, showError: true);

    if (addressList == null || addressList.length == 0) {
      return Fluttertoast.showToast(msg: '该客户没有设置收货地址！');
    }

    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: addressList.length,
          separatorBuilder: (BuildContext context, int index) {
            return createLine();
          },
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(addressList[index]['address']),
              onTap: () {
                setState(() {
                  address = addressList[index]['address'];
                  addressId = addressList[index]['addressId'];
                  taker = addressList[index]['receiver'];

                  String phone = addressList[index]['phone'];
                  String mobile = addressList[index]['mobile'];
                  String show;
                  if (phone != null && phone.isNotEmpty) {
                    show = phone;
                  }
                  if (mobile != null && mobile.isNotEmpty) {
                    show = mobile;
                  }
                  if (phone != null &&
                      phone.isNotEmpty &&
                      mobile != null &&
                      mobile.isNotEmpty) {
                    show = phone + "/" + mobile;
                  }

                  this.phone = show;
                  Navigator.of(context).pop(index);
                });
              },
            );
          },
        );
      },
    );
  }

  String validator() {
    if (operationSiteController.text == null ||
        operationSiteController.text.isEmpty) {
      return '请填写手术部位';
    }
    if (operationTime == null || operationTime.isEmpty) {
      return '请选择手术时间';
    }
    if (clientId == null) {
      return '请选择客户';
    }
    if (addressId == null) {
      return '请选择收货地址';
    }
    if (deadline == null || deadline.isEmpty) {
      return '请选择到货期限';
    }
    return '200';
  }
}
