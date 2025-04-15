// import 'package:flutter/material.dart';

// // Order Model
// class Order {
//   final String orderId;
//   final String farmerName;
//   final String itemName;
//   final int quantity;
//   String status;

//   Order({
//     required this.orderId,
//     required this.farmerName,
//     required this.itemName,
//     required this.quantity,
//     this.status = 'Processing',
//   });
// }

// // Mock list of orders (you can replace this with data from your API)
// List<Order> orders = [
//   Order(
//       orderId: 'ORD001',
//       farmerName: 'John Doe',
//       itemName: 'Tomatoes',
//       quantity: 100),
//   Order(
//       orderId: 'ORD002',
//       farmerName: 'Jane Smith',
//       itemName: 'Potatoes',
//       quantity: 200),
//   Order(
//       orderId: 'ORD003',
//       farmerName: 'Albert Brown',
//       itemName: 'Cabbage',
//       quantity: 150),
// ];

// class AgentOrder extends StatelessWidget {
//   // Constructor with 'const' keyword
//   const AgentOrder({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders from Farmers'),
//       ),
//       body: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           return Card(
//             margin: EdgeInsets.all(8.0),
//             child: ListTile(
//               title: Text('Order ID: ${order.orderId}'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Farmer: ${order.farmerName}'),
//                   Text('Item: ${order.itemName}'),
//                   Text('Quantity: ${order.quantity}'),
//                   Text('Status: ${order.status}'),
//                 ],
//               ),
//               trailing: DropdownButton<String>(
//                 value: order.status,
//                 onChanged: (String? newValue) {
//                   // Update status of the order
//                   if (newValue != null) {
//                     order.status = newValue;
//                     (context as Element).markNeedsBuild(); // Refresh the UI
//                   }
//                 },
//                 items: <String>['Processing', 'Shipped', 'Delivered']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // void main() {
// //   runApp(MaterialApp(
// //     home: AgentOrder(),
// //   ));
// // }

import 'package:flutter/material.dart';

// Order Model
class Order {
  final String orderId;
  final String farmerName;
  final String itemName;
  final int quantity;
  String status;

  Order({
    required this.orderId,
    required this.farmerName,
    required this.itemName,
    required this.quantity,
    this.status = 'Processing',
  });
}

// Mock list of orders (you can replace this with data from your API)
List<Order> orders = [
  Order(
      orderId: 'ORD001',
      farmerName: 'John Doe',
      itemName: 'Tomatoes',
      quantity: 100),
  Order(
      orderId: 'ORD002',
      farmerName: 'Jane Smith',
      itemName: 'Potatoes',
      quantity: 200),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
  Order(
      orderId: 'ORD003',
      farmerName: 'Albert Brown',
      itemName: 'Cabbage',
      quantity: 150),
];

class AgentOrder extends StatelessWidget {
  // Constructor with 'const' keyword
  const AgentOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Order ID: ${order.orderId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Farmer: ${order.farmerName}'),
                  Text('Item: ${order.itemName}'),
                  Text('Quantity: ${order.quantity}'),
                  Text('Status: ${order.status}'),
                ],
              ),
              trailing: DropdownButton<String>(
                value: order.status,
                onChanged: (String? newValue) {
                  // Update status of the order
                  if (newValue != null) {
                    order.status = newValue;
                    (context as Element).markNeedsBuild(); // Refresh the UI
                  }
                },
                items: <String>['Processing', 'Shipped', 'Delivered']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: AgentOrder(),
//   ));
// }
