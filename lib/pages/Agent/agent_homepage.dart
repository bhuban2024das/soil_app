import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:dsi_pro/dsi_pro.dart';
import 'package:original/pages/Agent/agent_explorepage.dart';
import 'package:original/pages/Agent/agent_order.dart';
import 'package:original/pages/Agent/agent_profilepage.dart';
import 'package:original/pages/Agent/agent_test_report.dart';
import 'package:original/pages/Agent/my_earning.dart';
import 'package:original/pages/Agent/product_inventory.dart';
import 'package:original/pages/Agent/test_list.dart';
import 'package:original/pages/Agent/test_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:original/utils/config.dart';
import 'package:original/pages/Agent/soil_request_list.dart';

class AgentHomepage extends StatefulWidget {
  const AgentHomepage({super.key});

  @override
  State<AgentHomepage> createState() => _HomePageState();
}

class _HomePageState extends State<AgentHomepage> {
  final pages = [
    const AgentExplorepage(),
    // const AgentSearch(),
    const AgentOrder(),
    const AgentProfilepage()
  ];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String agentName = "Loading...";
  String agentMobile = "Fetchibg...";

  @override
  void initState() {
    super.initState();
    print("initState called");
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final mobile = prefs.getString('agentMobile') ?? "";
    final token = prefs.getString('userToken') ?? "";

    if (mobile.isEmpty || token.isEmpty) {
      setState(() {
        agentName = "Unknown";
        agentMobile = "Not found";
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
          agentName = data['name'] ?? "Unknownnn";
          agentMobile = data['mobileNumber'] ?? "Unknownnn";
        });
      } else {
        setState(() {
          agentName = "Failed to load";
          agentMobile = "Try again";
        });
      }
    } catch (e) {
      print("Error fetching user: $e");
      setState(() {
        agentName = "Error";
        agentMobile = "Check connection";
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
                  accountName: Text(agentName),
                  accountEmail: Text("+91 $agentMobile"),
                  currentAccountPicture: CircleAvatar(
                    child: Text(HelloDevsecit().getProfilePhoto("Mr. Provat")),
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
                        go(context, AgentHomepage());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.radar_sharp),
                      title: Text("Test Requests "),
                      onTap: () {
                        go(context, SoilTestRequestsScreen());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.radar_sharp),
                      title: Text("Test Reports"),
                      onTap: () {
                        go(context, AgentTestReportList());
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => TestList()),
                        // );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_bag),
                      title: Text("Product & Inventory"),
                      onTap: () {
                        // setState(() {
                        //   currentPageIndex = 2;
                        //   goBack(context);
                        // });
                        go(context, ProductInventory());
                      },
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.ads_click_sharp),
                    //   title: Text("My Order History"),
                    //   onTap: () {},
                    // ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("My Earning"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewEarnings()),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("About us"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.chat_outlined),
                      title: Text("Terms and Conditions"),
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
                agentName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text("Lets grow our Business",
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
                    '7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  position: badges.BadgePosition.topEnd(top: -15, end: -12),
                  badgeStyle: const badges.BadgeStyle(badgeColor: Colors.green),
                  // badgeColor: Colors.blue),
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
            // BottomNavigationBarItem(
            //   icon: Icon(IconlyLight.search),
            //   label: "Search",
            //   activeIcon: Icon(IconlyBold.search),
            // ),
            BottomNavigationBarItem(
              icon: Icon(IconlyBold.graph),
              label: "Orders",
              activeIcon: Icon(IconlyBold.graph),
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
