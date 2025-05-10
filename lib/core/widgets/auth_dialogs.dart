import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../controllers/transaction_auth_controller.dart';

// Dialog for setting PIN and biometric preference
class PinSetupDialog extends StatefulWidget {
  final Function(String pin, bool useBiometrics) onPinSet;
  final bool showBiometricsOption; // Added parameter to toggle biometrics

  const PinSetupDialog({
    super.key,
    required this.onPinSet,
    this.showBiometricsOption = true, // Default to true for compatibility
  });

  @override
  PinSetupDialogState createState() => PinSetupDialogState();
}

class PinSetupDialogState extends State<PinSetupDialog> {
  String _pin = '';
  bool _useBiometrics = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    if (widget.showBiometricsOption) {
      _checkBiometricSupport();
    }
  }

  Future<void> _checkBiometricSupport() async {
    final localAuth = LocalAuthentication();
    bool canCheck = await localAuth.canCheckBiometrics &&
        await localAuth.isDeviceSupported();
    if (canCheck) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      canCheck = availableBiometrics.isNotEmpty;
      print(
          'checkBiometricSupport: Available biometrics = $availableBiometrics');
    }
    setState(() {
      _canCheckBiometrics = canCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.showBiometricsOption
                  ? 'Set Up Transaction Security'
                  : 'Set New PIN', // Dynamic title
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter a 4-digit PIN for transactions',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 48,
                fieldWidth: 48,
                activeColor: const Color(0xFF00C853),
                inactiveColor: Colors.grey[300],
                selectedColor: const Color(0xFF00C853),
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                borderWidth: 1.5,
              ),
              keyboardType: TextInputType.number,
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              onChanged: (value) {
                _pin = value;
              },
              enableActiveFill: true,
            ),
            if (widget.showBiometricsOption && _canCheckBiometrics) ...[
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _useBiometrics,
                onChanged: (value) {
                  setState(() {
                    _useBiometrics = value ?? false;
                    print('Use Biometrics toggled: $_useBiometrics');
                  });
                },
                title: const Row(
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: Color(0xFF00C853),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Enable Biometric Authentication',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                activeColor: const Color(0xFF00C853),
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_pin.length == 4) {
                  widget.onPinSet(_pin, _useBiometrics);
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a 4-digit PIN'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog for PIN authentication (unchanged)
class PinAuthDialog extends StatefulWidget {
  final String transactionDescription;
  final Future<bool> Function(String pin) onPinEntered;

  const PinAuthDialog({
    super.key,
    required this.transactionDescription,
    required this.onPinEntered,
  });

  @override
  PinAuthDialogState createState() => PinAuthDialogState();
}

class PinAuthDialogState extends State<PinAuthDialog> {
  String _pin = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionAuthController>();

    return Obx(() => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Authenticate Transaction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter PIN to confirm ${widget.transactionDescription}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 48,
                    fieldWidth: 48,
                    activeColor: const Color(0xFF00C853),
                    inactiveColor: Colors.grey[300],
                    selectedColor: const Color(0xFF00C853),
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    errorBorderColor: Colors.red,
                    borderWidth: 1.5,
                  ),
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    _pin = value;
                    controller.isPinError.value = false;
                  },
                  onCompleted: (value) async {
                    bool isValid = await widget.onPinEntered(value);
                    if (isValid) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Incorrect PIN'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  enableActiveFill: true,
                ),
                if (controller.isPinError.value)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Incorrect PIN',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_pin.length == 4) {
                          bool isValid = await widget.onPinEntered(_pin);
                          if (isValid) {
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Incorrect PIN'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(120, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
