import 'package:get/get.dart';
import '../models/mode_model.dart';
import '../controllers/mode_controller.dart';

class LightningModeController extends GetxController {
  final LightningModeService _service = LightningModeService();
  var currentMode = Rx<LightningMode>(LightningMode(mode: 'light')); // Default

  @override
  void onInit() {
    super.onInit();
    _loadModeFromStorage();
  }

  // Update the mode and persist it
  Future<void> updateMode(String mode) async {
    currentMode.value = LightningMode(mode: mode);
    await _service.saveMode(mode);
    update();
  }

  // Load mode from storage before setting UI state
  Future<void> _loadModeFromStorage() async {
    String? savedMode = await _service.getSavedMode();
    print("Saved mode from storage: $savedMode");
    if (savedMode != null) {
      currentMode.value = LightningMode(mode: savedMode); // Set the value
      update();
    }
  }
}
