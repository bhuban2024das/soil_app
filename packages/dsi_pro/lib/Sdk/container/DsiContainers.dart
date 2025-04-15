import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

class DSI_CONTAINER extends StatelessWidget {
  DSI_CONTAINER({
    super.key,
    this.alignment,
    this.border,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.child,
    this.color,
    this.decoration,
    this.height,
    this.margin,
    this.padding,
    this.width,
  });
  var height,
      width,
      color,
      decoration,
      border,
      borderRadius,
      margin,
      padding,
      child,
      alignment,
      boxShadow,
      borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 0,
      width: width ?? DSIheightWidth(context, 100, false),
      padding: padding ?? EdgeInsets.all(DSI_CONFIG.appDefaultPadding),
      margin: margin ?? EdgeInsets.all(DSI_CONFIG.appDefaultMargin),
      decoration: decoration ??
          BoxDecoration(
            color: color ?? DSI_CONFIG.appAccentColor,
            borderRadius: borderRadius ??
                BorderRadius.circular(DSI_CONFIG.appBorderRadius),
            border: border ??
                Border.all(color: borderColor ?? DSI_CONFIG.appBorderColor),
          ),
      child: child ?? Container(),
    );
  }
}

class DBR extends StatelessWidget {
  DBR({super.key, this.height, this.width});
  var height, width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 10,
      width: width ?? 10,
    );
  }
}
