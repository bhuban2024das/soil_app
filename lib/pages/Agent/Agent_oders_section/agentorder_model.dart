class Order {
  final int id;
  final String items;
  final int quantity;
  final double totalPrice;
  String status;

  Order({
    required this.id,
    required this.items,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0, // Default to 0 if 'id' is null
      items: json['itemq'] ?? '', // Default to empty string if 'itemq' is null
      quantity: json['quantity'] ?? 0, // Default to 0 if 'quantity' is null
      totalPrice: (json['totalPrice'] ?? 0.0)
          .toDouble(), // Default to 0.0 if 'totalPrice' is null
      status:
          json['status'] ?? '', // Default to empty string if 'status' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status,
    };
  }
}
