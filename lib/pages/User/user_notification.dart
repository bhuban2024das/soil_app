import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Text(
          "No notifications yet",
          style: TextStyle(
            color: Colors.black54, // Light black color
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
