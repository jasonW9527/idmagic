import 'dart:async';

import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///switch开关
class SwitchWidget extends StatefulWidget {
  final String title1;
  final String title2;
  final Color selectColor;
  final Color unSelectColor;
  final double width;
  final double height;
  final double textSize;
  final Color selectTextColor;
  final Color unSelectTextColor;
  final int initedValue;
  final BorderRadius borderRadius;
  final Function selectCallback;

  const SwitchWidget(
      {Key key,
      this.title1 = '标题1',
      this.title2 = '标题2',
      this.selectColor,
      this.unSelectColor,
      this.width,
      this.height,
      this.borderRadius,
      this.textSize,
      this.selectTextColor,
      this.unSelectTextColor,
      this.selectCallback,
      this.initedValue = 0})
      : super(key: key);
  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  final _controller = new PageController();
  final int pageSwitchAnimatedTime = 200;

//  double centerPoint = ScreenUtil().setWidth(318) / 2;
  double value;
  static double _defWidth = 150;
  static double _defHeight = 40;
  final List<Widget> _pages = <Widget>[
//    MatchCp(),
//    MatchHistory(),
  ];
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initedValue;
    value = widget.initedValue * (widget.width ?? _defWidth) / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: hex('#00f'),
//      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          //主题Body
          InkWell(
            onTap: () {
              setState(() {
                if (this.value == 0.0) {
                  this.value = (widget.width ?? _defWidth) / 2;
                  currentIndex = 1;
                } else {
                  currentIndex = 0;
                  this.value = 0.0;
                }
                if (widget.selectCallback != null) {
                  print('index==$currentIndex');
                  widget
                      .selectCallback(currentIndex == 1 ? 0 : 1); //控制按钮0-1逻辑正反
                }
              });
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // 切换Tab
                  Center(
                    child: Stack(
                      children: <Widget>[
                        // 主题
                        GestureDetector(
                          child: Container(
                            width: widget.width ?? _defWidth,
                            height: widget.height ?? _defHeight,
                            decoration: BoxDecoration(
                              color: widget.unSelectColor ?? Color(0xffF3F4F5),
                              borderRadius: widget.borderRadius ??
                                  BorderRadius.circular(30),
                              /*border:
                                  Border.all(color: Colors.grey, width: 1)*/
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  widget.title1 ?? '',
                                  style: TextStyle(
                                    color: widget.unSelectTextColor ??
                                        Color(0xff999999),
                                    fontSize: widget.textSize ?? 14,
                                  ),
                                ),
                                Text(
                                  widget.title2 ?? '',
                                  style: TextStyle(
                                    color: widget.unSelectTextColor ??
                                        Color(0xff999999),
                                    fontSize: widget.textSize ?? 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 滑块
                        AnimatedPositioned(
                          left: this.value,
                          duration:
                              Duration(milliseconds: pageSwitchAnimatedTime),
                          child: Container(
                            width: (widget.width ?? _defWidth) / 2,
                            height: widget.height ?? _defHeight,
                            decoration: BoxDecoration(
                                color: widget.selectColor ?? Color(0xffED9CBE),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(70)),
                                border: Border.all(
                                    color: hex('#f2f2f2'), width: 1)),
                            child: Center(
                              child: Text(
                                currentIndex == 1
                                    ? widget.title2 ?? ''
                                    : widget.title1 ?? '',
                                style: TextStyle(
                                  color: widget.selectTextColor ?? Colors.white,
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
