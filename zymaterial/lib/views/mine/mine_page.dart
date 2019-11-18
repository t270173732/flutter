import 'package:flustars/flustars.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zymaterial/common/global.dart';
import 'package:zymaterial/data/api/net.dart';
import 'package:zymaterial/res/index.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/utils/service_locator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zymaterial/utils/photo_util.dart';
import 'package:zymaterial/widgets/gradient_app_bar.dart';

class MinePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MinePageWidgetState();
  }
}

class MinePageWidgetState extends State<MinePageWidget>
    with AutomaticKeepAliveClientMixin {
  var birthday = DateTime.now().toString().substring(0, 10); //生日
  var phone = ''; //电话
  List sexSelectValue = ['未知', '男', '女'];
  int _sexValue = 0;
  var sex = ''; //性别
  var userName = '';
  var account = prefix0.SpUtil.getString('account');
  String avFile = '';
  List<Asset> imageList = List();

  FocusNode _focusNodeInput = new FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      requestData();
    });
  }

  void requestData({bool showProgress = true}) async {
    Map map = Map();
    map['account'] = prefix0.SpUtil.getString('account');

    await HttpUtils.put(
      Api.API_USER_INFO,
      params: map,
      showProgress: showProgress,
      context: context,
      showError: true,
      text: '加载中……',
      success: (res) {
        print(res);
        if (res['code'] == '200') {
          prefix0.SpUtil.putObject('userInfo', res['data']);
          print(prefix0.SpUtil.getObject('userInfo'));
          if (res['data']['birth'] != null) {
            birthday = res['data']['birth'].substring(0, 10);
          }
          if (res['data']['gender'] != null) {
            _sexValue = res['data']['gender'];
            sex = sexSelectValue[res['data']['gender']];
          }
          if (res['data']['phone'] != null) {
            phone = res['data']['phone'];
          }

          userName = res['data']['username'];
          if (res['data']['avatarUrl'] != null) {
            avFile = res['data']['avatarUrl'];
          }
          if (mounted) {
            setState(() {});
          }
        } else {
          Fluttertoast.showToast(msg: res['msg']);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget userNameArea = new Container(
      margin: EdgeInsets.all(25.0),
      child: new Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              imageList = [];
              imageList = await showGallery(context, maxSelected: 1);
              if (imageList.length == 0) {
                return;
              }
              print('$imageList + 1111111111111');
              var _params = {};
              _params['account'] = account;
              await HttpUtils.uploadFile(Api.API_UPLOAD_FILE,
                  assetList: imageList,
                  showProgress: true,
                  context: context, success: (v) async {
                if (v['code'] == '200') {
                  List list = v['rows'];
                  _params['avatarFile'] = list[0];
                  await HttpUtils.post(
                    Api.API_USER_INFO_UPDATE,
                    params: _params,
                    success: (res) {
                      if (res['code'] == '200') {
                        print(res);
                        avFile = list[0]['fileName'];
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                  );
                }
              });
            },
            child: CircleAvatar(
              radius: 38,
              backgroundColor: Colors.white,
              child: ClipOval(
                  child: avFile == ''
                      ? Image.asset(
                          "images/logo.jpg",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          image: Api.BASE_IMAGE_URL + avFile,
                          placeholder: "images/logo.jpg",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              height: 35.0,
              child: Text(userName,
                  style: TextStyle(
                      fontSize: Dimens.font_sp18, color: Colors.white)),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'login', (Route<dynamic> route) => false);
              })
        ],
      ),
    );

    Widget userSexArea = new Container(
      child: new Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('images/mine/icon_gender.png'),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey[300]))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('性别', style: TextStyle(fontSize: Dimens.font_sp16)),
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(sex == null ? '' : sex,
                              style: TextStyle(fontSize: Dimens.font_sp16)),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    void updateSex(value) async {
      Navigator.of(context).pop();

      Map map = Map();
      map['account'] = account;
      map['gender'] = value;

      await HttpUtils.post(
        Api.API_USER_INFO_UPDATE,
        params: map,
        showProgress: true,
        context: context,
        text: '更新中……',
        success: (res) {
          if (res['code'] == '200') {
            var userInfo = prefix0.SpUtil.getObject('userInfo');
            userInfo['sex'] = value;
            prefix0.SpUtil.putObject('userInfo', userInfo);
            _sexValue = value;
            sex = sexSelectValue[_sexValue];
            if (mounted) {
              setState(() {});
            }
          } else {
            Fluttertoast.showToast(msg: res['msg']);
          }
        },
      );
    }

    // 弹出对话框
    Future showSexDialog() {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile(
                    value: 0,
                    title: Text('未知'),
                    groupValue: _sexValue,
                    onChanged: (value) {
                      (context as Element).markNeedsBuild();
                      _sexValue = value;
                      updateSex(value);
                    },
                  ),
                  RadioListTile(
                    value: 1,
                    title: Text('男'),
                    groupValue: _sexValue,
                    onChanged: (value) {
                      (context as Element).markNeedsBuild();
                      _sexValue = value;
                      updateSex(value);
                    },
                  ),
                  RadioListTile(
                    value: 2,
                    title: Text('女'),
                    groupValue: _sexValue,
                    onChanged: (value) {
                      (context as Element).markNeedsBuild();
                      _sexValue = value;
                      updateSex(value);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget userBirthdayArea = new Container(
      child: new Row(
        children: <Widget>[
          Image.asset('images/mine/icon_birthday.png'),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey[300]))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('生日', style: TextStyle(fontSize: Dimens.font_sp16)),
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(birthday == null ? '' : birthday,
                              style: TextStyle(fontSize: Dimens.font_sp16)),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    Widget userPhoneArea = new Container(
      child: new Row(
        children: <Widget>[
          Image.asset('images/mine/icon_phone.png'),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey[300]))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('手机', style: TextStyle(fontSize: Dimens.font_sp16)),
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text(phone == null ? '' : phone,
                              style: TextStyle(fontSize: Dimens.font_sp16)),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    Future showPhoneDialog() {
      String validateInput(value) {
        if (value.isEmpty) {
          return '请填手机号';
        } else if (value.trim().length > 11 || value.trim().length < 11) {
          return '请输入正确手机号';
        }
        return null;
      }

      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("手机"),
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
                          initialValue: phone,
                          focusNode: _focusNodeInput,
                          keyboardType: TextInputType.number,
                          validator: validateInput,
                          onSaved: (String value) {
                            phone = value;
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
                child: Text(
                  "取消",
                  style: TextStyle(color: Colours.text_gray),
                ),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
              FlatButton(
                child: Text(
                  "确定",
                ),
                onPressed: () async {
                  //关闭对话框并返回true
                  // Navigator.of(context).pop(true);
                  _focusNodeInput.unfocus();
                  if (_formKey.currentState.validate()) {
                    //只有输入通过验证，才会执行这里
                    _formKey.currentState.save();
                    Map map = Map();
                    map['account'] = account;
                    map['phone'] = phone;
                    await HttpUtils.post(
                      Api.API_USER_INFO_UPDATE,
                      params: map,
                      showProgress: true,
                      context: context,
                      text: '更新中……',
                      success: (res) {
                        if (res['code'] == '200') {
                        } else {
                          phone = '';
                          Fluttertoast.showToast(msg: res['msg']);
                        }
                        Navigator.of(context).pop();
                        if (mounted) {
                          setState(() {});
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

    Widget resetPwdButtonArea = new Container(
      child: new Row(
        children: <Widget>[
          Image.asset('images/mine/icon_modify.png'),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey[300]))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('修改密码', style: TextStyle(fontSize: Dimens.font_sp16)),
                  Opacity(opacity: 0.6, child: Icon(Icons.chevron_right)),
                ],
              ),
            ),
          )
        ],
      ),
    );

    return Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top), //获取状态栏高度
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
              Colours.app_main_color,
              Colours.app_main_color_end,
            ])),
        child: Column(
          children: <Widget>[
            userNameArea,
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                color: Colours.app_background_color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showSexDialog();
                    },
                    child: userSexArea,
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context, showTitleActions: true,
                          onChanged: (date) {
                        // print('change $date');
                      }, onConfirm: (date) async {
                        print('confirm $date');
                        Map map = Map();
                        map['account'] = account;
                        map['birth'] = date.toString().substring(0, 10);

                        await HttpUtils.post(
                          Api.API_USER_INFO_UPDATE,
                          params: map,
                          showProgress: true,
                          context: context,
                          text: '更新中……',
                          success: (res) {
                            print(res);
                            if (res['code'] == '200') {
                              var userInfo =
                                  prefix0.SpUtil.getObject('userInfo');
                              userInfo['birth'] =
                                  date.toString().substring(0, 10);
                              prefix0.SpUtil.putObject('userInfo', userInfo);
                              if (mounted) {
                                setState(() {
                                  birthday = date.toString().substring(0, 10);
                                });
                              }
                            } else {
                              Fluttertoast.showToast(msg: res['msg']);
                            }
                          },
                        );
                      },
                          currentTime: DateTime.parse(birthday),
                          locale: LocaleType.zh);
                    },
                    child: userBirthdayArea,
                  ),
                  GestureDetector(
                    onTap: () {
                      showPhoneDialog();
                    },
                    child: userPhoneArea,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return ResetPwdView();
                      }));
                    },
                    child: resetPwdButtonArea,
                  ),
                ],
              ),
            )),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class ResetPwdView extends StatefulWidget {
  @override
  _ResetPwdViewState createState() => _ResetPwdViewState();
}

