import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:original/pages/Agent/Agent_oders_section/agentOrder_screen.dart'; // Assuming Order model is imported here
import 'package:original/utils/config.dart';
import 'package:original/pages/Agent/Agent_oders_section/agentorder_model.dart'; // Assuming Constants is imported here for your API base URL

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Order> orders = [];
  bool _isLoading = true;
  String _errorMessage = "";

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
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          orders = data.map((json) => Order.fromJson(json)).toList();
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
        title: const Text('Orders from Farmers'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        title: Text('Order ID: ${order.orderId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Farmer: ${order.farmerName}'),
                            Text('Mobile: ${order.mobileNumber}'),
                            Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
                            DropdownButton<String>(
                              value: order.status,
                              items: [
                                'Processing',
                                'Shipped',
                                'Delivered',
                              ].map((status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (newStatus) {
                                setState(() {
                                  order.status = newStatus!;
                                });
                                // Call API to update the order status here
                                _updateOrderStatus(order.orderId, newStatus);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      if (token == null) {
        setState(() {
          _errorMessage = "User not logged in.";
        });
        return;
      }

      final response = await http.put(
        Uri.parse("${Constants.apiBaseUrl}/orders/$orderId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        print('Order status updated successfully');
      } else {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }
}
