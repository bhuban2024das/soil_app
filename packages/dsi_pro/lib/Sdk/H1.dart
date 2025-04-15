// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  var text, color, fontWeight, fontSize, textAlign, fontFamily;
  final int? maxlIne;
  final TextOverflow? overflow;
  H1(
      {super.key,
      required this.text,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.textAlign,
      this.fontFamily,
      this.maxlIne,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxlIne ?? 1,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize.toString() != "null"
            ? double.parse(fontSize.toString())
            : double.parse("26"),
        fontWeight: fontWeight ?? FontWeight.w500,
        fontFamily: fontFamily ?? "Airal",
      ),
      softWrap: true,
    );
  }
}
