import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zymaterial/res/index.dart';
import 'dart:async';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';
import 'package:zymaterial/widgets/photo_view_pager.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zymaterial/widgets/num_edit.dart';
// import 'package:zymaterial/widgets/loading_view.dart';
import 'package:zymaterial/common/totast.dart';

class ConsumeDetailView extends StatefulWidget {
  ConsumeDetailView({Key key, @required this.ordId}) : super(key: key);
  final ordId;

  @override
  _ConsumeDetailViewState createState() => _ConsumeDetailViewState();
}

class _ConsumeDetailViewState extends State<ConsumeDetailView> {
  List _dataSource = List();
  var _orderDetail;
  List _numList = List();
  List _chooseList = List();
  List<Asset> selectedList = List();

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      requestData();
    });
  }

  void requestData({bool showProgress = true}) async {
    Map map = Map();
    map['ordId'] = widget.ordId;

    await HttpUtils.put(
      Api.API_DELIVER_ORDER_DETAIL,
      params: map,
      showProgress: showProgress,
      context: context,
      showError: true,
      success: (res) {
        print(res);
        if (res['code'] == '200') {
          if (mounted) {
            setState(() {
              _dataSource = res['data']['details'];
              _dataSource.forEach((item) {
                _numList.add(item['deliverAmt']);
              });
              _orderDetail = res['data'];
            });
          }
        } else {
          Fluttertoast.showToast(msg: res['msg']);
        }
      },
    );
  }

  void dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
        appBar: GradientAppBar(
          title: Text('清台明细'),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[100],
        body: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            PhotoGrid(
              selectedList,
              (v) {
                selectedList = v;
              },
              maxCount: 9,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _dataSource.length,
              itemBuilder: (context, index) {
                return _mtlListView(_dataSource, _chooseList, index);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(120),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FlatButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            child: Container(
              width: MediaQuery.of(context).size.width - 80,
              child: Text(
                "确认消耗",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontSize: Dimens.font_sp16),
              ),
            ),
            onPressed: () {
              // if(_chooseList.length == 0){
              //   Fluttertoast.showToast(msg: '请选择剩余耗材!');
              //   return;
              // }
              postForm();
            },
          ),
        ));
  }

  Widget _mtlListView(List _dataSource, List _chooseList, int index) {
    var _num = _numList[index];
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 5.0),
      // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          // Container(
          //   width: 50,
          //   child: Center(
          //     child: Checkbox(
          //       value: _chooseList.contains(index),
          //       activeColor: Colors.blue, //选中时的颜色
          //       onChanged: (value) {
          //         _chooseList.contains(index)
          //             ? _chooseList.remove(index)
          //             : _chooseList.add(index);

          //         setState(() {});
          //       },
          //     ),
          //   ),
          // ),
          Container(
            // width: MediaQuery.of(context).size.width - 50,
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('耗材名称：', style: TextStyle(fontSize: Dimens.font_sp16)),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Text('${_dataSource[index]['mtlName']}',
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: Dimens.font_sp16,
                              color: Colours.app_text_three_color)),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Row(
                  children: <Widget>[
                    Text('厂商：', style: TextStyle(fontSize: Dimens.font_sp16)),
                    Text(
                        _dataSource[index]['factoryName'] != null
                            ? _dataSource[index]['factoryName']
                            : '',
                        style: TextStyle(
                            fontSize: Dimens.font_sp16,
                            color: Colours.app_text_three_color))
                  ],
                ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //         flex: 1,
                //         child: Text(
                //           "厂商:${_dataSource[index]['factoryName']}",
                //           style: TextStyle(
                //               color: Colours.app_text_three_color,
                //               fontSize: Dimens.font_sp14),
                //         )),
                //     Expanded(
                //         flex: 1,
                //         child: Text(
                //           "产品类型:XXX",
                //           style: TextStyle(
                //               color: Colours.app_text_three_color,
                //               fontSize: Dimens.font_sp14),
                //         ))
                //   ],
                // ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text.rich(TextSpan(
                          style: TextStyle(fontSize: Dimens.font_sp14),
                          children: [
                            TextSpan(
                              text: '规格：',
                            ),
                            TextSpan(
                              text: _dataSource[index]['spec'] != null
                                  ? _dataSource[index]['spec']
                                  : '',
                              style: TextStyle(
                                  color: Colours.app_text_three_color),
                            )
                          ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text.rich(TextSpan(
                          style: TextStyle(fontSize: Dimens.font_sp14),
                          children: [
                            TextSpan(
                              text: '单位：',
                            ),
                            TextSpan(
                              text: _dataSource[index]['unitName'] != null
                                  ? _dataSource[index]['unitName']
                                  : '',
                              style: TextStyle(
                                  color: Colours.app_text_three_color),
                            )
                          ])),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text.rich(TextSpan(
                          style: TextStyle(fontSize: Dimens.font_sp14),
                          children: [
                            TextSpan(
                              text: '配送数量：',
                            ),
                            TextSpan(
                              text: '${_dataSource[index]['deliverAmt']}',
                              style: TextStyle(
                                  color: Colours.app_text_three_color),
                            )
                          ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "剩余数量：",
                              style: TextStyle(fontSize: Dimens.font_sp14),
                            ),
                            NumberEditText(
                              (i) {
                                _numList[index] = i;
                                setState(() {});
                              },
                              num: _num,
                              size: NumberEditSize.small,
                              maxNum: _dataSource[index]['deliverAmt'],
                              minNum: 0,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void postForm() {
    if (_dataSource.length == 0) {
      Fluttertoast.showToast(msg: '没有数据提交!');
      return;
    }
    List _mtlList = _dataSource;
    for (int i = 0; i < _mtlList.length; i++) {
      _mtlList[i]['consumeAmt'] = _mtlList[i]['deliverAmt'] - _numList[i];
    }
    var _params = _orderDetail;
    _params['details'] = _mtlList;

    if (selectedList.length == 0) {
      postConfirm(_params);
    } else {
      HttpUtils.uploadFile(Api.API_UPLOAD_FILE,
          assetList: selectedList,
          showProgress: true,
          context: context, success: (v) {
        if (v['code'] == '200') {
          List list = v['rows'];
          _params['fileList'] = list;
          postConfirm(_params);
        }
      });
    }
  }

  void postConfirm(_params) {
    HttpUtils.post(Api.API_CONFIRM_USE, params: _params, success: (res) {
      if (res['code'] == '200') {
        // Fluttertoast.showToast(msg: '成功！');
        HelperToast().showCenterToast('成功!');
        Navigator.pop(context, '200');
      } else {
        Fluttertoast.showToast(msg: res['msg']);
      }
    }, showProgress: true, context: context);
  }
}
