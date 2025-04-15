import 'package:flutter/material.dart';

class SearchFarmer extends StatefulWidget {
  const SearchFarmer({super.key});

  @override
  _SearchFarmerState createState() => _SearchFarmerState();
}

class _SearchFarmerState extends State<SearchFarmer> {
  final TextEditingController _controller = TextEditingController();
  String? farmerDetails;

  void searchFarmer() {
    setState(() {
      // Mock data for demonstration
      if (_controller.text == "1234567890") {
        farmerDetails =
            "Farmer: John Doe\nMobile: 1234567890\nSoil Test History: 3 tests\nOrders: 5 completed";
      } else {
        farmerDetails = "Farmer not found!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Farmer', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 22, 96, 22),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Enter Mobile Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: searchFarmer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 22, 96, 22),
                  ),
                  child: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (farmerDetails != null)
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    farmerDetails!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
