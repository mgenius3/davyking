import 'package:davyking/core/constants/symbols.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/tv/controllers/index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TvVariationWidget extends StatelessWidget {
  const TvVariationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TvIndexController controller = Get.find<TvIndexController>();

    return Obx(() {
      final variations = controller.variations
          .where((v) =>
              v['service_id'].toString().toLowerCase() ==
              controller.tvMapping[controller.selectedTv.value]['service_id']
                  .toString()
                  .toLowerCase())
          .toList();

      if (variations.isEmpty) {
        return const Text('No tv yet');
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6),
        itemCount: variations.length,
        itemBuilder: (context, index) {
          final variation = variations[index];
          return Obx(() => TvPlanCard(
                plan: variation['package_bouquet'],
                price: variation['price'],
                variationId: variation['variation_id'].toString(),
                isSelected: controller.selectedVariationId.value ==
                    variation['variation_id'].toString(),
                onTap: () {
                  controller.setVariation(
                      variation['variation_id'].toString(),
                      variation['package_bouquet'],
                      variation['price'].toString());
                },
              ));
        },
      );
    });
  }
}

class TvPlanCard extends StatelessWidget {
  final String plan;
  final String price;
  final String variationId;
  final bool isSelected;
  final Function() onTap;

  const TvPlanCard({
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
