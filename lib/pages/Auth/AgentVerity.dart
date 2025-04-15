import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:original/models/usersdata.dart';
import 'package:original/pages/Agent/agent_homepage.dart';
import 'dart:convert';

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/config.dart';

class AgentOtp extends StatefulWidget {
  final String phoneNumber;

  const AgentOtp({super.key, required this.phoneNumber});

  @override
  _AgentOtpState createState() => _AgentOtpState();
}

class _AgentOtpState extends State<AgentOtp> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  bool _isVerifying = false;
  bool _isResending = false;

  Future<void> verifyOtp() async {
    final agentotp =
        _otpControllers.map((controller) => controller.text).join();
    if (agentotp.length < 6) return;

    setState(() => _isVerifying = true);

    try {
      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/auth/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobileNumber": widget.phoneNumber,
          "otp": agentotp,
        }),
      );

      print("Agent OTP Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final accessToken = data['accessToken'] ?? '';
        final user = data['user'] ?? {};

        final name = user['name'] ?? 'Agent';
        final agentId = (user['agentId'] ?? '').toString();

        if (accessToken.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong. Try again.')),
          );
          return;
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', accessToken);
        await prefs.setString('agentMobile', widget.phoneNumber);
        await prefs.setString('agentName', name);
        await prefs.setString('agentId', agentId);

        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const AgentHomepage(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP. Please try again')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: $e')),
      );
    }

    setState(() => _isVerifying = false);
  }

  Future<void> resendOtp() async {
    setState(() => _isResending = true);

    try {
      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/auth/agent/resend-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": widget.phoneNumber}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP resent successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend OTP')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isResending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child:
                      Icon(Icons.arrow_back, size: 32, color: Colors.black54),
                ),
              ),
              SizedBox(height: 18),
              Text('Verification',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                "Enter your OTP code number",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          List.generate(6, (index) => _textFieldOTP(index)),
                    ),
                    SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isVerifying ? null : verifyOtp,
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 45, 79, 6)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0)),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: _isVerifying
                              ? CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)
                              : Text('Verify', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 18),
              Text(
                "Didn't receive any code?",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38),
              ),
              SizedBox(height: 18),
              GestureDetector(
                onTap: _isResending ? null : resendOtp,
                child: Text(
                  _isResending ? "Resending..." : "Resend New Code",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 45, 79, 6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP(int index) {
    return SizedBox(
      height: 45,
      width: 40,
      child: TextField(
        controller: _otpControllers[index],
        autofocus: index == 0,
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counter: Offstage(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.purple),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
