
class ZYHelper {
  
  //返回空字符串
  String avoidNullString(String string) {
    if(string.isEmpty || string == null || string == "null"){
      return "";

    }
    return string;

  }
}