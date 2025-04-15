// agent_test_report_detail.dart

import 'package:flutter/material.dart';
import 'package:original/pages/Agent/model/test_report_model.dart';

class AgentTestReportDetail extends StatelessWidget {
  final SoilTestRequest report;

  const AgentTestReportDetail({super.key, required this.report});

  Widget _buildReadOnlyField(String label, String? value) {
    return TextFormField(
      initialValue: value ?? '',
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildReadOnlyField("Farmer Name", report.userName),
            const SizedBox(height: 10),
            _buildReadOnlyField("Phone Number", report.userMobileNumber),
            const SizedBox(height: 10),
            _buildReadOnlyField("Farm Location", report.farmLocation),
            const SizedBox(height: 10),
            _buildReadOnlyField("Test Date", report.testDate),
            const SizedBox(height: 10),
            _buildReadOnlyField("Status", report.status),
            const Divider(),
            _buildReadOnlyField("pH Level", report.phLevel?.toString()),
            _buildReadOnlyField("Nitrogen", report.nitrogen?.toString()),
            _buildReadOnlyField("Phosphorus", report.phosphorus?.toString()),
            _buildReadOnlyField("Potassium", report.potassium?.toString()),
          ],
        ),
      ),
    );
  }
}
