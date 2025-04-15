// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  var text, color, fontWeight, fontSize, textAlign;
  Paragraph({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize.toString() != "null"
              ? double.parse(fontSize.toString())
              : double.parse("14"),
          fontWeight: fontWeight ?? FontWeight.normal),
    );
  }
}
