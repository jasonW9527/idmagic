import 'dart:convert';
import 'dart:ui';

import 'package:IDMagic/components/searchBox/searchBox.dart';
import 'package:IDMagic/utils/throttle.dart';
import 'package:barcode_scan_plugin/barcode_scan_plugin.dart';
import 'package:color_dart/hex_color.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:IDMagic/route.dart';
import 'package:permission_handler/permission_handler.dart';

///
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _inputStr = '';
  String barcodeStr = '';

  @override
  void initState() {
    super.initState();
    requestPermission().then((p) {
      if (!p) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          EasyLoading.showInfo('打开手机相关权限才能正常使用app功能');
          Future.delayed(Duration(seconds: 3), () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop', true);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQueryData.fromWindow(window).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        child: Scaffold(
          body: Container(
              height: double.infinity,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Stack(
                  children: <Widget>[
                    wHomeHead(_height + 10),
                    Positioned(
                      child: wHomeBottom(),
                      top: 261.h,
                      left: 58.w,
                      right: 58.w,
                    ),
                    Positioned(
                      top: 1000.h,
                      left: 62.w,
                      right: 62.w,
                      child: Opacity(
                        opacity: 0.6,
                        child: Container(
                          width: 604.w,
                          height: 390.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: ExactAssetImage(
                                    'lib/assets/images/bottom_bg.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget wHomeHead(double offset) {
    return Container(
        height: 460.h,
        width: double.infinity,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: offset),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage('lib/assets/images/head_bg.png'),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'IDMagic',
                  style: TextStyle(fontSize: 38.sp, color: hex('fff')),
                )
              ],
            ),
          ],
        ));
  }

  Widget wHomeBottom() {
    return Container(
      height: 790.h,
      width: 634.w,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: ExactAssetImage('lib/assets/images/mid_bg.png'),
            fit: BoxFit.fill),
      ),
      child: Column(
        children: <Widget>[
          SearchBox(
            margin: EdgeInsets.only(top: 46.h, left: 42.w, right: 42.w),
            width: 550.w,
            height: 70.h,
            inputTxtCallback: (v) {
              if (mounted) {
                setState(() {
                  _inputStr = v;
                });
              }
              print('搜索...$v');
            },
            searchCallback: () {
              gotoWebPage(_inputStr);
            },
          ),
          Container(
            width: 250.w,
            height: 250.w,
            margin: EdgeInsets.only(top: 90.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage('lib/assets/images/circle_bg.png'),
                  fit: BoxFit.fill),
            ),
            child: /*_inputStr.isEmpty
                ? */
                InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 44.w,
                    height: 42.w,
                    child: Image.asset('lib/assets/images/scan_icon.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 22.h),
                    child: Text(
                      '扫码查询',
                      style: TextStyle(fontSize: 32.sp, color: hex('fff')),
                    ),
                  )
                ],
              ),
              onTap: throttle(() async {
                if (!mounted) {
                  return;
                }
                print('走扫描');
                scan().then((value) {
                  gotoWebPage(value);
                });
                await Future.delayed(Duration(milliseconds: 2000));
              }),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
            ),
          ),
          Container(
              height: 100.h,
//              color: hex('#ff0'),
              margin: EdgeInsets.only(bottom: 98.h),
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '1、请输入handle，点击查询结果',
                    style: TextStyle(fontSize: 32.sp, color: hex('#999999')),
                  ),
                  Text(
                    '2、请点击扫码，查询结果',
                    style: TextStyle(fontSize: 32.sp, color: hex('#999999')),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  //跳结果页
  void gotoWebPage(String input) {
    if (input == null || input.isEmpty) {
      EasyLoading.showInfo('请先输入或者扫码，请重试');
      return;
    }
    if (!isCanonical(input)) {
      EasyLoading.showToast('内容不符合规范，请重试');
      return;
    }
    var str = jsonEncode(Utf8Encoder().convert(input));
    Routes.router
        .navigateTo(context, '${Routes.webViewPage}?param=$str', //跳转路径
            transition: TransitionType.native,
            transitionDuration: Duration(milliseconds: 350), //过场效果
            clearStack: false)
        .then((result) {
      if (result != null) {
        if (result == 'web_open_scan') {
          Future.delayed(Duration(milliseconds: 200), () {
            scan().then((value) {
              gotoWebPage(value);
            });
          });
        }
      }
    });
  }

  Future<String> scan() async {
    String barcode;
    try {
      barcode = await BarcodeScanPlugin.scan();
      setState(() => this.barcodeStr = barcode);
    } on Exception catch (e) {}
    print('code = $barcodeStr');
    return barcode ?? '';
  }

  ///申请动态权限
  Future<bool> requestPermission() async {
    bool checkOk = false;
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      checkOk = true;
    } else {
      ///新版本用法
      Map<Permission, PermissionStatus> statuses = await [
//      Permission.location,
        Permission.storage,
        Permission.camera
      ].request();
      if (/*statuses[Permission.location] == PermissionStatus.granted &&*/
          statuses[Permission.storage] == PermissionStatus.granted &&
              statuses[Permission.camera] == PermissionStatus.granted) {
        print('权限申请通过');
        checkOk = true;
      }
    }
    return checkOk;
  }

  ///对输入扫码的结果做过滤
  bool isCanonical(String input) {
    RegExp exp = RegExp(r"^((zrp:)|(\d+\.))+(\d+$|\d+\/+(.*)+$)");
    return exp.hasMatch(input);
  }
}
