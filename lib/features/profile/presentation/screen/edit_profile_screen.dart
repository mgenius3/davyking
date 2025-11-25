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
              // margin: const EdgeInsets.only(top: 170),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.nameController,
                      name: 'Name')),
                  const SizedBox(height: 20),
                  profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.phoneController,
                      name: 'Phone')),
                  const SizedBox(height: 20),
                  profileInputField(ProfileInputFieldModel(
                      inputcontroller: controller.emailController,
                      name: 'Email Address')),
                  const SizedBox(height: 40),
                  Obx(() => controller.isLoading.value
                      ? CustomPrimaryButton(
                          controller: CustomPrimaryButtonController(
                              model: const CustomPrimaryButtonModel(
                                  child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))),
                              onPressed: () {}),
                        )
                      : CustomPrimaryButton(
                          controller: CustomPrimaryButtonController(
                              model: const CustomPrimaryButtonModel(
                                text: 'Edit Profile',
                                textColor: Colors.white,
                              ),
                              onPressed: () {
                                controller.editProfile();
                              }))),
                  const SizedBox(height: 20),
                ],
              ),
            )));
  }
}
