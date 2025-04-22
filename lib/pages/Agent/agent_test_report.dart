import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:original/utils/config.dart';
import 'package:original/pages/Agent/model/test_report_model.dart';
import 'package:original/pages/Agent/agent_testreportdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentTestReportList extends StatefulWidget {
  const AgentTestReportList({super.key});

  @override
  State<AgentTestReportList> createState() => _AgentTestReportListState();
}

class _AgentTestReportListState extends State<AgentTestReportList> {
  List<SoilTestRequest> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompletedReports();
  }

  Future<void> fetchCompletedReports() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/soil-test/reports"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<SoilTestRequest> data = jsonList
            .map((json) => SoilTestRequest.fromJson(json))
            .where((item) => item.status == "COMPLETED")
            .toList();

        setState(() {
          reports = data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load reports");
      }
    } catch (e) {
      print("Error fetching reports: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Completed Test Reports")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? const Center(
                  child: Text("No completed test reports available."),
                )
              : ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];

                    // Set status color based on status
                    Color statusColor = report.status == "COMPLETED"
                        ? Colors.green.shade700
                        : Colors.grey.shade600;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AgentTestReportDetail(report: report),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.assignment_turned_in,
                                color: statusColor,
                                size: 28,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      report.userName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      report.farmLocation,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Status: ${report.status}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
