import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/config.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String location = '';
  File? imageFile;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? "";
    // final userId = prefs.getString('userId') ?? "";

    if (token.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/user/me"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? '';
          phone = data['mobileNumber'] ?? '';
          location = data['location'] ?? '';
        });
      }
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? "";
    final userId = prefs.getInt('userId') ?? 0;

    if (token.isEmpty) return;

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse("${Constants.apiBaseUrl}/user/$userId"),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = name;
      request.fields['mobileNumber'] = phone;
      request.fields['location'] = location;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profilePictureUrl', imageFile!.path),
        );
      }

      var res = await request.send();

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated profile Successfully')),
        );
        Navigator.pop(context, true); 
        loadUserData();// Success, go back
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print("Error saving profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                  child: imageFile == null
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
                onChanged: (val) => name = val,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                validator: (value) => value!.isEmpty ? 'Enter mobile number' : null,
                onChanged: (val) => phone = val,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Enter location' : null,
                onChanged: (val) => location = val,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
