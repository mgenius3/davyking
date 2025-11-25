

import 'package:davyking/core/constants/images.dart';
import 'package:davyking/features/airtime/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/network_card_widget.dart';

class AirtimeNetworkWidget extends StatelessWidget {
  const AirtimeNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AirtimeIndexController airtimeIndexController = Get.find<AirtimeIndexController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => airtimeIndexController.setNetwork(0),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FF7E03D),
                innerColor: const Color(0x7FF7E03D),
                iconColor: const Color(0xFFF7E03D),
                iconPath: SvgConstant.mtnIcon,
                label: 'MTN',
                isSelected: airtimeIndexController.selectedNetwork.value == 0,
              )),
        ),
        GestureDetector(
          onTap: () => airtimeIndexController.setNetwork(1),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FBDE3BE),
                innerColor: const Color(0x3F50B651),
                iconColor: Colors.transparent,
                iconPath: SvgConstant.gloIcon,
                label: 'GLO',
                isSelected: airtimeIndexController.selectedNetwork.value == 1,
              )),
        ),
        GestureDetector(
          onTap: () => airtimeIndexController.setNetwork(2),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FF1A0A6),
                innerColor: const Color(0x33E20010),
                iconColor: Colors.transparent,
                iconPath: SvgConstant.airtelIcon,
                label: 'AIRTEL',
                isSelected: airtimeIndexController.selectedNetwork.value == 2,
              )),
        ),
        GestureDetector(
          onTap: () => airtimeIndexController.setNetwork(3),
          child: Obx(() => NetworkCard(
                color: const Color(0x3FEDF3A2),
                innerColor: const Color(0x33D6E806),
                iconColor: Colors.transparent,
                iconPath: SvgConstant.etisalatIcon,
                label: '9MOBILE',
                isSelected: airtimeIndexController.selectedNetwork.value == 3,
              )),
        ),
      ],
    );
  }
}