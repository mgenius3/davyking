import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/widgets/dot_index_indicator.dart';
import 'package:davyking/features/ads/controller/ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/ad_widget.dart';

class AdScreen extends StatefulWidget {
  const AdScreen({super.key});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  final AdController controller = Get.put(AdController());
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: controller.ads.isEmpty ? 0 : 130,
        child: Obx(() => controller.isLoading.value
            ? _buildShimmerList()
            : controller.errorMessage.value.isNotEmpty
                ? Center(child: Text(controller.errorMessage.value))
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                            onRefresh: () async {
                              controller.refreshAds();
                            },
                            child: SizedBox(
                              width: Get.width,
                              height: 100,
                              child: PageView.builder(
                                itemCount: controller.ads.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return AdWidget(ad: controller.ads[index]);
                                },
                              ),
                            )),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 20,
                        child: DotIndexIndicator(
                            itemCount: controller.ads.length,
                            currentIndex: _currentIndex,
                            activeColor: DarkThemeColors.primaryColor,
                            inactiveColor: const Color(0xFFCCCCD0)),
                      )
                    ],
                  )));
  }

  /// Shimmer effect for loading
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 1, // Show 5 shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100, // Adjust height based on your AdWidget
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)
                  ),
            ),
          ),
        );
      },
    );
  }
}