class _ResetPwdViewState extends State<ResetPwdView> {
  //焦点
  static FocusNode _focusNodeOldPwd = new FocusNode();
  static FocusNode _focusNodeNewPwd = new FocusNode();
  static FocusNode _focusNodeConfirmPwd = new FocusNode();

  //新密码输入框控制器，此控制器可以监听新密码输入框操作
  TextEditingController _newPwdController = new TextEditingController();
  TextEditingController _confirmPwdController = new TextEditingController();

  //表单状态
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static var oldPwd = ''; //原密码
  static var newPwd = ''; //新密码
  static var confirmPwd = ''; //确认密码

  @override
  void initState() {
    //设置焦点监听
    _focusNodeOldPwd.addListener(_focusNodeListener);
    _focusNodeNewPwd.addListener(_focusNodeListener);
    _focusNodeConfirmPwd.addListener(_focusNodeListener);

    _newPwdController.addListener(() {
      print(_newPwdController.text);
    });
    _confirmPwdController.addListener(() {
      print(_confirmPwdController.text);
    });

    if (mounted) {
      setState(() {});
    }
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeOldPwd.removeListener(_focusNodeListener);
    _focusNodeNewPwd.removeListener(_focusNodeListener);
    _focusNodeConfirmPwd.removeListener(_focusNodeListener);

    _newPwdController.dispose();
    _confirmPwdController.dispose();

    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeOldPwd.hasFocus) {
      oldPwd = '';
      print("旧密码获取焦点");
      // 取消密码框的焦点状态
      _focusNodeNewPwd.unfocus();
      _focusNodeConfirmPwd.unfocus();
    }
    if (_focusNodeNewPwd.hasFocus) {
      newPwd = '';
      print("新密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeOldPwd.unfocus();
      _focusNodeConfirmPwd.unfocus();
    }
    if (_focusNodeConfirmPwd.hasFocus) {
      confirmPwd = '';
      print("确认密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeNewPwd.unfocus();
      _focusNodeOldPwd.unfocus();
    }
  }

  static String validateOldPwd(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    }
    return null;
  }

