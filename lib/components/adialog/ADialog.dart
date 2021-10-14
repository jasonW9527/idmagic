import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class ADialog {
  ///缩放类型动画
  static const int ANIM_TYPE_SCALE = 0;

  ///线性偏移类型动画
  static const int ANIM_TYPE_LINEAR = 1;

  final BuildContext context;
  final Widget title;
  final Widget content;
  static Widget _title;
  static Widget _content;
  static Widget _bottom;

  /// 提示弹窗
  /// @param {BuildContext} context
  /// @param {Widget} title - 标题
  /// @param {Widget} content - 内容
  /// @param {bool} hasAnim - 是否开启弹框动画
  /// @param {int} animType - 动画类型
  /// @param {double} width - dialog宽度
  /// @param {int} duration - 动画持续时间
  /// @param {Function} confirmButtonPress - 点击确认回调
  /// @param {Text} confirmButtonText - 确认的文字
  ADialog.alert(
    this.context, {
    this.title,
    @required this.content,
    bool hasAnim = false,
    int animType = 0,
    double width,
    int duration,
    Function confirmButtonPress,
    Text confirmButtonText,
  }) {
//    _title = _initTitle();
    _content = _initContent();
    _bottom = _initBottom(
        confirmButtonPress: confirmButtonPress,
        confirmButtonText: confirmButtonText == null
            ? Text(
                '确认',
                style: TextStyle(
                    color: hex('#4f86f9'), fontWeight: FontWeight.w600),
              )
            : confirmButtonText,
        confirmBorderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)));
    if (hasAnim)
      _initDialog2(animType: animType, width: width, duration: duration);
    else
      _initDialog();
  }

  /// 确认弹窗
  /// @param {BuildContext} context
  /// @param {Widget} title - 标题
  /// @param {Widget} content - 内容
  /// @param {bool} hasAnim - 是否开启弹框动画
  /// @param {bool} bottomOrder - 底部按钮顺序（true-左边取消右边确认，false-相反）
  /// @param {int} animType - 动画类型
  /// @param {double} width - dialog宽度
  /// @param {int} duration - 动画持续时间
  /// @param {Function} confirmButtonPress - 点击确认回调
  /// @param {Text} confirmButtonText - 确认的文字
  /// @param {Function} cancelButtonPress - 点击取消回调
  /// @param {Text} cancelButtonText - 取消的文字
  ADialog.confirm(
    this.context, {
    this.title,
    @required this.content,
    bool hasAnim = false,
    bool bottomOrder = true,
    int animType = 0,
    double width,
    int duration,
    Function confirmButtonPress,
    Function contentCallBack,
    Text confirmButtonText,
    Function cancelButtonPress,
    Text cancelButtonText,
  }) {
//    _title = _initTitle();
    _content = _initContent();

    _bottom = _initBottom(
        confirmButtonPress: confirmButtonPress,
        bottomOrder: bottomOrder,
        confirmButtonText: confirmButtonText == null
            ? Text(
                '确认',
                style: TextStyle(
                    color: hex('#4f86f9'), fontWeight: FontWeight.w600),
              )
            : confirmButtonText,
        cancelButtonText: cancelButtonText == null
            ? Text(
                '取消',
                style:
                    TextStyle(color: hex('#333'), fontWeight: FontWeight.w600),
              )
            : cancelButtonText,
        cancelButtonPress: cancelButtonPress,
        cancelBorderRadius: bottomOrder
            ? BorderRadius.only(bottomLeft: Radius.circular(6))
            : BorderRadius.only(bottomRight: Radius.circular(6)),
        confirmBorderRadius: bottomOrder
            ? BorderRadius.only(bottomRight: Radius.circular(6))
            : BorderRadius.only(bottomLeft: Radius.circular(6)));

    if (hasAnim)
      _initDialog2(animType: animType, width: width, duration: duration);
    else
      _initDialog();
  }

  Widget _initContent() {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(6.0), // 圆角度
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(24),
            horizontal: ScreenUtil().setWidth(24)),
        child: Column(
          children: <Widget>[
            Container(
              child: title,
              margin: EdgeInsets.only(bottom: 10),
            ),
            content
          ],
        ));
  }

  // 底部按钮
  // 如果 confirmButtonText || cancelButtonText 为null 代表不显示改按钮
  Widget _initBottom({
    Text confirmButtonText,
    Text cancelButtonText,
    bool bottomOrder,
    Function confirmButtonPress,
    Function cancelButtonPress,
    BorderRadius cancelBorderRadius,
    BorderRadius confirmBorderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: hex('#ccc'), width: 0.4),
      )),
      child: bottomOrder
          ? Row(
              children: <Widget>[
                // 取消按钮
                Container(
                  child: cancelButtonText == null
                      ? null
                      : Expanded(
                          child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            //宽度
                            width: double.infinity,
                            //高度
                            height: 46,
                            // 盒子样式
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: cancelBorderRadius),
                            child: cancelButtonText,
                          ),
                          onTap: () {
                            if (cancelButtonPress == null) {
                              Navigator.pop(context);
                            } else {
                              cancelButtonPress();
                            }
                          },
                        )),
                ),
                Offstage(
                  child: Container(
                    width: 1.2.w,
                    height: 80.h,
                    color: hex('#E5E5E5'),
                  ),
                  offstage: cancelButtonText == null ? true : false,
                ),
                // 确认按钮
                Container(
                  child: Expanded(
                      child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      //宽度
                      width: double.infinity,
                      //高度
                      height: 46,
                      // 盒子样式
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          //设置Border属性给容器添加边框
                          border: new Border.all(
                            //为边框添加颜色
                            color: Colors.transparent,
                            //边框宽度
                            width: 0,
                          ),
                          borderRadius: confirmBorderRadius),
                      child: confirmButtonText,
                    ),
                    onTap: () {
                      if (confirmButtonPress != null) {
                        print('dialog shut...');
                        confirmButtonPress();
                      } else {
                        print('confirmButtonPress==null');
                      }
//                      Navigator.pop(context);
                    },
                  )),
                )
              ],
            )
          : Row(
              children: <Widget>[
                // 确认按钮
                Container(
                  child: Expanded(
                      child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      //宽度
                      width: double.infinity,
                      //高度
                      height: 46,
                      // 盒子样式
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          //设置Border属性给容器添加边框
                          border: new Border.all(
                            //为边框添加颜色
                            color: Colors.transparent,
                            //边框宽度
                            width: 0,
                          ),
                          borderRadius: confirmBorderRadius),
                      child: confirmButtonText,
                    ),
                    onTap: () {
                      if (confirmButtonPress != null) {
                        print('dialog shut...');
                        confirmButtonPress();
                      } else {
                        print('confirmButtonPress==null');
                      }
//                      Navigator.pop(context);
                    },
                  )),
                ),
                Offstage(
                  child: Container(
                    width: 1.2.w,
                    height: 80.h,
                    color: hex('#E5E5E5'),
                  ),
                  offstage: cancelButtonText == null ? true : false,
                ),
                // 取消按钮
                Container(
                  child: cancelButtonText == null
                      ? null
                      : Expanded(
                          child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            //宽度
                            width: double.infinity,
                            //高度
                            height: 46,
                            // 盒子样式
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: cancelBorderRadius),
                            child: cancelButtonText,
                          ),
                          onTap: () {
                            if (cancelButtonPress == null) {
                              Navigator.pop(context);
                            } else {
                              cancelButtonPress();
                            }
                          },
                        )),
                ),
              ],
            ),
    );
  }

  // 初始化dialog
  _initDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
