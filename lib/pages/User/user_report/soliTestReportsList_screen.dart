import 'package:flutter/material.dart';

import 'package:original/pages/User/user_report/reportservice.dart';
import 'package:original/pages/User/user_report/soilTestReport_Model.dart';
import 'package:original/pages/User/user_report/reportDetailsScreen.dart';

class UserReportsScreen extends StatefulWidget {
  const UserReportsScreen({Key? key}) : super(key: key);

  @override
  State<UserReportsScreen> createState() => _UserReportsScreenState();
}

class _UserReportsScreenState extends State<UserReportsScreen> {
  late Future<List<SoilTestReport>> _futureReports;
  List<SoilTestReport> _allReports = [];
  List<SoilTestReport> _filteredReports = [];
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _futureReports = fetchReports();
    _futureReports.then((reports) {
      setState(() {
        _allReports = reports;
        _filteredReports = reports;
      });
    });
  }

  void _filterReports(String query) {
    setState(() {
      _searchText = query.toLowerCase();
      _filteredReports = _allReports.where((report) {
        return report.location.toLowerCase().contains(_searchText) ||
            report.status.toLowerCase().contains(_searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Test Reports'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by location or status',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterReports,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SoilTestReport>>(
              future: _futureReports,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _allReports.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (_filteredReports.isEmpty) {
                  return const Center(child: Text('No matching reports found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _filteredReports.length,
                  itemBuilder: (context, index) {
                    final report = _filteredReports[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        title: Text(
                          'Farm Location: ${report.location}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${report.testDate}'),
                              Text(
                                'Status: ${report.status}',
                                style: TextStyle(
                                  color: report.status
                                          .toLowerCase()
                                          .contains("pending")
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
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
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// import 'package:original/pages/User/user_report/reportservice.dart';
// import 'package:original/pages/User/user_report/soilTestReport_Model.dart';
// import 'package:original/pages/User/user_report/reportDetailsScreen.dart'; // Ensure correct path for fetchReports()

// class UserReportsScreen extends StatefulWidget {
//   const UserReportsScreen({Key? key}) : super(key: key);

//   @override
//   _UserReportsScreenState createState() => _UserReportsScreenState();
// }

// class _UserReportsScreenState extends State<UserReportsScreen> {
//   late Future<List<SoilTestReport>> _futureReports;

//   @override
//   void initState() {
//     super.initState();
//     _futureReports = fetchReports(); // Fetch reports when screen is loaded
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Soil Test Reports')),
//       body: FutureBuilder<List<SoilTestReport>>(
//         future: _futureReports, // Use future that fetches reports
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No reports found.'));
//           }

//           final reports = snapshot.data!; // Get reports from snapshot
//           return ListView.builder(
//             itemCount: reports.length, // Total number of reports
//             itemBuilder: (context, index) {
//               final report = reports[index]; // Get each report
//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ListTile(
//                   title: Text('Farm: ${report.location}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Date: ${report.testDate}'),
//                       Text('Status: ${report.status}'), // ✅ show status
//                     ],
//                   ),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () {
//                     // Navigate to detailed report page
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ReportDetailScreen(report: report),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
