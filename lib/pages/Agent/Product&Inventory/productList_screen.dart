import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:original/pages/Agent/Product&Inventory/addproduct_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:original/pages/Agent/Product&Inventory/ProductModel.dart';
import 'package:original/utils/config.dart';
import 'package:original/pages/Agent/Product&Inventory/update_productScreen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? token;

  Future<void> _fetchUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('userToken');
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _fetchUserToken();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductScreen(),
                  ),
                ).then((_) => fetchProducts());
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Centered Product Image
                              Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${Constants.imageBaseUrl}${product.image}",
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                              strokeWidth: 2),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: 85,
                                      height: 85,
                                      httpHeaders: {
                                        'Authorization': 'Bearer $token'
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Product Info + Icon Buttons
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text("Stock: ${product.stock}"),
                                    Text(
                                        "Price: ₹${product.price.toStringAsFixed(2)}"),
                                    Text("Category: ${product.category}"),
                                    Text("Description: ${product.description}"),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    UpdateProductScreen(
                                                        product: product),
                                              ),
                                            ).then((_) => fetchProducts());
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
                                  ],
                                ),
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
