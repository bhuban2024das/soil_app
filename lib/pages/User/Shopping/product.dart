import 'package:original/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Product {
  final int productId;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int stock;
  final String image;
  int itemq = 0;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.quantity,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['imageUrl'] ?? 'assets/images/plant-six.png', // fallback
      // image: "${Constants.imageBaseUrl}/${json['imageUrl']}",
      stock: json['stock'] != null ? json['stock'] as int : 0, 
      quantity: json['quantity'] != null ? json['quantity'] as int : 0,
    );
  }


   Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': image,
    };
  }

  void updateQuantity(int newitemq) {
    itemq = newitemq; // Update the quantity
  }
}
