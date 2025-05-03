import 'package:flutter/material.dart';

class DotIndexIndicator extends StatelessWidget {
  final int itemCount; // Total number of dots
  final int currentIndex; // Currently active dot index
  final Color activeColor; // Color for the active dot
  final Color inactiveColor; // Color for the inactive dots
  final double baseSize; // Base size of the dots
  final double activeSize; // Size of the active dot

  const DotIndexIndicator(
      {Key? key,
      required this.itemCount,
      required this.currentIndex,
      this.activeColor = const Color(0xFFABABB1),
      this.inactiveColor = Colors.grey,
      this.baseSize = 8.0,
      this.activeSize = 12.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        // Calculate relative size and opacity for each dot
        final distance = (index - currentIndex).abs(); // Absolute distance
        final size = activeSize -
            (distance * 2.0).clamp(0, activeSize - baseSize); // Size reduction
        final opacity =
            1.0 - (distance * 0.3).clamp(0.0, 0.6); // Opacity reduction

        final width = activeSize - distance * 1.2;
        final opacity_main = 1.0 - distance * 0.1;

        return Opacity(
            opacity: 0.70,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                width: currentIndex == index ? 16 : width,
                height: currentIndex == index ? 14 : width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: (currentIndex == index ? activeColor : inactiveColor)
                        .withOpacity(opacity_main))));
      }),
    );
  }
}
