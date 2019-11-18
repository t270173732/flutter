
import 'package:multi_image_picker/multi_image_picker.dart';

class CreateOrderModel {
  CreateOrderModel();

  int addressId;
  String remark;
  int clientId;
  String patient;
  int gender; //性别 1-男 2-女
  int age;
  String expectTime; //期望到货时间
  String opName; //手术名称
  String opSite; //手术部位
  String opTime; //手术时间
  int isUrgent; //是否加急 0-否 1-是
  int ordType = 1;

  List files;
  List details;
  List<Asset> assets;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressId'] = this.addressId;
    data['remark'] = this.remark;
    data['clientId'] = this.clientId;
    data['patient'] = this.patient;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['expectTime'] = this.expectTime;
    data['opName'] = this.opName;
    data['opSite'] = this.opSite;
    data['opTime'] = this.opTime;
    data['isUrgent'] = this.isUrgent;
    data['ordType'] = this.ordType;
    data['files'] = this.files;
    data['details'] = this.details;

    //不能再手动序列化，否则服务端解析会报错
//    if (this.files != null) {
//      data['files'] = this.files.map((v) => json.encode(v)).toList();
//    }
//    if (this.details != null) {
//      data['details'] = this.details.map((v) => json.encode(v)).toList();
//    }
    return data;
  }
}

class CreateOrderDetail {
  String mtlId;
  int planAmt;
}
