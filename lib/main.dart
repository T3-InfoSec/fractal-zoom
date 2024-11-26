import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_linux_webview/flutter_linux_webview.dart';
import 'package:fractal_zoom/web_view_linux.dart';
import 'package:fractal_zoom/web_view_screen_flutter_react.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:webview_flutter/webview_flutter.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(defaultTargetPlatform != TargetPlatform.linux) {

    final InAppLocalhostServer localhostServer =
    InAppLocalhostServer(documentRoot: 'assets/react_app');

    if (!kIsWeb) {
      await localhostServer.start();
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }
  } else {
    WidgetsFlutterBinding.ensureInitialized();

    // Set up a static file server to serve the React build
    final handler = createStaticHandler(
      Directory.current.path + '/assets/react_app',
      defaultDocument: 'index.html',
    );

    final server = await serve(handler, 'localhost', 8080);
    print('Server running at http://${server.address.host}:${server.port}');

    // Run `LinuxWebViewPlugin.initialize()` first before creating a WebView.
    LinuxWebViewPlugin.initialize(options: <String, String?>{
      'user-agent': 'UA String',
      'remote-debugging-port': '8888',
      'autoplay-policy': 'no-user-gesture-required',
    });

    // Configure [WebView] to use the [LinuxWebView].
    WebView.platform = LinuxWebView();
  }
  runApp(const MaterialApp(home: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  void _startWebView() {
    bool isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if(!isLinux) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample()));
    }
    print('Linux is not supported');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startWebView,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
