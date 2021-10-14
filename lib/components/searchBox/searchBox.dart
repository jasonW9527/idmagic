import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///搜索框控件
class SearchBox extends StatefulWidget {
  final double height;
  final Color bgColor;
  final Color boxFillColor;
  final Color iconColor;
  final Color txtColor;
  final double txtSize;
  final double width;
  final double iconSize;
  final double borderRadius;
  final double scaling;
  final Widget prefixChild;
  final Widget suffixChild;
  final EdgeInsetsGeometry margin;
  final TextInputFormatter inputFormatter;
  final Function inputTxtCallback;
  final Function searchCallback;

  const SearchBox(
      {Key key,
      this.height,
      this.bgColor,
      this.txtSize,
//      this.maxHeight,
      this.width,
      this.iconSize,
      this.borderRadius,
      this.iconColor,
      this.txtColor,
      this.boxFillColor,
      @required this.inputTxtCallback,
      this.prefixChild,
      this.suffixChild,
      this.inputFormatter,
      this.scaling = 3,
      this.margin,
      this.searchCallback})
      : assert(inputTxtCallback != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchBoxState();
  }
}

class _SearchBoxState extends State<SearchBox> {
  bool hasInput = false;
  String inputStr = '';
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.blue, width: 1.0), //灰色的一层边框
        color: Colors.grey,
        borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (v) {
          if (widget.searchCallback != null) widget.searchCallback();
        },
        decoration: InputDecoration(
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.only(
            left: 40.w,
          ),
          hintText: '请输入搜索内容',
          hintStyle:
              TextStyle(fontSize: widget.txtSize ?? 28.sp, color: Colors.grey),
          suffixIcon: widget.suffixChild ??
              Container(
                width: 160.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      child: InkWell(
                        child: Icon(
                          Icons.cancel,
                          color: widget.iconColor ?? Colors.grey,
                          size: widget.iconSize != null
                              ? widget.iconSize / 1.3
                              : 40.sp,
                        ),
                        onTap: () {
                          //一帧刷新后执行一个回调，不会冲突
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.clear();
                            inputStr = controller.text;
                            if (inputStr.isNotEmpty)
                              setState(() {
                                hasInput = true;
                              });
                            else
                              setState(() {
                                hasInput = false;
                              });
                            widget.inputTxtCallback(inputStr);
                          });
                        },
                      ),
                      offstage: !hasInput,
                    ),
                    InkWell(
                      child: Container(
                          margin: EdgeInsets.only(left: 20.w, right: 20.w),
                          child: SizedBox(
                            width: 40.w,
                            height: 40.w,
                            child: Image.asset(
                              'lib/assets/images/search_icon.png',
                              color: widget.iconColor ?? Colors.blueAccent,
                            ),
                          )),
                      onTap: () {
                        print('search....');
                        if (widget.searchCallback != null) {
                          widget.searchCallback();
                        }
                      },
                    )
                  ],
                ),
              ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: widget.boxFillColor ?? Colors.white,
        ),
        style: TextStyle(
            color: widget.txtColor ?? Colors.black,
            fontSize: widget.txtSize ?? 28.sp),
        inputFormatters:
            widget.inputFormatter != null ? [widget.inputFormatter] : null,
        controller: controller,
        onChanged: (e) {
          setState(() {
            inputStr = e;
          });

          if (inputStr.isNotEmpty)
            setState(() {
              hasInput = true;
            });
          else
            setState(() {
              hasInput = false;
            });

          widget.inputTxtCallback(e);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
