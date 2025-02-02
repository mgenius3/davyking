import 'package:flutter_svg/svg.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';

class NetworkCard extends StatelessWidget {
  final Color color;
  final Color innerColor;
  final Color iconColor;
  final String iconPath;
  final String label;
  final bool isSelected;

  const NetworkCard(
      {super.key,
      required this.color,
      required this.innerColor,
      required this.iconColor,
      required this.iconPath,
      required this.label,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: isSelected
                ? BorderSide(color: DarkThemeColors.primaryColor, width: 2)
                : BorderSide.none),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 5,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 50,
            padding: const EdgeInsets.all(5),
            decoration: ShapeDecoration(
              color: innerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 3,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: ShapeDecoration(
                color: iconColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: SvgPicture.asset(iconPath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 3),
          Text(label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 10, fontWeight: FontWeight.w400, height: 1.5)),
        ],
      ),
    );
  }
}
