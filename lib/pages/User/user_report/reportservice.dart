import 'dart:convert';
import 'package:original/pages/User/user_report/soilTestReport_Model.dart';
import 'package:http/http.dart' as http;
import 'package:original/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ensure correct import

Future<List<SoilTestReport>> fetchReports() async {
  final prefs = await SharedPreferences.getInstance();
  final token =
      prefs.getString('userToken'); // JWT token from shared preferences

  final response = await http.get(
    Uri.parse('${Constants.apiBaseUrl}/soil-test/reports'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Include token in header
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonList =
        json.decode(response.body); // Parse the response body
    return jsonList
        .map((json) => SoilTestReport.fromJson(json))
        .toList(); // Convert to SoilTestReport list
  } else {
    throw Exception('Failed to load soil test reports');
  }
}
