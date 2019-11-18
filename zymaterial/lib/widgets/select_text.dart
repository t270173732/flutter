import 'package:flutter/material.dart';
import 'package:zymaterial/res/colors.dart';

class SelectedText extends StatelessWidget {
  const SelectedText(this.text,
      {Key key,
      this.fontSize: 14.0,
      this.selected: false,
      this.unSelectedTextColor: Colours.text_dark,
      this.enable: true,
      this.onTap})
      : super(key: key);

  final String text; //文本
  final double fontSize;
  final bool selected; //是否选中
  final Color unSelectedTextColor; //未选中字体颜色（默认选中为白色）
  final VoidCallback onTap; //点击事件
  final bool enable; //是否可点

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: enable ? onTap : null,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 32.0,
          minHeight: 32.0,
        ),
        padding: EdgeInsets.symmetric(horizontal: fontSize > 14 ? 10.0 : 0.0),
        decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x805793FA),
                      offset: Offset(0.0, 2.0),
                      blurRadius: 8.0,
                      spreadRadius: 0.0),
                ],
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [Color(0xFF5758FA), Color(0xFF5793FA)]))
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_buildText()],
        ),
      ),
    );
  }

  _buildText() {
    return Text(text,softWrap: false,
        style: TextStyle(color: getTextColor(), fontSize: fontSize));
  }

  getTextColor() {
    return enable
        ? (selected ? Colors.white : unSelectedTextColor)
        : Colours.text_gray_c;
  }
}
