import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class HelperToast{

  //显示在中间的 提示语
  void showCenterToast(String msg){
       Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Color.fromRGBO(224, 224, 224, 1.0),
        textColor: Colors.black,
        fontSize: 14.0
    );
  }
 //显示在底部的提示语
  void showBottomTost(String msg){

     Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Color.fromRGBO(224, 224, 224, 1.0),
        textColor: Colors.black,
        fontSize: 14.0
    );
  }

}