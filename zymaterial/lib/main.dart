import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymaterial/res/index.dart';
import 'package:zymaterial/views/home/home_page.dart';
import 'data/model/even/event_model.dart';
import 'utils/service_locator.dart';
import 'views/statistic/statistic_page.dart';
import './views/mine/mine_page.dart';
import 'package:zymaterial/views/login/login_page.dart';

void main() async {
  await SpUtil.getInstance(); //初始化SP工具
  setupLocator(); //初始化容器
  initConfiguration(); //初始化配置
  runApp(MyApp());

  if (Platform.isAndroid) {
    //Android端的沉浸式状态栏
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<NavigateService>().key,
      //获取navigate，绑定GlobalKey
      title: 'Flutter Demo',
      initialRoute: 'login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "login": (context) => LoginPage(), //登录路由
        "home": (context) => BottomNavigationWidget()
      },
      //国际化代理
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'), // 中文简体
      ],
    );
  }
}

class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BottomNavigationWidgetState();
  }
}

//底部导航栏
class BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with SingleTickerProviderStateMixin {
  BottomNavigationWidgetState() {
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }
  int _currentIndex = 0;
  int homeClickCount = 0; //主页点击次数
  List<Widget> pages = new List();

  DateTime lastPressedTime; //上次点击时间

  DateTime homePressedTime = DateTime.now(); //主页点击时间

  PageController _controller;

  @override
//initState是初始化函数，在绘制底部导航控件的时候就把这3个页面添加到list里面用于下面跟随标签导航进行切换显示
  void initState() {
    super.initState();
    pages
      ..add(HomePageWidget())
      ..add(StatisticPageWidget())
      ..add(MinePageWidget());

    _controller = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_currentIndex != 0) {
            //如果没有在主页，点击返回键则是返回主页
            setState(() {
              _currentIndex = 0;
            });
            return false;
          }

          if (lastPressedTime == null ||
              DateTime.now().difference(lastPressedTime) >
                  Duration(seconds: 1)) {
            Fluttertoast.showToast(msg: '再次点击返回键退出');
            //两次点击间隔超过1秒则重新计时
            lastPressedTime = DateTime.now();
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: PageView.builder(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  if (_currentIndex != index) _currentIndex = index;
                });

                // 主页点击超过2次 或者 时间超过5分钟 刷新
                if (index == 0) {
                  homeClickCount++;
                  if (homeClickCount >= 2 ||
                      DateTime.now().difference(homePressedTime).inMinutes >
                          5) {
                    ApplicationEvent.event.fire(OrderRefreshEvent());
                    homeClickCount = 0;
                    homePressedTime = DateTime.now();
                  }
                }
              },
              itemCount: pages.length,
              itemBuilder: (context, index) => pages[index]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            //点击选择
            onTap: (int i) {
              _controller.jumpToPage(i);
            },
            items: [
              BottomNavigationBarItem(
                title: new Text("主页"),
                icon: Image.asset(
                  'images/main/icon_home.png',
                ),
                activeIcon: Image.asset(
                  'images/main/icon_home_pre.png',
                ),
              ),
              BottomNavigationBarItem(
                title: new Text("统计"),
                icon: Image.asset(
                  'images/main/icon_statistics.png',
                ),
                activeIcon: Image.asset(
                  'images/main/icon_statistics_pre.png',
                ),
              ),
              BottomNavigationBarItem(
                title: new Text("我的"),
                icon: Image.asset(
                  'images/main/icon_my.png',
                ),
                activeIcon: Image.asset(
                  'images/main/icon_my_pre.png',
                ),
              )
            ],
          ),
        ));
  }
}

//初识化配置
void initConfiguration() {
  //高德
  //  AMap.init("8d64a7d162aa2ee4746df79a1107f2a2");
}
