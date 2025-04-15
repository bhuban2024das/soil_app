// ignore_for_file: must_be_immutable, camel_case_types, file_names, prefer_typing_uninitialized_variables, prefer_const_constructors, sized_box_for_whitespace

import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

import 'widget/dsiselect_modal.dart';

class DSI_TEXT_BOX extends StatelessWidget {
  DSI_TEXT_BOX({
    super.key,
    this.label,
    this.border,
    required this.controller,
    this.borderradius,
    this.prefix,
    this.suffix,
    this.height,
    this.width,
    this.textAlign,
    this.textAlignVertical,
    this.isNumber,
    this.isPassword,
    this.decoration,
    this.textColor,
    this.isReadonly,
    this.onChanged,
    this.maxLength,
    this.maxLines,
  });
  var label,
      border,
      borderradius,
      controller,
      prefix,
      suffix,
      height,
      width,
      textAlign,
      textAlignVertical,
      isNumber,
      isPassword,
      decoration,
      textColor,
      isReadonly,
      onChanged,
      maxLength,
      maxLines;

  @override
  Widget build(BuildContext context) {
    bool isNarrow = MediaQuery.of(context).size.width < 300;
    if (controller != null) {
      if (controller.text.toString() == "" ||
          controller.text.toString() == "null") {
        controller.text = "";
      }
    }
    return Container(
      height: height.toString() != "null" ? height : 45.0,
      width: width.toString() != "null" ? width : 230.0,
      child: TextFormField(
        maxLength: maxLength ?? 100,
        maxLines: maxLines ?? 1,
        onChanged: (v) {
          if (onChanged != null) {
            onChanged(v);
          }
        },
        readOnly: isReadonly ?? false,
        obscureText: isPassword.toString() == "true" ? true : false,
        keyboardType: isNumber.toString() == "true"
            ? TextInputType.number
            : TextInputType.text,
        textAlign: textAlign ?? TextAlign.start,
        textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
        controller: controller,
        cursorColor: textColor.toString() != "null" ? textColor : Colors.black,
        decoration: decoration ??
            InputDecoration(
              counterText: "",
              counterStyle: TextStyle(fontSize: 1),
              label: Text(label ?? ""),
              prefixIcon: isNarrow
                  ? null
                  : prefix != null
                      ? prefix
                      : null,
              suffixIcon: isNarrow
                  ? null
                  : suffix != null
                      ? suffix
                      : null,
              border: border ??
                  OutlineInputBorder(
                    borderRadius: borderradius ??
                        BorderRadius.circular(DSI_CONFIG.appBorderRadius),
                    borderSide: BorderSide(
                        color: textColor.toString() != "null"
                            ? textColor
                            : Colors.black),
                  ),
              labelStyle: TextStyle(
                  color: textColor.toString() != "null"
                      ? textColor
                      : Colors.black),
            ),
        style: TextStyle(
            color: textColor.toString() != "null" ? textColor : Colors.black),
      ),
    );
  }
}

class DSI_TEXT_BOX_WITH_VALUE extends StatelessWidget {
  DSI_TEXT_BOX_WITH_VALUE(
      {super.key,
      this.label,
      this.border,
      this.borderradius,
      this.prefix,
      this.suffix,
      this.height,
      this.width,
      this.textAlign,
      this.textAlignVertical,
      this.isNumber,
      this.isPassword,
      required this.onChanged,
      required this.initialValue,
      this.decoration,
      this.textColor,
      this.maxLength,
      this.isReadonly,
      this.maxLines});
  var label,
      border,
      borderradius,
      prefix,
      suffix,
      height,
      width,
      textAlign,
      textAlignVertical,
      isNumber,
      isPassword,
      initialValue,
      decoration,
      textColor,
      maxLength,
      isReadonly,
      maxLines;
  Function onChanged;
  @override
  Widget build(BuildContext context) {
    bool isNarrow = MediaQuery.of(context).size.width < 300;
    return Container(
      height: height ?? 55,
      width: width ?? 230,
      padding: EdgeInsets.all(0),
      child: TextFormField(
        scrollPadding: EdgeInsets.all(0),
        maxLines: maxLines ?? 1,
        maxLength: maxLength ?? 100,
        obscureText: isPassword.toString() == "true" ? true : false,
        keyboardType: isNumber.toString() == "true"
            ? TextInputType.number
            : TextInputType.text,
        readOnly: isReadonly ?? false,
        textAlign: textAlign ?? TextAlign.start,
        textAlignVertical: textAlignVertical ?? TextAlignVertical.bottom,
        initialValue: initialValue.toString() == "null" ? "" : initialValue,
        onChanged: (v) {
          onChanged(v);
        },
        cursorColor: textColor.toString() != "null" ? textColor : Colors.black,
        decoration: decoration ??
            InputDecoration(
              prefixIcon: isNarrow
                  ? null
                  : prefix != null
                      ? prefix
                      : null,
              suffixIcon: isNarrow
                  ? null
                  : suffix != null
                      ? suffix
                      : null,
              contentPadding: EdgeInsets.all(16),
              counterText: "",
              counterStyle: TextStyle(fontSize: 1),
              label: Text(label ?? ""),
              labelStyle: TextStyle(
                  color: textColor.toString() != "null"
                      ? textColor
                      : Colors.black),
              border: border ??
                  OutlineInputBorder(
                    borderRadius: borderradius ??
                        BorderRadius.circular(DSI_CONFIG.appBorderRadius),
                    borderSide: BorderSide(
                      color: textColor.toString() != "null"
                          ? textColor
                          : Colors.black,
                    ),
                  ),
            ),
        style: TextStyle(
            color: textColor.toString() != "null" ? textColor : Colors.black),
      ),
    );
  }
}

