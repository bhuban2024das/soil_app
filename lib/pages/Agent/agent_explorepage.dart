import 'package:flutter/material.dart';
import 'package:original/data/products.dart';
import 'package:original/pages/Agent/agent_search.dart';
import 'package:original/pages/Agent/my_earning.dart';

class AgentExplorepage extends StatelessWidget {
  const AgentExplorepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchFarmer()),
              );
            },
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 57, 107, 59),
                // color: Colors.black,

                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  const Text(
                    "Search farmers",
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_right_alt_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Products ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See all"),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var x = 0; x < products.length; x++)
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        products[x].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: 140,
              width: 140,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 57, 107, 59),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bhuban Ruidas",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Earning: \$200",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewEarnings()),
                        );
                      },
                      child: Text("More Info"),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
