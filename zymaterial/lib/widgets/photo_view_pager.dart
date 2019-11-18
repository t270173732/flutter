import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:zymaterial/res/colors.dart';
import 'package:zymaterial/utils/photo_util.dart';

///上传图片的GridView
// ignore: must_be_immutable
class PhotoGrid extends StatefulWidget {
  PhotoGrid(this.imageList, this.onSelectedCallBack, {this.maxCount});

  List<Asset> imageList;
  int maxCount;
  ValueChanged<List<Asset>> onSelectedCallBack;

  @override
  State<StatefulWidget> createState() {
    return PhotoGridState();
  }
}

class PhotoGridState extends State<PhotoGrid> {
  List<Asset> imageList;
  int maxCount;
  List<File> fileList = List();

  @override
  void initState() {
    super.initState();

    imageList = widget.imageList;
    maxCount = widget.maxCount;
  }

  @override
  Widget build(BuildContext context) {
    void open(BuildContext context, int index) {
      imageList.forEach((v) async {
        fileList.add(File(await v.filePath));
      });

      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PhotoViewPager(
              imageList: imageList,
              fileList: fileList,
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: index,
            ),
          ));
    }

    return Column(
      children: <Widget>[
        GridView.count(
          padding: EdgeInsets.all(8),
          //禁用GridView的滚动事件，否则会导致卡顿
          physics: NeverScrollableScrollPhysics(),
          //根据子组件长度控制GridView的高度，否则会显示不全
          shrinkWrap: true,
          //横向个数
          crossAxisCount: 3,
          //横向间距
          crossAxisSpacing: 8.0,
          //纵向间距
          mainAxisSpacing: 8.0,
          children: List.generate(
              imageList.length == maxCount
                  ? imageList.length
                  : imageList.length + 1, (index) {
            if ((imageList.length <= maxCount && index == imageList.length) ||
                imageList.length == 0) {
              //如果是最后一项并且没有超过最大值，就显示添加
              return createPhotoUpload(context);
            } else {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        //open(context, index);
                      },
//                    child: Hero(
//                        tag: imageList[index].name,
                      child: FutureBuilder<String>(
                        future: imageList[index].filePath,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Image.file(
                              File(snapshot.data),
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Icon(Icons.warning);
                          }
                        },
                      )

//child:  AssetThumb(
//  asset: imageList[index],
//  width: 200,
//  height: 200,
//),
//                    ),
                      ),
                  Align(
                    alignment: Alignment(1.1, -1.1),
                    //1和-1是相对父控件最靠边的位置，超出这个值相当于是加偏移量
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          imageList.removeAt(index);
                          widget.imageList = imageList;
                          if (widget.onSelectedCallBack != null) {
                            widget.onSelectedCallBack(imageList);
                          }
                        });
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                            color: Color(0x99000000), shape: CircleBorder()),
                        child: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
        Container(
          color: Colours.app_background_color,
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Center(
            child: Text('上传图片凭证，最多$maxCount张（可不上传）'),
          ),
        ),
      ],
    );
  }

  ///添加图片按钮
  Widget createPhotoUpload(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        imageList = await showGallery(context,
            maxSelected: maxCount, selectedList: imageList);
        setState(() {
          widget.imageList = imageList;
          if (widget.onSelectedCallBack != null) {
            widget.onSelectedCallBack(imageList);
          }
        });
      },
      child: Container(
        color: Colours.line,
//          decoration: BoxDecoration(
//              border: Border.all(width: 2, color: Colors.grey),
//              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Center(

              child: Icon(
            Icons.add,
            size: 50,
            color: Colors.grey,
          ))),
    );
  }
}

///点击图片放大后的viewpager页
class PhotoViewPager extends StatefulWidget {
  PhotoViewPager(
      {this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.fileList,
      this.initialIndex,
      @required this.imageList})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<Asset> imageList;
  final List<File> fileList;

  @override
  State<StatefulWidget> createState() {
    return PhotoViewPagerState();
  }
}

class PhotoViewPagerState extends State<PhotoViewPager> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: buildItem,
                itemCount: widget.imageList.length,
                loadingChild: widget.loadingChild,
                backgroundDecoration: widget.backgroundDecoration,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "${currentIndex + 1}/${widget.imageList.length}",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16.0, decoration: null),
                ),
              )
            ],
          )),
    );
  }

  PhotoViewGalleryPageOptions buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: FileImage(widget.fileList[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes:
          PhotoViewHeroAttributes(tag: widget.imageList[index].name),
    );
  }
}
