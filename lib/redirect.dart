import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cosmossoft/nointernet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class Redirect extends StatefulWidget {
  const Redirect({Key? key}) : super(key: key);

  @override
  State<Redirect> createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  late StreamSubscription<ConnectivityResult> networkSubscription;
  bool connectionStatus = true;
  @override
  void initState() {
    super.initState();
    networkSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      check();
    });
    check(); // Needed for the check on start
  }

  void check() {
    Timer.periodic(new Duration(seconds: 1), (time) async {
      final flutterWebViewPlugin = FlutterWebviewPlugin();
      if (connectionStatus == false) flutterWebViewPlugin.reload();
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          connectionStatus = true;
        }
      } on SocketException catch (_) {
        connectionStatus = false;
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ConnectionLostScreen()));
      }
    });
  }

  // @override
  // void dispose() {
  //   hasConnection = false;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barnwal Electronics'),
        backgroundColor: const Color(0XFF130925),
        toolbarHeight: 70,
      ),
      body: WebviewScaffold(
        url: "https://login.barnwalelectric.in/",
        javascriptChannels: jsChannels,
        mediaPlaybackRequiresUserGesture: false,
        geolocationEnabled: true,
        withZoom: true,
        withLocalStorage: true,
        hidden: false,
      ),
    );
  }
}
