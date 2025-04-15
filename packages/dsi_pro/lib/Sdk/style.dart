// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dsi_pro/dsi_pro.dart';
import 'package:flutter/material.dart';

var DSI_PRIMARY_COLOR = DSIHexColor("#0b1bc5");
var DSI_SECONDARY_COLOR = DSIHexColor("#096D9F");
var DSI_ACCENT_COLOR = DSIHexColor("#F4F4FB");

var DSI_PRIMARY_DARK_COLOR = DSIHexColor("#372e0a");
var DSI_SECONDARY_DARK_COLOR = DSIHexColor("#751900");
var DSI_ACCENT_DARK_COLOR = DSIHexColor("#FBF9F4");

DSI_LOADER(context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Container(
        padding: EdgeInsets.all(5),
        height: 45,
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          maxWidth: 350,
        ),
        child: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text("Please wait..."),
          ],
        ),
      ),
    ),
  );
}
