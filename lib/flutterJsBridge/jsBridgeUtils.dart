import 'dart:convert';

import 'package:IDMagic/flutterJsBridge/jsBridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class JsBridgeUtil {
  static JsBridge parseJson(String jsonStr) {
    JsBridge jsBridgeModel = JsBridge.fromMap(jsonDecode(jsonStr));
    return jsBridgeModel;
  }

  static executeMethod(context, JsBridge jsBridge) async {
    if (jsBridge.method == 'open_barcode_scan') {
      EasyLoading.showToast('扫码打开...');
      Navigator.pop(context, "web_open_scan");

      jsBridge.success?.call();
    }
  }
}
