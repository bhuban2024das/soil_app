import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

const double defaultRadius = 10.0;
const double defaultPadding = 10.0;

const double defaultIconSize = 20.0;
var defaultAppColor = DSIHexColor("#0800F5");
var defaultTxtColor = DSIHexColor("#F8F4FB");

class DSI_CONFIG {
  static Color appPrimaryColor = Colors.blue;
  static Color appAccentColor = Colors.white;
  static Color appSecondaryColor = Colors.white;
  static Color appBorderColor = Colors.transparent;
  static Color iconColor = const Color.fromARGB(255, 43, 39, 68);

  static double appBorderRadius = 4.0;
  static double appDefaultMargin = 10.0;
  static double appDefaultPadding = 18.0;
  static double iconSize = 18.0;
  static double fontSize = 14.0;
}

void initializeDSIPro({
  Color? primaryColor,
  Color? secondaryColor,
  Color? accentColor,
  Color? appBorderColor,
  Color? iconColor,
  double? borderRadius,
  double? defaultMargin,
  double? defaultPadding,
  double? fontSize,
  double? iconSize,
}) {
  DSI_CONFIG.appPrimaryColor = primaryColor ?? DSI_CONFIG.appPrimaryColor;
  DSI_CONFIG.appSecondaryColor = primaryColor ?? DSI_CONFIG.appSecondaryColor;
  DSI_CONFIG.appAccentColor = accentColor ?? DSI_CONFIG.appAccentColor;
  DSI_CONFIG.appBorderColor = appBorderColor ?? DSI_CONFIG.appBorderColor;
  DSI_CONFIG.appBorderRadius = borderRadius ?? DSI_CONFIG.appBorderRadius;
  DSI_CONFIG.appDefaultMargin = defaultMargin ?? DSI_CONFIG.appDefaultMargin;
  DSI_CONFIG.appDefaultPadding = defaultPadding ?? DSI_CONFIG.appDefaultPadding;

  DSI_CONFIG.iconColor = iconColor ?? DSI_CONFIG.iconColor;
  DSI_CONFIG.iconSize = iconSize ?? DSI_CONFIG.iconSize;
  DSI_CONFIG.fontSize = fontSize ?? DSI_CONFIG.fontSize;
}

class ToastType {
  static const String NORMAL = "normal";
  static const String ERROR = "error";
  static const String SUCCESS = "success";
  static const String WARNING = "warning";
}
