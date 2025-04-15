// ignore_for_file: must_be_immutable, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';

import '../config.dart';

class DSI_PRIMARY_BUTTON extends StatefulWidget {
  DSI_PRIMARY_BUTTON({
    super.key,
    required this.title,
    this.borderradius,
    this.buttonColor,
    this.height,
    this.textColor,
    this.width,
    required this.onPressed,
    this.alignment,
    this.border,
    this.fontSize,
    this.fontWeight,
    this.buttonHoverRadius,
    this.hoverButtonColor,
    this.hoverColor,
  });
  final String title;
  final Function onPressed;
  var height,
      width,
      buttonColor,
      borderradius,
      textColor,
      alignment,
      fontSize,
      border,
      fontWeight,
      buttonHoverRadius,
      hoverButtonColor,
      hoverColor;

  @override
  State<DSI_PRIMARY_BUTTON> createState() => _DSI_PRIMARY_BUTTONState();
}

class _DSI_PRIMARY_BUTTONState extends State<DSI_PRIMARY_BUTTON> {
  bool isHoverd = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: widget.buttonHoverRadius ??
          BorderRadius.circular(DSI_CONFIG.appBorderRadius),
      onFocusChange: (v) {
        print(v.toString());
        isHoverd = v;
        setState(() {});
      },
      onHover: (v) {
        isHoverd = v;
        setState(() {});
      },
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        alignment: widget.alignment ?? Alignment.center,
        height: widget.height ?? 45,
        width: widget.width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isHoverd
              ? widget.hoverButtonColor.toString() != "null"
                  ? widget.hoverButtonColor
                  : Colors.transparent
              : widget.buttonColor.toString() != "null"
                  ? widget.buttonColor
                  : DSI_CONFIG.appPrimaryColor,
          borderRadius: widget.borderradius ??
              BorderRadius.circular(DSI_CONFIG.appBorderRadius),
          border: widget.border ??
              Border.all(
                color: isHoverd
                    ? widget.hoverColor.toString() != "null"
                        ? widget.hoverColor
                        : const Color.fromARGB(255, 15, 37, 54)
                    : Colors.transparent,
              ),
        ),
        child: Text(
          widget.title.toString(),
          style: TextStyle(
            color: widget.textColor.toString() != "null"
                ? widget.textColor
                : isHoverd
                    ? widget.textColor.toString() != "null"
                        ? widget.hoverColor
                        : Colors.black
                    : Colors.white,
            fontSize: widget.fontSize ?? 14,
            fontWeight: widget.fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class DSI_SECONDARY_BUTTON extends StatelessWidget {
  DSI_SECONDARY_BUTTON({
    super.key,
    required this.title,
    this.borderradius,
    this.buttonColor,
    this.height,
    this.textColor,
    this.width,
    required this.onPressed,
    this.alignment,
    this.border,
    this.fontSize,
    this.fontWeight,
    this.borderColor,
  });
  final String title;
  final Function onPressed;
  var height,
      width,
      buttonColor,
      borderradius,
      textColor,
      alignment,
      fontSize,
      border,
      fontWeight,
      borderColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: height ?? 45,
        alignment: alignment ?? Alignment.center,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: buttonColor.toString() != "null"
              ? buttonColor
              : Color.fromARGB(255, 109, 106, 106),
          borderRadius:
              borderradius ?? BorderRadius.circular(DSI_CONFIG.appBorderRadius),
          border:
              border ?? Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Text(
          title.toString(),
          style: TextStyle(
            color: textColor.toString() != "null" ? textColor : Colors.white,
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class DSI_ICON_BUTTON extends StatefulWidget {
  DSI_ICON_BUTTON({
    super.key,
    required this.title,
    this.borderradius,
    this.buttonColor,
    this.height,
    this.textColor,
    this.width,
    required this.icon,
    required this.onPressed,
    this.iconSize,
    this.iconColor,
    this.buttonHoverRadius,
    this.toolTip,
  });
  final String title;
  var height, width, buttonColor, borderradius, textColor;
  var icon, iconSize, iconColor, buttonHoverRadius, toolTip;
  final Function onPressed;

  @override
  State<DSI_ICON_BUTTON> createState() => _DSI_ICON_BUTTONState();
}

class _DSI_ICON_BUTTONState extends State<DSI_ICON_BUTTON> {
  bool isHoverd = false;
  @override
  Widget build(BuildContext context) {
    bool isNarrow = MediaQuery.of(context).size.width < 400;
    return InkWell(
      borderRadius: widget.buttonHoverRadius ??
          BorderRadius.circular(DSI_CONFIG.appBorderRadius),
      onFocusChange: (v) {
        // print(v.toString());
        isHoverd = v;
        setState(() {});
      },
      onHover: (v) {
        isHoverd = v;
        setState(() {});
      },
      onTap: () {
        if (widget.onPressed.toString() != "null") {
          widget.onPressed();
        }
      },
      child: Tooltip(
        message: widget.toolTip ?? "",
        child: Container(
          height: widget.height.toString() != "null" ? widget.height : 45.0,
          width: widget.width.toString() != "null"
              ? widget.width
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.buttonColor.toString() != "null"
                ? widget.buttonColor
                : isHoverd
                    ? Colors.transparent
                    : DSI_CONFIG.appPrimaryColor,
            borderRadius: widget.borderradius ??
                BorderRadius.circular(DSI_CONFIG.appBorderRadius),
            border:
                Border.all(color: isHoverd ? Colors.black : Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: widget.iconSize.toString() != "null"
                    ? double.parse(widget.iconSize.toString())
                    : 16.0,
                color:
                    widget.iconColor ?? isHoverd ? Colors.black : Colors.white,
              ),
              if (!isNarrow && widget.title.toString() != "")
                SizedBox(width: 10),
              if (!isNarrow && widget.title.toString() != "")
                Text(
                  widget.title.toString(),
                  style: TextStyle(
                      color: widget.textColor.toString() != "null"
                          ? widget.textColor
                          : isHoverd
                              ? Colors.black
                              : Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
