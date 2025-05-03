import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Create an instance of FlutterSecureStorage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Save data securely
  Future<void> saveData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  // Retrieve data securely
  Future<String?> getData(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Delete specific data
  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Clear all stored data
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
