class OrderType {
  //返仓或配送订单
  String deliveryOrReturnOrder(int status) {
    switch (status) {
      case 0:
        return "待分配";
        break;
      case 1:
        return "已分配";
        break;
      case 2:
        return "已接受";
        break;
      case 3:
        return "已确认";
        break;
      case 4:
        return "已送达";
        break;
      default:
        return "";
        break;
    }
  }

 //配送
 String deliveryOrder(int status) {
    switch (status) {
      case 0:
        return "待分配";
        break;
      case 1:
        return "已分配";
        break;
      case 2:
        return "已接受";
        break;
      case 3:
        return "已确认";
        break;
      case 4:
        return "已送达";
        break;
      default:
        return "";
        break;
    }
  }
  
  //返仓
   String returnOrder(int status) {
    switch (status) {
      case 0:
        return "待分配";
        break;
      case 1:
        return "已分配";
        break;
      case 2:
        return "已接受";
        break;
      case 3:
        return "已确认";
        break;
      case 4:
        return "已完成";
        break;
      default:
        return "";
        break;
    }
  }

  //跟台订单
  String followerOrder(int status) {
    switch (status) {
      case 0:
        return "待分配";
        break;
      case 1:
        return "已分配";
        break;
      case 2:
        return "已接受";
        break;
      case 3:
        return "已消耗";
        break;
      case 4:
        return "已返仓";
        break;
      default:
        return "";
        break;
    }
  }

  //业务员订单
  String salesManOrder(int status) {
    switch (status) {
      case 0:
        return "新建";
        break;
      case 1:
        return "进行中";
        break;
      case 2:
        return "已完成";
        break;
      default:
        return "已取消";
        break;
    }
  }

  //订单状态类型 0-创建  1-响应 2-配送 3-跟台 4-返仓 5-完成
  int opCls(int status) {
    switch (status) {
      case 1:
        return 2;
        break;
      case 2:
        return 4;
        break;
      case 3:
        return 3;
        break;
      case 4:
        return 0;
        break;
      default:
        return 5;
        break;
    }
  }
}
