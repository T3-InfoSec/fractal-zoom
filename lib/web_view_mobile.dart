import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class WebViewScreen extends StatefulWidget {
  final double real;
  final double imag;

  const WebViewScreen({super.key, required this.real, required this.imag});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> with WidgetsBindingObserver {
  Timer? _messageCheckTimer;
  InAppWebViewController? _webViewController;

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
        final result = await _webViewController!.evaluateJavascript(
          source: 'window.getFlutterMessages()',
        );
        print("Result: $result");

        if (result != 'null') {
          // Parse messages from the buffer
          final messages = jsonDecode(result) as List;
          for (final messageStr in messages) {
            final message = jsonDecode(messageStr);
            _handleWebMessage(message);
          }
        }
      } catch (e) {
        print('Error checking messages: $e');
      }
    }
  }

  void _handleWebMessage(dynamic message) {
    print("Message from web: $message");
    // Show message in UI
    // if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Received: $message")),
      );
    // }
  }

  Future<void> sendMessageToWeb(dynamic message) async {
    if (_webViewController != null) {
      final messageJson = jsonEncode(message);
      await _webViewController!.evaluateJavascript(
        source: "window.receiveFromFlutter('$messageJson')",
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
    return AppExitResponse.exit;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.teal,
      child: SafeArea(
        child: InAppWebView(
          initialSettings: InAppWebViewSettings(
            useOnDownloadStart: true,
            javaScriptCanOpenWindowsAutomatically: true,
            javaScriptEnabled: true,
            useShouldOverrideUrlLoading: true,
          ),
          initialUrlRequest:
          URLRequest(url: WebUri("http://localhost:8080/index.html")),
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
          onConsoleMessage: (controller, message) {},
          onDownloadStartRequest: (controller, string) {},
        ),
      ),
    );
  }
}