import 'dart:convert';

import 'package:IDMagic/pages/home.dart';
import 'package:IDMagic/pages/webView.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static FluroRouter router;

  ///起始页
  static String home = '/';

  ///webview
  static String webViewPage = '';

  static void configureRoutes(FluroRouter router) {
    // 起始页
    router.define(home,
        handler: Handler(handlerFunc: (context, params) => MyHomePage()));

    router.define(webViewPage, handler: Handler(handlerFunc: (context, params) {
      var p = params['param']?.first;
      return WebViewPage(
        param: deCode(p),
      );
    }));

    Routes.router = router;
  }

  ///解码
  static String deCode(var encodeStr) {
    if (encodeStr == null) return '';
    var list;
    String deCodeStr;
    list = List<int>();

    ///字符串解码
    jsonDecode(encodeStr).forEach(list.add);
    deCodeStr = Utf8Decoder().convert(list);
    return deCodeStr ?? '';
  }
}
