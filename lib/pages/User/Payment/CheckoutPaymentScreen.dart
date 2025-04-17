import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardlistener.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardwidget.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfcard.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfcardpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfnetbanking.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfnetbankingpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupi.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfupipayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfupi/cfupiutils.dart';
import 'package:original/pages/User/Payment/PaymentSuccessScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:original/utils/config.dart';

class PaymentPage extends StatefulWidget {
  final double amount;

  const PaymentPage({super.key, required this.amount});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final cfPaymentGatewayService = CFPaymentGatewayService();
  bool isProcessing = true;
  String? message;

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(_onPaymentSuccess, _onPaymentError);
    _initiatePayment();
  }

  void _onPaymentSuccess(String orderId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(orderId: orderId),
      ),
    );
  }

  void _onPaymentError(CFErrorResponse error, String orderId) {
    setState(() {
      message = "Payment failed: ${error.getMessage()}";
      isProcessing = false;
    });
  }

  Future<void> _initiatePayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('userToken') ?? '';

    if (token.isEmpty) {
      setState(() {
        isProcessing = false;
        message = "User not logged in.";
      });
      return;
    }

    final Uri paymentUrl = Uri.parse("${Constants.apiBaseUrl}/payments");

    try {
      final response = await http.post(
        paymentUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "amount": widget.amount,
          "paymentMode": "ONLINE",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final String orderId = data['cashfreeOrderResponse']['order_id'];
        final String paymentSessionId =
            data['cashfreeOrderResponse']['payment_session_id'];

        final session = CFSessionBuilder()
            .setEnvironment(CFEnvironment.SANDBOX) // Use SANDBOX during testing
            .setOrderId(orderId)
            .setPaymentSessionId(paymentSessionId)
            .build();

        final cfWebCheckout =
            CFWebCheckoutPaymentBuilder().setSession(session).build();

        cfPaymentGatewayService.doPayment(cfWebCheckout);
      } else {
        setState(() {
          message = "Payment failed: ${response.statusCode}";
          isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        message = "Payment error: $e";
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Processing Payment")),
      body: Center(
        child: isProcessing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message ?? "Unknown error"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back"),
                  ),
                ],
              ),
      ),
    );
  }
}
