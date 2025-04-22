import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF61C25A),
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "🌱 Welcome to BhumiSakti !",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Your Smart Agriculture Partner",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "AgriCare is a one-stop platform for farmers and agriculture professionals to improve soil health, manage farm activities, and boost productivity with smart recommendations.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              "🌾 Key Features",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A4F2F),
              ),
            ),
            const SizedBox(height: 12),
            featurePoint("Soil Test Requests: Schedule and track tests for your farmland."),
            featurePoint("Crop Advisory: Get personalized crop recommendations."),
            featurePoint("Product Suggestions: Based on your soil report."),
            featurePoint("Order Management: Buy farm inputs directly from the app."),
            featurePoint("Agent Support: Assigned agents help you manage requests."),
            featurePoint("Reports: View and download soil reports and orders."),
            const SizedBox(height: 20),
            const Text(
              "📈 Our Vision",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF304FFE),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "To empower every farmer with technology-driven insights for sustainable and profitable agriculture.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              "📍 Contact Us",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Email: support@bhumisakti.com",
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              "Phone: +91 9876543210",
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              "Website: www.bhumisaktiplatform.com",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 25),
            const Center(
              child: Text(
                "Thank you for choosing BhumiSakti! 🌿",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget featurePoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