class DSI_SELECT_BOX extends StatelessWidget {
  DSI_SELECT_BOX(
      {super.key,
      this.label,
      this.border,
      this.borderradius,
      this.prefix,
      this.suffix,
      this.height,
      this.width,
      this.textAlign,
      this.textAlignVertical,
      this.isNumber,
      this.isPassword,
      required this.onChanged,
      required this.initialValue,
      this.decoration,
      this.textColor,
      this.maxLength,
      this.isReadonly,
      required this.item,
      required this.data,
      this.subtitle,
      this.cancelText,
      this.cancelTextColor});
  final String item;
  final List data;
  var label,
      border,
      borderradius,
      prefix,
      suffix,
      height,
      width,
      textAlign,
      textAlignVertical,
      isNumber,
      isPassword,
      initialValue,
      decoration,
      textColor,
      maxLength,
      isReadonly,
      subtitle;
  Function onChanged;
  final String? cancelText;
  final Color? cancelTextColor;

  @override
  Widget build(BuildContext context) {
    bool isNarrow = MediaQuery.of(context).size.width < 300;
    return Container(
      height: height ?? 55,
      width: width ?? 230,
      padding: EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
          DSI_BOTTOM_MODAL(
            context,
            DSI_SELECT_BOX_WIDGET_NOT_FOR_USE(
              onChanged: onChanged,
              initialValue: initialValue,
              item: item,
              data: data,
              subtitle: subtitle,
            ),
            cancelText: cancelText ?? "Cancel",
            textColor: cancelTextColor ?? Colors.red,
          );
        },
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            counterText: "",
            counterStyle: TextStyle(fontSize: 1),
            label: Text(label ?? ""),
            prefixIcon: isNarrow ? null : prefix,
            suffixIcon: isNarrow ? null : suffix,
            labelStyle: TextStyle(
                color:
                    textColor.toString() != "null" ? textColor : Colors.black),
            border: border ??
                OutlineInputBorder(
                  borderRadius: borderradius ??
                      BorderRadius.circular(DSI_CONFIG.appBorderRadius),
                  borderSide: BorderSide(
                    color: textColor.toString() != "null"
                        ? textColor
                        : Colors.black,
                  ),
                ),
          ),
          child: Text(initialValue.toString() == "null" ? "" : initialValue),
        ),
      ),
    );
  }
}

class DSI_SELECT_BOX_MULTIPLE extends StatefulWidget {
  DSI_SELECT_BOX_MULTIPLE(
      {super.key,
      this.label,
      this.border,
      this.borderradius,
      this.prefix,
      this.suffix,
      this.height,
      this.width,
      this.textAlign,
      this.textAlignVertical,
      this.isNumber,
      this.isPassword,
      required this.onChanged,
      required this.initialValue,
      this.decoration,
      this.textColor,
      this.maxLength,
      this.isReadonly,
      required this.item,
      required this.data,
      this.subtitle,
      this.cancelText,
      this.cancelTextColor});
  final String? cancelText;
  final Color? cancelTextColor;
  final String item;
  final List data;
  final List initialValue; // Changed to List to store multiple selected values
  var label,
      border,
      borderradius,
      prefix,
      suffix,
      height,
      width,
      textAlign,
      textAlignVertical,
      isNumber,
      isPassword,
      decoration,
      textColor,
      maxLength,
      isReadonly,
      subtitle;
  Function(List<dynamic>) onChanged; // Return the selected list

  @override
  _DSI_SELECT_BOX_MULTIPLEState createState() =>
      _DSI_SELECT_BOX_MULTIPLEState();
}

class _DSI_SELECT_BOX_MULTIPLEState extends State<DSI_SELECT_BOX_MULTIPLE> {
  List<dynamic> selectedItems = [];

  onUpdated(var v) {
    setState(() {
      selectedItems = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isNarrow = MediaQuery.of(context).size.width < 300;
    return Container(
      height: widget.height ?? 55,
      child: InkWell(
        onTap: () {
          DSI_BOTTOM_MODAL(
            context,
            DSI_SELECT_MULTIPLE_BOX_WIDGET_NOT_FOR_USE(
              onChanged: widget.onChanged,
              initialValue: widget.initialValue,
              item: widget.item,
              data: widget.data,
              onUpdated: onUpdated,
              prefilled: selectedItems,
            ),
            cancelText: widget.cancelText ?? "Cancel",
            textColor: widget.cancelTextColor ?? Colors.red,
          );
        },
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            counterText: "",
            counterStyle: TextStyle(fontSize: 1),
            label: Text(widget.label ?? ""),
            prefixIcon: isNarrow ? null : widget.prefix,
            suffixIcon: isNarrow ? null : widget.suffix,
            labelStyle: TextStyle(
                color: widget.textColor.toString() != "null"
                    ? widget.textColor
                    : Colors.black),
            border: widget.border ??
                OutlineInputBorder(
                  borderRadius: widget.borderradius ??
                      BorderRadius.circular(DSI_CONFIG.appBorderRadius),
                  borderSide: BorderSide(
                    color: widget.textColor.toString() != "null"
                        ? widget.textColor
                        : Colors.black,
                  ),
                ),
          ),
          child: selectedItems.isEmpty
              ? Text("Select")
              : Text(selectedItems.join(", ")), // Display selected items
        ),
      ),
    );
  }
}
