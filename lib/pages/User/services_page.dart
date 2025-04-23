import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:original/data/services.dart';
import 'package:original/pages/User/service_details/service_DetailsPage.dart';

class ServicesPage extends StatelessWidget {
 const  ServicesPage({super.key});


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: services.length,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
           onTap: () {
              // final String description = serviceDescriptionsList[index] ;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ServiceDetailPage(
        title: services[index].name,
        description: services[index].description,
      ),
    ),
  );
},
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    services[index].image,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            services[index].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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


// import 'dart:ui';

// import 'package:original/data/services.dart';
// import 'package:flutter/material.dart';

// class ServicesPage extends StatelessWidget {
//   const ServicesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GridView.builder(
//         itemCount: services.length,
//         padding: const EdgeInsets.all(16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.85,
//           crossAxisSpacing: 14,
//           mainAxisSpacing: 14,
//         ),
//         itemBuilder: (context, index) {
//           return Container(
//             alignment: Alignment.bottomCenter,
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 image: AssetImage(services[index].image),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                   ),
//                   child: Text(
//                     services[index].name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
