// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, prefer_const_constructors

import 'dart:math';

import 'package:dsi_pro/config.dart';
import 'package:dsi_pro/lang/dsi_constants.dart';
import 'package:dsi_pro/lang/hospitalConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dsi_pro_platform_interface.dart';
import 'lang/common.dart';

export 'config.dart';
export 'Sdk/H1.dart';
export 'Sdk/H2.dart';
export 'Sdk/H3.dart';
export 'Sdk/Paragraph.dart';
export 'Sdk/HTTP/http.dart';
export 'Nav/BottomBar.dart';
export 'Sdk/Buttons.dart';
export 'Sdk/TextBox.dart';
export 'Sdk/Percent_indicator.dart';
export 'Dialogs/Dialogs.dart';
export "Modal/DSIBottomModal.dart";
export "Sdk/Tables/ResponsiveTable.dart";
export "Sdk/OTPBox.dart";
export "Sdk/style.dart";
export "Sdk/container/DsiContainers.dart";
export "Sdk/icon/DSIIcon.dart";
export "Sdk/widget/AnalyticCards.dart";

List<Map<String, String>> rawConstantData = [
  ...rawData,
  ...hospitalConstants,
  ...commonData
];

go(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

goReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

goNamed(context, page) {
  Navigator.pushNamed(context, page);
}

goNamedReplace(context, page) {
  Navigator.pushReplacementNamed(context, page);
}

goBack(context) {
  Navigator.pop(context);
}

DSI_DRAWER_GO(context, page) {
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

DSI_DRAWER_GO_NAMED(context, page) {
  Navigator.pop(context);
  Navigator.pushNamed(context, page);
}

String dsi_translate(String key, String lang) {
  var result = rawConstantData.firstWhere(
    (element) => element['key'] == key,
    orElse: () => {},
  );

  // Return the translation if found, otherwise return the input key
  return result.isNotEmpty
      ? result[lang] ?? key
      : key[0].toUpperCase() + key.substring(1);
}

String DTR(String key, String lang) {
  var result = rawConstantData.firstWhere(
    (element) => element['key'] == key.toString().toLowerCase(),
    orElse: () => {},
  );

  // Return the translation if found, otherwise return the input key
  return result.isNotEmpty
      ? result[lang] ?? key
      : key[0].toUpperCase() + key.substring(1);
}

String DTS(String sentence, String lang) {
  // Split the sentence by space, but keep punctuation marks with the words
  sentence = sentence.toLowerCase();
  RegExp regex = RegExp(r'(\w+|[,:;-])');
  List<RegExpMatch> matches = regex.allMatches(sentence).toList();

  List<String> translatedWords = [];

  for (var match in matches) {
    String word = match.group(0)!;

    // Check if the word is a punctuation mark
    if (RegExp(r'[,:;-]').hasMatch(word)) {
      translatedWords.add(word);
    } else {
      String translatedWord = DTR(word, lang);
      if (translatedWord == word) {
        // If a word cannot be translated, return the original sentence
        return sentence;
      }
      translatedWords.add(translatedWord);
    }
  }

  // Join the translated words back into a sentence
  return translatedWords.join(' ');
}

class DSIHexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  DSIHexColor(final String hex) : super(_getColor(hex));
}

// class
class HelloDevsecit {
  static const MethodChannel _channel = MethodChannel('dsi_pro');

  Future<String?> getPlatformVersion() {
    return HelloDevsecitPlatform.instance.getPlatformVersion();
  }

  Future<String> restartWindowsApp() {
    return HelloDevsecitPlatform.instance.restartWindowsApp();
  }

  Future<String?> getAndroidId() {
    return HelloDevsecitPlatform.instance.getAndroidId();
  }

  static Future<String?> launchWebPage({required String url}) async {
    try {
      final val = await _channel.invokeMethod<String>('launchWeb', {
        'url': url,
      });
      print("Received from Native Code: $val");
      return val; // Return the received value
    } on PlatformException catch (e) {
      print("Error loading web page: $e");
      return e.message; // Return the error message
    }
  }

  static void showToast(BuildContext context, String message,
      {int time = 3,
      double borderRadius = 8.0,
      String type = ToastType.NORMAL}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: SingleChildScrollView(
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
        duration: Duration(seconds: time),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: type == ToastType.ERROR
            ? Colors.red
            : type == ToastType.SUCCESS
                ? Colors.green
                : type == ToastType.WARNING
                    ? Colors.orange
                    : DSI_CONFIG.appPrimaryColor,
        action: SnackBarAction(
          label: 'x',
          textColor: Colors.white,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  static void showToastError(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 1), // Adjust the duration as needed
        behavior: SnackBarBehavior.floating,
        // You can customize the appearance of the toast message here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'x',
          textColor: Colors.white,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  static void showToastLong(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5), // Adjust the duration as needed
        behavior: SnackBarBehavior.floating,
        // You can customize the appearance of the toast message here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: defaultAppColor,
        action: SnackBarAction(
          label: 'x',
          textColor: Colors.white,
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  goNow(settings, page) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  String generateRandomString(int len) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        len, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  String getProfilePhoto(String fullName) {
    List<String> names = fullName.split(' ');
    String initials = '';
    for (String name in names) {
      if (name.isNotEmpty) {
        initials += name[0].toUpperCase();
      }
    }
    return initials;
  }

  static Future<void> showNotification({
    required String title,
    required String content,
    String? buttonText,
    String? buttonAction,
  }) async {
    try {
      await _channel.invokeMethod('showNotification', {
        'title': title,
        'content': content,
        'buttonText': buttonText,
        'buttonAction': buttonAction,
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Handle permission denied error and request permission
        requestNotificationPermission();
      }
      print("Error showing notification: $e");
    }
  }

  HelloDevsecit() {
    // Register the MethodCallHandler
    _channel.setMethodCallHandler(_handleMethodCall);
  }

// Handle responses from Android for navigation
  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == "navigateToRoute") {
      final String route = call.arguments as String;
      dsi_go_nav(route); // Navigate using the provided route
    }
  }

  void dsi_go_nav(String route) {
    // Implement the navigation logic
    // For example, using a navigator key to navigate to the route
  }

  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}
