import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:original/pages/Agent/Product&Inventory/ProductModel.dart';
import 'package:original/utils/config.dart';
import 'package:original/pages/Agent/Product&Inventory/productList_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  UpdateProductScreen({required this.product});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _stockController =
        TextEditingController(text: widget.product.stock.toString());
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _categoryController = TextEditingController(text: widget.product.category);
  }

  Future<void> _updateProduct() async {
    final productId = widget.product.id;

    final uri = Uri.parse("${Constants.apiBaseUrl}/products/$productId");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken'); // Replace with your key
    final request = http.MultipartRequest('PUT', uri);

    request.fields['name'] = _nameController.text;
    request.fields['stock'] = _stockController.text;
    request.fields['price'] = _priceController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['category'] = _categoryController.text;

    // Add headers (if using auth, update accordingly)
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    // request.headers['Authorization'] = 'Bearer your_token'; // Uncomment if needed

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final updatedProduct = Product(
          id: productId,
          name: _nameController.text,
          stock: int.parse(_stockController.text),
          price: double.parse(_priceController.text),
          description: _descriptionController.text,
          category: _categoryController.text,
        );

        Navigator.pop(context, updatedProduct);
      } else {
        print("Failed to update product: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stock quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _updateProduct();
                  }
                },
                child: Text('Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:original/pages/Agent/Product&Inventory/ProductModel.dart'; // Replace with the actual path to your Product model
// import 'package:original/utils/config.dart'; // Import your constants file

// class UpdateProductScreen extends StatefulWidget {
//   final Product product;

//   UpdateProductScreen({required this.product});

//   @override
//   _UpdateProductScreenState createState() => _UpdateProductScreenState();
// }

// class _UpdateProductScreenState extends State<UpdateProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _stockController;
//   late TextEditingController _priceController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _categoryController;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with the existing product details
//     _nameController = TextEditingController(text: widget.product.name);
//     _stockController =
//         TextEditingController(text: widget.product.stock.toString());
//     _priceController =
//         TextEditingController(text: widget.product.price.toString());
//     _descriptionController =
//         TextEditingController(text: widget.product.description);
//     _categoryController = TextEditingController(text: widget.product.category);
//   }

//   Future<void> _updateProduct() async {
//     final productId =
//         widget.product.id; // Assuming you pass the product id to the screen

//     final updatedProduct = Product(
//       id: productId,
//       name: _nameController.text,
//       stock: int.parse(_stockController.text),
//       price: double.parse(_priceController.text),
//       description: _descriptionController.text,
//       category: _categoryController.text,
//     );

//     final url =
//         Uri.parse("${Constants.apiBaseUrl}/products/$productId");

//     try {
//       final response = await http.put(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(updatedProduct.toJson()),
//       );

//       if (response.statusCode == 200) {
//         Navigator.pop(context, updatedProduct); // Go back with updated product
//       } else {
//         print("Failed to update product: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error updating product: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _stockController.dispose();
//     _priceController.dispose();
//     _descriptionController.dispose();
//     _categoryController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Update Product"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Product Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter product name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _stockController,
//                 decoration: InputDecoration(labelText: 'Stock'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter stock quantity';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.numberWithOptions(decimal: true),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter price';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: InputDecoration(labelText: 'Category'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a category';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                     _updateProduct();
//                   }
//                 },
//                 child: Text('Update Product'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
