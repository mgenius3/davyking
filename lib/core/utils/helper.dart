import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void openLink(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not launch $url";
  }
}

Future<void> copyToClipboard({
  required String text,
  BuildContext? context,
  String? confirmationMessage,
}) async {
  await Clipboard.setData(ClipboardData(text: text));

  // toastSuccess(context, message: "copied");
  ScaffoldMessenger.of(context!).showSnackBar(
    const SnackBar(content: Text('copied')),
  );

  if (context != null && confirmationMessage != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(confirmationMessage)),
    );
  }
}
