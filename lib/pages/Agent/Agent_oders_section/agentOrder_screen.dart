import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:original/pages/Agent/Agent_oders_section/agentorder_model.dart';

// import 'package:original/pages/Agent/Agent_oders_section/agentorder_model.dart'; // Replace with the actual path to your Order model
import 'package:original/utils/config.dart'; // Replace with your constants file path

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/orders"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          orders = jsonList.map((json) => Order.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final response = await http.put(
        Uri.parse("${Constants.apiBaseUrl}/orders/$orderId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Update the status locally
          final updatedOrder =
              orders.firstWhere((order) => order.id == orderId);
          updatedOrder.status = newStatus;
        });
      } else {
        throw Exception("Failed to update order status");
      }
    } catch (e) {
      print("Error updating order status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders from Farmers')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Items: ${order.items}"),
                        Text("Quantity: ${order.quantity}"),
                        Text(
                            "Total Price: ₹${order.totalPrice.toStringAsFixed(2)}"),
                        Text("Status: ${order.status}"),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        updateOrderStatus(order.id, value);
                      },
                      itemBuilder: (BuildContext context) {
                        return ['Processing', 'Shipped', 'Delivered']
                            .map((status) => PopupMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
