import 'package:flutter/material.dart';

import 'package:original/pages/User/user_report/reportservice.dart';
import 'package:original/pages/User/user_report/soilTestReport_Model.dart';
import 'package:original/pages/User/user_report/reportDetailsScreen.dart'; // Ensure correct path for fetchReports()

class UserReportsScreen extends StatefulWidget {
  const UserReportsScreen({Key? key}) : super(key: key);

  @override
  _UserReportsScreenState createState() => _UserReportsScreenState();
}

class _UserReportsScreenState extends State<UserReportsScreen> {
  late Future<List<SoilTestReport>> _futureReports;

  @override
  void initState() {
    super.initState();
    _futureReports = fetchReports(); // Fetch reports when screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soil Test Reports')),
      body: FutureBuilder<List<SoilTestReport>>(
        future: _futureReports, // Use future that fetches reports
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          final reports = snapshot.data!; // Get reports from snapshot
          return ListView.builder(
            itemCount: reports.length, // Total number of reports
            itemBuilder: (context, index) {
              final report = reports[index]; // Get each report
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Farm: ${report.location}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${report.testDate}'),
                      Text('Status: ${report.status}'), // ✅ show status
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to detailed report page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReportDetailScreen(report: report),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
