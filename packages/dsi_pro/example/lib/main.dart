// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_web_libraries_in_flutter, unused_import
import 'package:dsi_pro/dsi_pro.dart';
import 'package:example/OTPScreen.dart';
import 'package:flutter/material.dart';

void main() {
  initializeDSIPro(
    primaryColor: const Color.fromARGB(255, 5, 25, 141),
    accentColor: Colors.white,
    borderRadius: 4.0,
    defaultMargin: 8.0,
    defaultPadding: 8.0,
    appBorderColor: Colors.transparent,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello DSI DEMO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: 'Hello DSI DEMO'),
        "/notifications-all": (context) => const OTPScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  String lang = "ben";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DSI_CONFIG.appAccentColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DBR(height: 50.0),
                H1(
                  text: DTS("contact us", lang),
                ),
                DSI_PRIMARY_BUTTON(
                  title: "LAUNCH WEB",
                  onPressed: () async {
                    final val = await HelloDevsecit.launchWebPage(
                      url: "https://auth.devsecit.com",
                    );
                    print("Received :::::::::::::::::::::::::::::::::::: $val");

                    if (val != null) {
                      HelloDevsecit.showNotification(
                        title: "Web Page Closed",
                        content: val, // Use the returned value
                      );
                    } else {
                      print("No value received from web page.");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: DSIBottomNav(
        height: 65.0,
        padding: EdgeInsets.all(5),
        color: DSI_CONFIG.appPrimaryColor,
        items: [
          DSI_BOTTOM_NAV_BUTTON(
            icon: Icons.home,
            onPressed: () {},
            defaultColor: Colors.white,
            label: dsi_translate("home", lang),
            activeColor: Colors.blue,
            isActive: true,
            iconSize: 26.0,
          ),
          DSI_BOTTOM_NAV_BUTTON(
            icon: Icons.trending_up_rounded,
            onPressed: () {
              HelloDevsecit.showToast(
                context,
                "To ensure that the toast message expands its size to show the full content if the message is large, you can make a few adjustments to the, To ensure that the toast message expands its size to show the full content if the message is large, you can make a few adjustments to the",
                type: ToastType.SUCCESS,
                time: 10,
                borderRadius: 20.0,
              );
            },
            defaultColor: Colors.white,
            label: dsi_translate("trending", lang),
            activeColor: Colors.blue,
            isActive: false,
            iconSize: 26.0,
          ),
          DSI_BOTTOM_NAV_BUTTON(
            icon: Icons.settings,
            onPressed: () {},
            defaultColor: Colors.white,
            label: dsi_translate("hospital", lang),
            activeColor: Colors.blue,
            isActive: false,
            iconSize: 26.0,
          ),
        ],
      ),
    );
  }
}
