// ignore_for_file: camel_case_types, must_be_immutable, file_names, prefer_const_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class DSI_OTP_BOX extends StatefulWidget {
  DSI_OTP_BOX({
    super.key,
    required this.length,
    required this.onComplete,
    this.borderradius,
    this.borderColor,
    this.backgroundColor,
    this.border,
    this.height,
    this.padding,
    this.textColor,
    this.width,
  });
  final int length;
  final Function onComplete;
  var borderradius,
      borderColor,
      border,
      height,
      width,
      padding,
      textColor,
      backgroundColor;
  @override
  State<DSI_OTP_BOX> createState() => _DSI_OTP_BOXState();
}

class _DSI_OTP_BOXState extends State<DSI_OTP_BOX> {
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes
    otpControllers =
        List.generate(widget.length, (index) => TextEditingController());
    focusNodes = List.generate(
      widget.length,
      (index) => FocusNode(),
    );
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].dispose();
      focusNodes[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: widget.height ?? 60,
        padding: EdgeInsets.all(18),
        child: Row(
          children: List.generate(
            widget.length,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  height: widget.height ?? 60,
                  width: widget.width ?? 60,
                  child: TextFormField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.isNotEmpty &&
                          index < otpControllers.length - 1) {
                        // Move focus to the next OTP box
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        // Clear the previous OTP box
                        otpControllers[index - 1].clear();
                        // Move focus to the previous OTP box
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index - 1]);
                      } else if (value.isEmpty && index == 0) {
                        // Clear the current OTP box
                        otpControllers[index].clear();
                      } else if (value.isNotEmpty &&
                          index == otpControllers.length - 1) {
                        // Show dialog with the entered OTP
                        String otp = "";
                        for (var controller in otpControllers) {
                          otp += controller.text;
                        }
                        widget.onComplete(otp);
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: widget.backgroundColor ?? Colors.transparent,
                      contentPadding: EdgeInsets.all(2),
                      border: widget.border ??
                          OutlineInputBorder(
                            borderSide: BorderSide(
                              color: widget.borderColor ?? Colors.black,
                            ),
                            borderRadius:
                                widget.borderradius ?? BorderRadius.circular(4),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
