import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/config.dart';
import '../../pages/Auth/agentLogout.dart';

class AgentProfilepage extends StatefulWidget {
  const AgentProfilepage({super.key});

  @override
  State<AgentProfilepage> createState() => _AgentProfilepageState();
}

class _AgentProfilepageState extends State<AgentProfilepage> {
  String agentName = "";
  String agentMobile = "";
  String? pfp;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('agentMobile') ?? "";
    final token = prefs.getString('userToken') ?? "";

    if (mobile.isEmpty || token.isEmpty) {
      setState(() {
        agentName = "Unknown";
        agentMobile = "Not found";
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/user/me"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          agentName = data['name'] ?? "Unknown";
          agentMobile = data['mobileNumber'] ?? "Unknown";
          pfp = data['profilePictureUrl'] ?? "";

          prefs.setString('agentName', agentName);
          prefs.setString('agentMobile', agentMobile);
          prefs.setString('profilePictureUrl', pfp ?? "");
        });
      } else {
        setState(() {
          agentName = "Failed to load";
          agentMobile = "Try again";
        });
      }
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        agentName = "Error";
        agentMobile = "Check connection";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String firstLetter = agentName.isNotEmpty ? agentName[0].toUpperCase() : "?";

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constants.primaryColor.withOpacity(.5),
                        width: 5.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        firstLetter,
                        style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    agentName,
                    style: TextStyle(
                      color: Constants.blackColor,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    agentMobile,
                    style: TextStyle(
                      color: Constants.blackColor.withOpacity(.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                Agentlogout.logout(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// import '../../utils/config.dart';
// import '../../widgets/ProfileWidget.dart';
// import '../../pages/Auth/agentLogout.dart';

// class AgentProfilepage extends StatefulWidget {
//   const AgentProfilepage({super.key});

//   @override
//   State<AgentProfilepage> createState() => _AgentProfilepageState();
// }

// class _AgentProfilepageState extends State<AgentProfilepage> {
//   String agentName = "";
//   String agentMobile = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final mobile = prefs.getString('agentMobile') ?? "";
//     final token = prefs.getString('userToken') ?? "";

//     if (mobile.isEmpty || token.isEmpty) {
//       setState(() {
//         agentName = "Unknown";
//         agentMobile = "Not found";
//       });
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse("${Constants.apiBaseUrl}/user/me"),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           agentName = data['name'] ?? "Unknown";
//           agentMobile = data['mobileNumber'] ?? "Unknown";
//         });
//       } else {
//         setState(() {
//           agentName = "Failed to load";
//           agentMobile = "Try again";
//         });
//       }
//     } catch (e) {
//       print("Error fetching user: $e");
//       setState(() {
//         agentName = "Error";
//         agentMobile = "Check connection";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           height: size.height,
//           width: size.width,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Empty CircleAvatar with person icon
//               Container(
//                 width: 150,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Constants.primaryColor.withOpacity(.5),
//                     width: 5.0,
//                   ),
//                 ),
//                 child: const CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey,
//                   child: Icon(Icons.person, size: 60, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: size.width * .6,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       agentName,
//                       style: TextStyle(
//                         color: Constants.blackColor,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     SizedBox(
//                       height: 24,
//                       child: Image.asset("assets/images/verified.png"),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 agentMobile,
//                 style: TextStyle(
//                   color: Constants.blackColor.withOpacity(.3),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 height: size.height * .7,
//                 width: size.width,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const ProfileWidget(
//                       icon: Icons.person,
//                       title: 'My Profile',
//                     ),
//                     const ProfileWidget(
//                       icon: Icons.settings,
//                       title: 'Settings',
//                     ),
//                     const ProfileWidget(
//                       icon: Icons.notifications,
//                       title: 'Notifications',
//                     ),
//                     const ProfileWidget(
//                       icon: Icons.share,
//                       title: 'Share',
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Agentlogout.logout(context);
//                       },
//                       child: const ProfileWidget(
//                         icon: Icons.logout,
//                         title: 'Log Out',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
