import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:original/pages/Auth/AgentVerity.dart';
import 'dart:convert';

import 'package:original/pages/Auth/Verify.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/config.dart';
import '../../widgets/CustomTextField.dart';

class AgentIn extends StatefulWidget {
  const AgentIn({super.key});

  @override
  State<AgentIn> createState() => _AgentInState();
}

class _AgentInState extends State<AgentIn> {
  final TextEditingController _mobileController = TextEditingController();

  Future<void> _sendLoginOtp() async {
    final mobile = _mobileController.text.trim();

    if (mobile.isEmpty || mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/auth/login"), // ✅ Agent endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobileNumber': mobile}),
      );

      if (response.statusCode == 200) {
        // Agent exists, OTP sent
        Navigator.push(
          context,
          PageTransition(
            child: AgentOtp(phoneNumber: mobile),
            type: PageTransitionType.bottomToTop,
          ),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Login failed';

        if (response.statusCode == 404 ||
            errorMessage.contains("not registered")) {
          errorMessage = "This number is not registered. Please sign up first.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/signup.png'),
              const Text(
                'Agent Sign In',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _mobileController,
                      obscureText: false,
                      hintText: 'Enter Number',
                      icon: Icons.call,
                    ),
                    SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendLoginOtp,
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 45, 79, 6)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Send Code',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
