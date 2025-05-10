import 'package:davyking/core/widgets/auth_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransactionAuthController extends GetxController {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _pinKey = 'transaction_pin';
  static const String _useBiometricsKey = 'use_biometrics';

  // Reactive state for dialogs (optional, used for error handling)
  final RxBool isPinError = false.obs;

  // Check if PIN is already set
  Future<bool> isPinSet() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  // Reset PIN and biometric preference
  Future<void> resetPin(BuildContext context) async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _useBiometricsKey);
    await setupAuth(context);
  }

  // Check if device supports biometrics and user has enabled them
  Future<bool> canUseBiometrics() async {
    final useBiometricsStr = await _storage.read(key: _useBiometricsKey);
    bool useBiometrics = useBiometricsStr == 'true';
    print('canUseBiometrics: useBiometrics preference = $useBiometrics');

    if (!useBiometrics) {
      print('canUseBiometrics: Biometrics disabled by user');
      return false;
    }

    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    bool deviceSupportsBiometrics = await _localAuth.isDeviceSupported();
    bool biometricsAvailable = canCheckBiometrics && deviceSupportsBiometrics;

    return biometricsAvailable;
  }

  // Set PIN and biometric preference
  Future<void> setupAuth(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinSetupDialog(
        onPinSet: (pin, useBiometrics) async {
          await _storage.write(key: _pinKey, value: pin);
          await _storage.write(
              key: _useBiometricsKey, value: useBiometrics.toString());
        },
      ),
    );
  }

// Authenticate transaction (returns true if successful)
  Future<bool> authenticate(
      BuildContext context, String transactionDescription) async {
    if (!await isPinSet()) {
      await setupAuth(context);
      // return false; // Require setup before proceeding
    }

    if (await canUseBiometrics()) {
      try {
        bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Authenticate to confirm $transactionDescription',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true),
        );
        if (didAuthenticate) return true;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Biometric authentication failed. Please use PIN.')),
        );
      }
    } else {
      print('authenticate: Biometrics not available, falling back to PIN');
    }

    // Show PIN dialog for authentication
    print('authenticate: Showing PIN dialog');
    // Show PIN dialog for authentication
    bool? authenticated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinAuthDialog(
        transactionDescription: transactionDescription,
        onPinEntered: (pin) async {
          final storedPin = await _storage.read(key: _pinKey);
          bool isValid = pin == storedPin;
          isPinError.value = !isValid; // Update reactive state
          return isValid;
        },
      ),
    );

    return authenticated ?? false;
  }

  // Change PIN only (preserves biometric preference)
// In TransactionAuthController
  Future<bool> changePin(BuildContext context) async {
    print('changePin: Starting PIN change process');
    if (!await isPinSet()) {
      print('changePin: No PIN set, prompting setup');
      await setupAuth(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please set up a PIN first'),
            backgroundColor: Colors.red),
      );
      return false;
    }

    bool isAuthenticated =
        await authenticate(context, 'PIN change verification');
    if (!isAuthenticated) {
      print('changePin: Old PIN authentication failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Incorrect old PIN'), backgroundColor: Colors.red),
      );
      return false;
    }

    bool? pinChanged = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PinSetupDialog(
        onPinSet: (pin, _) async {
          await _storage.write(key: _pinKey, value: pin);
          print('changePin: New PIN saved = $pin');
        },
        showBiometricsOption: false, // Hide biometric checkbox
      ),
    );

    if (pinChanged == true) {
      print('changePin: PIN changed successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('PIN changed successfully'),
            backgroundColor: Color(0xFF00C853)),
      );
      return true;
    } else {
      print('changePin: PIN change cancelled');
      return false;
    }
  }
}
