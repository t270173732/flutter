import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zymaterial/res/colors.dart';

enum NumberEditSize {
  small,
  normal,
  large,
}

class NumberEditText extends StatefulWidget {
  const NumberEditText(this.onNumCallBack,
      {Key key,
      this.num: 1,
      this.size: NumberEditSize.normal,
      this.minNum: 1,
      this.maxNum: 999,
      this.borderColor: Colours.text_normal,
      this.iconColor: Colours.text_normal,
      this.iconDisableColor: Colours.text_gray_c})
      : super(key: key);

  final int minNum;

  final int maxNum;

  final int num;

  final Color borderColor; //边框颜色

  final Color iconColor; //按钮颜色

  final Color iconDisableColor; //按钮不可用颜色

  final ValueChanged<int> onNumCallBack;

  final NumberEditSize size;

  @override
  State<StatefulWidget> createState() {
    return NumberEditTextState();
  }
}

class NumberEditTextState extends State<NumberEditText> {
  int minNum;
  int maxNum;
  int num;
  Color borderColor;
  Color iconColor;
  Color iconDisableColor;

  NumberEditSize size;

  EdgeInsetsGeometry contentPadding;

  ///宽是指的文本框的宽度
  double width;

  ///高是指的整个控件的高度
  double height;

  double iconSize;

  bool enableAdd = true, enableMinus = true;

  Timer timer;

  @override
  void initState() {
    super.initState();

    minNum = widget.minNum;
    maxNum = widget.maxNum;
    num = widget.num;
    borderColor = widget.borderColor;
    iconColor = widget.iconColor;
    iconDisableColor = widget.iconDisableColor;
    size = widget.size;

    switch (size) {
      case NumberEditSize.small:
        iconSize = 15;
        width = 36;
        height = 26;
        contentPadding = EdgeInsets.all(1);
        break;
      case NumberEditSize.normal:
        iconSize = 20;
        width = 48;
        height = 36;
        contentPadding = EdgeInsets.all(7);
        break;
      case NumberEditSize.large:
        iconSize = 25;
        width = 60;
        height = 46;
        contentPadding = null;
        break;
    }

    if (num == minNum) {
      enableMinus = false;
    } else if (num == maxNum) {
      enableAdd = false;
    }
  }

  /*
   * onTapDown	用户每次和屏幕交互时都会被调用
   * onTapUp	用户停止触摸屏幕时触发
   * onTap	短暂触摸屏幕时触发
   * onTapCancel	用户触摸了屏幕，但是没有完成Tap的动作时触发
   */
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: <Widget>[
            GestureDetector(
              child: Container(
                height: height,
                width: height,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: borderColor,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5)),
                ),
                child: Icon(
                  Icons.remove_circle,
                  size: iconSize,
                  color: enableMinus ? iconColor : iconDisableColor,
                ),
              ),
              onTap: () {
                //单次点击的事件
                setState(() {
                  enableAdd = true;
                  if (num - 1 == minNum) {
                    enableMinus = false;
                  }
                  if (num <= minNum) {
                    return;
                  }
                  num--;
                  if (widget.onNumCallBack != null) {
                    widget.onNumCallBack(num);
                  }
                });
              },
              onTapDown: (e) {
                if (timer != null) {
                  timer.cancel();
                }
                if (num <= minNum) {
                  return;
                }
                // 这里面的触发时间可以自己定义
                timer = new Timer.periodic(Duration(milliseconds: 100), (e) {
                  setState(() {
                    enableAdd = true;
                    if (num - 1 == minNum) {
                      enableMinus = false;
                    }
                    if (num <= minNum) {
                      return;
                    }
                    num--;
                    if (widget.onNumCallBack != null) {
                      widget.onNumCallBack(num);
                    }
                  });
                });
              },
              onTapUp: (e) {
                if (timer != null) {
                  timer.cancel();
                }
              },
              // 这里防止长按没有抬起手指，而move到了别处，会继续 --
              onTapCancel: () {
                if (timer != null) {
                  timer.cancel();
                }
              },
            ),
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(width: 1, color: borderColor),
                bottom: BorderSide(width: 1, color: borderColor),
              )),
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: contentPadding,
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(32)
                ],
                onChanged: (value) {
                  if (value == null || value.isEmpty) {
                    //输入为空时，改为最小值
                    num = minNum;
                    enableMinus = false;
                    enableAdd = true;
                  } else {
                    int n = int.parse(value);

                    if (n == minNum) {
                      setState(() {
                        enableMinus = false;
                        enableAdd = true;
                      });
                    }

                    if (n > minNum && n < maxNum) {
                      num = n;
                      setState(() {
                        enableMinus = true;
                        enableAdd = true;
                      });
                    } else {
                      if (n <= minNum) {
                        num = minNum;
                        setState(() {
                          enableMinus = false;
                          enableAdd = true;
                        });
                      } else if (n >= maxNum) {
                        num = maxNum;
                        setState(() {
                          enableMinus = true;
                          enableAdd = false;
                        });
                      }
                    }
                  }

                  if (widget.onNumCallBack != null) {
                    widget.onNumCallBack(num);
                  }
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                  text: num.toString(),
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: num.toString().length)),
                )),
              ),
            ),
            GestureDetector(
              child: Container(
                  height: height,
                  width: height,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: borderColor,
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                  ),
                  child: Icon(
                    Icons.add_circle,
                    size: iconSize,
                    color: enableAdd ? iconColor : iconDisableColor,
                  )),
              onTap: () {
                setState(() {
                  enableMinus = true;
                  if (num + 1 == maxNum) {
                    enableAdd = false;
                  }
                  if (num >= maxNum) {
                    enableAdd = false;
                    return;
                  }
                  num++;
                  if (widget.onNumCallBack != null) {
                    widget.onNumCallBack(num);
                  }
                });
              },
              onTapDown: (e) {
                if (timer != null) {
                  timer.cancel();
                }
                if (num >= maxNum) {
                  return;
                }
                timer = new Timer.periodic(Duration(milliseconds: 100), (e) {
                  setState(() {
                    enableMinus = true;
                    if (num + 1 == maxNum) {
                      enableAdd = false;
                    }
                    if (num >= maxNum) {
                      return;
                    }
                    num++;
                    if (widget.onNumCallBack != null) {
                      widget.onNumCallBack(num);
                    }
                  });
                });
              },
              onTapUp: (e) {
                if (timer != null) {
                  timer.cancel();
                }
              },
              onTapCancel: () {
                if (timer != null) {
                  timer.cancel();
                }
              },
            ),
          ],
        ));
  }

  BorderSide createBorder() {
    return BorderSide(width: 1, color: borderColor, style: BorderStyle.solid);
  }
}
