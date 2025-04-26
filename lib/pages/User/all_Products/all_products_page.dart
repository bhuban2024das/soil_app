import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:original/pages/User/Shopping/product.dart';
import 'package:original/pages/User/cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:original/utils/config.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  List<Product> allProducts = [];
  Set<int> selectedProductIds = {};
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('userToken');

    final Uri apiUrl = Uri.parse("${Constants.apiBaseUrl}/products");

    final response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Product> fetchedProducts =
          responseData.map<Product>((item) => Product.fromJson(item)).toList();

      setState(() {
        allProducts = fetchedProducts;
        isLoading = false;
      });
    } else {
      print("Error fetching products: ${response.statusCode}");
      setState(() => isLoading = false);
    }
  }

  void toggleProductSelection(int productId) {
    setState(() {
      if (selectedProductIds.contains(productId)) {
        selectedProductIds.remove(productId);
      } else {
        selectedProductIds.add(productId);
      }
    });
  }

  void goToCartPage() async {
  List<Product> selectedItems = allProducts
      .where((item) => selectedProductIds.contains(item.productId))
      .toList();

  if (selectedItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select at least one product.")),
    );
    return;
  }

  // Save to SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cartJsonList =
      selectedItems.map((product) => json.encode(product.toJson())).toList();
  await prefs.setStringList('userCart', cartJsonList);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => CartPage(),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: goToCartPage,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                final product = allProducts[index];
                final isSelected = selectedProductIds.contains(product.productId);

                return GestureDetector(
                  onTap: () => toggleProductSelection(product.productId),
                  child: Card(
                    color: isSelected ? Colors.green[100] : null,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Image.network(
                        "${Constants.imageBaseUrl}${product.image}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        headers: {'Authorization': 'Bearer $token'},
                      ),
                      title: Text(product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.description),
                          const SizedBox(height: 5),
                          Text("₹${product.price.toStringAsFixed(2)}"),
                        ],
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.radio_button_unchecked),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: goToCartPage,
          child: const Text("Go to Cart"),
        ),
      ),
    );
  }
}
