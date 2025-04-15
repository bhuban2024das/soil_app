import 'package:flutter/material.dart';
import 'package:original/pages/Agent/agent_testreport.dart';

void main() {
  runApp(TestList());
}

class TestList extends StatelessWidget {
  const TestList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Lists',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FarmerListScreen(),
    );
  }
}

class FarmerListScreen extends StatelessWidget {
  final int n = 5;

  const FarmerListScreen({super.key}); // Total number of containers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Test Lists',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 22, 96, 22),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle popup button action
            },
            itemBuilder: (BuildContext context) {
              return ['Option 1', 'Option 2'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: n,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 36, 158, 36),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farmer Name ${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Mobile Number: 123-456-7890',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SoilTestInputForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        // primary: Colors.white,
                        ),
                    child: Text(
                      'Update Report',
                      style: TextStyle(color: Color.fromARGB(255, 22, 96, 22)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
