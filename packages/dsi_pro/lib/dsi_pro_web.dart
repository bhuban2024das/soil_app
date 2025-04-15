// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:html' as html;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'dsi_pro_platform_interface.dart';

class HelloDevsecitWeb extends HelloDevsecitPlatform {
  
  HelloDevsecitWeb();

  static void registerWith(Registrar registrar) {
    HelloDevsecitPlatform.instance = HelloDevsecitWeb();
  } 

  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}

goBackWeb() {
  html.window.history.back();
}

setWebTitle(title) {
  html.document.title = title.toString();
}
