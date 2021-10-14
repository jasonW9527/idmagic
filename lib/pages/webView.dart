import 'dart:async';

import 'package:IDMagic/flutterJsBridge/jsBridgeUtils.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';

///结果展示
class WebViewPage extends StatefulWidget {
  final String param;

  const WebViewPage({Key key, this.param}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  static const baseUrl = 'https://idmagic.teleinfo.cn/view/handle?handle=';

  var isLoading = false;
  int progress = 0;

  Timer _timer;
  JavascriptChannel _JsBridge(BuildContext context) => JavascriptChannel(
      name: 'IDMagicApp',
      onMessageReceived: (JavascriptMessage msg) async {
        String jsonStr = msg.message;
        JsBridgeUtil.executeMethod(context, JsBridgeUtil.parseJson(jsonStr));
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String url = Uri.encodeComponent('$baseUrl${widget.param}');

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('IDMagic'),
          backgroundColor: hex('#4B7FF7'),
          elevation: 0,
          centerTitle: true,
          bottom: PreferredSize(
              child: _progressBar(), preferredSize: Size.fromHeight(1.5)),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: WebView(
            initialUrl: Uri.decodeComponent(url),
            userAgent: FlutterUserAgent.webViewUserAgent + " IDMagicApp",
            javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController controller) {
//               //页面加载的时候可以获取到controller可以用来reload等操作
// //              _webViewController = controller;
//             },
            javascriptChannels: <JavascriptChannel>[
              _JsBridge(context) // 与h5 通信
            ].toSet(),
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
          ),
        ));
  }

  ///进度条至96%时停止
  Future _startProgress() async {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 50), (time) {
        progress++;
        if (progress > 96) {
          _timer.cancel();
          _timer = null;
          return;
        } else {
          setState(() {});
        }
      });
    }
  }

  Widget _progressBar() {
    return SizedBox(
      height: isLoading ? 1.5 : 0,
      child: LinearProgressIndicator(
        value: isLoading ? progress / 100 : 1,
        backgroundColor: Color(0xfff3f3f3),
        valueColor: new AlwaysStoppedAnimation<Color>(hex('#4B7FF7')),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    _startProgress();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}
