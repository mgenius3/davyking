// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import '../controllers/transaction_auth_controller.dart';

// // Dialog for setting PIN and biometric preference
// class PinSetupDialog extends StatefulWidget {
//   final Function(String pin, bool useBiometrics) onPinSet;
//   final bool showBiometricsOption; // Added parameter to toggle biometrics

//   const PinSetupDialog({
//     super.key,
//     required this.onPinSet,
//     this.showBiometricsOption = true, // Default to true for compatibility
//   });

//   @override
//   PinSetupDialogState createState() => PinSetupDialogState();
// }

// class PinSetupDialogState extends State<PinSetupDialog> {
//   String _pin = '';
//   bool _useBiometrics = false;
//   bool _canCheckBiometrics = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.showBiometricsOption) {
//       _checkBiometricSupport();
//     }
//   }

//   Future<void> _checkBiometricSupport() async {
//     final localAuth = LocalAuthentication();
//     bool canCheck = await localAuth.canCheckBiometrics &&
//         await localAuth.isDeviceSupported();
//     if (canCheck) {
//       List<BiometricType> availableBiometrics =
//           await localAuth.getAvailableBiometrics();
//       canCheck = availableBiometrics.isNotEmpty;
//       print(
//           'checkBiometricSupport: Available biometrics = $availableBiometrics');
//     }
//     setState(() {
//       _canCheckBiometrics = canCheck;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               widget.showBiometricsOption
//                   ? 'Set Up Transaction Security'
//                   : 'Set New PIN', // Dynamic title
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Enter a 4-digit PIN for transactions',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             PinCodeTextField(
//               appContext: context,
//               length: 4,
//               obscureText: true,
//               animationType: AnimationType.fade,
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(8),
//                 fieldHeight: 48,
//                 fieldWidth: 48,
//                 activeColor: const Color(0xFF00C853),
//                 inactiveColor: Colors.grey[300],
//                 selectedColor: const Color(0xFF00C853),
//                 activeFillColor: Colors.white,
//                 inactiveFillColor: Colors.white,
//                 selectedFillColor: Colors.white,
//                 borderWidth: 1.5,
//               ),
//               keyboardType: TextInputType.number,
//               textStyle:
//                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               onChanged: (value) {
//                 _pin = value;
//               },
//               enableActiveFill: true,
//             ),
//             if (widget.showBiometricsOption && _canCheckBiometrics) ...[
//               const SizedBox(height: 16),
//               CheckboxListTile(
//                 value: _useBiometrics,
//                 onChanged: (value) {
//                   setState(() {
//                     _useBiometrics = value ?? false;
//                     print('Use Biometrics toggled: $_useBiometrics');
//                   });
//                 },
//                 title: const Row(
//                   children: [
//                     Icon(
//                       Icons.fingerprint,
//                       color: Color(0xFF00C853),
//                       size: 20,
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'Enable Biometric Authentication',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//                 activeColor: const Color(0xFF00C853),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 0),
//               ),
//             ],
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 if (_pin.length == 4) {
//                   widget.onPinSet(_pin, _useBiometrics);
//                   Navigator.pop(context, true);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please enter a 4-digit PIN'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00C853),
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 48),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 2,
//               ),
//               child: const Text(
//                 'Save',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Dialog for PIN authentication (unchanged)
// class PinAuthDialog extends StatefulWidget {
//   final String transactionDescription;
//   final Future<bool> Function(String pin) onPinEntered;

//   const PinAuthDialog({
//     super.key,
//     required this.transactionDescription,
//     required this.onPinEntered,
//   });

//   @override
//   PinAuthDialogState createState() => PinAuthDialogState();
// }

// class PinAuthDialogState extends State<PinAuthDialog> {
//   String _pin = '';

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<TransactionAuthController>();

