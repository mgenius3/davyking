import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key});

  // Helper function to launch URLs with better error handling
  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);
      
      // Try platformDefault first, then fallback to externalApplication
      bool launched = false;
      
      try {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        // If platformDefault fails, try externalApplication
        try {
          launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          // If that fails too, try externalNonBrowserApplication
          launched = await launchUrl(
            uri,
            mode: LaunchMode.externalNonBrowserApplication,
          );
        }
      }

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $url'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening link: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Helper function to get the correct URL based on platform
  String _getPlatformUrl(String type, String value) {
    switch (type.toLowerCase()) {
      case 'phone':
        return 'tel:${value.replaceAll(' ', '')}';
      case 'website':
        return value;
      case 'facebook':
        // Try app first, fallback to web
        return 'https://www.facebook.com/$value';
      case 'instagram':
        // Try app first, fallback to web
        return 'https://www.instagram.com/$value';
      case 'whatsapp':
        // Format: remove + and spaces for WhatsApp link
        final cleanNumber = value.replaceAll('+', '').replaceAll(' ', '');
        return 'https://wa.me/$cleanNumber';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        helpList(
          context,
          CupertinoIcons.question_circle_fill,
          "Customer Service",
          '+234 703 834 2861',
          'phone',
        ),
        const SizedBox(height: 20),
        helpList(
          context,
          CupertinoIcons.globe,
          "Website",
          'https://davykingexchange.com.ng',
          'website',
        ),
        const SizedBox(height: 20),
        helpList(
          context,
          FontAwesomeIcons.facebook,
          "Facebook",
          'Davyking001',
          'facebook',
        ),
        const SizedBox(height: 20),
        helpList(
          context,
          FontAwesomeIcons.whatsapp,
          "WhatsApp",
          '+234 703 834 2861',
          'whatsapp',
        ),
        const SizedBox(height: 20),
        helpList(
          context,
          FontAwesomeIcons.instagram,
          "Instagram",
          'Davyking001',
          'instagram',
        ),
      ],
    );
  }

  Widget helpList(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String type,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          // Show loading indicator
          Get.showSnackbar(
            GetSnackBar(
              message: 'Opening $title...',
              duration: const Duration(seconds: 1),
              snackPosition: SnackPosition.BOTTOM,
            ),
          );
          
          // Get the correct URL based on type
          String url = _getPlatformUrl(type, value);
          await _launchUrl(url, context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: DarkThemeColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11.15),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13.94,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}