import 'package:dsi_pro/dsi_pro.dart';
// import 'package:original/pages/User/AddSoliTestRequest.dart';
import 'package:original/pages/User/SoilTestRequests.dart';
import 'package:original/pages/User/cart_page.dart';
import 'package:original/pages/User/explore_page.dart';
import 'package:original/pages/settings/Profile.dart';
import 'package:original/pages/User/services_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../utils/config.dart';
// import 'package:original/pages/User/User_testReport/Soil_testListScreen.dart';
import 'package:original/pages/User/user_report/soliTestReportsList_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [
    const ExplorePage(),
    const ServicesPage(),
    const CartPage(),
    const ProfilePage()
  ];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String userName = "Loading...";
  String userMobile = "Fetching...";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('userMobile') ?? "";
    final token = prefs.getString('userToken') ?? "";

    if (mobile.isEmpty || token.isEmpty) {
      setState(() {
        userName = "Unknown";
        userMobile = "Not found";
      });
      return;
    }

    // final url = Uri.parse('http://10.0.2.2:8080/user/{userId}/$mobile');

    try {
      final response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/user/me"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['name'] ?? "Unknown";
          userMobile = data['mobileNumber'] ?? "Unknown";
        });
      } else {
        setState(() {
          userName = "Failed to load";
          userMobile = "Try again";
        });
      }
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        userName = "Error";
        userMobile = "Check connection";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: UserAccountsDrawerHeader(
                  accountName: Text(userName),
                  accountEmail: Text("+91 $userMobile"),
                  currentAccountPicture: CircleAvatar(
                    child: Text(HelloDevsecit().getProfilePhoto(userName)),
                  ),
                ),
              ),
              SizedBox(
                height: DSIheightWidth(context, 100, true) - 200,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ListTile(
                      leading: Icon(Icons.home_outlined),
                      title: Text("Home"),
                      onTap: () {
                        go(context, HomePage());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.radar_sharp),
                      title: Text("Test Requests"),
                      onTap: () {
                        go(context, SoilTestRequests());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text("Shopping Cart"),
                      onTap: () {
                        setState(() {
                          currentPageIndex = 2;
                          goBack(context);
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.ads_click_sharp),
                      title: Text("My Order History"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.ac_unit_sharp),
                      title: Text("My Crop "),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.text_snippet_rounded),
                      title: Text("Crop Agronomy "),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.trending_up_rounded),
                      title: Text("Market Place "),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.receipt_long_outlined),
                      title: Text("My Reports "),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserReportsScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("My Profile Settings"),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("About us"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.support_agent),
                      title: Text("Help & Support"),
                      onTap: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton.filledTonal(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $userName 👋🏾",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text("Enjoy our services",
                  style: Theme.of(context).textTheme.bodySmall)
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton.filledTonal(
                onPressed: () {},
                icon: badges.Badge(
                  badgeContent: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  position: badges.BadgePosition.topEnd(top: -15, end: -12),
                  badgeStyle: const badges.BadgeStyle(badgeColor: Colors.green),
                  child: const Icon(IconlyBroken.notification),
                ),
              ),
            ),
          ],
        ),
        body: pages[currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPageIndex,
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.home),
              label: "Home",
              activeIcon: Icon(IconlyBold.home),
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.call),
              label: "Services",
              activeIcon: Icon(IconlyBold.call),
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.buy),
              label: "Cart",
              activeIcon: Icon(IconlyBold.buy),
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile),
              label: "Profile",
              activeIcon: Icon(IconlyBold.profile),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:dsi_pro/dsi_pro.dart';
// import 'package:original/pages/User/SoilTestRequests.dart';
// import 'package:original/pages/User/cart_page.dart';
// import 'package:original/pages/User/explore_page.dart';
// import 'package:original/pages/settings/Profile.dart';
// import 'package:original/pages/User/services_page.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:flutter/material.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final pages = [
//     const ExplorePage(),
//     const ServicesPage(),
//     const CartPage(),
//     const ProfilePage()
//   ];
//   int currentPageIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: Drawer(
//         child: Column(
//           children: [
//             Container(
//               height: 200,
//               child: UserAccountsDrawerHeader(
//                 accountName: Text("Mr. Provat"),
//                 accountEmail: Text("+91 9876543210"),
//                 currentAccountPicture: CircleAvatar(
//                   child: Text(HelloDevsecit().getProfilePhoto("Mr. Provat")),
//                 ),
//               ),
//             ),
//             Container(
//               height: DSIheightWidth(context, 100, true) - 200,
//               child: ListView(
//                 padding: EdgeInsets.all(0),
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.home_outlined),
//                     title: Text("Home"),
//                     onTap: () {
//                       go(context, HomePage());
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.radar_sharp),
//                     title: Text("Test Requests"),
//                     onTap: () {
//                       go(context, SoilTestRequests());
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.shopping_bag),
//                     title: Text("Shopping Cart"),
//                     onTap: () {
//                       setState(() {
//                         currentPageIndex = 2;
//                         goBack(context);
//                       });
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.ads_click_sharp),
//                     title: Text("My Order History"),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.ac_unit_sharp),
//                     title: Text("My Crop "),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.text_snippet_rounded),
//                     title: Text("Crop Agronomy "),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.trending_up_rounded),
//                     title: Text("Market Place "),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.receipt_long_outlined),
//                     title: Text("My Reports "),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.settings),
//                     title: Text("My Profile Settings"),
//                     onTap: () {},
//                   ),
//                   Divider(),
//                   ListTile(
//                     leading: Icon(Icons.info_outline),
//                     title: Text("About us"),
//                     onTap: () {},
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.support_agent),
//                     title: Text("Help & Support"),
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         centerTitle: false,
//         leading: IconButton.filledTonal(
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//           icon: const Icon(Icons.menu),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Hi, Mr. Provat 👋🏾",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             Text("Enjoy our services",
//                 style: Theme.of(context).textTheme.bodySmall)
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: IconButton.filledTonal(
//               onPressed: () {},
//               icon: badges.Badge(
//                 badgeContent: const Text(
//                   '3',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                 ),
//                 position: badges.BadgePosition.topEnd(top: -15, end: -12),
//                 badgeStyle: const badges.BadgeStyle(badgeColor: Colors.green),
//                 // badgeColor: Colors.blue),
//                 child: const Icon(IconlyBroken.notification),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: pages[currentPageIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentPageIndex,
//         onTap: (index) {
//           setState(() {
//             currentPageIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(IconlyLight.home),
//             label: "Home",
//             activeIcon: Icon(IconlyBold.home),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(IconlyLight.call),
//             label: "Services",
//             activeIcon: Icon(IconlyBold.call),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(IconlyLight.buy),
//             label: "Cart",
//             activeIcon: Icon(IconlyBold.buy),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(IconlyLight.profile),
//             label: "Profile",
//             activeIcon: Icon(IconlyBold.profile),
//           ),
//         ],
//       ),
//     );
//   }
// }
