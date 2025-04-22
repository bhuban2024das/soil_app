import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:original/utils/config.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  Future<void> _fetchUserOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');
      final userId = prefs.getInt('userId');

      if (token == null || userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "User not logged in.";
        });
        return;
      }

      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/orders/"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _orders = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to fetch orders.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Colors.green.shade700,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _orders.isEmpty
                  ? Center(child: Text("No orders found."))
                  : ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        final items = order['items'] ?? [];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order ID: ${order['orderId'] ?? ''}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                // Text(
                                //   "Total: ${order['totalAmount']}",
                                //   style: TextStyle(color: Colors.grey[600]),
                                // ),
                                // SizedBox(height: 4),
                                Text(
                                  "Status: ${order['orderStatus']}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                // Divider(),
                                // ...items.map<Widget>((item) {
                                //   return Padding(
                                //     padding:
                                //         const EdgeInsets.symmetric(vertical: 6),
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Expanded(
                                //           child: Text(
                                //             item['productName'] ?? 'Product',
                                //             style: TextStyle(fontSize: 15),
                                //           ),
                                //         ),
                                //         Text(
                                //           "x${item['quantity']}",
                                //           style: TextStyle(
                                //               fontSize: 14,
                                //               color: Colors.grey[700]),
                                //         ),
                                //         Text(
                                //           "₹${item['price']}",
                                //           style: TextStyle(
                                //               fontSize: 14,
                                //               fontWeight: FontWeight.w500),
                                //         ),
                                //       ],
                                //     ),
                                //   );
                                // }).toList(),
                                Divider(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Total: ₹${order['totalAmount']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
