import 'package:davyking/features/airtime/controllers/index_controller.dart';
import 'package:davyking/features/airtime/data/model/input_field_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/states/mode.dart';

Widget vtuInputField(AirtimeInputFieldModel params) {
  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();
  // final AirtimeIndexController airtimeIndexController =
  //     Get.put(AirtimeIndexController());

  return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(params.name,
              style: TextStyle(
                  color:
                      lightningModeController.currentMode.value.mode == "light"
                          ? Colors.black
                          : Colors.white,
                  fontSize: 13.39,
                  fontWeight: FontWeight.w500,
                  height: 1.43)),
          const SizedBox(height: 5),
          SizedBox(
              height: 45,
              child: TextFormField(
                  controller: params.inputcontroller,
                  obscureText: params.obscureText,
                  onChanged: params.onChanged,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF5FFF6),
                      hintText: params.hintText,
                      hintStyle: TextStyle(color: Colors.transparent),
                      // prefixIcon: params.prefixIcon,
                      // prefixIconConstraints:
                      //     const BoxConstraints(minWidth: 40, minHeight: 50),
                      // contentPadding: const EdgeInsets.symmetric(
                      //     vertical: 10.0, horizontal: 1),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(11.48))))),
        ],
      ));
}
