import 'package:original/pages/Agent/Product&Inventory/category.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String description;
  final String? image;
  final Category category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.category,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['productId'] as num).toInt(),
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      description: json['description'],
      image: json['imageUrl'],
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': id,
      'name': name,
      'price': price,
      'stock': stock,
      'description': description,
      'imageUrl': image,
      'category': category.toJson(),
    };
  }
}
