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
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _concernsController = TextEditingController();
  String? _selectedSoilType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
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
          "farmName": _farmNameController.text.trim(),
          "farmLocation": _locationController.text.trim(),
          "soilType": _selectedSoilType,
          "testDate": requestDateTime,
          "concerns": _concernsController.text.trim(),
          "userId": int.parse(userId),
          "agentId": prefs.getInt('agentId'),
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
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Soil Test"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInputField(_farmNameController, "Farm Name"),
                  SizedBox(height: 16),
                  _buildInputField(_locationController, "Farm Location"),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedSoilType,
                    items: _soilTypes
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSoilType = val),
                    decoration: _inputDecoration("Soil Type"),
                    validator: (value) =>
                        value == null ? "Select soil type" : null,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickDate(context),
                          icon: Icon(Icons.date_range),
                          label: Text(_selectedDate == null
                              ? 'Pick Date'
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickTime(context),
                          icon: Icon(Icons.access_time),
                          label: Text(_selectedTime == null
                              ? 'Pick Time'
                              : _selectedTime!.format(context)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInputField(_concernsController, "Concerns (Optional)",
                      maxLines: 3),
                  SizedBox(height: 24),
                  SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: Icon(Icons.send, color: Colors.black), // icon color black too (optional)
    label: _isSubmitting
        ? CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
        : Text(
            "Submit Request",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
    onPressed: _isSubmitting ? null : _submitRequest,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 14),
      backgroundColor: Colors.green.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      foregroundColor: Colors.black, // ensures the icon/text are black
    ),
  ),
),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      maxLines: maxLines,
      validator: (value) =>
          label.contains("Optional") || (value != null && value.isNotEmpty)
              ? null
              : "Enter $label",
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