//     return Obx(() => Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Authenticate Transaction',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Enter PIN to confirm ${widget.transactionDescription}',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 24),
//                 PinCodeTextField(
//                   appContext: context,
//                   length: 4,
//                   obscureText: true,
//                   animationType: AnimationType.fade,
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.box,
//                     borderRadius: BorderRadius.circular(8),
//                     fieldHeight: 48,
//                     fieldWidth: 48,
//                     activeColor: const Color(0xFF00C853),
//                     inactiveColor: Colors.grey[300],
//                     selectedColor: const Color(0xFF00C853),
//                     activeFillColor: Colors.white,
//                     inactiveFillColor: Colors.white,
//                     selectedFillColor: Colors.white,
//                     errorBorderColor: Colors.red,
//                     borderWidth: 1.5,
//                   ),
//                   keyboardType: TextInputType.number,
//                   textStyle: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                   onChanged: (value) {
//                     _pin = value;
//                     controller.isPinError.value = false;
//                   },
//                   onCompleted: (value) async {
//                     bool isValid = await widget.onPinEntered(value);
//                     if (isValid) {
//                       Navigator.pop(context, true);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Incorrect PIN'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   },
//                   enableActiveFill: true,
//                 ),
//                 if (controller.isPinError.value)
//                   const Padding(
//                     padding: EdgeInsets.only(top: 8),
//                     child: Text(
//                       'Incorrect PIN',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: const Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (_pin.length == 4) {
//                           bool isValid = await widget.onPinEntered(_pin);
//                           if (isValid) {
//                             Navigator.pop(context, true);
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Incorrect PIN'),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF00C853),
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size(120, 48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 2,
//                       ),
//                       child: const Text(
//                         'Confirm',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:davyking/core/theme/colors.dart';
import '../controllers/transaction_auth_controller.dart';

// Bottom Modal for setting PIN and biometric preference
class PinSetupModal extends StatefulWidget {
  final Function(String pin, bool useBiometrics) onPinSet;
  final bool showBiometricsOption;

  const PinSetupModal({
    super.key,
    required this.onPinSet,
    this.showBiometricsOption = true,
  });

  @override
  PinSetupModalState createState() => PinSetupModalState();
}

class PinSetupModalState extends State<PinSetupModal> {
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

  void _onNumberPressed(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
      });
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            widget.showBiometricsOption
                                ? 'Set Up Transaction Security'
                                : 'Set New PIN',
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
                          const SizedBox(height: 32),
                          // PIN Display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4,
                              (index) => Container(
                                width: 56,
                                height: 56,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _pin.length > index
                                        ? LightThemeColors.primaryColor
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: _pin.length > index
                                      ? const Icon(
                                          Icons.circle,
                                          size: 16,
                                          color: Color(0xFFFFD700),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          if (widget.showBiometricsOption &&
                              _canCheckBiometrics) ...[
                            const SizedBox(height: 24),
                            CheckboxListTile(
                              value: _useBiometrics,
                              onChanged: (value) {
                                setState(() {
                                  _useBiometrics = value ?? false;
                                  print(
                                      'Use Biometrics toggled: $_useBiometrics');
                                });
                              },
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.fingerprint,
                                    color: LightThemeColors.primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Enable Biometric Authentication',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              activeColor: LightThemeColors.primaryColor,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                            ),
                          ],
                          const SizedBox(height: 24),
                          // Custom Number Keyboard
                          _NumberKeyboard(
                              onNumberPressed: _onNumberPressed,
                              onBackspacePressed: _onBackspacePressed),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (_pin.length == 4) {
                                widget.onPinSet(_pin, _useBiometrics);
                                Navigator.pop(context, true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please enter a 4-digit PIN'),
                                      backgroundColor: Colors.red),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LightThemeColors.primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Bottom Modal for PIN authentication
class PinAuthModal extends StatefulWidget {
  final String transactionDescription;
  final Future<bool> Function(String pin) onPinEntered;

  const PinAuthModal({
    super.key,
    required this.transactionDescription,
    required this.onPinEntered,
  });

  @override
  PinAuthModalState createState() => PinAuthModalState();
}

class PinAuthModalState extends State<PinAuthModal> {
  String _pin = '';
  bool _isError = false;

  void _onNumberPressed(String number) {
    if (_pin.length < 4) {
      setState(() {
        _pin += number;
        _isError = false;
      });

      if (_pin.length == 4) {
        _validatePin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _validatePin() async {
    bool isValid = await widget.onPinEntered(_pin);
    if (isValid) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      setState(() {
        _isError = true;
        _pin = '';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect PIN'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
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
                          const SizedBox(height: 32),
                          // PIN Display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              4,
                              (index) => Container(
                                width: 56,
                                height: 56,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _isError
                                        ? Colors.red
                                        : (_pin.length > index
                                            ? LightThemeColors.primaryColor
                                            : Colors.grey[300]!),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: _pin.length > index
                                      ? Icon(
                                          Icons.circle,
                                          size: 16,
                                          color: _isError
                                              ? Colors.red
                                              : LightThemeColors.primaryColor,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          if (_isError)
                            const Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text(
                                'Incorrect PIN',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          // Custom Number Keyboard
                          _NumberKeyboard(
                            onNumberPressed: _onNumberPressed,
                            onBackspacePressed: _onBackspacePressed,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    side: BorderSide(color: Colors.grey[300]!),
                                    minimumSize: const Size(0, 52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      _pin.length == 4 ? _validatePin : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        LightThemeColors.primaryColor,
                                    foregroundColor: Colors.black87,
                                    disabledBackgroundColor: Colors.grey[300],
                                    minimumSize: const Size(0, 52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Number Keyboard Widget
class _NumberKeyboard extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;

  const _NumberKeyboard({
    required this.onNumberPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 12),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 12),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 12),
        _buildRow(['', '0', 'backspace']),
      ],
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number.isEmpty) {
          return const Expanded(child: SizedBox());
        }

        if (number == 'backspace') {
          return Expanded(
            child: _KeyButton(
              onPressed: onBackspacePressed,
              child: const Icon(
                Icons.backspace_outlined,
                color: Colors.black87,
                size: 24,
              ),
            ),
          );
        }

        return Expanded(
          child: _KeyButton(
            onPressed: () => onNumberPressed(number),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Key Button Widget
class _KeyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _KeyButton({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
