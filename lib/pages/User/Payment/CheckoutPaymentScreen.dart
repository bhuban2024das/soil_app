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
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({super.key, required this.orderId, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CFPaymentGatewayService _cfPaymentGatewayService =
      CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    _cfPaymentGatewayService.setCallback(verifyPayment, onError);
    startPayment();
  }

  void verifyPayment(String orderId) {
    print("✅ Payment verification called for Order ID: $orderId");
    // You should confirm payment on your backend here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment successful!")),
    );
    Navigator.pop(context); // Navigate away after successful payment
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print("❌ Payment Error: ${errorResponse.getMessage()}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${errorResponse.getMessage()}")),
    );
  }

  Future<void> startPayment() async {
    try {
      final session = await createSession(); // From your backend
      if (session == null) return;

      final cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session).build();

      _cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      print("Cashfree Exception: ${e.message}");
    }
  }

  Future<CFSession?> createSession() async {
    final String orderId = widget.orderId;
    final double amount = widget.amount;

    try {
      final response = await http.post(
        Uri.parse("https://your-api.com/payments"), // Replace with your backend
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "orderId": orderId,
          "orderAmount": amount,
          "orderCurrency": "INR",
          "paymentMode": "web", // optional, or "card", "upi", etc.
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessionId = data['payment_session_id']; // from your backend

        return CFSessionBuilder()
            .setEnvironment(
                CFEnvironment.SANDBOX) // Change to PROD in production
            .setOrderId(orderId)
            .setPaymentSessionId(sessionId)
            .build();
      } else {
        print("❌ Failed to get session: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error creating session: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
