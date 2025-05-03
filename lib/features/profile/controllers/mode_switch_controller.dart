import 'package:get/get.dart';
import 'package:davyking/core/states/mode.dart';

class ModeSwitchController extends GetxController {
  late final LightningModeController lightningModeController;
  late final RxBool isOn;

  @override
  void onInit() {
    super.onInit();
    // Ensure LightningModeController is loaded first
    lightningModeController = Get.find<LightningModeController>();

    // Wait for storage loading before setting isOn
    ever(lightningModeController.currentMode, (_) {
      isOn.value = lightningModeController.currentMode.value.mode == "dark";
    });

    isOn = (lightningModeController.currentMode.value.mode == "dark")
        ? true.obs
        : false.obs;
  }

  void toggleSwitch() {
    isOn.value = !isOn.value;
    lightningModeController.updateMode(isOn.value ? 'dark' : 'light');
  }
}
