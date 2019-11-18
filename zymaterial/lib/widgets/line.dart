import 'package:flutter/material.dart';
import 'package:zymaterial/res/colors.dart';

class Line extends StatelessWidget {
  const Line(
      {this.direction = Axis.horizontal,
      this.lineColor = Colours.line,
      this.margin,
      this.width,
      this.height});

  ///线的方向，默认[Axis.horizontal].
  final Axis direction;

  ///线的颜色，默认[Colours.line]
  final Color lineColor;

  ///线的margin，水平线默认0，垂直线默认左右两边4px
  final EdgeInsetsGeometry margin;

  ///水平线宽度默认[double.infinity]，垂直线宽度默认0.5
  final double width;

  ///水平线高度默认0.5，垂直线高度默认24
  final double height;

  @override
  Widget build(BuildContext context) {
   
    return Container(
      margin: margin == null
          ? (direction == Axis.horizontal
              ? EdgeInsets.all(0)
              : EdgeInsets.symmetric(horizontal: 4))
          : margin,
      color: lineColor,
      width: direction == Axis.horizontal
          ? double.infinity
          : (width == null || width == 0 ? 0.5 : width),
      height: direction == Axis.horizontal
          ? 0.5
          : (height == null || height == 0 ? 24 : height),
    );
  }
}
