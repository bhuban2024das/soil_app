import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:original/pages/User/User_testReport/soil_test_models.dart';
import 'package:original/utils/config.dart';

class SoilTestService {
  // static const String baseUrl = "http://YOUR_BACKEND_URL/api/soil-test";

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userToken");
  }

  static Future<List<SoilTestSummary>> fetchUserReports() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse("${Constants.apiBaseUrl}/soil-test/reports"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print(response.body);

      return data.map((e) => SoilTestSummary.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load reports");
    }
  }

  static Future<SoilTestDetail> fetchReportDetail(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse("${Constants.apiBaseUrl}/soil-test/reports"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return SoilTestDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load report details");
    }
  }
}
