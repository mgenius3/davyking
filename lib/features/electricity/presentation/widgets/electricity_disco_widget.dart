import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/widgets/network_card_widget.dart';
import 'package:davyking/features/electricity/controllers/index_controller.dart';
import 'package:davyking/features/electricity/presentation/widgets/disco_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElectricityDiscoWidget extends StatelessWidget {
  const ElectricityDiscoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ElectricityIndexController controller =
        Get.find<ElectricityIndexController>();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
        controller.discoMapping.length,
        (index) => GestureDetector(
          onTap: () => controller.setDisco(index),
          child: Obx(() =>
              //  NetworkCard(
              //     color: const Color(0x3F00A1D6), // Generic color, adjust as needed
              //     innerColor: const Color(0x3F00A1D6),
              //     iconColor: Colors.transparent,
              //     iconPath: controller.discoMapping[index]
              //         ['icon']!, // Replace with Disco-specific icons
              //     label: controller.discoMapping[index]['name']!,
              //     isIconPathImg: true,
              //     isSelected: controller.selectedDisco.value == index)
              DiscoCard(
                  iconPath: controller.discoMapping[index]['icon']!,
                  label: controller.discoMapping[index]['name']!,
                  isSelected: controller.selectedDisco.value == index,
                  isIconPathImg: true // Set to true if using PNG/JPG icons
                  )),
        ),
      ),
    );
  }
}
