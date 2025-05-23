import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiscoCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final bool isIconPathImg;

  const DiscoCard({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    this.isIconPathImg = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Fixed width for consistent sizing
      height: 100, // Fixed height for square cards
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: DarkThemeColors.primaryColor, width: 2)
              : const BorderSide(color: Colors.grey, width: 0.5),
        ),
        shadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isIconPathImg
              ? Image.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                )
              : SvgPicture.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}