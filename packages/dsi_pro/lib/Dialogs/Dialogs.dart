// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';

DSIProressDialog(context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Container(
        height: 45,
        child: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text("Please wait...")
          ],
        ),
      ),
    ),
  );
}

DSIAlertDialog(context, String text, Function onPressed) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Text(text),
      actions: [
        TextButton(
            onPressed: () {
              onPressed();
            },
            child: Text("OK"))
      ],
    ),
  );
}

DSIConfirmDialog(context,
    {Function? onPressed,
    String titleText = "Demo Confirm",
    String btnText = "Ok",
    bool isDismissible = true}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Text(titleText),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed!();
            },
            child: Text(btnText)),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel")),
      ],
    ),
  );
}

DSIErrorDialog(context, String text, Function onPressed) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      content: Text(text),
      actions: [
        TextButton(
            onPressed: () {
              onPressed();
            },
            child: Text("Try again later"))
      ],
    ),
  );
}
