import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:original/pages/User/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:original/utils/config.dart';

class DropdownSelectionPage extends StatefulWidget {
  const DropdownSelectionPage({super.key});

  @override
  State<DropdownSelectionPage> createState() => _DropdownSelectionPageState();
}

class _DropdownSelectionPageState extends State<DropdownSelectionPage> {
  List<dynamic> agentList = [];
  int? selectedAgentId;

  @override
  void initState() {
    super.initState();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/admin/agents"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> agents = jsonDecode(response.body);
        final List<dynamic> filteredAgents = agents
            .where(
                (agent) => agent["role"] == "AGENT" && agent["active"] == true)
            .toList();

        setState(() {
          agentList = filteredAgents;
        });
      } else {
        print("Failed to load agents");
      }
    } catch (e) {
      print("Error fetching agents: $e");
    }
  }

  void handleOkPressed() async {
    if (selectedAgentId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final selectedAgent = agentList.firstWhere(
        (agent) => agent["userId"] == selectedAgentId,
        orElse: () => null,
      );

      if (selectedAgent != null) {
        await prefs.setInt('agentId', selectedAgent["userId"]);
        await prefs.setString('agentMobile', selectedAgent["mobileNumber"].toString());
        await prefs.setString('agentName', selectedAgent["name"]);

        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const HomePage(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Agent")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Select Agent',
                prefixIcon: Icon(Icons.group),
                border: OutlineInputBorder(),
              ),
              value: selectedAgentId,
              items: agentList
                  .map((agent) => DropdownMenuItem<int>(
                        value: agent["userId"],
                        child: Text(agent["name"]),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedAgentId = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAgentId == null ? null : handleOkPressed,
              child: const Text("OK"),
            )
          ],
        ),
      ),
    );
  }
}
