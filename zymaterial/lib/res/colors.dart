import 'package:flutter/material.dart';

class Colours {
  //主题色
  static const Color app_theme_color = Color(0xFF666666);

  static const Color app_main_color = Color(0xFF3F6EFE);
  static const Color app_main_color_end = Color(0xFF7044F0);


  static const Color transparent_80 = Color(0x80000000); //<!--204-->
  //三色
  static const Color app_text_one_color = Color(0xFF333333);
  static const Color app_text_two_color = Color(0xFF666666);
  static const Color app_text_three_color = Color(0xFF999999);
  //线
  static const Color app_line_color = Color(0xffe5e5e5);

  //背景色
  static const Color app_background_color = Color(0xFFF9F9F9); //51


  static const Color text_dark = Color(0xFF333333);
  static const Color text_normal = Color(0xFF666666);
  static const Color text_gray = Color(0xFF999999);
  static const Color text_gray_c = Color(0xFFcccccc);
  static const Color bg_gray = Color(0xFFF6F6F6);
  static const Color line = Color(0xFFEEEEEE);
  static const Color text_red = Color(0xFFFF4759);


  static String color2Str(Color color){
    String colorString = color.toString(); // Color(0x12345678)
    String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    return '#$valueString';
  }

}
