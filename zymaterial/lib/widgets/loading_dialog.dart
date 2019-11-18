import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  final String text;
  final double progress;
  final WillPopCallback onBackPress;

  LoadingDialog({Key key, this.text, this.progress, this.onBackPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency, //透明类型
      child: WillPopScope(
          child: new Center(
            child: new SizedBox(
              width: 120.0,
              height: 120.0,
              child: new Container(
                decoration: ShapeDecoration(
                  color: Color(0x99000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      value: progress,
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: new Text(
                        text != null && text.isNotEmpty ? text : "加载中……",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onWillPop: onBackPress),
    );
  }
}
