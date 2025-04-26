import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:original/pages/User/Shopping/product.dart';
import 'package:original/widgets/cart_item.dart';
import 'package:original/utils/config.dart';
import 'package:original/pages/User/Payment/CheckoutPaymentScreen.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> selectedItems = [];
  List<Product> cartItems = [];
  bool isLoading = true;
  String _selectedPaymentMethod = 'ONLINE';
  bool isProcessing = true;
  String? message;
  bool orderPlaced = false; 

  @override
  void initState() {
    super.initState();
    _loadCartItems();  
  }

  void _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJsonList = prefs.getStringList('userCart');

    if (cartJsonList != null && cartJsonList.isNotEmpty) {
      setState(() {
        cartItems = cartJsonList
            .map((jsonStr) => Product.fromJson(json.decode(jsonStr)))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;  // If no cart items exist, set loading to false
      });
    }
  }

  Future<dynamic> initiatePayment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('userToken') ?? '';

      if (token.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return null;
      }

      final total = cartItems.fold(0.0, (sum, item) => sum + (item.price * (item.itemq)));
      final Uri apiUrl = Uri.parse("${Constants.apiBaseUrl}/payments");

      final response = await http.post(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "amount": total,
          "paymentMode": _selectedPaymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print("Failed to create payment. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      setState(() {
        message = "Payment error: $e";
        isProcessing = false;
      });
      return null;
    }
  }

  Future<void> placeOrder(int paymentId, BuildContext? externalContext) async {
  selectedItems = cartItems.where((item) => item.itemq > 0).toList();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';
  final int agentId = prefs.getInt('agentId') ?? -1;

  if (agentId == -1) {
    ScaffoldMessenger.of(externalContext ?? context).showSnackBar(
      const SnackBar(content: Text("No agent found")),
    );
    return;
  }
  if (token.isEmpty) {
    ScaffoldMessenger.of(externalContext ?? context).showSnackBar(
      const SnackBar(content: Text("User not logged in.")),
    );
    return;
  }

  final Uri orderUrl = Uri.parse("${Constants.apiBaseUrl}/orders/");

  final List<Map<String, dynamic>> items = selectedItems.map((product) {
    return {
      "productId": product.productId,
      "quantity": product.itemq,
    };
  }).toList();

  try {
    final response = await http.post(
      orderUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {"items": items, "paymentId": paymentId, "agentId": agentId},
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final orderResponse = data['cashfreeOrderResponse'];

      if (orderResponse != null && orderResponse['payment_session_id'] != null) {
        setState(() {
          for (var item in selectedItems) {
            item.itemq = 0;  // Reset item quantities
          }
        });

        // Clear cart from SharedPreferences after successful order
        prefs.remove('userCart');  // Remove all cart items from SharedPreferences
        setState(() {
          cartItems.clear();  // Clear the cartItems list in the app
          isLoading = false;
         
          orderPlaced = true;  // Set the flag to true after order placement
        });

        ScaffoldMessenger.of(externalContext ?? context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully!")),
        );
      }
    } else {
      ScaffoldMessenger.of(externalContext ?? context).showSnackBar(
        SnackBar(content: Text("Order failed: ${response.statusCode}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(externalContext ?? context).showSnackBar(
      const SnackBar(content: Text("Something went wrong.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final total = cartItems.fold(0.0, (sum, item) => sum + (item.price * (item.itemq)));

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty!"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...cartItems.map((cartItem) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: CartItem(
                              cartItem: cartItem,
                              onQuantityChanged: () {
                                setState(() {
                                  // Recalculate total when quantity changes
                                });
                              },
                            ),
                          )),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total (${cartItems.length} items)"),
                          Text(
                            "₹${total.toStringAsFixed(2)}",
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                      // Dropdown Button for Payment Method
                      DropdownButton<String>(
                        value: _selectedPaymentMethod,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPaymentMethod = newValue!;
                          });
                        },
                        items: <String>['ONLINE', 'CASH']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            final selectedItems =
                                cartItems.where((item) => item.itemq > 0).toList();

                            if (selectedItems.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No items selected.")),
                              );
                              return;
                            }

                            var response = await initiatePayment();
                            if (_selectedPaymentMethod == 'ONLINE') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    amount: total,
                                    orderId: response['cashfreeOrderResponse']
                                        ['order_id'] as String,
                                    sessionId: response['cashfreeOrderResponse']
                                        ['payment_session_id'] as String,
                                    paymentId: response['paymentId'] as int,
                                    placeOrder: placeOrder,
                                  ),
                                ),
                              );
                            } else {
                              await placeOrder(
                                response['paymentId'] as int,
                                context,
                              );
                            }
                          },
                          label: const Text("Proceed to Checkout"),
                          icon: const Icon(IconlyBold.arrowRight),
                          style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        orderPlaced ? Colors.blue : Theme.of(context).primaryColor,
      ),
    ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}





// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:original/pages/User/Shopping/product.dart';
// import 'package:original/widgets/cart_item.dart';
// import 'package:original/utils/config.dart';
// import 'package:original/pages/User/Payment/CheckoutPaymentScreen.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
   
//   List<Product> selectedItems = [];
//   List<Product> cartItems = [];
//   bool isLoading = true;
//   String _selectedPaymentMethod = 'ONLINE';
//   bool isProcessing = true;
//   String? message;

//   @override
//   void initState() {
//     super.initState();
//     fetchProductsFromAPI();
//   }

//   void fetchProductsFromAPI() {
//     SharedPreferences.getInstance().then((prefs) async {
//       final String token = prefs.getString('userToken') ?? '';

//       if (token.isEmpty) {
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       final Uri apiUrl = Uri.parse("${Constants.apiBaseUrl}/products");

//       try {
//         final http.Response response = await http.get(
//           apiUrl,
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );

//         // Process the response
//         if (response.statusCode == 200) {
//           final List<dynamic> responseData = json.decode(response.body);

//           final List<Product> fetchedProducts =
//               responseData.map((item) => Product.fromJson(item)).toList();
//           print(responseData);

//           setState(() {
//             cartItems = fetchedProducts;
//             isLoading = false;
//           });
//         } else {
//           print("Failed to load products. Status code: ${response.statusCode}");
//           setState(() => isLoading = false);
//         }
//       } catch (error) {
//         print("Error while fetching products: $error");
//         setState(() => isLoading = false);
//       }
//     });
//   }

//   Future initiatePayment() async {
//     SharedPreferences.getInstance().then((prefs) async {
//       final String token = prefs.getString('userToken') ?? '';

//       if (token.isEmpty) {
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       final Uri apiUrl = Uri.parse("${Constants.apiBaseUrl}/payments");

//       try {
//         final http.Response response = await http.post(
//           apiUrl,
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode({"amount": 100}),
//         );

//         // Process the response
//         if (response.statusCode == 200) {
//           return json.decode(response.body);
//         } else {
//           print("Failed to create payment. Status code: ${response.statusCode}");
//         }
//       } catch (e) {
//       setState(() {
//         message = "Payment error: $e";
//         isProcessing = false;
//       });
//     }
//     });
//   }

//   Future<void> placeOrder(int paymentId, BuildContext externalContext) async {
//      selectedItems = cartItems.where((item) => item.itemq > 0).toList();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String token = prefs.getString('userToken') ?? '';
//     final int agentId = prefs.getInt('agentId') ?? -1;

//     if (agentId == -1) {
//       ScaffoldMessenger.of(externalContext).showSnackBar(
//         const SnackBar(content: Text("No agent found")),
//       );
//       return null;
//     }
//     if (token.isEmpty) {
//       ScaffoldMessenger.of(externalContext).showSnackBar(
//         const SnackBar(content: Text("User not logged in.")),
//       );
//       return null;
//     }

