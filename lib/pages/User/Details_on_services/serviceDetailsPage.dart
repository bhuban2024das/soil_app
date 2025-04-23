import 'package:flutter/material.dart';

import 'package:original/pages/User/Details_on_services/services.dart';

class ServiceDetailPage extends StatelessWidget {
  final int index;

  const ServiceDetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final service = services[index];

    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/services/seeds.jpg'),
            const SizedBox(height: 16),
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
