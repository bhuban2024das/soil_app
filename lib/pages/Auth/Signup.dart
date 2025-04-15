import 'package:flutter/material.dart';
import 'package:original/pages/Auth/UserLogin.dart';
import 'package:original/pages/Auth/Verify.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> registerUser() async {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all details")),
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
        }),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
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
        SnackBar(content: Text("Something went wrong")),
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
                    const SizedBox(height: 22),
                    CustomTextfield(
                      controller: _locationController,
                      obscureText: false,
                      hintText: 'Enter location',
                      icon: Icons.call,
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
                              : const Text(
                                  'Send Code',
                                  style: TextStyle(fontSize: 16),
                                ),
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
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
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


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:original/pages/Auth/UserLogin.dart';
// import 'package:original/pages/Auth/Verify.dart';
// import 'package:page_transition/page_transition.dart';

// import '../../utils/config.dart';
// import '../../widgets/CustomTextField.dart';
// import 'LoginScreen.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _signUp() async {
//     final String fullName = _fullNameController.text.trim();
//     final String phone = _phoneController.text.trim();

//     if (fullName.isEmpty || phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     final url = Uri.parse("${Constants.apiBaseUrl}/signup");

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "fullName": fullName,
//           "phone": phone,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // You can also extract OTP or user ID from the response if needed
//         Navigator.of(context).push(MaterialPageRoute(builder: (context) => Otp()));
//       } else {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'Signup failed')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
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
//                 padding: EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     CustomTextfield(
//                       obscureText: false,
//                       hintText: 'Enter Full name',
//                       icon: Icons.person,
//                       controller: _fullNameController,
//                     ),
//                     CustomTextfield(
//                       obscureText: false,
//                       hintText: 'Enter Number',
//                       icon: Icons.call,
//                       controller: _phoneController,
//                     ),
//                     const SizedBox(height: 22),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _signUp,
//                         style: ButtonStyle(
//                           foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
//                           backgroundColor: WidgetStateProperty.all<Color>(
//                               const Color.fromARGB(255, 45, 79, 6)),
//                           shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(24.0),
//                             ),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(14.0),
//                           child: _isLoading
//                               ? CircularProgressIndicator(color: Colors.white)
//                               : Text(
//                                   'Send Code',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                         ),
//                       ),
//                     ),
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
//                         style: TextStyle(color: Constants.blackColor),
//                       ),
//                       TextSpan(
//                         text: 'Login',
//                         style: TextStyle(color: Constants.primaryColor),
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



// import 'package:flutter/material.dart';
// import 'package:original/pages/Auth/UserLogin.dart';
// import 'package:original/pages/Auth/Verify.dart';
// import 'package:page_transition/page_transition.dart';

// import '../../utils/config.dart';
// import '../../widgets/CustomTextField.dart';
// import 'LoginScreen.dart';

// class SignUp extends StatelessWidget {
//   const SignUp({Key? key}) : super(key: key);

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
//                 'Sign Up',
//                 style: TextStyle(
//                   fontSize: 35.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               //   const CustomTextfield(
//               //   obscureText: false,
//               //   hintText: 'Enter Number',
//               //   icon: Icons.call,
//               // ),
//               // const CustomTextfield(
//               //   obscureText: false,
//               //   hintText: 'Enter Email',
//               //   icon: Icons.alternate_email,
//               // ),
//               // const CustomTextfield(
//               //   obscureText: false,
//               //   hintText: 'Enter Full name',
//               //   icon: Icons.person,
//               // ),
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
//                       hintText: 'Enter Full name',
//                       icon: Icons.person,
//                     ),
//                     const CustomTextfield(
//                       obscureText: false,
//                       hintText: 'Enter Number',
//                       icon: Icons.call,
//                     ),
//                     // TextFormField(
//                     //   keyboardType: TextInputType.number,
//                     //   style: TextStyle(
//                     //     fontSize: 18,
//                     //     fontWeight: FontWeight.bold,
//                     //   ),
//                     //   decoration: InputDecoration(
//                     //     enabledBorder: OutlineInputBorder(
//                     //         borderSide: BorderSide(color: Colors.black12),
//                     //         borderRadius: BorderRadius.circular(10)),
//                     //     focusedBorder: OutlineInputBorder(
//                     //         borderSide: BorderSide(color: Colors.black12),
//                     //         borderRadius: BorderRadius.circular(10)),
//                     //     prefix: Padding(
//                     //       padding: EdgeInsets.symmetric(horizontal: 8),
//                     //       child: Text(
//                     //         '(+91)',
//                     //         style: TextStyle(
//                     //           fontSize: 18,
//                     //           fontWeight: FontWeight.bold,
//                     //         ),
//                     //       ),
//                     //     ),
//                     //     suffixIcon: Icon(
//                     //       Icons.check_circle,
//                     //       color: Colors.green,
//                     //       size: 32,
//                     //     ),
//                     //   ),
//                     // ),
//                     SizedBox(
//                       height: 22,
//                     ),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(builder: (context) => Otp()),
//                           );
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
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                       context,
//                       PageTransition(
//                           child: const UserIn(),
//                           type: PageTransitionType.bottomToTop));
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
