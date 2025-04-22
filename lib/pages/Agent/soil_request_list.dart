import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:original/pages/Agent/soiltest_report_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../utils/config.dart';

class SoilTestRequest {
  final int soilTestId; // Non-nullable field (int)
  final String farmLocation; // Non-nullable field (String)
  final String? soilType; // Nullable field (String?)
  final String status; // Non-nullable field (String)
  final String testDate; // Non-nullable field (String)
  final double? phLevel; // Nullable field (double?)
  final double? nitrogen; // Nullable field (double?)
  final double? phosphorus; // Nullable field (double?)
  final double? potassium; // Nullable field (double?)
  final int userId; // Non-nullable field (int)
  final String userName; // Non-nullable field (String)
  final String userMobileNumber; // Non-nullable field (String)
  final int agentId; // Non-nullable field (int)
  final String agentName; // Non-nullable field (String)
  final String agentMobileNumber; // Non-nullable field (String)
  final List<dynamic>? recommendedCrops;
  final List<dynamic>? recommendedProducts;
  final String? soilPreparations; // Nullable field (String?)

  SoilTestRequest({
    required this.soilTestId,
    required this.farmLocation,
    this.soilType,
    required this.status,
    required this.testDate,
    this.phLevel,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    required this.userId,
    required this.userName,
    required this.userMobileNumber,
    required this.agentId,
    required this.agentName,
    required this.agentMobileNumber,
    this.recommendedCrops,
    this.recommendedProducts,
    this.soilPreparations,
  });

  factory SoilTestRequest.fromJson(Map<String, dynamic> json) {
    return SoilTestRequest(
      soilTestId: json['soilTestId'],
      farmLocation: json['farmLocation'] ?? 'Unknown', // Default value for null
      soilType: json['soilType'], // Nullable field
      status: json['status'] ?? 'Unknown', // Default value for null
      testDate: json['testDate'] ?? 'Unknown', // Default value for null
      phLevel: json['phLevel'] != null
          ? double.tryParse(json['phLevel'].toString())
          : null,
      nitrogen: json['nitrogen'] != null
          ? double.tryParse(json['nitrogen'].toString())
          : null,
      phosphorus: json['phosphorus'] != null
          ? double.tryParse(json['phosphorus'].toString())
          : null,
      potassium: json['potassium'] != null
          ? double.tryParse(json['potassium'].toString())
          : null,
      userId: json['userId'],
      userName: json['userName'] ?? 'Unknown', // Default value for null
      userMobileNumber: json['userMobileNumber'] ?? 'Unknown', // Default value for null
      agentId: json['agentId'],
      agentName: json['agentName'] ?? 'Unknown', // Default value for null
      agentMobileNumber: json['agentMobileNumber'] ?? 'Unknown', // Default value for null
      recommendedCrops: json['recommendedCrops'], // Nullable field
      recommendedProducts: json['recommendedProducts'], // Nullable field
      soilPreparations: json['soilPreparations'], // Nullable field
    );
  }
}

class SoilTestRequestsScreen extends StatefulWidget {
  const SoilTestRequestsScreen({super.key});

  @override
  State<SoilTestRequestsScreen> createState() => _SoilTestRequestsScreenState();
}

class _SoilTestRequestsScreenState extends State<SoilTestRequestsScreen> {
  List<SoilTestRequest> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSoilTestRequests();
  }

  void fetchSoilTestRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    if (token.isEmpty) return;

    final url = Uri.parse("${Constants.apiBaseUrl}/soil-test/reports");

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          requests =
              data.map((item) => SoilTestRequest.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soil Test Requests"),
        backgroundColor: Colors.green.shade700,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : requests.isEmpty
              ? Center(
                  child: Text(
                    "No soil test reports available.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: InkWell(
                        onTap: () async {
                          final success = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SoilTestDetailScreen(
                                request: request,
                              ),
                            ),
                          );
                          if (success == true) {
                            fetchSoilTestRequests();
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.green.shade700),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      request.userName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: Colors.grey.shade600),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      request.farmLocation,
                                      style: TextStyle(color: Colors.grey.shade700),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined, color: Colors.grey.shade600, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    "Requested on: ${request.testDate}",
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                  ),
                                  Spacer(),
                                  Icon(Icons.chevron_right, color: Colors.grey.shade600),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.orange.shade600),
                                  SizedBox(width: 8),
                                  Text(
                                    "Status: ${request.status}",
                                    style: TextStyle(fontSize: 14, color: Colors.orange.shade600),
                                  ),
                                ],
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
