
class FileInfo {

  String orgName;
  String fileType;
  String fileName;
  int fileSize;


  FileInfo.fromJson(Map<String, dynamic> value) {
    orgName = value['orgName'];
    fileType = value['fileType'];
    fileName = value['fileName'];
    fileSize = value['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgName'] = this.orgName;
    data['fileType'] = this.fileType;
    data['fileName'] = this.fileName;
    data['fileSize'] = this.fileSize;
    return data;
  }

}
