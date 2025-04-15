import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:original/pages/User/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/config.dart';

class Otp extends StatefulWidget {
  final String phoneNumber;

  const Otp({super.key, required this.phoneNumber});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  bool _isVerifying = false;
  bool _isResending = false;

  Future<void> verifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length < 6) return;

    setState(() => _isVerifying = true);

    try {
      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/auth/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mobileNumber": widget.phoneNumber,
          "otp": otp,
        }),
      );

      print("OTP Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print("Decoded JSON data: ${jsonEncode(data)}");

        final accessToken = data['accessToken'] ?? '';

        final user = data['user'] ?? {};

        final name = user['name'] ?? 'User';
        final uId = (user['userId'] ?? '').toString();

        if (accessToken.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Something went wrong. Try again.')),
          );
          return;
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', accessToken);
        await prefs.setString('userMobile', widget.phoneNumber);
        await prefs.setString('userName', name);
        await prefs.setString('userId', uId);

        Navigator.pushReplacement(
          context,
          PageTransition(
              child: const HomePage(), type: PageTransitionType.bottomToTop),
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
        Uri.parse("${Constants.apiBaseUrl}/resend-otp"),
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
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                'Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
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
                      children: List.generate(
                        6,
                        (index) => _textFieldOTP(index),
                      ),
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
                              borderRadius: BorderRadius.circular(24.0),
                            ),
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
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
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
                  textAlign: TextAlign.center,
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




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:original/pages/User/home_page.dart';
// import 'package:page_transition/page_transition.dart';
// import '../../utils/config.dart';

// class Otp extends StatefulWidget {
//   final String phoneNumber;

//   const Otp({Key? key, required this.phoneNumber}) : super(key: key);

//   @override
//   _OtpState createState() => _OtpState();
// }

// class _OtpState extends State<Otp> {
//   List<TextEditingController> _otpControllers =
//       List.generate(6, (index) => TextEditingController());

//   // String phoneNumber = "YOUR_PHONE_NUMBER"; 
//   late String phoneNumber;

//   @override
//   void initState() {
//     super.initState();
//     phoneNumber = widget.phoneNumber;
//   }

//   void verifyOtp() async {
//     String otp = _otpControllers.map((e) => e.text).join();

//     var response = await http.post(
//       Uri.parse("${Constants.apiBaseUrl}/auth/signup/verify-otp"),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "phoneNumber": phoneNumber,
//         "otp": otp,
//       }),
//     );

//     if (response.statusCode == 200) {
//       Navigator.pushReplacement(
//         context,
//         PageTransition(
//             child: const HomePage(), type: PageTransitionType.bottomToTop),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Invalid OTP. Please try again.")),
//       );
//     }
//   }

//   void resendOtp() async {
//     var response = await http.post(
//       Uri.parse("${Constants.apiBaseUrl}/resend-otp"),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "phoneNumber": phoneNumber,
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("OTP resent successfully.")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to resend OTP.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Color(0xfff7f6fb),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child:
//                       Icon(Icons.arrow_back, size: 32, color: Colors.black54),
//                 ),
//               ),
//               SizedBox(height: 18),
//               Text(
//                 'Verification',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Enter your OTP code number",
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black38),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 28),
//               Container(
//                 padding: EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: List.generate(
//                         6,
//                         (index) => _textFieldOTP(
//                             index: index, first: index == 0, last: index == 5),
//                       ),
//                     ),
//                     SizedBox(height: 22),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: verifyOtp,
//                         style: ButtonStyle(
//                           foregroundColor:
//                               WidgetStateProperty.all<Color>(Colors.white),
//                           backgroundColor: WidgetStateProperty.all<Color>(
//                               Color.fromARGB(255, 45, 79, 6)),
//                           shape:
//                               WidgetStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(24.0)),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(14.0),
//                           child: Text('Verify', style: TextStyle(fontSize: 16)),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(height: 18),
//               Text(
//                 "Didn't you receive any code?",
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black38),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 18),
//               GestureDetector(
//                 onTap: resendOtp,
//                 child: Text(
//                   "Resend New Code",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 45, 79, 6)),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _textFieldOTP(
//       {required int index, required bool first, required bool last}) {
//     return Container(
//       height: 45,
//       width: 45,
//       child: TextField(
//         controller: _otpControllers[index],
//         autofocus: index == 0,
//         onChanged: (value) {
//           if (value.length == 1 && !last) {
//             FocusScope.of(context).nextFocus();
//           }
//           if (value.isEmpty && !first) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         maxLength: 1,
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         style: TextStyle(fontSize: 20),
//         decoration: InputDecoration(
//           counter: Offstage(),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(width: 2, color: Colors.black12),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(width: 2, color: Colors.purple),
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:original/pages/User/home_page.dart';
// // import 'package:page_transition/page_transition.dart';

