import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:original/pages/User/Shopping/product.dart';
import 'package:original/utils/config.dart';

class ProductService {
  // static const String baseUrl = 'http://YOUR_BACKEND_IP:PORT'; // e.g. http://192.168.1.10:8080

  static Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('${Constants.apiBaseUrl}/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
