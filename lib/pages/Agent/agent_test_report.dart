// agent_test_report_list.dart

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
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  title: Text(report.userName),
                  subtitle: Text(report.farmLocation),
                  trailing: Text(report.status),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AgentTestReportDetail(report: report),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