// // class Otp extends StatefulWidget {
// //   const Otp({Key? key}) : super(key: key);

// //   @override
// //   _OtpState createState() => _OtpState();
// // }

// // class _OtpState extends State<Otp> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       resizeToAvoidBottomInset: false,
// //       backgroundColor: Color(0xfff7f6fb),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
// //           child: Column(
// //             children: [
// //               Align(
// //                 alignment: Alignment.topLeft,
// //                 child: GestureDetector(
// //                   onTap: () => Navigator.pop(context),
// //                   child: Icon(
// //                     Icons.arrow_back,
// //                     size: 32,
// //                     color: Colors.black54,
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(
// //                 height: 18,
// //               ),
// //               Text(
// //                 'Verification',
// //                 style: TextStyle(
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               SizedBox(
// //                 height: 10,
// //               ),
// //               Text(
// //                 "Enter your OTP code number",
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black38,
// //                 ),
// //                 textAlign: TextAlign.center,
// //               ),
// //               SizedBox(
// //                 height: 28,
// //               ),
// //               Container(
// //                 padding: EdgeInsets.all(28),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         _textFieldOTP(first: true, last: false),
// //                         _textFieldOTP(first: false, last: false),
// //                         _textFieldOTP(first: false, last: false),
// //                         _textFieldOTP(first: false, last: true),
// //                       ],
// //                     ),
// //                     SizedBox(
// //                       height: 22,
// //                     ),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton(
// //                         onPressed: () {
// //                           Navigator.pushReplacement(
// //                               context,
// //                               PageTransition(
// //                                   child: const HomePage(),
// //                                   type: PageTransitionType.bottomToTop));
// //                         },
// //                         style: ButtonStyle(
// //                           foregroundColor:
// //                               WidgetStateProperty.all<Color>(Colors.white),
// //                           backgroundColor: WidgetStateProperty.all<Color>(
// //                               const Color.fromARGB(255, 45, 79, 6)),
// //                           shape:
// //                               WidgetStateProperty.all<RoundedRectangleBorder>(
// //                             RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(24.0),
// //                             ),
// //                           ),
// //                         ),
// //                         child: Padding(
// //                           padding: EdgeInsets.all(14.0),
// //                           child: Text(
// //                             'Verify',
// //                             style: TextStyle(fontSize: 16),
// //                           ),
// //                         ),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(
// //                 height: 18,
// //               ),
// //               Text(
// //                 "Didn't you receive any code?",
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black38,
// //                 ),
// //                 textAlign: TextAlign.center,
// //               ),
// //               SizedBox(
// //                 height: 18,
// //               ),
// //               Text(
// //                 "Resend New Code",
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: const Color.fromARGB(255, 45, 79, 6),
// //                 ),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _textFieldOTP({bool? first, last}) {
// //     return Container(
// //       height: 45,
// //       child: AspectRatio(
// //         aspectRatio: 1.0,
// //         child: TextField(
// //           autofocus: true,
// //           onChanged: (value) {
// //             if (value.length == 1 && last == false) {
// //               FocusScope.of(context).nextFocus();
// //             }
// //             if (value.length == 0 && first == false) {
// //               FocusScope.of(context).previousFocus();
// //             }
// //           },
// //           showCursor: false,
// //           readOnly: false,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //             fontSize: 20,
// //           ),
// //           keyboardType: TextInputType.number,
// //           maxLength: 1,
// //           decoration: InputDecoration(
// //             counter: Offstage(),
// //             enabledBorder: OutlineInputBorder(
// //                 borderSide: BorderSide(width: 2, color: Colors.black12),
// //                 borderRadius: BorderRadius.circular(12)),
// //             focusedBorder: OutlineInputBorder(
// //                 borderSide: BorderSide(width: 2, color: Colors.purple),
// //                 borderRadius: BorderRadius.circular(12)),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
