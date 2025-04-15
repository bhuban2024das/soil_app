import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:original/utils/config.dart';
import 'package:original/pages/Agent/soil_request_list.dart';

class SoilTestDetailScreen extends StatefulWidget {
  final SoilTestRequest request;

  const SoilTestDetailScreen({super.key, required this.request});

  @override
  State<SoilTestDetailScreen> createState() => _SoilTestDetailScreenState();
}

class _SoilTestDetailScreenState extends State<SoilTestDetailScreen> {
  final TextEditingController phController = TextEditingController();
  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorusController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();

  List<String> statusOptions = ['PENDING', 'IN_PROGRESS', 'COMPLETED'];
  String? selectedStatus;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phController.text = widget.request.phLevel?.toString() ?? '';
    nitrogenController.text = widget.request.nitrogen?.toString() ?? '';
    phosphorusController.text = widget.request.phosphorus?.toString() ?? '';
    potassiumController.text = widget.request.potassium?.toString() ?? '';
    selectedStatus = widget.request.status;
  }

  Future<void> submitReport() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    final url = Uri.parse(
        "${Constants.apiBaseUrl}/soil-test/${widget.request.soilTestId}");
    final body = {
      "phLevel": double.tryParse(phController.text),
      "nitrogen": double.tryParse(nitrogenController.text),
      "phosphorus": double.tryParse(phosphorusController.text),
      "potassium": double.tryParse(potassiumController.text),
      "status": selectedStatus,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Report submitted successfully.")),
        );
        Navigator.pop(context, true); // Return to list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
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
      appBar: AppBar(title: const Text("Update Soil Test Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildReadOnlyField("Farmer Name", widget.request.userName),
                    const SizedBox(height: 10),
                    _buildReadOnlyField(
                        "Phone Number", widget.request.userMobileNumber),
                    const SizedBox(height: 10),
                    _buildReadOnlyField(
                        "Farm Location", widget.request.farmLocation),
                    const SizedBox(height: 10),
                    _buildReadOnlyField("Test Date", widget.request.testDate),
                    const SizedBox(height: 10),

                    // Editable Status Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(),
                      ),
                      items: statusOptions.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),

                    const Divider(height: 30, thickness: 1),
                    const Text(
                      "Enter Report Values",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phController,
                      decoration: const InputDecoration(labelText: "pH Level"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nitrogenController,
                      decoration: const InputDecoration(labelText: "Nitrogen"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phosphorusController,
                      decoration:
                          const InputDecoration(labelText: "Phosphorus"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: potassiumController,
                      decoration: const InputDecoration(labelText: "Potassium"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: submitReport,
                      child: const Text("Submit Report"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
