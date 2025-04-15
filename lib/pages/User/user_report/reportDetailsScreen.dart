import 'package:flutter/material.dart';
import 'package:original/pages/User/user_report/soilTestReport_Model.dart';

class ReportDetailScreen extends StatelessWidget {
  final SoilTestReport report;

  const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soil Test Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Farm Location: ${report.location}"),
            Text("Test Date: ${report.testDate}"),
            Text("Status: ${report.recommendations}"),
            const SizedBox(height: 10),
            Text("pH Level: ${report.phLevel}"),
            Text("Nitrogen: ${report.nitrogen}"),
            Text("Phosphorus: ${report.phosphorus}"),
            Text("Potassium: ${report.potassium}"),
          ],
        ),
      ),
    );
  }
}
