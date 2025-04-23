import 'package:flutter/material.dart';

class ViewEarnings extends StatelessWidget {
  const ViewEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Earnings Report"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  EarningsCard(title: "Soil Test Commissions", amount: "\$150"),
                  EarningsCard(title: "Product Sales", amount: "\$300"),
                  EarningsCard(title: "Incentives", amount: "\$50"),
                  EarningsCard(
                      title: "Total Earnings", amount: "\$500", isTotal: true),
                ],
              ),
            ),
            SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
}

class EarningsCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;

  const EarningsCard(
      {super.key,
      required this.title,
      required this.amount,
      this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
