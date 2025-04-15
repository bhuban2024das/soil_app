import 'package:flutter/material.dart';
import 'soil_test_service.dart';
import 'package:original/pages/User/User_testReport/soil_test_models.dart';

class SoilTestDetailScreen extends StatelessWidget {
  final int soilTestId;

  const SoilTestDetailScreen({super.key, required this.soilTestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soil Test Details")),
      body: FutureBuilder<SoilTestDetail>(
        future: SoilTestService.fetchReportDetail(soilTestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Failed to load report details."));
          }

          final report = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text("Location: ${report.location}"),
                Text("Test Date: ${report.testDate}"),
                Text("Status: ${report.status}"),
                Divider(),
                Text("pH Level: ${report.phLevel}"),
                Text("Nitrogen: ${report.nitrogen}"),
                Text("Phosphorus: ${report.phosphorus}"),
                Text("Potassium: ${report.potassium}"),
                Divider(),
                Text("Recommendation: ${report.recommendation}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
