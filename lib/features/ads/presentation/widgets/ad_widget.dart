import 'package:davyking/core/utils/helper.dart';
import 'package:flutter/material.dart';
import '../../data/models/ad_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AdWidget extends StatelessWidget {
  final Ad ad;
  final VoidCallback? onTap;

  const AdWidget({super.key, required this.ad, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (ad.targetUrl != null) {
              // Handle navigation (e.g., open URL in browser)
              launch(ad.targetUrl!);
            }
          },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        height: 130, // Fixed height for consistency
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _getGradient(ad.type),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Section (Image or Icon)
            Expanded(
              flex: 2,
              child: _buildLeftSection(ad),
            ),
            // Right Section (Text and Button)
            Expanded(
              flex: 3,
              child: _buildRightSection(context, ad),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradient(String type) {
    if (type == 'banner') {
      return const LinearGradient(
        colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFFFFA726), Color(0xFFFFD54F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Widget _buildLeftSection(Ad ad) {
    if (ad.imageUrl != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
        child: Image.network(
          ad.imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      );
    } else if (ad.type == 'banner') {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.currency_bitcoin, color: Colors.purple, size: 40),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.emoji_events, color: Colors.white, size: 40),
      );
    }
  }

  Widget _buildRightSection(BuildContext context, Ad ad) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ad.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (ad.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                shortenString(ad.description!, 20),
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          // const Spacer(),
          // const SizedBox(height: 20),
          // Row(
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //       decoration: BoxDecoration(
          //         color: Colors.green,
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       child: const Text(
          //         'View',
          //         style: TextStyle(color: Colors.white, fontSize: 12),
          //       ),
          //     ),
          //     // const SizedBox(width: 8),
          //     // ...List.generate(
          //     //     3,
          //     //     (index) =>
          //     //         const Icon(Icons.circle, size: 6, color: Colors.grey)),
          //   ],
          // ),
        ],
      ),
    );
  }
}
