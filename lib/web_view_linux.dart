import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_linux_webview/flutter_linux_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final double real;
  final double imag;
  const WebViewExample({super.key, required this.real, required this.imag});

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> with WidgetsBindingObserver {
  Timer? _messageCheckTimer;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Start polling for messages from web
    _startMessagePolling();
  }

  void _startMessagePolling() {
    // Poll for messages every 500ms
    _messageCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _checkForMessages();
    });
  }

  Future<void> _checkForMessages() async {
    if (_webViewController != null) {
      try {
        final result = await _webViewController!.runJavascriptReturningResult(
          'window.getFlutterMessages()',
        );

        if (result != 'null' && result != '"[]"') {
          print('got message');
          // Parse messages from the buffer
          // final messages = jsonDecode(jsonDecode(result)) as List;
          // // print('here');
          // for (final messageStr in messages) {
          //   final message = jsonDecode(messageStr);
          //   _handleWebMessage(message);
          // }
        }
      } catch (e) {
        print('Error checking messages: $e');
      }
    }
  }

  void _handleWebMessage(dynamic message) {
    print("Message from web:");
    // print("Message from web: $message");
    // Show message in UI
    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Received: $message")),
    //   );
    // }
  }

  Future<void> sendMessageToWeb(dynamic message) async {
    if (_webViewController != null) {
      final messageJson = jsonEncode(message);
      await _webViewController!.runJavascript(
        "window.receiveFromFlutter('$messageJson')",
      );
    }
  }

  @override
  void dispose() {
    _messageCheckTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await LinuxWebViewPlugin.terminate();
    return AppExitResponse.exit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_linux_webview example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebView(
              initialUrl: 'http://localhost:8080/index.html',
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ],
      ),
    );
  }
}