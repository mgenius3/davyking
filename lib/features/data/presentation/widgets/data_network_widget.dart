import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/widgets/network_card_widget.dart';
import 'package:davyking/features/data/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataNetworkWidget extends StatelessWidget {
  const DataNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DataIndexController controller = Get.find<DataIndexController>();

    print(controller.selectedNetwork.value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => controller.setNetwork(0),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FF7E03D),
                innerColor: const Color(0x7FF7E03D),
                iconColor: const Color(0xFFF7E03D),
                iconPath: SvgConstant.mtnIcon,
                label: 'MTN',
                isSelected: controller.selectedNetwork.value == 0,
              )),
        ),
        GestureDetector(
          onTap: () => controller.setNetwork(1),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FBDE3BE),
                innerColor: const Color(0x3F50B651),
                iconColor: Colors.transparent,
                iconPath: SvgConstant.gloIcon,
                label: 'GLO',
                isSelected: controller.selectedNetwork.value == 1,
              )),
        ),
        GestureDetector(
          onTap: () => controller.setNetwork(2),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FF1A0A6),
                innerColor: const Color(0x33E20010),
                iconColor: Colors.transparent,
                iconPath: SvgConstant.airtelIcon,
                label: 'AIRTEL',
                isSelected: controller.selectedNetwork.value == 2,
              )),
        ),
        GestureDetector(
          onTap: () => controller.setNetwork(3),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FEDF3A2),
                innerColor: const Color(0x33D6E806),
                iconColor: Colors.transparent,
                iconPath: SvgConstant.etisalatIcon,
                label: '9MOBILE',
                isSelected: controller.selectedNetwork.value == 3,
              )),
        ),
        GestureDetector(
          onTap: () => controller.setNetwork(4),
          child: Obx(() => NetworkCard(
              color: const Color(0x3F00A1D6),
              innerColor: const Color(0x3F00A1D6),
              iconColor: Colors.transparent,
              iconPath: ImagesConstant.smileIcon,
              isIconPathImg: true,
              label: 'SMILE',
              isSelected: controller.selectedNetwork.value == 4)),
        ),
      ],
    );
  }
}
