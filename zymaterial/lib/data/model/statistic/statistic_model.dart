import 'dart:convert';

class StatisticModel {
  String msg;
  int total;
  int code;
  String serverIp;
  List<List> rows;
  int timestamp;

  StatisticModel(
      {this.msg,
      this.total,
      this.code,
      this.serverIp,
      this.rows,
      this.timestamp});

  StatisticModel.fromJson(Map<String, dynamic> value) {
    msg = value['msg'];
    total = value['total'];
    code = value['code'];
    serverIp = value['serverIp'];
    if (value['rows'] != null) {
      rows = new List<List>();
      (value['rows'] as List).forEach((v) {
        rows.add(json.decode(v));
      });
    }
    timestamp = value['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['total'] = this.total;
    data['code'] = this.code;
    data['serverIp'] = this.serverIp;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => json.encode(v)).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class StatisticRow {
  int num;
  String orderDate;

  StatisticRow({this.num, this.orderDate});

  StatisticRow.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    orderDate = json['orderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['orderDate'] = this.orderDate;
    return data;
  }
}
