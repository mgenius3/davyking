// lightning_mode_controller.dart
import 'package:get/get.dart';
import '../../data/models/mode_model.dart';
import '../../controllers/mode_controller.dart';

class LightningModeController extends GetxController {
  final LightningModeService _service;

  // Observed state
  var currentMode = LightningMode(mode: 'light').obs; // Default to light mode

  LightningModeController({required LightningModeService service})
      : _service = service;

  @override
  void onInit() {
    super.onInit();
    _loadModeFromStorage();
  }

  // Update the mode and persist it using the service
  Future<void> updateMode(String mode) async {
    switch (mode) {
      case 'dark':
        currentMode.value = LightningMode(mode: 'dark');
        break;
      default:
        currentMode.value = LightningMode(mode: 'light');
    }
    // Save mode using the service
    await _service.saveMode(mode);
  }

  // Load mode from secure storage using the service
  Future<void> _loadModeFromStorage() async {
    String? savedMode = await _service.getSavedMode();
    if (savedMode != null) {
      await updateMode(savedMode);
    }
  }
}
