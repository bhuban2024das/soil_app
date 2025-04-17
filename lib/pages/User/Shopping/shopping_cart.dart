// lib/screens/shopping_cart_screen.dart
import 'package:flutter/material.dart';
import 'package:original/pages/User/Shopping/product.dart';
import 'package:original/pages/User/Shopping/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late Future<List<Product>> futureProducts;

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
    _fetchUserToken();
    futureProducts = ProductService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          final products = snapshot.data!.reversed.take(3).toList(); // Latest 3

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: product.image.isNotEmpty && token != null
                      ? Container(
                          height: double.infinity,
                          width: 90,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                product.image,
                                headers: {'Authorization': 'Bearer $token'},
                              ),
                            ),
                          ),
                        )
                      : const Icon(Icons.shopping_bag),
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  trailing: Text('₹${product.price.toStringAsFixed(2)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
