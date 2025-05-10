import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String initialUrl;
  final String? title;
  final Function(String)? onPageStarted;
  final Function(String)? onPageFinished;
  final NavigationDelegate? navigationDelegate;

  const WebViewScreen({
    super.key,
    required this.initialUrl,
    this.title,
    this.onPageStarted,
    this.onPageFinished,
    this.navigationDelegate,
  });

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            widget.onPageStarted?.call(url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            widget.onPageFinished?.call(url);
          },
          onNavigationRequest: widget.navigationDelegate != null
              ? widget.navigationDelegate!.onNavigationRequest
              : (NavigationRequest request) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'WebView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}