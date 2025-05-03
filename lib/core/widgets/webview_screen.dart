import 'package:davyking/core/widgets/back_navigation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

void openWebView(BuildContext context, String url, String name) {
  double padding = 20; // Padding inside the Container

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(url));

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  BackNavigationWidget(),
                  const SizedBox(width: 20),
                  Text(
                    name,
                    style: const TextStyle(fontFamily: "Work Sans"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: WebViewWidget(controller: controller),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
