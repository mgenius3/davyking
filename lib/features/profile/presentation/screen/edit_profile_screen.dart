import 'package:davyking/core/controllers/primary_button_controller.dart';
import 'package:davyking/core/models/primary_button_model.dart';
import 'package:davyking/core/widgets/primary_button_widget.dart';
import 'package:davyking/features/profile/controllers/edit_profile_controller.dart';
import 'package:davyking/features/profile/data/model/input_field_model.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/input_field_model.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
            title: "Edit Profile",
            child: Container(
              margin: const EdgeInsets.only(top: 170),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.userNameController,
                      name: 'Username')),
                  const SizedBox(height: 20),
                  profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.userNameController,
                      name: 'Phone')),
                  const SizedBox(height: 20),
                  profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.userNameController,
                      name: 'Email Address')),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 50,
                    child: CustomPrimaryButton(
                        controller: CustomPrimaryButtonController(
                            model: const CustomPrimaryButtonModel(text: 'Save'),
                            onPressed: () {})),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )));
  }
}
