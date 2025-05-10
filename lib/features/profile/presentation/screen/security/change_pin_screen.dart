import 'package:davyking/features/profile/controllers/change_pin_controller.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';

class ChangePinScreen extends StatelessWidget {
  const ChangePinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangePinController controller = Get.put(ChangePinController());

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
            showProfileDetails: false,
            title: "Change Pin",
            child: Obx(() => SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Your Transaction PIN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your current PIN and set a new 4-digit PIN for secure transactions.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildPinField(
                        label: 'Old PIN',
                        onChanged: (value) {
                          controller.oldPin.value = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPinField(
                        label: 'New PIN',
                        onChanged: (value) {
                          controller.newPin.value = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPinField(
                        label: 'Confirm New PIN',
                        onChanged: (value) {
                          controller.confirmPin.value = value;
                        },
                      ),
                      if (controller.errorMessage.value.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                bool success =
                                    await controller.changePin(context);
                                if (success) {
                                  Navigator.pop(context);
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
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Change PIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => controller.resetPin(context),
                        child: const Text(
                          'Forgot PIN? Reset it',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF00C853),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  Widget _buildPinField({
    required String label,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        PinCodeTextField(
          appContext: Get.context!,
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
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          onChanged: (value) {
            onChanged(value);
            HapticFeedback.lightImpact();
          },
          enableActiveFill: true,
        ),
      ],
    );
  }
}
