class JsBridge {
  String method;
  Map data;
  Function success;
  Function error;

  JsBridge(this.method, this.data, this.success, this.error);

  Map toJson() {
    Map map = new Map();
    map["method"] = this.method;
    map["data"] = this.data;
    map["success"] = this.success;
    map["error"] = this.error;
    return map;
  }

  static JsBridge fromMap(Map<String, dynamic> map) {
    JsBridge jsonModel =
        new JsBridge(map['method'], map['data'], map['success'], map['error']);
    return jsonModel;
  }

  @override
  String toString() {
    return "JsBridge: {method: $method, data: $data, success: $success, error: $error}";
  }
}
