import 'package:flutter/material.dart';
import 'package:original/pages/Auth/UserLogin.dart';
import 'package:original/pages/Auth/Verify.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../../utils/config.dart';
import '../../widgets/CustomTextField.dart';
import 'LoginScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool isLoading = false;
  List<dynamic> agentList = [];
  int? selectedAgentId;

  @override
  void initState() {
    super.initState();
    fetchAgents();
    getCurrentLocation();
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

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationController.text = '${position.latitude}, ${position.longitude}';
    });
  }

  bool isValidPhoneNumber(String number) {
    final regex = RegExp(r'^[0-9]{10}$');
    return regex.hasMatch(number);
  }

  Future<void> registerUser() async {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty ||
        number.isEmpty ||
        location.isEmpty ||
        selectedAgentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all details")),
      );
      return;
    }

    if (!isValidPhoneNumber(number)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter a valid 10-digit phone number")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "mobileNumber": number,
          "location": location,
          "role": "USER",
          "active": 1,
          "agentId": selectedAgentId
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("agentId", selectedAgentId!);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Otp(phoneNumber: _numberController.text)));
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
        const SnackBar(content: Text("Something went wrong")),
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
                'Sign Up',
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
                    CustomTextfield(
                      controller: _locationController,
                      obscureText: false,
                      hintText: 'Enter location',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 22),
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
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : registerUser,
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
                              : const Text('Send Code',
                                  style: TextStyle(fontSize: 16)),
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
                      child: const UserIn(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Have an Account? ',
                        style: TextStyle(color: Constants.blackColor),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(color: Constants.primaryColor),
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



// import 'package:flutter/material.dart';
// import 'package:original/pages/Auth/UserLogin.dart';
// import 'package:original/pages/Auth/Verify.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../../utils/config.dart';
// import '../../widgets/CustomTextField.dart';
// import 'LoginScreen.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _numberController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   bool isLoading = false;

//   Future<void> registerUser() async {
//     final name = _nameController.text.trim();
//     final number = _numberController.text.trim();
//     final location = _locationController.text.trim();

//     if (name.isEmpty || number.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter all details")),
//       );
//       return;
//     }

//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final response = await http.post(
//         Uri.parse("${Constants.apiBaseUrl}/auth/signup"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "name": name,
//           "mobileNumber": number,
//           "location": location,
//         }),
//       );

//       setState(() {
//         isLoading = false;
//       });

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Otp(phoneNumber: _numberController.text)));
//       } else {
//         final res = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(res['message'] ?? "Signup failed")),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Something went wrong")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Image.asset('assets/images/signup.png'),
//               const Text(
//                 'Sign Up',
//                 style: TextStyle(
//                   fontSize: 35.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 padding: const EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     CustomTextfield(
//                       controller: _nameController,
//                       obscureText: false,
//                       hintText: 'Enter Full name',
//                       icon: Icons.person,
//                     ),
//                     CustomTextfield(
//                       controller: _numberController,
//                       obscureText: false,
//                       hintText: 'Enter Number',
//                       icon: Icons.call,
//                     ),
//                     const SizedBox(height: 22),
//                     CustomTextfield(
//                       controller: _locationController,
//                       obscureText: false,
//                       hintText: 'Enter location',
//                       icon: Icons.call,
//                     ),
//                     const SizedBox(height: 22),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: isLoading ? null : registerUser,
//                         style: ButtonStyle(
//                           foregroundColor:
//                               WidgetStateProperty.all<Color>(Colors.white),
//                           backgroundColor: WidgetStateProperty.all<Color>(
//                             const Color.fromARGB(255, 45, 79, 6),
//                           ),
//                           shape:
//                               WidgetStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(14.0),
//                           child: isLoading
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white)
//                               : const Text(
//                                   'Send Code',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     PageTransition(
//                       child: const UserIn(),
//                       type: PageTransitionType.bottomToTop,
//                     ),
//                   );
//                 },
//                 child: Center(
//                   child: Text.rich(
//                     TextSpan(children: [
//                       TextSpan(
//                         text: 'Have an Account? ',
//                         style: TextStyle(
//                           color: Constants.blackColor,
//                         ),
//                       ),
//                       TextSpan(
//                         text: 'Login',
//                         style: TextStyle(
//                           color: Constants.primaryColor,
//                         ),
//                       ),
//                     ]),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


