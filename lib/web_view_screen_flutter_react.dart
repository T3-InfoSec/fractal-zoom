import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  // final String fileName;
  // final String fileLink;

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
            controller.addJavaScriptHandler(
                handlerName: 'fileDetailsHandler',
                callback: (args) {
                  return {
                    "name": 'hello',
                    "link": 'world',
                  };
                }
            );
          },
          onConsoleMessage: (controller, message) {},
          onDownloadStart: (controller, string) {},
        ),
      ),
    );
  }
}