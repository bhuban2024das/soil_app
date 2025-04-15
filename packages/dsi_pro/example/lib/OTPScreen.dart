// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DTR("confirm", "eng"),
          style: TextStyle(fontFamily: "DSI5"),
        ),
        elevation: 5,
      ),
      body: DSI_OTP_BOX(
        backgroundColor: Colors.orange,
        borderColor: Colors.orange,
        height: 90.0,
        length: 10,
        onComplete: (v) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(v.toString()),
            ),
          );
        },
        borderradius: BorderRadius.circular(5),
      ),
    );
  }
}
