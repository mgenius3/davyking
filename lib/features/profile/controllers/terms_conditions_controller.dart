import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsController extends GetxController {
  var checkedbox = false.obs;

  void checkBoxChanged(bool? checkedboxchanges) {
    checkedbox.value = checkedboxchanges ?? false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
