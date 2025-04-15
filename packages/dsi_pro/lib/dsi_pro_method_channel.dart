// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/services.dart';

import 'dsi_pro_platform_interface.dart';

/// An implementation of [HelloDevsecitPlatform] that uses method channels.
class MethodChannelHelloDevsecit extends HelloDevsecitPlatform {
  /// The method channel used to interact with the native platform.
  // @visibleForTesting
  @override
  final methodChannel = const MethodChannel('dsi_pro');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> restartWindowsApp() async {
    try {
      final resp = await methodChannel.invokeMethod<String>('restartApp');
      return resp;
    } on PlatformException catch (e) {
      print("Failed to restart app: '${e.message}'.");
    }
  }

  @override
  Future<String?> getAndroidId() async {
    final android = await methodChannel.invokeMethod<String>('getAndroidId');
    return android;
  }
}
