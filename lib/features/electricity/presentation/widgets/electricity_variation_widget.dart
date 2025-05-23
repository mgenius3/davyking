import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/electricity/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElectricityVariationWidget extends StatelessWidget {
  const ElectricityVariationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ElectricityIndexController controller =
        Get.find<ElectricityIndexController>();
    final variations = [
      {'id': 'prepaid', 'name': 'Prepaid'},
      {'id': 'postpaid', 'name': 'Postpaid'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: variations.map((variation) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => controller.setVariation(variation['id']!),
            child: Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: controller.selectedVariationId.value ==
                                variation['id']
                            ? BorderSide(
                                color: DarkThemeColors.primaryColor, width: 2)
                            : const BorderSide(color: Colors.grey, width: 0.5)),
                    shadows: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    variation['name']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                )),
          ),
        );
      }).toList(),
    );
  }
}
