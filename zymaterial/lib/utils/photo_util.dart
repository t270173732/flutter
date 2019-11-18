import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zymaterial/res/colors.dart';
import 'package:zymaterial/widgets/line.dart';

///目前的第三方库都不是相册和拍照都支持，并且有些库有缺陷，
///推荐使用第三方库multi_image_picker（相册）+官方库image_picker（拍照）

///调用相册，里面也集成了拍照功能,[returnType]0-返回asset 1-返回file
Future<dynamic> showGallery(BuildContext context,
    {int maxSelected, List<Asset> selectedList, int returnType = 0}) async {

  if (selectedList == null) {
    selectedList = List();
  }
  try {
    selectedList = await MultiImagePicker.pickImages(
      //最大选择数
      maxImages: maxSelected == 0 || maxSelected == null ? 9 : maxSelected,
      //是否启用相机
      enableCamera: true,
      //已选中的
      selectedAssets: selectedList,
      //iOS风格设置
      cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      //MD风格设置
      materialOptions: MaterialOptions(
        actionBarColor: context != null
            ? Colours.color2Str(Theme.of(context).primaryColor)
            : Colours.color2Str(Colours.app_main_color),
        statusBarColor: context != null
            ? Colours.color2Str(Theme.of(context).primaryColorDark)
            : Colours.color2Str(Colours.app_main_color),
        actionBarTitle: "选择照片",
        allViewTitle: "所有照片",
        useDetailsView: true,
        selectCircleStrokeColor: "#ffffff",
        selectionLimitReachedText: "选择照片数过多",
        textOnNothingSelected: "请选则至少一张照片",
      ),
    );

  } on Exception catch (e) {
    print('选择图片时出错：${e.toString()}');
  }

  if (returnType == 0) {
    return selectedList;
  } else {
    List<File> resultList = List<File>();
    for (var r in selectedList) {
      resultList.add(File(r.filePath.toString()));
    }
    return resultList;
  }

}


///以下暂时不使用

///单独调用相机
Future<File> showCamera() async {
  File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  return imageFile;
}

/// 弹出相册、拍照dialog，
Future<List<File>> showPhotoDialog(BuildContext context, {int maxSelected}) {
  return showModalBottomSheet<List<File>>(
    context: context,
    builder: (BuildContext context) {
      return Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    showGallery(context, maxSelected: maxSelected);
                  },
                  child: Text('相册')),
              Line(),
              FlatButton(
                  onPressed: () async {
                    List<File> file = List();
                    file[0] = await showCamera();
                    return file;
                  },
                  child: Text('拍照')),
              Line(),
              Expanded(
                child: Container(
                  height: 5,
                  width: double.infinity,
                  color: Colours.app_background_color,
                ),
              ),
              Line(),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.redAccent),
                  ))
            ],
          ));
    },
  );
}
