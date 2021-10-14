import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:IDMagic/route.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';

void main() {
  final router = new FluroRouter();
  Routes.configureRoutes(router);
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  configLoading();
  FlutterUserAgent.init();
}

///loading 配置
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.blue
    ..backgroundColor = Colors.black12.withOpacity(0.5)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black12.withOpacity(0)
    ..userInteractions = true;

  EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
  EasyLoading.instance.maskType = EasyLoadingMaskType.custom;
}

final GlobalKey<NavigatorState> naviKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      builder: () => MaterialApp(
        builder: EasyLoading.init(),
        title: 'IDMagic',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(brightness: Brightness.dark),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: Routes.router.generator,
        navigatorKey: naviKey,
        debugShowCheckedModeBanner: false,
        // home: Tt(),
      ),
    );
  }
}
