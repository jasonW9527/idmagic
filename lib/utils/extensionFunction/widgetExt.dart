export 'package:widget_chain/widget_chain.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///对widget_chain库做扩展
extension MyWidgetChain on Widget {
  ///点击事件
  InkWell intoInkWell({
    Key key,
    GestureTapCallback onTap,
    GestureTapCallback onDoubleTap,
    GestureLongPressCallback onLongPress,
    GestureTapDownCallback onTapDown,
    GestureTapCancelCallback onTapCancel,
    ValueChanged<bool> onHighlightChanged,
    ValueChanged<bool> onHover,
    MouseCursor mouseCursor,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    MaterialStateProperty<Color> overlayColor,
    Color splashColor,
    InteractiveInkFeatureFactory splashFactory,
    double radius,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    bool enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode focusNode,
    bool canRequestFocus = true,
    ValueChanged<bool> onFocusChange,
    bool autofocus = false,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      onHighlightChanged: onHighlightChanged,
      onHover: onHover,
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      overlayColor: overlayColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      child: this,
    );
  }
}
