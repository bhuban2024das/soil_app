import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:original/pages/Auth/userLogout.dart';
import '../../utils/config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? "";

    if (token.isEmpty) {
      setState(() {
        name = "Unknown";
        phone = "Not found";
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
          name = data['name'] ?? "Unknown";
          phone = data['mobileNumber'] ?? "Unknown";
        });
      } else {
        setState(() {
          name = "Failed to load";
          phone = "Try again";
        });
      }
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        name = "Error";
        phone = "Check connection";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                "My Profile",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(
                  color: Constants.blackColor,
                  fontSize: 20,
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(.3),
                ),
              ),
              const SizedBox(height: 300,),
              GestureDetector(
                onTap: () {
                  UserLogout.logout(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:original/pages/Auth/userLogout.dart';
// import '../../utils/config.dart';
// import '../../widgets/ProfileWidget.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String name = '';
//   String phone = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('userToken') ?? "";

//     if (token.isEmpty) {
//       setState(() {
//         name = "Unknown";
//         phone = "Not found";
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
//           name = data['name'] ?? "Unknown";
//           phone = data['mobileNumber'] ?? "Unknown";
//         });
//       } else {
//         setState(() {
//           name = "Failed to load";
//           phone = "Try again";
//         });
//       }
//     } catch (e) {
//       print("Error fetching user: $e");
//       setState(() {
//         name = "Error";
//         phone = "Check connection";
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
//               // Empty circle avatar without image
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
//                   backgroundColor: Colors.grey, // Empty avatar
//                   child: Icon(Icons.person, size: 60, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: size.width * .5,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       name,
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
//                 phone,
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
//                       icon: Icons.chat,
//                       title: 'FAQs',
//                     ),
//                     const ProfileWidget(
//                       icon: Icons.share,
//                       title: 'Share',
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         UserLogout.logout(context);
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
