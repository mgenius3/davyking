import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/widgets/network_card_widget.dart';
import 'package:davyking/features/data/controllers/index_controller.dart';
import 'package:davyking/features/tv/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TvNetworkWidget extends StatelessWidget {
  const TvNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TvIndexController controller = Get.find<TvIndexController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // DSTV
        GestureDetector(
          onTap: () => controller.setTv(0),
          child: Obx(() => NetworkCard(
                color: const Color(0xFF0076C0),          // DSTV Blue
                innerColor: const Color(0x330076C0),     // DSTV Blue with transparency
                iconColor: Colors.white,
                iconPath: ImagesConstant.dstv,
                label: 'DSTV',
                isIconPathImg: true,
                isSelected: controller.selectedTv.value == 0,
              )),
        ),

        // GOTV
        GestureDetector(
          onTap: () => controller.setTv(1),
          child: Obx(() => NetworkCard(
                color: const Color(0xFFE61E2A),          // GOTV Red
                innerColor: const Color(0x33E61E2A),     // Transparent red
                iconColor: Colors.white,
                iconPath: ImagesConstant.gotv,
                label: 'GOTV',
                isIconPathImg: true,
                isSelected: controller.selectedTv.value == 1,
              )),
        ),

        // Startimes
        GestureDetector(
          onTap: () => controller.setTv(2),
          child: Obx(() => NetworkCard(
                color: const Color(0xFF0072C6),          // Startimes Blue
                innerColor: const Color(0x330072C6),     // Transparent Startimes blue
                iconColor: Colors.white,
                iconPath: ImagesConstant.startimes,
                label: 'Startimes',
                isIconPathImg: true,
                isSelected: controller.selectedTv.value == 2,
              )),
        ),

        // Showmax
        GestureDetector(
          onTap: () => controller.setTv(3),
          child: Obx(() => NetworkCard(
                color: const Color(0xFFCE0F69),          // Showmax pinkish
                innerColor: const Color(0x33CE0F69),     // Transparent version
                iconColor: Colors.white,
                iconPath: ImagesConstant.showmax,
                label: 'Showmax',
                isIconPathImg: true,
                isSelected: controller.selectedTv.value == 3,
              )),
        ),
      ],
    );
  }
}
