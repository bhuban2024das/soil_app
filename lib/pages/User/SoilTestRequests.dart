import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoilTestRequests extends StatefulWidget {
  const SoilTestRequests({super.key});

  @override
  State<SoilTestRequests> createState() => _SoilTestRequestsState();
}

class _SoilTestRequestsState extends State<SoilTestRequests> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _farmNameController =
      TextEditingController(); // ✅ Added
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _concernsController = TextEditingController();
  String? _selectedSoilType;
  final uidId = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime; // ✅ Added
  bool _isSubmitting = false;

  final List<String> _soilTypes = [
    'LOAMY',
    'SANDY',
    'CLAY',
    'SILT',
    'PEAT',
    'CHALK'
  ];

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate() ||
        _selectedSoilType == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all required fields")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in.")),
        );
        setState(() => _isSubmitting = false);
        return;
      }
      final userInfoResponse = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/user/me"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        // if your backend requires just the token to identify
      );
      if (userInfoResponse.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch user info")),
        );
        setState(() => _isSubmitting = false);
        return;
      }
      final userInfo = jsonDecode(userInfoResponse.body);
      final userId = userInfo['userId']?.toString();

      if (userId == null || userId.isEmpty || int.tryParse(userId) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid user ID received.")),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      await prefs.setString('userId', userId);

      // String? userId = prefs.getString('userId');
      // if (userId == null || userId.isEmpty || int.tryParse(userId) == null) {
      //   print("User ID from SharedPreferences: $userId");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("User ID not found or invalid")),
      //   );
      //   return;
      // }

      // print("User ID from SharedPreferences: $userId");

      // if (token == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("User not logged in or ID missing")),
      //   );
      //   setState(() => _isSubmitting = false);
      //   return;
      // }

      final requestDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ).toIso8601String();

      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/soil-test/request"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          // "farmName": _farmNameController.text.trim(), // ✅ Farm name
          "farmLocation": _locationController.text.trim(), // ✅ Location
          // "soilType": _selectedSoilType, // ✅ Soil type
          "testDate": requestDateTime, // ✅ Format: yyyy-MM-dd
          // "concerns": _concernsController.text.trim(), // ✅ Concerns
          "userId": int.parse(userId), // ✅ Convert userId
          "agentId": 1, // ✅ Hardcoded agent
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Soil Test Request Submitted Successfully!")),
        );
        _formKey.currentState!.reset();
        setState(() {
          _selectedSoilType = null;
          _selectedDate = null;
          _selectedTime = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit request")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isSubmitting = false);
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Soil Test")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _farmNameController, // ✅ New input
                decoration: InputDecoration(labelText: "Farm Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter farm name" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: "Farm Location"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter location" : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSoilType,
                items: _soilTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedSoilType = val),
                decoration: InputDecoration(labelText: "Soil Type"),
                validator: (value) => value == null ? "Select soil type" : null,
              ),
              SizedBox(height: 16),
              Row(
                // ✅ Combined Date and Time Pickers
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickDate(context),
                      child: Text(_selectedDate == null
                          ? 'Pick Test Date'
                          : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _pickTime(context),
                      child: Text(_selectedTime == null
                          ? 'Pick Time'
                          : 'Time: ${_selectedTime!.format(context)}'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _concernsController,
                decoration: InputDecoration(labelText: "Concerns (Optional)"),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRequest,
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Submit Request"),
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
// import 'package:original/widgets/test_request.dart';

// import '../../data/products.dart';

// class SoilTestRequests extends StatefulWidget {
//   const SoilTestRequests({super.key});

//   @override
//   State<SoilTestRequests> createState() => _SoilTestRequestsState();
// }

// class _SoilTestRequestsState extends State<SoilTestRequests> {
//   final cartItems = products.take(4).toList();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Soil Test Requests"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ...List.generate(
//               cartItems.length,
//               (index) {
//                 final cartItem = cartItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 5),
//                   child: TestRequestWidget(cartItem: cartItem),
//                 );
//               },
//             ),
//             const SizedBox(height: 15),
//           ],
//         ),
//       ),
//     );
//   }
// }
