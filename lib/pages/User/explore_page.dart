import 'package:original/data/products.dart';
import 'package:original/pages/User/AddSoliTestRequest.dart';
import 'package:original/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SizedBox(
              height: 170,
              child: Card(
                color: Colors.green.shade50,
                elevation: 0.1,
                shadowColor: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Free consultation",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.green.shade700,
                                  ),
                            ),
                            const Text(
                                "Get free support from our customer service"),
                            FilledButton(
                              onPressed: () {},
                              child: const Text("Call now"),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/contact_us.png',
                        width: 140,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const AddSoilTestRequest(),
                  type: PageTransitionType.bottomToTop,
                ),
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
                    Icons.celebration_sharp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  const Text(
                    "Diagnosis issues with crops",
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
                "Gallery",
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Diseases",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See all"),
              ),
            ],
          ),
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var x = 0; x < products.length; x++)
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              products[x].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                products[x].name,
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Icon(Icons.info_outline_rounded, size: 12),
                                  SizedBox(width: 2),
                                  Text("Impact")
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Best Crops to Plant",
          //       style: Theme.of(context).textTheme.titleMedium,
          //     ),
          //     TextButton(
          //       onPressed: () {},
          //       child: const Text("See all"),
          //     ),
          //   ],
          // ),
          // Container(
          //   height: 100,
          //   width: MediaQuery.of(context).size.width,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       for (var x = 0; x < products.length; x++)
          //         Container(
          //           width: MediaQuery.of(context).size.width - 40,
          //           margin: const EdgeInsets.all(5),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(8),
          //             color: Colors.white,
          //           ),
          //           child: Row(
          //             children: [
          //               Container(
          //                 width: MediaQuery.of(context).size.width / 3.5,
          //                 child: ClipRRect(
          //                   borderRadius: BorderRadius.circular(8),
          //                   child: Image.asset(
          //                     products[x].image,
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(width: 15),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Text(
          //                       "${products[x].name}",
          //                       style: TextStyle(
          //                           fontSize: 19, fontWeight: FontWeight.bold),
          //                     ),
          //                     SizedBox(height: 15),
          //                     Row(
          //                       children: [
          //                         Icon(Icons.info_outline_rounded, size: 12),
          //                         SizedBox(width: 2),
          //                         Text("Impact")
          //                       ],
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Products",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See all"),
              ),
            ],
          ),
          GridView.builder(
            itemCount: products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          )
        ],
      ),
    );
  }
}
