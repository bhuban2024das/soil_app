import 'package:flutter/material.dart';

// void main() {
//   runApp(ProductInventory());
// }

class Product {
  String id;
  String name;
  String description;
  double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
  });

  // Update product price and stock
  void updateProduct({double? newPrice, int? newStock}) {
    if (newPrice != null) {
      price = newPrice;
    }
    if (newStock != null) {
      stock = newStock;
    }
  }
}

class ProductInventory extends StatelessWidget {
  const ProductInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 22, 96, 22),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge:
              TextStyle(color: Color.fromARGB(255, 22, 96, 22), fontSize: 18),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [
    Product(
        id: '1',
        name: 'Fertilizer for Crops',
        description: 'High-quality fertilizer for all crops',
        price: 20.0,
        stock: 100),
    Product(
        id: '1',
        name: 'Fertilizer for Crops',
        description: 'High-quality fertilizer for all crops',
        price: 20.0,
        stock: 100),
    Product(
        id: '2',
        name: 'Organic Seeds',
        description: 'Organic seeds for various crops',
        price: 15.0,
        stock: 200),
    Product(
        id: '3',
        name: 'Eco Pesticide',
        description: 'Eco-friendly pesticide for pest control',
        price: 25.0,
        stock: 50),
    Product(
        id: '4',
        name: 'Drip Irrigation',
        description: 'Advanced drip irrigation system',
        price: 150.0,
        stock: 30),
    Product(
        id: '5',
        name: 'Tractor Engine Oil',
        description: 'High-performance oil for tractors',
        price: 40.0,
        stock: 60),
    Product(
        id: '6',
        name: 'Heavy Duty Plough',
        description: 'Heavy-duty plough for farming',
        price: 100.0,
        stock: 40),
    Product(
        id: '7',
        name: 'Water Pump',
        description: 'Durable water pump for irrigation',
        price: 75.0,
        stock: 80),
    Product(
        id: '8',
        name: 'Shovel for Digging',
        description: 'Strong metal shovel for digging',
        price: 12.0,
        stock: 150),
    Product(
        id: '9',
        name: 'Agriculture Rope',
        description: 'Durable agricultural rope',
        price: 8.0,
        stock: 250),
  ];

  void _updateProduct(Product product, double newPrice, int newStock) {
    setState(() {
      product.updateProduct(newPrice: newPrice, newStock: newStock);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Catalog',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 22, 96, 22),
        // leading: IconButton(
        //   // Add a back button
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context); // Pop the current page
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        // Add ScrollView to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true, // Ensures the gridview takes only necessary space
            physics:
                NeverScrollableScrollPhysics(), // Prevent scrolling inside GridView
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two products in a row
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75, // Adjust for better space distribution
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                color: Color.fromARGB(255, 62, 186, 62),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   product.name.length > 26
                      //       ? product.name.substring(0, 26) + '...'
                      //       : product.name,
                      //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      //       fontSize: 16, fontWeight: FontWeight.bold),
                      // ),
                      SizedBox(height: 4),
                      Text(
                        product.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white70),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Price: \$${product.price}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16),
                      ),
                      // SizedBox(height: 2),
                      Text(
                        'Stock: ${product.stock}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showUpdateDialog(context, product);
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                              Color.fromARGB(255, 22, 96, 22),
                            )),
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to show update dialog
  void _showUpdateDialog(BuildContext context, Product product) {
    final priceController =
        TextEditingController(text: product.price.toString());
    final stockController =
        TextEditingController(text: product.stock.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'New Price'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'New Stock'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newPrice =
                    double.tryParse(priceController.text) ?? product.price;
                final newStock =
                    int.tryParse(stockController.text) ?? product.stock;
                _updateProduct(product, newPrice, newStock);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
