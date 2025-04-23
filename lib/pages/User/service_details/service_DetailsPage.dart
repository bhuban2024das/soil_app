import 'package:flutter/material.dart';
// import 'package:original/pages/User/service_details/service_model.dart';

class ServiceDetailPage extends StatelessWidget {
  final String title;
  final String description;

  const ServiceDetailPage({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green, // Optional: set your desired color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
