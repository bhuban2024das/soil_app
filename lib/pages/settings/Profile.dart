import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:original/pages/Auth/userLogout.dart';
import '../../utils/config.dart';
import 'edit_profile.dart'; // Import EditProfilePage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String phone = '';
  String location = '';
  String profilePicUrl = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('userToken') ?? "";

    if (token.isEmpty) {
      setState(() {
        name = "Unknown";
        phone = "Not found";
        location = "Unknown";
        profilePicUrl = "";
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
          location = data['location'] ?? "Unknown";
          profilePicUrl = data['profilePictureUrl'] ?? "";
        });
      } else {
        setState(() {
          name = "Failed to load";
          phone = "Try again";
          location = "Unknown";
          profilePicUrl = "";
        });
      }
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        name = "Error";
        phone = "Check connection";
        location = "Unknown";
        profilePicUrl = "";
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Constants.primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Constants.primaryColor),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                      );
                      if (updated == true) {
                        fetchUserData();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: profilePicUrl.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: "${Constants.imageBaseUrl}$profilePicUrl",
                          httpHeaders: {
                            'Authorization': 'Bearer $token',
                          },
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey,
                            child: const Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey,
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                name,
                style: TextStyle(
                  color: Constants.blackColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                phone,
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(.6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                location,
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(.6),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
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
