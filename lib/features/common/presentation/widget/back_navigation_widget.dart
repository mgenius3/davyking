import 'package:davyking/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BackNavigationWidget extends StatelessWidget {
  const BackNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        child: SvgPicture.asset(SvgConstant.backNavigation),
      ),
    );
  }
}
