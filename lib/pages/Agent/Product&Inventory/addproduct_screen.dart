import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:original/pages/Agent/Product&Inventory/ProductModel.dart'; // Replace with the actual path to your Product model
import 'package:original/utils/config.dart'; // Replace with your constants file path

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _stockController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;

  int newProductId = 0;
  XFile? _image; // To hold the image file

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _stockController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
    _fetchLastProductId();
  }

  Future<void> _fetchLastProductId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/products"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          final lastProduct = Product.fromJson(jsonList.last);
          setState(() {
            newProductId = lastProduct.id +
                1; // Set new product ID to the last product ID + 1
          });
        } else {
          setState(() {
            newProductId = 1; // Start from 1 if no products are available
          });
        }
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _addProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    // Create a new product object
    final newProduct = Product(
      id: newProductId,
      name: _nameController.text,
      stock: int.parse(_stockController.text),
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      category: _categoryController.text,
    );

    // Prepare the multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${Constants.apiBaseUrl}/products/"),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    // Add fields
    request.fields['id'] = newProduct.id.toString();
    request.fields['name'] = newProduct.name;
    request.fields['stock'] = newProduct.stock.toString();
    request.fields['price'] = newProduct.price.toString();
    request.fields['description'] = newProduct.description;
    request.fields['category'] = newProduct.category;

    // If an image is selected, add it to the multipart form data
    if (_image != null) {
      var pic = await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType:
            MediaType('image', 'jpeg'), // or 'png', depending on your file type
      );
      request.files.add(pic);
    }

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        // Wait for the server response
        response.stream.transform(utf8.decoder).listen((value) {
          // The value will be the server's response in JSON format
          _showSuccessDialog(); // Go back with the new product
        });
      } else {
        print("Failed to add product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  // Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Product has been successfully added."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(
                    context, true); // Optionally, pop the screen if needed
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Pick an image from gallery or camera
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
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
      appBar: AppBar(title: Text('Add New Product')),
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
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      _image == null ? 'Pick an Image' : 'Change Image',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _addProduct();
                  }
                },
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
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

// class AddProductScreen extends StatefulWidget {
//   @override
//   _AddProductScreenState createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _stockController;
//   late TextEditingController _priceController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _categoryController;

//   int newProductId = 0;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _stockController = TextEditingController();
//     _priceController = TextEditingController();
//     _descriptionController = TextEditingController();
//     _categoryController = TextEditingController();
//     _fetchLastProductId();
//   }

//   Future<void> _fetchLastProductId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('userToken') ?? '';

//     try {
//       final response = await http.get(
//         Uri.parse("${Constants.apiBaseUrl}/products"),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = jsonDecode(response.body);
//         if (jsonList.isNotEmpty) {
//           final lastProduct = Product.fromJson(jsonList.last);
//           setState(() {
//             newProductId = lastProduct.id +
//                 1; // Set new product ID to the last product ID + 1
//           });
//         } else {
//           setState(() {
//             newProductId = 1; // Start from 1 if no products are available
//           });
//         }
//       } else {
//         throw Exception("Failed to load products");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   Future<void> _addProduct() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('userToken') ?? '';

//     final newProduct = Product(
//       id: newProductId,
//       name: _nameController.text,
//       stock: int.parse(_stockController.text),
//       price: double.parse(_priceController.text),
//       description: _descriptionController.text,
//       category: _categoryController.text,
//     );

//     try {
//       final response = await http.post(
//         Uri.parse("${Constants.apiBaseUrl}/products/"),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(newProduct.toJson()),
//       );

//       if (response.statusCode == 201) {
//         Navigator.pop(context, newProduct); // Go back with the new product
//       } else {
//         print("Failed to add product: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error adding product: $e");
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
//       appBar: AppBar(title: Text('Add New Product')),
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
//                     _addProduct();
//                   }
//                 },
//                 child: Text('Add Product'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