  static String validateNewPwd(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 3) {
      return '密码长度必须大于3位';
    }
    return null;
  }

  static String validateConfirmPwd(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (newPwd != value) {
      return '两次密码不一致';
    }
    return null;
  }

  Widget pwdInputArea = new Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white),
    child: new Form(
      key: _formKey,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            focusNode: _focusNodeOldPwd,
            decoration: InputDecoration(
              labelText: '原密码',
              hintText: '请输入原密码',
            ),
            obscureText: true,
            validator: validateOldPwd,
            onSaved: (String value) {
              oldPwd = value;
            },
          ),
          TextFormField(
            // controller: _newPwdController,
            focusNode: _focusNodeNewPwd,
            decoration: InputDecoration(
              labelText: '新密码',
              hintText: '请输入新密码',
            ),
            obscureText: true,
            validator: validateNewPwd,
            onSaved: (String value) {
              newPwd = value;
            },
          ),
          TextFormField(
            // controller: _confirmPwdController,
            focusNode: _focusNodeConfirmPwd,
            decoration: InputDecoration(
              labelText: '确认密码',
              hintText: '请输入新密码',
            ),
            obscureText: true,
            validator: validateConfirmPwd,
            onSaved: (String value) {
              confirmPwd = value;
            },
          ),
        ],
      ),
    ),
  );

  Widget confirmButtonArea = new Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    height: 45.0,
    child: new RaisedButton(
      color: Color(0xff4B82FB),
      child: Text(
        "确认修改",
        style: TextStyle(fontSize: Dimens.font_sp16, color: Colors.white),
      ),
      // 设置按钮圆角
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        //点击确定按钮，解除焦点，回收键盘
        _focusNodeOldPwd.unfocus();
        _focusNodeNewPwd.unfocus();
        _focusNodeConfirmPwd.unfocus();

        _formKey.currentState.save();
        if (_formKey.currentState.validate()) {
          print("$oldPwd + $newPwd + $confirmPwd");

          Map map = Map();
          map['account'] = prefix0.SpUtil.getString('account');
          map['oldPwd'] = oldPwd;
          map['password'] = newPwd;

          HttpUtils.post(Api.API_UPDATE_PASSWORD, params: map, success: (res) {
            print(res);
            if (res['code'] == '200') {
              Fluttertoast.showToast(msg: '密码修改成功，请重新登录');
              return getIt<NavigateService>().pushNamed('login');
            }
          });
        }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text("修改密码"),
        ),
        body: Container(
          child: new ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              pwdInputArea,
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              confirmButtonArea
            ],
          ),
        ));
  }
}
// class ResetPwdView extends StatelessWidget {

//   var oldPwd = '';//原密码
//   var newPwd = '';//新密码
//   var confirmPwd = '';//确认密码

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("修改密码"),),
//       body: Container(
//         child: RaisedButton(
//           child: Text("返回我的"),
//           onPressed: (){
//             Navigator.pop(context);
//           },
//         ),
//       ),

//     );
//   }
// }
