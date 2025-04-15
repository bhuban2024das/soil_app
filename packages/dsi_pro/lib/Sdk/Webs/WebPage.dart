import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DSIWebPage extends StatefulWidget {
  const DSIWebPage({Key? key, this.topChild, this.bottomChild, this.onTap})
      : super(key: key);
  final Widget? topChild, bottomChild;
  final Function? onTap;

  @override
  _DSIWebPageState createState() => _DSIWebPageState();
}

class _DSIWebPageState extends State<DSIWebPage> {
  late Position _position;

  bool _isLoading = true;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    _fetchLocation();

    timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchLocation());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _isLoading = false;
      // controller.loadRequest(Uri.parse(
      //     'https://maps.devsecit.com?lat=${_position.latitude}&lon=${_position.longitude}&focus=20'));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final url =
        'https://maps.devsecit.com/entry/?lat=${_position.latitude}&lon=${_position.longitude}&focus=10';

    return kIsWeb
        ? WebMapView(
            url: url,
            bottomChild: widget.bottomChild,
            topChild: widget.topChild,
          )
        : MobileMapView(
            url: url,
            bottomChild: widget.bottomChild,
            topChild: widget.topChild,
            onTap: widget.onTap,
          );
  }
}

class WebMapView extends StatefulWidget {
  final String url;
  final Widget? topChild, bottomChild;

  const WebMapView(
      {required this.url, Key? key, this.topChild, this.bottomChild})
      : super(key: key);

  @override
  State<WebMapView> createState() => _WebMapViewState();
}

class _WebMapViewState extends State<WebMapView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return Scaffold(
    //   body: Column(
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       if (widget.topChild != null) widget.topChild!,
    //       Expanded(
    //         child: PlatformWebViewWidget(
    //           PlatformWebViewWidgetCreationParams(
    //             controller: widget.controller,
    //           ),
    //         ).build(context),
    //       ),
    //     ],
    //   ),
    //   bottomNavigationBar: widget.bottomChild ??
    //       SizedBox(
    //         height: 0,
    //       ),
    // );
  }
}

class MobileMapView extends StatefulWidget {
  final String url;
  // final WebViewController controller;
  final Widget? topChild, bottomChild;
  final Function? onTap;
  const MobileMapView(
      {required this.url,
      Key? key,
      // required this.controller,
      this.topChild,
      this.bottomChild,
      this.onTap})
      : super(key: key);

  @override
  State<MobileMapView> createState() => _MobileMapViewState();
}

class _MobileMapViewState extends State<MobileMapView> {
  late WebViewController _controller;
  late Map<String, dynamic> data;
  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..addJavaScriptChannel("myChannel",
          onMessageReceived: (JavaScriptMessage message) {
        try {
          data = jsonDecode(message.message);
          widget.onTap!(data);
          setState(() {});
        } catch (e) {}
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // _injectJavascript(_controller);
          },
        ),
      );
    print("Reload Requested");
    super.initState();
  }

  @override
  void didUpdateWidget(MobileMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload the web view with the new URL if it has changed
    if (widget.url != oldWidget.url) {
      _controller.loadRequest(Uri.parse(widget.url));
    }
    print("Reload Requested");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (widget.topChild != null) widget.topChild!,
          Expanded(
            child: WebViewWidget(
              controller: _controller,
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.bottomChild ??
          const SizedBox(
            height: 0,
          ),
    );
  }
}
