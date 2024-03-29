import 'package:flustars/flustars.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zymaterial/common/global.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zymaterial/common/totast.dart';
import 'package:zymaterial/res/index.dart';

import '../../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = ''; //用户名
  var _username = ''; //密码
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  @override
  void initState() {
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {
      // print(_userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
    super.initState();

    _userNameController.text= prefix0.SpUtil.getString('account');
    _passwordController.text = prefix0.SpUtil.getString('password');
  }

  @override
  void dispose() {
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  /*
   * 验证用户名
   */
  String validateUserName(value) {
    if (value.isEmpty) {
      return '用户名不能为空!';
    }
    return null;
  }

  // 验证密码

  String validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    // logo 图片区域
    Widget logoImageArea = new Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          "images/logo.jpg",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );

    //输入文本框区域
    Widget inputTextArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          _userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value) {
                _username = value;
              },
            ),
            new TextFormField(
              controller: _passwordController,
              focusNode: _focusNodePassWord,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )),
              obscureText: !_isShowPwd,
              //密码验证
              validator: validatePassWord,
              //保存数据
              onSaved: (String value) {
                _password = value;
              },
            )
          ],
        ),
      ),
    );

    // 登录按钮区域
    Widget loginButtonArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 40.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "登录",
          // style: Theme.of(context).primaryTextTheme.headline,
          style: TextStyle(fontSize: Dimens.font_sp16,color: Colors.white),
        ),
        // 设置按钮圆角
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();

          if (_formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState.save();

            Map map = Map();
            map['account'] = _username;
            map['password'] = _password;
            HttpUtils.post(
              Api.API_Login_URL,
              params: map,
              success: (res) {
                if (res['code'] == '200') {
                  // Fluttertoast.showToast(msg: '登录成功!');
                  HelperToast().showCenterToast('登录成功!');
                  prefix0.SpUtil.putString('Authorization', res['data']['Authorization']);
                  prefix0.SpUtil.putString('account', _username);
                  prefix0.SpUtil.putString('password', _password);
                  prefix0.SpUtil.putObject(Global.accountInfo, res["data"]);
                  HttpUtils.setToken(res['data']['Authorization']);

                  //跳转并关闭当前页面
                  Navigator.pushAndRemoveUntil(
                    context,
                    new CupertinoPageRoute(
                        builder: (context) => new BottomNavigationWidget()),
                        (route) => route == null,
                  );
                }else{
                  Fluttertoast.showToast(msg: res['msg']);
                }
              },
              failure: (exception) {
                print(exception);
              },
              showProgress: true,
              context: context,
              text: '登录中……'
            );
          }
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
        },
        child: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new SizedBox(
              height: ScreenUtil().setHeight(80),
            ),
            logoImageArea,
            new SizedBox(
              height: ScreenUtil().setHeight(70),
            ),
            inputTextArea,
            new SizedBox(
              height: ScreenUtil().setHeight(80),
            ),
            loginButtonArea,
          ],
        ),
      ),
    );
  }
}
