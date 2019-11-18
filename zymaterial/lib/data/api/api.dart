class Api {
  // 110  8091
  static const String BASE_URL_SYS = 'http://192.168.0.110:8091/';

  // 110  8093
  static const String BASE_URL_BIZ = 'http://192.168.0.110:8093/';

  //图片地址
  static const String BASE_IMAGE_URL =
      'http://192.168.0.11:9999/zy-material/picture/';

  //登录
  static const String API_Login_URL = BASE_URL_SYS + 'login';

  //上传文件
  static const String API_UPLOAD_FILE = BASE_URL_SYS + 'upload/file';

  //首页订单列表
  static const String API_homeOrderIndex_URL =
      BASE_URL_BIZ + 'purOrderIndex/appOrders';

  //订单详情
  static const String API_homeOrderDetail_URL =
      BASE_URL_BIZ + 'purOrderIndex/appRead/detail';

   //首页接受消息  
   static const String API_homeGetNewJob_URL =
      BASE_URL_BIZ + 'purOrderIndex/getNewJob';
      
  //统计
  static const String API_STATISTIC =
      BASE_URL_BIZ + 'purOrderIndex/workStatistical';

  //个人信息
  static const String API_USER_INFO = BASE_URL_SYS + 'sysUser/read/detail';

  //个人信息更新
  static const String API_USER_INFO_UPDATE = BASE_URL_SYS + 'sysUser/update';

  //密码修改
  static const String API_UPDATE_PASSWORD = BASE_URL_SYS + 'sysUser/updatePwd';

  //搜索产品
  static const String API_productSearch_URL = BASE_URL_BIZ + 'dicMtl/read/page';

  //商品详情
  static const String API_productDetail_URL =
      BASE_URL_BIZ + 'dicMtl/read/detail';

  //跟台人员订单
  static const String API_ORDER_BY_CONSUME =
      BASE_URL_BIZ + '/purConsume/app/page';
  
  //跟台详情
  static const String API_CONFIRM_DETAIL =
      BASE_URL_BIZ + 'purConsume/read/detail';

  //跟台人员接受任务
  static const String API_CONSUME_RECEPT_TAKE =
      BASE_URL_BIZ + 'purConsume/responseConsume';

  //配送详情
  static const String API_DELIVER_ORDER_DETAIL =
      BASE_URL_BIZ + 'purDeliver/read/detail';

  //确认消耗
  static const String API_CONFIRM_USE =
      BASE_URL_BIZ + 'purConsume/confirmConsume';

  //配送管理
  static const String API_distributionMange_URL =
      BASE_URL_BIZ + 'purDeliver/deliverOrder';

  //订单详情
  static const String API_distributionDetail_URL =
      BASE_URL_BIZ + 'purDeliver/deliverOrderDetail';

  //配送订单 拒绝或接受
  static const String API_deliverResponse_URL =
      BASE_URL_BIZ + 'purDeliver/responseDeliver';

  //返仓订单 拒绝或接受
  static const String API_returnRefuse_URL =
      BASE_URL_BIZ + '/purReturn/responseDeliver';

  //配送订单确认收货
  static const String API_deliverConfirmMtl_URL =
      BASE_URL_BIZ + 'purDeliver/confirmMtl';

  //配送订单确认送达
  static const String API_deliverConfirmArrive_URL =
      BASE_URL_BIZ + 'purDeliver/confirmArrive';

  //返仓订单确认收货
  static const String API_returnConfirmMtl_URL =
      BASE_URL_BIZ + 'purReturn/confirmMtl';

  //返仓订单确认送达
  static const String API_returnConfirmArrive_URL =
      BASE_URL_BIZ + 'purReturn/confirmArrive';

  //配送订单详情
  static const String API_deliverOrderDetail_URL =
      BASE_URL_BIZ + 'purDeliver/deliverOrderDetail';

  //订单进度历史
  static const String API_orderHistory_URL =
      BASE_URL_BIZ + 'purOrderHis/read/list';

  //创建订单
  static const String API_CREATE_ORDER = BASE_URL_BIZ + 'purOrderIndex/add';

  //获取客户列表
  static const String API_GET_CLIENT =
      BASE_URL_BIZ + 'dicClient/getClientByRole';

  //获取客户收货地址
  static const String API_CLIENT_SHIP_ADDRESS =
      BASE_URL_BIZ + 'clientShipAddress/read/list';
}
