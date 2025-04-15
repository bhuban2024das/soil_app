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
  final String? recommendedCrops; // Nullable field (String?)
  final String? recommendedProducts; // Nullable field (String?)
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
          ? (json['phLevel'] as num).toDouble()
          : null, // Convert if not null
      nitrogen: json['nitrogen'] != null
          ? (json['nitrogen'] as num).toDouble()
          : null, // Convert if not null
      phosphorus: json['phosphorus'] != null
          ? (json['phosphorus'] as num).toDouble()
          : null, // Convert if not null
      potassium: json['potassium'] != null
          ? (json['potassium'] as num).toDouble()
          : null, // Convert if not null
      userId: json['userId'],
      userName: json['userName'] ?? 'Unknown', // Default value for null
      userMobileNumber:
          json['userMobileNumber'] ?? 'Unknown', // Default value for null
      agentId: json['agentId'],
      agentName: json['agentName'] ?? 'Unknown', // Default value for null
      agentMobileNumber:
          json['agentMobileNumber'] ?? 'Unknown', // Default value for null
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
        print("Data: $data");
        setState(() {
          requests =
              data.map((item) => SoilTestRequest.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        print("Failed: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching soil test requests: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soil Test Requests")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(request.userName),
                    subtitle: Text(
                        "${request.farmLocation}\nRequested on: ${request.testDate}"),
                    isThreeLine: true,
                    trailing: Icon(Icons.chevron_right),
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
                        // Optionally refresh list
                        fetchSoilTestRequests();
                      }
                      // Navigate to edit & report screen
                    },
                  ),
                );
              },
            ),
    );
  }
}
