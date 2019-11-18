import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart' as prefix0;
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymaterial/data/model/even/event_model.dart';
import 'package:zymaterial/views/home/deliveryStaff/distributionOrderDetail_page.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';

class ConsumeTake extends StatefulWidget {
  @override
  _ConsumeTakeState createState() => _ConsumeTakeState();
}

class _ConsumeTakeState extends State<ConsumeTake> {
  _ConsumeTakeState() {
    //全局事件
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }
  var reason = '';
  List _dataSource = List();
  static ScrollController _scrollController = ScrollController();
  int _page = 1; //请求第几页数据，用于分页请求数据
  static bool _haveMore = true; //是否还有更多的数据可以请求

  FocusNode _focusNodeInput = new FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      requestData();
    });

    //监听订单刷新事件
    ApplicationEvent.event.on<OrderRefreshEvent>().listen((event) {
      Future.delayed(Duration(seconds: 1), () {
        requestData();
      });
    });

    //监听滚动条的滚动事件
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //当还有更多数据的时候才会进行加载新数据
        if (_haveMore) {
          _page++;
          requestData();
        }
      }
    });
    setState(() {});
  }

  void requestData({bool showProgress = true}) async {
    Map map = Map();
    map['followUser'] = prefix0.SpUtil.getString('account');
    map['pageSize'] = 10;
    map['current'] = this._page;
    // map['offset'] = (_page - 1) * 10;

    await HttpUtils.put(Api.API_ORDER_BY_CONSUME,
        params: map,
        showProgress: showProgress,
        context: context,
        showError: true, success: (res) {
      print(res);
      if (res['code'] == '200') {
        List resultList = res['rows'];
        // if (_dataSource.length == 0) {
        //   //第一次加载或者下拉加载
        //   _dataSource = resultList;
        // } else {
        //   //上拉刷新（将新加载的数据拼接到原来的数据数组中）
        //   // for (int i = 0; i < resultList.length; i++) {
        //   //   _dataSource.add(resultList[i]);
        //   // }

        // }
        if (_page == 1) {
          //第一次加载或者下拉加载
          _dataSource.clear();
          _dataSource = resultList;
        } else {
          //上拉刷新（将新加载的数据拼接到原来的数据数组中）
          _dataSource.addAll(resultList);
        }

        /**
           * 这里根据当前返回的数组长度是否小于pagesize来判断接下来是否还有更多数据
           * 这里的pagesize是10
           */
        // if (resultList.length < 10) {
        //   _haveMore = false;
        // }

        res["pages"] <= this._page ? _haveMore = false : _haveMore = true;

        if (mounted) {
          setState(() {});
        }
      } else {
        Fluttertoast.showToast(msg: res['msg']);
      }
    }, failure: (err) {});
  }

  //下拉刷新
  Future<void> _refreshData() async {
    _page = 1;
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('跟台任务管理'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      // body: takeListView,
      body: _dataSource.length == 0
          ? Center(
              child: Text('暂无内容'),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: _dataSource.length,
                itemBuilder: (context, index) {
                  return _takeListView(_dataSource, index);
                },
              ),
            ),
    );
  }

  Widget _takeListView(List _dataSource, int index) {
    if (index == _dataSource.length - 1) {
      return Column(
        children: <Widget>[
          _itemContainerView(_dataSource, index),
          _loadMoreWidget()
        ],
      );
    } else {
      return _itemContainerView(_dataSource, index);
    }
  }

  Widget _itemContainerView(List _dataSource, int index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(bottom: 5.0),
      child: Column(
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
                    child: Image.asset("images/common/icon_rectangle1.png"),
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
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: _dataSource[index]["ordId"].toString(),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
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
                        text: "客户: ",
                        style: TextStyle(
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: ZYHelper().avoidNullString(
                            _dataSource[index]["clientName"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
                      )
                    ]))),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "创建人: ",
                        style: TextStyle(
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: ZYHelper().avoidNullString(
                            _dataSource[index]["followUsername"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
                      )
                    ]))),
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
                        text: "手术名称: ",
                        style: TextStyle(
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: ZYHelper().avoidNullString(
                            _dataSource[index]["opName"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
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
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: ZYHelper().avoidNullString(
                            _dataSource[index]["opSite"].toString()),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
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
                        text: "手术时间: ",
                        style: TextStyle(
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: DateUtil.formatDate(
                            DateUtil.getDateTime(ZYHelper().avoidNullString(
                                _dataSource[index]["opTime"].toString())),
                            format: "yyyy-MM-dd"),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
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
                            color: Colours.app_text_one_color, fontSize: 14),
                      ),
                      TextSpan(
                        text: DateUtil.formatDate(
                            DateUtil.getDateTime(ZYHelper().avoidNullString(
                                _dataSource[index]["createTime"].toString())),
                            format: "yyyy-MM-dd"),
                        style: TextStyle(
                            color: Colours.app_text_three_color, fontSize: 14),
                      )
                    ]))),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 0, 0),
            child: Text(
                DateUtil.formatDate(
                        DateUtil.getDateTime(ZYHelper().avoidNullString(
                            _dataSource[index]["opTime"].toString())),
                        format: "yyyy-MM-dd") +
                    '进行${_dataSource[index]['opName']}手术',
                style: TextStyle(
                    fontSize: Dimens.font_sp14,
                    color: Colours.app_text_three_color)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
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
                                color: Color(0xFF3a72ff), fontSize: 14),
                          ),
                        )),
                  ),
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => DistributionOrderDetailPage(
                            orderId: _dataSource[index]['ordId'],
                            orderDeliverType: 1,
                            fromPage: 'consume')));
                  },
                ),
              ),
              _dataSource[index]['status'] == 1
                  ? Padding(
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
                          showRejectDialog(_dataSource[index]['ordId']);
                        },
                      ),
                    )
                  : Text(''),
              _dataSource[index]['status'] == 1
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
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
                          showAcceptDialog(_dataSource[index]['ordId']);
                        },
                      ),
                    )
                  : Text(''),
              _dataSource[index]['status'] == 2
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              )),
                        ),
                        onTap: () {},
                      ),
                    )
                  : Text(''),
              // _dataSource[index]['status'] == 0 &&
              //         _dataSource[index]['reason'] != null
              //     ? Container(
              //         margin: EdgeInsets.only(top: 5.0, right: 5.0),
              //         padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              //         decoration: BoxDecoration(
              //             border: Border.all(width: 1, color: Colors.grey[400]),
              //             borderRadius: BorderRadius.all(Radius.circular(6.0))),
              //         child: Text('已拒绝',
              //             style: TextStyle(color: Colors.grey[400])),
              //       )
              //     : Text(''),
            ],
          )
        ],
      ),
    );
  }

  // 弹出对话框
  Future showAcceptDialog(int ordId) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("确定接受该订单的跟台任务吗?"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消", style: TextStyle(color: Colours.text_gray)),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("接受"),
              onPressed: () {
                //关闭对话框并返回true
                // Navigator.of(context).pop();
                Map map = Map();
                map['ordId'] = ordId;
                map['status'] = 2;

                HttpUtils.post(
                  Api.API_CONSUME_RECEPT_TAKE,
                  params: map,
                  success: (res) {
                    print(res);
                    if (res['code'] == '200') {
                      Navigator.of(context).pop();
                      _page = 1;
                      _dataSource = [];
                      setState(() {});
                      requestData();
                      ApplicationEvent.event.fire(OrderRefreshEvent());
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future showRejectDialog(int ordId) {
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
              child: Text(
                "拒绝",
                style: TextStyle(color: Colors.red[300]),
              ),
              onPressed: () {
                //关闭对话框并返回true
                // Navigator.of(context).pop(true);
                _focusNodeInput.unfocus();
                if (_formKey.currentState.validate()) {
                  //只有输入通过验证，才会执行这里
                  _formKey.currentState.save();
                  Map map = Map();
                  map['ordId'] = ordId;
                  map['status'] = 0;
                  map['reason'] = reason;

                  HttpUtils.post(
                    Api.API_CONSUME_RECEPT_TAKE,
                    params: map,
                    success: (res) {
                      if (res['code'] == '200') {
                        Navigator.of(context).pop();
                        _page = 1;
                        _dataSource = [];
                        setState(() {});
                        requestData();
                        ApplicationEvent.event.fire(OrderRefreshEvent());
                      }
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  //加载中的圈圈
  static Widget _loadMoreWidget() {
    if (_haveMore) {
      //还有更多数据可以加载
      // return Center(
      //   child: Padding(
      //     padding: EdgeInsets.all(10.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: <Widget>[
      //         CircularProgressIndicator(
      //           strokeWidth: 2.0,
      //         ),
      //         SizedBox(
      //           height: 10,
      //         ),
      //         Text('加载中......')
      //       ],
      //     ),
      //   ),
      // );
      return Center(
        child: Text(
          '--上拉加载更多--',
          style: TextStyle(color: Colours.app_text_three_color),
        ),
      );
    } else {
      //当没有更多数据可以加载的时候，
      return Center(
        child: Text(
          '--我也是有底线的--',
          style: TextStyle(color: Colours.app_text_three_color),
        ),
      );
    }
  }
}
