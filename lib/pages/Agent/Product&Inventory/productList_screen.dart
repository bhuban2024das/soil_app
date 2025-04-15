import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:original/pages/Agent/Product&Inventory/addproduct_screen.dart';

import 'package:original/pages/Agent/Product&Inventory/ProductModel.dart'; // Replace with the actual path to your Product model
import 'package:original/utils/config.dart'; // Replace with your constants file path
import 'package:original/pages/Agent/Product&Inventory/update_productScreen.dart'; // Replace with the actual path to the update screen

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/products"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print("jsonList $jsonList");
        setState(() {
          products = jsonList.map((json) => Product.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteProduct(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final response = await http.delete(
        Uri.parse("${Constants.apiBaseUrl}/products/$id"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          products.removeWhere((product) => product.id == id);
        });
      } else {
        throw Exception("Failed to delete product");
      }
    } catch (e) {
      print("Delete error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: Column(
        children: [
          // Add Product Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the Add Product screen (Update screen with empty product)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductScreen(),
                  ),
                ).then((_) =>
                    fetchProducts()); // Refresh product list after adding a new one
              },
              child: Text('Add Product'),
            ),
          ),
          // Loading Indicator or Product List
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Stock: ${product.stock}"),
                              Text(
                                  "Price: ₹${product.price.toStringAsFixed(2)}"),
                              Text("Category: ${product.category}"),
                              Text("Description: ${product.description}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to Update Product screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          UpdateProductScreen(product: product),
                                    ),
                                  ).then((_) =>
                                      fetchProducts()); // Refresh product list after editing
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteProduct(product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:original/pages/Agent/Product&Inventory/ProductModel.dart'; // Replace with the actual path to your Product model
// import 'package:original/utils/config.dart'; // Replace with your constants file path
// import 'package:original/pages/Agent/Product&Inventory/update_productScreen.dart'; // Replace with the actual path to the update screen

// class ProductListScreen extends StatefulWidget {
//   @override
//   _ProductListScreenState createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   List<Product> products = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('userToken') ?? '';

//     try {
//       final response = await http.get(
//         Uri.parse("${Constants.apiBaseUrl}/products"),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = jsonDecode(response.body);
//         print("jsonList $jsonList");
//         setState(() {
//           products = jsonList.map((json) => Product.fromJson(json)).toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load products");
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> deleteProduct(int id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('userToken') ?? '';

//     try {
//       final response = await http.delete(
//         Uri.parse("${Constants.apiBaseUrl}/products/$id"),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           products.removeWhere((product) => product.id == id);
//         });
//       } else {
//         throw Exception("Failed to delete product");
//       }
//     } catch (e) {
//       print("Delete error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Product List')),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 final product = products[index];
//                 return Card(
//                   margin: EdgeInsets.all(8),
//                   child: ListTile(
//                     title: Text(product.name),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Stock: ${product.stock}"),
//                         Text("Price: ₹${product.price.toStringAsFixed(2)}"),
//                         Text("Category: ${product.category}"),
//                         Text("Description: ${product.description}"),
//                       ],
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () {
//                             // Navigate to Update Product screen
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) =>
//                                     UpdateProductScreen(product: product),
//                               ),
//                             ).then((_) => fetchProducts());
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             deleteProduct(product.id);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