//     final Uri orderUrl = Uri.parse("${Constants.apiBaseUrl}/orders/");
//     final String paymentIdStr = paymentId.toString();

//     final List<Map<String, dynamic>> items = selectedItems.map((product) {
//       return {
//         "productId": product.productId,
//         "quantity": product.itemq,
//       };
//     }).toList();

//     try {
//       final response = await http.post(
//         orderUrl,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         //  body: jsonEncode({"items": items, "paymentId": paymentIdStr, "agentId": agentId}),
//         body: jsonEncode({"items": items, "paymentId": paymentId, "agentId": agentId}),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         final orderResponse = data['cashfreeOrderResponse'];

//         if (orderResponse != null &&
//             orderResponse['payment_session_id'] != null) {

//           // Optional: Reset item quantity after successful order
//           setState(() {
//             for (var item in selectedItems) {
//               item.itemq = 0;
//             }
//           });

//           return data;
//         }
//       } else {
//         print("Failed: ${response.body}");
//         ScaffoldMessenger.of(externalContext ?? context).showSnackBar(
//           SnackBar(content: Text("Order failed: ${response.statusCode}")),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(externalContext ?? context).showSnackBar(
//         const SnackBar(content: Text("Something went wrong.")),
//       );
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final total =
//         cartItems.fold(0.0, (sum, item) => sum + (item.price * (item.itemq)));

//     return Scaffold(
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   ...cartItems.map((cartItem) => Padding(
//                         padding: const EdgeInsets.only(bottom: 5),
//                         child: CartItem(
//                           cartItem: cartItem,
//                           onQuantityChanged: () {
//                             setState(
//                                 () {}); // This will recalculate total when quantity changes
//                           },
//                         ),
//                       )),
//                   const SizedBox(height: 15),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Total (${cartItems.length} items)"),
//                       Text(
//                         "₹${total.toStringAsFixed(2)}",
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       )
//                     ],
//                   ),
//                   // Dropdown Button for Payment Method
//                   DropdownButton<String>(
//                     value: _selectedPaymentMethod,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedPaymentMethod = newValue!;
//                       });
//                     },
//                     items: <String>['ONLINE', 'CASH']
//                         .map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),

//                   const SizedBox(height: 20),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton.icon(
//                        onPressed: () 
//                       async {
//                         final selectedItems =
//                             cartItems.where((item) => item.itemq > 0).toList();

//                         if (selectedItems.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("No items selected.")),
//                           );
//                           return;
//                         }
//                         final response = await initiatePayment();
//                         if (_selectedPaymentMethod == 'ONLINE') {
//                           final double amount = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.itemq));
//                           final String paymentId = response['paymentId'] ?? '';
//                           final String orderId = response['orderId'] ?? '';
//                           final String sessionId = response['sessionId'] ?? '';

//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PaymentPage(amount: amount, paymentId: int.parse(paymentId), orderId: orderId, sessionId: sessionId, placeOrder: placeOrder),
//                             ),
//                           );
//                         } else {
//                           placeOrder(0, context);
//                         }
//                       },
//                       label: const Text("Proceed to Checkout"),
//                       icon: const Icon(IconlyBold.arrowRight),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//     );
//   }
// }

// import 'package:original/data/products.dart';
// import 'package:original/widgets/cart_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   final cartItems = products.take(4).toList();

//   @override
//   Widget build(BuildContext context) {
//     final total = cartItems
//         .map((cartItem) => cartItem.price)
//         .reduce((value, element) => value + element)
//         .toStringAsFixed(2);
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ...List.generate(
//               cartItems.length,
//               (index) {
//                 final cartItem = cartItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 5),
//                   child: CartItem(cartItem: cartItem),
//                 );
//               },
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Total (${cartItems.length} items)"),
//                 Text(
//                   "₹$total",
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         color: Theme.of(context).colorScheme.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton.icon(
//                 onPressed: () {},
//                 label: const Text("Proceed to Checkout"),
//                 icon: const Icon(IconlyBold.arrowRight),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
