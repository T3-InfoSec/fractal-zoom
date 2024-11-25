import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class LocalReactWebView extends StatefulWidget {
  const LocalReactWebView({Key? key}) : super(key: key);

  @override
  State<LocalReactWebView> createState() => _LocalReactWebViewState();
}

class _LocalReactWebViewState extends State<LocalReactWebView> {
  // Initialize the controller as nullable
  WebViewController? _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    // Create and configure the controller
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      );

    // Load the content
    try {
      await _loadFromAssets(controller);
      // or use: await _loadFromLocalServer(controller);

      // Only set the controller after successful initialization
      setState(() {
        _controller = controller;
      });
    } catch (e) {
      print('Error initializing WebView: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method 1: Load from assets
  Future<void> _loadFromAssets(WebViewController controller) async {
    final String htmlContent = await rootBundle.loadString('assets/index.html');
    await controller.loadHtmlString(htmlContent);
  }

  // Method 2: Load from local server
  Future<void> _loadFromLocalServer(WebViewController controller) async {
    await controller.loadRequest(Uri.parse('http://10.0.2.2:3000'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local React App'),
      ),
      body: Stack(
        children: [
          if (_controller != null)
            WebViewWidget(
              controller: _controller!,
            )
          else
            const Center(
              child: Text('Initializing WebView...'),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}