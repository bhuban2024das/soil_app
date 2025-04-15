// ignore_for_file: file_names, non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

DSI_BOTTOM_MODAL(context, child,
    {String cancelText = "Cancel", Color textColor = Colors.red}) {
  double width = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (_) => Container(
      height: 535,
      padding: width < 600
          ? EdgeInsets.only(left: 15, right: 15, bottom: 20)
          : EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 450,
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                cancelText.toString(),
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

DSI_BOTTOM_MODAL_CALLBACK(context, child) {
  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (_) => Container(
      height: 535,
      // padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: 450,
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
