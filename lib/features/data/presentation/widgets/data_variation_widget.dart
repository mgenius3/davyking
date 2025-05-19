import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/data/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:lucide_icons/lucide_icons.dart'; // You can use another icon package if needed

class DataVariationWidget extends StatelessWidget {
  const DataVariationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DataIndexController controller = Get.find<DataIndexController>();

    return Obx(() {
      final variations = controller.variations
          .where((v) =>
              v['service_id'].toString().toLowerCase() ==
              controller.networkMapping[controller.selectedNetwork.value]
                  .toLowerCase())
          .toList();

      if (variations.isEmpty) {
        Icon(Icons.hourglass_empty, size: 48, color: Colors.grey);
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemCount: variations.length,
        itemBuilder: (context, index) {
          final variation = variations[index];
          return Obx(() => DataPlanCard(
                plan: variation['data_plan'],
                price: variation['price'],
                variationId: variation['variation_id'].toString(),
                isSelected: controller.selectedVariationId.value ==
                    variation['variation_id'].toString(),
                onTap: () {
                  controller.setVariation(variation['variation_id'].toString(),
                      variation['data_plan']);
                },
              ));
        },
      );
    });
  }
}

class DataPlanCard extends StatelessWidget {
  final String plan;
  final String price;
  final String variationId;
  final bool isSelected;
  final Function() onTap;

  const DataPlanCard({
    super.key,
    required this.plan,
    required this.price,
    required this.variationId,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? DarkThemeColors.primaryColor.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isSelected
                ? DarkThemeColors.primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2.0 : 0.5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(plan,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    text: Symbols.currency_naira,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: DarkThemeColors.primaryColor),
                    children: [
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
