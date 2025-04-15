// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';

class H3 extends StatelessWidget {
  var text, color, fontWeight, fontSize, textAlign, fontFamily;
  final int? maxlIne;
  final TextOverflow? overflow;
  H3({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.fontSize,
    this.fontFamily,
    this.maxlIne,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxlIne ?? 1,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize.toString() != "null"
            ? double.parse(fontSize.toString())
            : double.parse("18"),
        fontWeight: fontWeight ?? FontWeight.w500,
        fontFamily: fontFamily ?? "Airal",
      ),
      softWrap: true,
    );
  }
}

class H4 extends StatelessWidget {
  var text, color, fontWeight, fontSize, textAlign, fontFamily;
  final int? maxlIne;
  final TextOverflow? overflow;
  H4({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.fontSize,
    this.fontFamily,
    this.maxlIne,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlIne ?? 1,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize.toString() != "null"
            ? double.parse(fontSize.toString())
            : double.parse("15"),
        fontWeight: fontWeight ?? FontWeight.w500,
        fontFamily: fontFamily ?? "Airal",
      ),
      softWrap: true,
    );
  }
}
