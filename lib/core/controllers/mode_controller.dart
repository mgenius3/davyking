// lightning_mode_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LightningModeService {
  static const String _storageKey = 'lightning_mode';
  final FlutterSecureStorage _storage;

  LightningModeService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveMode(String mode) async {
    await _storage.write(key: _storageKey, value: mode);
  }

  Future<String?> getSavedMode() async {
    return await _storage.read(key: _storageKey);
  }
}
