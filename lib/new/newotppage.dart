import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPageNew(),
    );
  }
}

class LoginPageNew extends StatefulWidget {
  const LoginPageNew({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageNew> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;

  void _sendOTP() {
    setState(() {
      _otpSent = true;
    });
    // Simulate OTP sending logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to ${_mobileController.text}')),
    );
  }

  void _verifyOTP() {
    // Simulate OTP verification logic
    if (_otpController.text == "1234") {
      // Dummy OTP for testing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verified Successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login with OTP')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendOTP,
              child: Text('Send OTP'),
            ),
            if (_otpSent) ...[
              SizedBox(height: 10),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: Text('Verify OTP'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
