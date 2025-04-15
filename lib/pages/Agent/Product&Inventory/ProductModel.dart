class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String description;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['productId'] as num).toInt(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      stock: json['stock'] != null
          ? int.tryParse(json['stock'].toString()) ?? 0
          : 0,
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'description': description,
      'category': category,
    };
  }
}
