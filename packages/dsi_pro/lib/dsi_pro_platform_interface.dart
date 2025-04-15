import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dsi_pro_method_channel.dart';

abstract class HelloDevsecitPlatform extends PlatformInterface {
  final methodChannel = const MethodChannel('dsi_pro');

  /// Constructs a HelloDevsecitPlatform.
  HelloDevsecitPlatform() : super(token: _token);

  static final Object _token = Object();

  static HelloDevsecitPlatform _instance = MethodChannelHelloDevsecit();

  /// The default instance of [HelloDevsecitPlatform] to use.
  ///
  /// Defaults to [MethodChannelHelloDevsecit].
  static HelloDevsecitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HelloDevsecitPlatform] when
  /// they register themselves.
  static set instance(HelloDevsecitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getAndroidId() {
    throw UnimplementedError('getAndroidId() has not been implemented.');
  }

  restartWindowsApp() async {
    try {
      await methodChannel.invokeMethod<void>('restartApp');
    } on PlatformException catch (e) {
      print("Failed to restart app: '${e.message}'.");
    }
  }
}
