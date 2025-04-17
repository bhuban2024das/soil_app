import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:original/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:original/utils/config.dart';

import 'package:original/pages/Agent/Product&Inventory/category.dart';
import 'package:original/pages/Agent/Product&Inventory/ProductModel.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;
  double? _latitude;
  double? _longitude;

  List<Category> _categories = [];
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchCategories();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/category'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> categoryList = json.decode(response.body);
      setState(() {
        _categories = categoryList
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();
      });
    } else {
      print('Failed to load categories');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    // Construct Product with nested Category
    final product = Product(
      id: 0,
      name: _nameController.text,
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      description: _descriptionController.text,
      category: _selectedCategory!,
      image: null,
    );

    // final productJson = jsonEncode(product.toJson());

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${Constants.apiBaseUrl}/products/'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = _nameController.text;
    request.fields['price'] = _priceController.text;
    request.fields['stock'] = _stockController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['categoryId'] = _selectedCategory!.categoryId
        .toString(); // Make sure this matches backend param name

    request.fields['latitude'] = _latitude?.toString() ?? '';
    request.fields['longitude'] = _longitude?.toString() ?? '';

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Product added successfully');
      Navigator.pop(context);
    } else {
      print('Failed to add product: ${response.statusCode}');
      print('Response: $responseBody');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_imageFile != null)
                Image.file(_imageFile!,
                    height: 200, width: double.infinity, fit: BoxFit.cover),
              TextButton.icon(
                icon: Icon(Icons.image),
                label: Text('Pick Image'),
                onPressed: _pickImage,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter stock quantity' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Enter description' : null,
              ),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((cat) {
                  return DropdownMenuItem<Category>(
                    value: cat,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
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
