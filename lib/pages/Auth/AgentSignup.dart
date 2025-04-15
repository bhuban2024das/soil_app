import 'package:flutter/material.dart';
import 'package:original/pages/Auth/AgentLogin.dart';
import 'package:original/pages/Auth/AgentVerity.dart';

import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/config.dart';
import '../../widgets/CustomTextField.dart';

import 'package:original/pages/Auth/AgentLoginScreen.dart';

class AgentSignUp extends StatefulWidget {
  const AgentSignUp({super.key});

  @override
  State<AgentSignUp> createState() => _AgentSignUpState();
}

class _AgentSignUpState extends State<AgentSignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool isLoading = false;

  Future<void> registerAgent() async {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all details")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/auth/signup"), // ✅ Agent API
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "mobileNumber": number,
          "location": location,
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                AgentOtp(phoneNumber: _numberController.text)));
      } else {
        final res = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? "Signup failed")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong")),
      );
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
                'Agent Sign Up', // ✅ Title change
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _nameController,
                      obscureText: false,
                      hintText: 'Enter Full name',
                      icon: Icons.person,
                    ),
                    CustomTextfield(
                      controller: _numberController,
                      obscureText: false,
                      hintText: 'Enter Number',
                      icon: Icons.call,
                    ),
                    const SizedBox(height: 22),
                    CustomTextfield(
                      controller: _locationController,
                      obscureText: false,
                      hintText: 'Enter location',
                      icon: Icons.call,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : registerAgent,
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 45, 79, 6),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Send Code',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child:
                          const AgentIn(), // ✅ Change to your Agent Login Widget
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Have an Agent Account? ',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
