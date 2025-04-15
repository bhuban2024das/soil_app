// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';

class H2 extends StatelessWidget {
  var text, color, fontWeight, fontSize, textAlign, fontFamily;
  final int? maxlIne;
  final TextOverflow? overflow;
  H2({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
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
            : double.parse("21"),
        fontWeight: fontWeight ?? FontWeight.w500,
        fontFamily: fontFamily ?? "Airal",
      ),
      softWrap: true,
    );
  }
}