//            scrollDirection: Axis.vertical,
                controller: ScrollController(
                    initialScrollOffset: 0, keepScrollOffset: false),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: StatefulBuilder(builder: (context, state) {
                    return Dialog(
                      shape: RoundedRectangleBorder(

                          ///这个控制整个dialog背景的形状，此处是圆角，它的的child是
                          ///覆盖在dialog上的一层view，它也需要是圆角，底部的两个按钮
                          ///又是这个view上层的子控件，也需要有圆角，最终的dialog才是
                          ///圆角。
                          ///此处的dialog的大小无法控制（系统固定的），如需定制大小，别用
                          ///系统dialog了，普通widget即可。
                          borderRadius: BorderRadius.circular(6)),
//                      insetAnimationDuration: Duration(milliseconds: 500),
//                      insetAnimationCurve: Curves.easeInOut,
                      child: Container(
                          decoration: BoxDecoration(
//                              color: hex('#ff0'),
                              borderRadius: BorderRadius.circular(6)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[/*_title,*/ _content, _bottom],
                          )),
                    );
                  }),
                )),
          );
        });
  }

  _initDialog2({int animType = 0, double width, int duration}) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea();
        },
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: duration ?? 300),
        barrierColor: Colors.black54,
        transitionBuilder: (context, anim1, anim2, child) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: StatefulBuilder(builder: (context, state) {
                final curvedValue =
                    Curves.easeInOutBack.transform(anim1.value) - 1.0;
                return 0 == animType
                    ? Transform.scale(
                        scale: anim1.value,
                        child: width == null
                            ? Dialog(
                                shape: RoundedRectangleBorder(

                                    ///这个控制整个dialog背景的形状，此处是圆角，它的的child是
                                    ///覆盖在dialog上的一层view，它也需要是圆角，底部的两个按钮
                                    ///又是这个view上层的子控件，也需要有圆角，最终的dialog才是
                                    ///圆角。
                                    ///此处的dialog的大小无法控制（系统固定的），如需定制大小，别用
                                    ///系统dialog，普通widget即可。
                                    borderRadius: BorderRadius.circular(6)),
                                child: Container(
                                    decoration: BoxDecoration(
//                            color: hex('#ff0'),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[_content, _bottom],
                                    )),
                              )
                            : Material(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
//                                        color: hex('#ff0'),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[_content, _bottom],
                                    )),
                              ),
                      )
                    : Transform(
                        transform:
                            Matrix4.translationValues(0, curvedValue * 120, 0),
                        transformHitTests: true,
                        child: Opacity(
                          opacity: anim1.value,
                          child: width == null
                              ? Dialog(
                                  shape: RoundedRectangleBorder(

                                      ///这个控制整个dialog背景的形状，此处是圆角，它的的child是
                                      ///覆盖在dialog上的一层view，它也需要是圆角，底部的两个按钮
                                      ///又是这个view上层的子控件，也需要有圆角，最终的dialog才是
                                      ///圆角。
                                      ///此处的dialog的大小无法控制（系统固定的），如需定制大小，别用
                                      ///系统dialog了，普通widget即可。
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          /*_title,*/ _content,
                                          _bottom
                                        ],
                                      )),
                                )
                              : Material(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          /*_title,*/ _content,
                                          _bottom
                                        ],
                                      )),
                                ),
                        ),
                      );
              }),
            ),
          );
        });
  }
}
