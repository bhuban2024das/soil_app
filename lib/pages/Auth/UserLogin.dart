import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:original/pages/Auth/Verify.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/config.dart';
import '../../widgets/CustomTextField.dart';

class UserIn extends StatefulWidget {
  const UserIn({super.key});

  @override
  State<UserIn> createState() => _UserInState();
}

class _UserInState extends State<UserIn> {
  final TextEditingController _mobileController = TextEditingController();

  Future<void> _sendLoginOtp() async {
    final mobile = _mobileController.text.trim();

    if (mobile.isEmpty || mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${Constants.apiBaseUrl}/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobileNumber': mobile}),
      );

      if (response.statusCode == 200) {
        // User exists, OTP sent
        Navigator.push(
          context,
          PageTransition(
            child: Otp(phoneNumber: mobile),
            type: PageTransitionType.bottomToTop,
          ),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'] ?? 'Login failed';

        // Example: handle if user not registered
        if (response.statusCode == 404 ||
            errorMessage.contains("not registered")) {
          errorMessage = "This number is not registered. Please sign up first.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again.')),
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
                'Sign In',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: _mobileController,
                      obscureText: false,
                      hintText: 'Enter Number',
                      icon: Icons.call,
                    ),
                    SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendLoginOtp,
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
                          child: Text(
                            'Send Code',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:original/pages/Auth/Verify.dart';
// import 'package:page_transition/page_transition.dart';

// import '../../utils/config.dart';
// import '../../widgets/CustomTextField.dart';
// import 'LoginScreen.dart';

// class UserIn extends StatelessWidget {
//   const UserIn({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Size size = MediaQuery.of(context).size;

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
//                 'Sign In',
//                 style: TextStyle(
//                   fontSize: 35.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
             
//               Container(
//                 padding: EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
                  
//                     const CustomTextfield(
//                       obscureText: false,
//                       hintText: 'Enter Number',
//                       icon: Icons.call,
//                     ),
                   
//                     SizedBox(
//                       height: 22,
//                     ),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Navigator.of(context).push(
//                           //   MaterialPageRoute(builder: (context) => Otp()),
//                           // );
//                           // Navigator.pushReplacement(
//                           // context,
//                           // PageTransition(
//                           //     child: const Otp(),
//                           //     type: PageTransitionType.bottomToTop));
//                         },
//                         style: ButtonStyle(
//                           foregroundColor:
//                               WidgetStateProperty.all<Color>(Colors.white),
//                           backgroundColor: WidgetStateProperty.all<Color>(
//                               const Color.fromARGB(255, 45, 79, 6)),
//                           shape:
//                               WidgetStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(14.0),
//                           child: Text(
//                             'Send Code',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               // const CustomTextfield(
//               //   obscureText: true,
//               //   hintText: 'Enter Password',
//               //   icon: Icons.lock,
//               // ),

//               // const SizedBox(
//               //   height: 10,
//               // ),
//               // GestureDetector(
//               //   onTap: () {},
//               //   child: Container(
//               //     height: 50,
//               //     width: size.width,
//               //     decoration: BoxDecoration(
//               //       color: Constants.primaryColor,
//               //       borderRadius: BorderRadius.circular(10),
//               //     ),
//               //     // padding:
//               //     //     const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//               //     child: const Center(
//               //       child: Text(
//               //         'Sign Up',
//               //         style: TextStyle(
//               //           color: Colors.white,
//               //           fontSize: 18.0,
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               // Row(
//               //   children: const [
//               //     Expanded(child: Divider()),
//               //     Padding(
//               //       padding: EdgeInsets.symmetric(horizontal: 10),
//               //       child: Text('OR'),
//               //     ),
//               //     Expanded(child: Divider()),
//               //   ],
//               // ),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               // Container(
//               //   width: size.width,
//               //   decoration: BoxDecoration(
//               //       border: Border.all(color: Constants.primaryColor),
//               //       borderRadius: BorderRadius.circular(10)),
//               //   padding:
//               //       const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //     children: [
//               //       SizedBox(
//               //         height: 20,
//               //         child: Image.asset('assets/images/google.png'),
//               //       ),
//               //       Text(
//               //         'Sign Up with Google',
//               //         style: TextStyle(
//               //           color: Constants.blackColor,
//               //           fontSize: 18.0,
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               const SizedBox(
//                 height: 20,
//               ),
//               //   GestureDetector(
//               //     onTap: () {
//               //       Navigator.pushReplacement(
//               //           context,
//               //           PageTransition(
//               //               child: const SignIn(),
//               //               type: PageTransitionType.bottomToTop));
//               //     },
//               //     child: Center(
//               //       child: Text.rich(
//               //         TextSpan(children: [
//               //           TextSpan(
//               //             text: 'Have an Account? ',
//               //             style: TextStyle(
//               //               color: Constants.blackColor,
//               //             ),
//               //           ),
//               //           TextSpan(
//               //             text: 'Login',
//               //             style: TextStyle(
//               //               color: Constants.primaryColor,
//               //             ),
//               //           ),
//               //         ]),
//               //       ),
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
