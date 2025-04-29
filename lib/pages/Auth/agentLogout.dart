// lib/pages/User/user_logout.dart

import 'package:flutter/material.dart';
import 'package:original/pages/Auth/AgentLoginScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';
// ✅ Update the import if your login screen path is different

class Agentlogout {
  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

  
    await prefs.clear();

    // Navigate to the Login Screen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AgentSignIn()),
      (Route<dynamic> route) => false,
    );
  }
}
