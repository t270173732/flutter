import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zymaterial/data/api/api.dart';
import 'package:zymaterial/utils/service_locator.dart';
import 'package:zymaterial/widgets/loading_dialog.dart';

class HttpUtils {
  static Dio _dio;
  static BaseOptions _options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: Headers.jsonContentType);

  static setToken(String token) {
    _dio.options.headers = {'Authorization': token};
  }

  //get
  static get(String url, {options, Function success, Function failure}) async {
    Dio dio = buildDio();
    try {
      Response response = await dio.get(url, options: options);
      success(response.data);
    } catch (exception) {
      failure(exception);
    }
  }

  //put 请求
  static put(String url,
      {params,
      options,
      Function success,
      Function failure,
      bool showProgress = false,
      BuildContext context,
      String text = "",
      bool showError = true}) async {
    Dio dio = buildDio();
    if (showProgress && context != null) show(context, text: text);
    try {
      Response response = await dio.put(url, data: params, options: options);
      if (showProgress && context != null) dismiss(context);
      success(response.data);
    } catch (exception) {
      if (showProgress && context != null) dismiss(context);
      if (showError) Fluttertoast.showToast(msg: exception.toString());
      failure(exception);
    }
  }

// post 请求
  static post(String url,
      {params,
      options,
      Function success,
      Function failure,
      bool showProgress = false,
      BuildContext context,
      String text = "",
      bool showError = true}) async {
    Dio dio = buildDio();
    if (showProgress && context != null) show(context, text: text);
    try {
      Response response = await dio.post(url, data: params, options: options);
      if (showProgress && context != null) dismiss(context);
      success(response.data);
    } catch (exception) {
      if (showProgress && context != null) dismiss(context);
      if (showError) Fluttertoast.showToast(msg: exception.toString());
      failure(exception);
    }
  }

  ///文件上传，只需要传assetList或fileList其中之一即可
  static uploadFile(String url,
      {List<Asset> assetList,
      List<File> fileList,
      Function success,
      Function failure,
      bool showProgress = false,
      BuildContext context,
      bool showError = true}) async {
    Dio dio = buildDio();

    if (showProgress && context != null) show(context, type: 1);

    FormData formData = FormData();

    List<MapEntry<String, MultipartFile>> partList = List();

    if (assetList != null) {
      for (int i = 0; i < assetList.length; i++) {
        partList.add(MapEntry(
            'file$i', MultipartFile.fromFileSync(await assetList[i].filePath)));
      }
      formData.files.addAll(partList);
    }

    if (fileList != null) {
      for (int i = 0; i < fileList.length; i++) {
        partList.add(
            MapEntry('file$i', MultipartFile.fromFileSync(fileList[i].path)));
      }
      formData.files.addAll(partList);
    }

    dio.options.sendTimeout = 30000;

    try {
      Response response = await dio.post(
        url,
        data: formData,
        onSendProgress: (sent, total) {
          if (showProgress) {
            if (total == -1) {
              _progress = null;
            } else {
              _progress = (sent / total);
            }
            if (_progress >= 1) {
              _progress = 1;
            }
            if (_state != null) _state(() {});
          }
        },
      );
      if (showProgress && context != null) dismiss(context);
      success(response.data);
    } catch (exception) {
      if (showProgress && context != null) dismiss(context);
      if (showError) Fluttertoast.showToast(msg: exception.toString());
      failure(exception);
    } finally {
      dio.options.sendTimeout = 5000;
      _progress = null;
      _state = null;
    }
  }

  static void downloadFile(String url, String savePath,
      {Map<String, dynamic> params,
      Function success,
      Function failure,
      bool showProgress = false,
      BuildContext context,
      bool showError = true}) async {
    if (showProgress && context != null) {
      show(context, type: 0);
    }

    Dio dio = buildDio();

    dio.options.receiveTimeout = 30000;
    try {
      var response = await dio.download(
        url,
        savePath,
        queryParameters: params,
        onReceiveProgress: (received, total) {
          if (showProgress) {
            if (total == -1) {
              _progress = null;
            } else {
              _progress = (received / total);
            }
            if (_progress >= 1) {
              _progress = 1;
            }
            if (_state != null) _state(() {});
          }
        },
      );
      if (showProgress && context != null) dismiss(context);
      success(response.data);
    } catch (exception) {
      if (showProgress && context != null) dismiss(context);
      if (showError) Fluttertoast.showToast(msg: exception.toString());
      failure(exception);
    } finally {
      dio.options.receiveTimeout = 5000;
      _progress = null;
      _state = null;
    }
  }

  //delete 请求
  static delete(String url,
      {params, options, Function success, Function failure}) async {
    Dio dio = buildDio();
    try {
      Response response = await dio.delete(url, data: params, options: options);
      success(response.data);
    } catch (exception) {
      failure(exception);
    }
  }

  //初始化
  static Dio buildDio() {
    if (_dio == null) {
      _dio = new Dio(_options);
      _dio.options.headers = {
        'Authorization': SpUtil.getString('Authorization')
      };
      _dio.interceptors.add(new TokenInterceptor());
      _dio.interceptors.add(new LogInterceptor());
    }
    return _dio;
  }

  static StateSetter _state;

  static double _progress;

  //显示进度条 type  0-下载 1-上传
  static void show(BuildContext context, {String text, type= 0}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (dialogContext, setDialogState) {
            _state = setDialogState;

            var str;

            if (_progress == null) {
              str = text;
            } else {
              if (type == 0) {
                if (_progress < 1)
                  str =
                      '已下载:\n${NumUtil.getNumByValueDouble(_progress * 100, 2).toString()}%';
                else
                  str = '已完成下载';
              } else {
                if (_progress < 1)
                  str =
                      '已上传:\n${NumUtil.getNumByValueDouble(_progress * 100, 2).toString()}%';
                else
                  str = '已完成上传';
              }
            }

            return LoadingDialog(
                text: str,
                progress: _progress,
                onBackPress: () async {
                  return false;
                });
          });
        });
  }

  //隐藏进度条
  static void dismiss(BuildContext context) {
    Navigator.pop(context);
  }
}

