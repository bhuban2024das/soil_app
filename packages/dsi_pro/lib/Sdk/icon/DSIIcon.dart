import 'package:dsi_pro/config.dart';
import 'package:flutter/material.dart';

class DSI_ICON extends StatelessWidget {
  DSI_ICON(
      {super.key,
      this.border,
      this.borderColor,
      this.borderRadius,
      this.color,
      required this.icon,
      this.iconColor,
      this.iconSize,
      this.onTap,
      this.size,
      this.padding,
      this.height,
      this.width});
  var icon,
      height,
      width,
      size,
      color,
      iconSize,
      border,
      borderRadius,
      iconColor,
      borderColor,
      onTap,
      padding;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap ? onTap() : null;
      },
      child: Container(
        height: height ?? 22,
        width: width ?? 22,
        padding: padding ?? EdgeInsets.all(DSI_CONFIG.appDefaultPadding),
        decoration: BoxDecoration(
          border: border ??
              Border.all(color: borderColor ?? DSI_CONFIG.appBorderColor),
          borderRadius:
              borderRadius ?? BorderRadius.circular(DSI_CONFIG.appBorderRadius),
        ),
        child: Icon(icon,
            size: size ?? 18, color: iconColor ?? DSI_CONFIG.appPrimaryColor),
      ),
    );
  }
}

class DSI_ICON_BOX extends StatelessWidget {
  DSI_ICON_BOX(
      {super.key,
      this.border,
      this.borderColor,
      this.borderRadius,
      this.color,
      this.child,
      this.iconColor,
      this.iconSize,
      this.onTap,
      this.size,
      this.padding,
      this.height,
      this.width});
  var child,
      height,
      width,
      size,
      color,
      iconSize,
      border,
      borderRadius,
      iconColor,
      borderColor,
      onTap,
      padding;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap ? onTap() : null;
      },
      child: Container(
        height: height ?? 22,
        width: width ?? 22,
        padding: padding ?? EdgeInsets.all(DSI_CONFIG.appDefaultPadding),
        decoration: BoxDecoration(
          border: border ??
              Border.all(color: borderColor ?? DSI_CONFIG.appBorderColor),
          borderRadius:
              borderRadius ?? BorderRadius.circular(DSI_CONFIG.appBorderRadius),
        ),
        child: child,
      ),
    );
  }
}
