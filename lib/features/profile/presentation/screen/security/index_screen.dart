import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/profile/controllers/edit_profile_controller.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:davyking/features/profile/presentation/widget/templates_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityIndexScreen extends StatelessWidget {
  const SecurityIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());

    return ProfileTemplatesWidget(
        data: ProfileTemplatesModel(
            title: 'Security',
            showProfileDetails: false,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  securityList(
                      name: "Change Pin",
                      route: RoutesConstant.profileSecurityChangePin),
                  const SizedBox(height: 40),
                  // securityList(name: "FAQ", route: ''),
                  // const SizedBox(height: 40),
                  securityList(
                      name: "Terms And Conditions",
                      route: RoutesConstant.profileSecurityTermsAndCondition),
                  const SizedBox(height: 40),
                  securityList(name: "Privacy Policy", route: ''),
                  // const SizedBox(height: 40),
                  // securityList(name: "Support Center", route: '')
                ],
              ),
            )));
  }
}

Widget securityList({required String name, required String route}) {
  return GestureDetector(
    onTap: () {
      Get.toNamed(route);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
            style: Theme.of(Get.context!)
                .textTheme
                .displayMedium
                ?.copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
        const Icon(Icons.arrow_forward_ios, size: 15)
      ],
    ),
  );
}
