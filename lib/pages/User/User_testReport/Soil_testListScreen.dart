import 'package:flutter/material.dart';
import 'package:original/pages/User/User_testReport/Soil_testDetailScreen.dart';
import 'soil_test_models.dart';
import 'soil_test_service.dart';

class SoilTestListScreen extends StatefulWidget {
  const SoilTestListScreen({super.key});

  @override
  _SoilTestListScreenState createState() => _SoilTestListScreenState();
}

class _SoilTestListScreenState extends State<SoilTestListScreen> {
  late Future<List<SoilTestSummary>> _futureReports;

  @override
  void initState() {
    super.initState();
    _futureReports = SoilTestService.fetchUserReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soil Test Reports")),
      body: FutureBuilder<List<SoilTestSummary>>(
        future: _futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Failed to load reports."));
          }

          final reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ListTile(
                title: Text(report.location),
                subtitle: Text("Status: ${report.status}"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
