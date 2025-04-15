// ignore_for_file: must_be_immutable, dead_code, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

class DSI_PERCENT_INDICATOR extends StatelessWidget {
  DSI_PERCENT_INDICATOR(
      {super.key,
      this.backgroundColor,
      this.borderradius,
      this.color,
      this.height,
      this.width,
      required this.percentage});
  var height, width, color, borderradius, backgroundColor;
  final double percentage;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 10,
      width: width ?? MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height,
        width: DSIDrawerheightWidth(context, percentage, false),
        decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: borderradius ?? BorderRadius.circular(15),
        ),
      ),
    );
  }
}

DSIheightWidth(context, percentage, isHeight) {
  double raw;

  if (isHeight) {
    raw = MediaQuery.of(context).size.height;
    double res = percentage * raw / 100;
    return res;
  } else {
    raw = MediaQuery.of(context).size.width;
    double res = percentage * raw / 100;
    return res;
  }
  return 0;
}

DSIDrawerheightWidth(context, percentage, isHeight) {
  double raw;
  if (isHeight) {
    raw = MediaQuery.of(context).size.height;
    double res = percentage * raw / 100;
    return res - 80;
  } else {
    raw = MediaQuery.of(context).size.width - 140;
    double res = percentage * raw / 100;
    return res;
  }
  return 0;
}
