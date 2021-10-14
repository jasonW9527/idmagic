
///所有定义的扩展函数

///判断非空
extension MapExtension on Map {

  bool isNotNullAndEmpty(){
    return this != null && this.isNotEmpty;
  }

  bool isNullOrEmpty(){
    return this == null || this.isEmpty;
  }

}

///
extension IterableExtension on Iterable {
  bool isNotNullAndEmpty(){
    return this != null && this.isNotEmpty;
  }

  bool isNullOrEmpty(){
    return this == null || this.isEmpty;
  }
}

///字符串操作
extension StringExtension on String {
  bool isNotNullAndEmpty(){
    return this != null && this.isNotEmpty;
  }

  bool isNullOrEmpty(){
    return this == null || this.isEmpty;
  }

  double toDouble() {
    return double.parse(this);
  }

  int toInt() {
    return int.parse(this);
  }
}







