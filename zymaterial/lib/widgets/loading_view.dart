// import 'package:flutter/material.dart';

// class LoadingView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             CircularProgressIndicator(
//               strokeWidth: 2.0,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text('加载中...')
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
 
class ProgressDialog extends StatelessWidget {
 
  //加载中是否显示
  final bool loading;
 
  //进度提醒内容
  final String msg;
 
  //加载中动画
  final Widget progress;
 
  //背景透明度
  final double alpha;
 
  //字体颜色
  final Color textColor;
 
  ProgressDialog(
      {Key key,
        @required this.loading,
        this.msg,
        this.progress = const CircularProgressIndicator(),
        this.alpha = 0.6,
        this.textColor = Colors.black})
      : assert(loading != null),
        super(key: key);
 
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    if (loading) {
      Widget layoutProgress;
      if (msg == null) {
        layoutProgress = Center(
          child: progress,
        );
      } else {
        layoutProgress = Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                progress,
                Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  child: Text(
                    msg,
                    style: TextStyle(color: textColor, fontSize: 16.0),
                  ),
                )
              ],
            ),
          ),
        );
      }
      widgetList.add(Opacity(
        opacity: alpha,
        child: new ModalBarrier(color: Colors.black87,dismissible: false,),
      ));
      widgetList.add(layoutProgress);
    }
    return Stack(
      children: widgetList,
    );
  }
}
