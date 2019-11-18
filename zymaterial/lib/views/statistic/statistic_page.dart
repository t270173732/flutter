import 'package:fl_chart/fl_chart.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/data/model/statistic/statistic_model.dart';
import 'package:zymaterial/res/colors.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:zymaterial/widgets/custom_flexible_space_bar.dart';
import 'package:zymaterial/widgets/line.dart';
import 'package:zymaterial/widgets/select_text.dart';

class StatisticPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StatisticPageWidgetState();
  }
}

//purOrderIndex/workStatistical
class StatisticPageWidgetState extends State<StatisticPageWidget>
    with AutomaticKeepAliveClientMixin {
  var selectedIndex = 1; //筛选栏下标1开始
  var firstDate = (DateTime.now()).subtract(Duration(days: 7));
  var lastDate = DateTime.now();
  List<DateTime> picked;
  List<String> pickedTimeList = List();

  List<FlSpot> spotsOne = [FlSpot(0, 0)], spotsTwo = [FlSpot(0, 0)]; //chart数据
  List<String> timeListOne = List(), timeListTwo = List(); //X轴显示数据
  double maxYOne = 1, maxYTwo = 1;
  bool offSecondChart = true; //T-隐藏 F-显示

  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Text(''),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            expandedHeight: 100.0,
            pinned: true,
            flexibleSpace: CustomFlexibleSpaceBar(
              background: Image.asset(
                'images/statistic/statistic_bg.png',
                fit: BoxFit.cover,
              ),
              centerTitle: true,
              titlePadding:
                  EdgeInsetsDirectional.only(start: 16.0, bottom: 14.0),
              collapseMode: CollapseMode.pin,
              title: Text(
                "数据走势",
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
                DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'images/statistic/statistic_bg1.png',
                          ),
                          fit: BoxFit.fill)),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'images/common/icon_rectangle_corner.png',
                            ),
                            fit: BoxFit.fill)),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          createSelectedText("一周", 1),
                          createLine(),
                          createSelectedText("一个月", 2),
                          createLine(),
                          createSelectedText("半年", 3),
                          createLine(),
                          createSelectedText("一年", 4),
                          createLine(),
                          createSelectedText("自定义", 5),
                        ],
                      ),
                    ),
                  ),
                ),
                50),
          ),
          SliverToBoxAdapter(
            // 让内容显示在安全区域内
            child: Padding(
              // 添加内边距
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  createContain(
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: createChart(true),
                    ),
                  ),
                  Offstage(
                    offstage: offSecondChart,
                    child: createContain(
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: createChart(false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///构建条件筛选行
  Expanded createSelectedText(String title, int index) {
    return Expanded(
      child: SelectedText(
        title,
        fontSize: 15.0,
        selected: selectedIndex == index,
        unSelectedTextColor: Colours.text_normal,
        onTap: () async {
          if (selectedIndex == index) {
            return;
          }
          setState(() {
            selectedIndex = index;
          });
          if (index == 5) {
            clickCustomTime();
          } else {
            requestData();
          }
        },
      ),
      flex: 1,
    );
  }

  ///构建间隔线
  Line createLine() {
    return Line(direction: Axis.vertical, lineColor: Colours.text_dark);
  }

  ///创建容器
  Widget createContain(Widget child) {
    return ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: double.infinity, //宽度尽可能大
            minHeight: 200 //最小高度为200像素
            ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: child,
        ));
  }

  ///构建图表
  Widget createChart(bool isFirst) {
    // 请求成功，显示数据
    return LineChart(
      LineChartData(
          //线形图属性
          lineTouchData: LineTouchData(enableNormalTouch: false),
          lineBarsData: [
            LineChartBarData(
              spots: isFirst ? spotsOne : spotsTwo,
              //T-曲线 F-直线
              isCurved: true,
              //线宽
              barWidth: 1,
              //线的颜色
              colors: isFirst
                  ? [
                      Colors.lightBlueAccent,
                      Colors.blue,
                    ]
                  : [Colors.redAccent, Colors.red],
              //点的属性
              dotData: FlDotData(
                dotColor: isFirst
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.red.withOpacity(0.5),
                show: isFirst
                    ? (spotsOne.length == 1 && spotsOne[0].y == 0
                        ? false
                        : true)
                    : (spotsTwo.length == 1 && spotsTwo[0].y == 0
                        ? false
                        : true),
                dotSize: 4,
              ),
            ),
          ],
          minY: 0,
          maxY: isFirst ? maxYOne : maxYTwo,
          minX: 0,
          maxX: isFirst
              ? timeListOne.length == 0 ? 1 : timeListOne.length.toDouble()
              : timeListTwo.length == 0 ? 1 : timeListTwo.length.toDouble(),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    //X轴title颜色
                    fontWeight: FontWeight.bold),
                getTitles: (value) {
                  var i = value.toInt();
                  var timeList = isFirst ? timeListOne : timeListTwo;
                  if (timeList.length > 10 && i % 2 == 0)
                    return ""; //数据过多时不全部显示
                  if (timeList.length > 0 && i < timeList.length) {
                    var time = DateUtil.getDateTime(timeList[i]);
                    var timeStr = DateUtil.formatDate(time, format: 'M月d日');
                    return timeStr;
                  } else {
                    return "";
                  }
                }),
            leftTitles: SideTitles(
              margin: 20,
              //Y轴
              reservedSize: 3,
              showTitles: true,
              getTitles: (value) {
                return '${value.toInt()}';
              },
            ),
          ),
          gridData: FlGridData(
            //网格
            show: false,
          ),
          borderData: FlBorderData(
              //边框，只绘制X轴和Y轴
              border: Border(
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  left: BorderSide(),
                  bottom: BorderSide()))),
    );
  }

  ///点击自定义时弹窗
  void clickCustomTime() async {
    picked = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: firstDate,
      initialLastDate: lastDate,
      firstDate: DateTime(DateTime.now().year - 3),
      //只取到3年前
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      if (picked.length > 1) {
        firstDate = picked[0];
        lastDate = picked[1];
        pickedTimeList
            .add(DateUtil.formatDate(firstDate, format: "yyyy-MM-dd"));
        pickedTimeList.add(DateUtil.formatDate(lastDate, format: "yyyy-MM-dd"));
        print('${DateUtil.formatDate(firstDate, format: "yyyy-MM-dd")}'
            '~${DateUtil.formatDate(lastDate, format: "yyyy-MM-dd")}');
        requestData();
      } else {
        Fluttertoast.showToast(msg: "请选择时间区间");
      }
    }
  }

  ///初始化
  @override
  void initState() {
    super.initState();
    //首次加载加入延迟，以加载context
    Future.delayed(Duration(milliseconds: 100), () {
      requestData();
    });
  }

  ///数据请求
  void requestData() async {
    //	queryType:5,
    //	queryTime:["2019-03-30","2019-10-1"]

    Map map = Map();
    map['queryType'] = selectedIndex;
    map['queryTime'] = pickedTimeList;

    //{"rows":[[{"num":1,"orderDate":"2019-09-30"},{"num":1,"orderDate":"2019-09-30"}],[]],"total":2,"code":"200","msg":"请求成功","serverIp":"192.168.0.110","timestamp":157}
    //配送员有两个数组，第一个是配送，第二个是返仓
    await HttpUtils.put(Api.API_STATISTIC, params: map, success: (value) {
      if (value != null && value['code'] == '200') {
        if (value['rows'] != null && value['rows'].length > 0) {
          List mapOne = value['rows'][0];
          convert(0, mapOne);
          List mapTwo = value['rows'][1];
          convert(1, mapTwo);
        }
      }
      //spots
    }, showProgress: true, context: context, showError: true);
  }

  ///数据转换
  void convert(int index, List map) {
    List<FlSpot> spots = index == 0 ? spotsOne : spotsTwo;
    List<String> timeList = index == 0 ? timeListOne : timeListTwo;
    double maxY = index == 0 ? maxYOne : maxYTwo;

    spots.clear();
    timeList.clear();

    List list = List();
    //解析
    for (int i = 0; i < map.length; i++) {
      StatisticRow item = StatisticRow.fromJson(map[i]);
      list.add(item);
    }
    //遍历
    for (int i = 0; i < list.length; i++) {
      var curNum = list[i].num.toDouble();
      if (curNum >= maxY) maxY = curNum * 2;
      FlSpot item = FlSpot((spots.length).toDouble(), curNum);
      spots.add(item);
      timeList.add(list[i].orderDate);
    }
    if (spots.length == 0) {
      spots.insert(0, FlSpot(0, 0));
      maxY = 1;
    }

    //重新赋值，刷新页面
    setState(() {
      if (index == 0) {
        spotsOne = spots;
        timeListOne = timeList;
        maxYOne = maxY;
      } else {
        spotsTwo = spots;
        timeListTwo = timeList;
        maxYTwo = maxY;
        offSecondChart = timeListTwo.length == 0;
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;

  SliverAppBarDelegate(this.widget, this.height);

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
