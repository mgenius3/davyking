import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class searchBoxWidget extends StatelessWidget {
  final String hintText;
  const searchBoxWidget({super.key, this.hintText = "Search.."});

  @override
  Widget build(BuildContext context) {
    final LightningModeController controller =
        Get.find<LightningModeController>();
    return SizedBox(
      height: 36,
      child: TextFormField(
          style: Theme.of(context).textTheme.displayMedium,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                  height: 1,
                  color: controller.currentMode.value.mode != "light"
                      ? Colors.white
                      : Colors.black),
              // filled: true,
              // fillColor: controller.currentMode.value.mode == "light"
              //     ? const Color(0xFFFFFCFA)
              //     : const Color(0x51FFFCFA),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child:
                    SizedBox(width: 16, height: 16, child: Icon(Icons.search)),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 30, minHeight: 20),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 30, minHeight: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    BorderSide(color: DarkThemeColors.primaryColor, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: DarkThemeColors
                          .primaryColor, // Adjust the color as needed for focus
                      width: 0.5)))),
    );
  }
}