class TokenInterceptor extends Interceptor {
  @override
  Future onResponse(Response response) async {
    if (response != null && response.data['code'] == '401') {
      //当返回未登录时重新登录刷新token，并且重新执行该次请求

      Dio dio = HttpUtils._dio; //获取Dio单例
      try {
        dio.lock(); //加锁
        String token = await getToken(); //异步获取新的token

        //重新发起一个请求获取数据
        Dio tokenDio2 = new Dio(HttpUtils._options); //创建新的Dio实例
        dio.options.headers['Authorization'] = token;
        var newRequest = await tokenDio2.request(response.request.path,
            data: response.request.data,
            queryParameters: response.request.queryParameters,
            options: Options(method: response.request.method));
        return newRequest;
      } on DioError catch (e) {
        return e;
      } finally {
        dio.unlock(); //解锁
      }
    }
  }

  @override
  onError(DioError error) async {
    if (error.message.contains('401') && error.message.contains('您还没有登录')) {
      getIt<NavigateService>().pushNamed('login');
    }
    super.onError(error);
  }

  Future<String> getToken() async {
    Dio tokenDio = new Dio(HttpUtils._options); //创建新Dio实例
    var map = {
      'account': SpUtil.getString('account'),
      'password': SpUtil.getString('password')
    };
    var token;

    try {
      String url = Api.API_Login_URL; //新的dio实例未配置baseURL，需要手动配置
      var response = await tokenDio.post(url, data: map); //请求token刷新的接口
      if (response != null && response.statusCode == 200) {
        //更新token
        token = response.data['data']['Authorization']; //新的token
        SpUtil.putString('Authorization', token);
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: '刷新token失败，请重新登录\n' + e.toString());
      return getIt<NavigateService>().pushNamed('login'); //token过期，弹出登录页面
    }
    return token;
  }
}

class LogInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    print('-----------------' * 6 + '\t请求开始\t' + '-----------------' * 6);
    print("请求baseUrl：${options.baseUrl}");
    print("请求url：${options.path}");
    print("请求method：${options.method}");
    print('请求头：' + options.headers.toString());
    if (options.data != null) {
      print('请求参数：' + options.data.toString());
    }
    return options;
  }

  @override
  onResponse(Response response) async {
    if (response != null) {
      print('-----------------' * 4 + '\t请求成功\t' + '-----------------' * 4);
      print('statusCode：${response.statusCode}');
      print('statusMsg：${response.statusMessage}');
      print('返回参数：${response.data.toString()}');
    } else {
      print('-----------------' * 4 +
          '\t请求成功，但没有返回值\t' +
          '-----------------' * 4);
    }
    print('-----------------' * 6 + '\t请求结束\t' + '-----------------' * 6);
    return response; // continue
  }

  @override
  onError(DioError err) async {
    print('-----------------' * 4 + '\t请求异常\t' + '-----------------' * 4);
    print('请求异常：' + err.toString());
    print('请求异常信息：${err.response != null ? err.response.toString() : ""}');
    print('-----------------' * 6 + '\t请求结束\t' + '-----------------' * 6);
    return err;
  }
}
