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
  // List<Product> cartItems = [];
  List<Product> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductsFromAPI();
  }

  void fetchProductsFromAPI() {
    SharedPreferences.getInstance().then((prefs) async {
      final String token = prefs.getString('userToken') ?? '';

      if (token.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final Uri apiUrl = Uri.parse("${Constants.apiBaseUrl}/products");

      try {
        final http.Response response = await http.get(
          apiUrl,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        // Process the response
        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);

          final List<Product> fetchedProducts =
              responseData.map((item) => Product.fromJson(item)).toList();
          print(responseData);

          setState(() {
            cartItems = fetchedProducts;
            isLoading = false;
          });
        } else {
          print("Failed to load products. Status code: ${response.statusCode}");
          setState(() => isLoading = false);
        }
      } catch (error) {
        print("Error while fetching products: $error");
        setState(() => isLoading = false);
      }
    });
  }

  Future<void> placeOrder(List<Product> selectedItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('userToken') ?? '';
    // final String agentId = prefs.getString('agentId') ?? '';

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
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
        body: jsonEncode({"items": items, "payment": 2, "agentId": 8}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully!")),
        );

        setState(() {
          for (var item in selectedItems) {
            item.itemq = 0;
          }
        });
      } else {
        print("Failed: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total =
        cartItems.fold(0.0, (sum, item) => sum + (item.price * (item.itemq)));

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...cartItems.map((cartItem) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: CartItem(
                          cartItem: cartItem,
                          onQuantityChanged: () {
                            setState(
                                () {}); // This will recalculate total when quantity changes
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
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        final selectedItems =
                            cartItems.where((item) => item.itemq > 0).toList();
                        if (selectedItems.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(amount: total)),
                          );
                        }
                      },
                      label: const Text("Proceed to Checkout"),
                      icon: const Icon(IconlyBold.arrowRight),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

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
