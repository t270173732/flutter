import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zymaterial/common/zyHelper.dart';
import 'package:zymaterial/data/model/even/event_model.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/views/home/consume/consumeDetail.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:flustars/flustars.dart' as prefix0;
import 'package:zymaterial/widgets/gradient_app_bar.dart';
// import 'package:zymaterial/widgets/loading_view.dart';

class ConsumeMgtView extends StatefulWidget {
  @override
  _ConsumeMgtViewState createState() => _ConsumeMgtViewState();
}

class _ConsumeMgtViewState extends State<ConsumeMgtView> {
  List _dataSource = List();
  ScrollController _scrollController = ScrollController();
  int _page = 1; //请求第几页数据，用于分页请求数据
  static bool _haveMore = true; //是否还有更多的数据可以请求

  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      requestData(false);
    });
    //监听滚动条的滚动事件
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //当还有更多数据的时候才会进行加载新数据
        if (_haveMore) {
          this._page++;
          requestData(false);
        }
      }
    });
  }

  void requestData(flag) async {
    if (flag) {
      _page = 1;
      if (mounted) {
        setState(() {});
      }
    }
    Map map = Map();
    map['account'] = prefix0.SpUtil.getString('account');
    map['pageSize'] = 10;
    map['current'] = this._page;
    // map['offset'] = (_page - 1) * 10;
    map['isCompleted'] = true;

    await HttpUtils.put(Api.API_ORDER_BY_CONSUME,
        params: map,
        showProgress: true,
        context: context,
        showError: true, success: (res) {
      print(res);
      if (res['code'] == '200') {
        List resultList = res['rows'];
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
        
        res["pages"] <= this._page ? _haveMore = false :_haveMore = true;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('清台管理'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      // ProgressDialog(loading: loading,msg: '加载中...',)
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
                  return _orderListView(_dataSource, index);
                },
              ),
            ),
    );
  }

  Widget _orderListView(List _dataSource, int index) {
    if (index == _dataSource.length - 1) {
      return Column(
        children: <Widget>[
          _itemContainerView(_dataSource, index),
          _loadMoreWidget()
        ],
      );
    }
    //  else {
    //   return _itemContainerView(_dataSource, index);
    // }
  return _itemContainerView(_dataSource, index);

      

  }

  Widget _itemContainerView(List _dataSource, int index) {
    var timeValue =
        DateTime.parse(_dataSource[index]['opTime'].toString().substring(0, 10))
                .millisecondsSinceEpoch -
            DateTime.parse(DateTime.now().toString().substring(0, 10))
                .millisecondsSinceEpoch;
    print(DateTime.parse(DateTime.now().toString().substring(0, 10))
        .millisecondsSinceEpoch);
    // List _statusValue = ['已接受', '消耗确认', '提交返仓'];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 10.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              timeValue <= 0 && _dataSource[index]['status'] == 2
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Container(
                              color: Color(0xFF4b82fb),
                              height: 34,
                              width: 76,
                              child: Center(
                                child: Text(
                                  "清台",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              )),
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => ConsumeDetailView(
                                  ordId: _dataSource[index]['ordId'])));
                          requestData(true);
                          ApplicationEvent.event.fire(OrderRefreshEvent());
                        },
                      ),
                    )
                  : _dataSource[index]['status'] != 3
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Container(
                                color: Colors.grey,
                                height: 34,
                                width: 76,
                                child: Center(
                                  child: Text(
                                    "未到时间",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                )),
                          ),
                        )
                      : Text('')
            ],
          ),
        ],
      ),
    );
  }

  //下拉刷新
  Future<void> _refreshData() async {
    this._page = 1;
    requestData(false);
  }

  //加载中的圈圈
   Widget _loadMoreWidget() {
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
