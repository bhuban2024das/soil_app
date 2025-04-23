import 'package:flutter/material.dart';

class AgentNotifiaction extends StatelessWidget {
  const AgentNotifiaction({super.key});

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
