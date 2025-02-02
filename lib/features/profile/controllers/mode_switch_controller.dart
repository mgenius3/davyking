import 'package:davyking/core/states/mode.dart';
import 'package:get/get.dart';

class ModeSwitchController extends GetxController {
  late final LightningModeController lightningModeController;
  late final RxBool isOn;

  @override
  void onInit() {
    super.onInit();
    lightningModeController = Get.find<LightningModeController>();
    isOn = (lightningModeController.currentMode.value.mode == "light")
        ? false.obs
        : true.obs;
  }

  void toggleSwitch() {
    isOn.value = !isOn.value;
    lightningModeController.updateMode(isOn.value ? 'dark' : 'light');
  }
}
