import 'dart:async';
import 'dart:io';
import 'package:cosmossoft/redirect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

const colorPrimaryDark = Color(0XFF7900F5);
// ignore: prefer_collection_literals

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  await FlutterDownloader.initialize(debug: true);
  // set true to enable printing logs to console
  await Permission.storage.request();
  await Permission.mediaLibrary.request();
  await Permission.locationWhenInUse.request();
  // ask for storage permission on app create

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barnwal Electronics',
      theme: ThemeData(primaryColor: colorPrimaryDark),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Redirect()),
    );
  }
}
