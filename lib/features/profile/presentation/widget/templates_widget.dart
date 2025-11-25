
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/dimensions.dart';
import 'package:davyking/core/models/top_header_model.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/widgets/bottom_navigation_widget.dart';
import 'package:davyking/core/widgets/top_header_widget.dart';
import 'package:davyking/features/profile/data/model/templates_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTemplatesWidget extends StatelessWidget {
  final ProfileTemplatesModel data;
  const ProfileTemplatesWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final LightningModeController lightningModeController =
        Get.find<LightningModeController>();
    final UserAuthDetailsController authDetailsController =
        Get.find<UserAuthDetailsController>();

    final bool isLight =
        lightningModeController.currentMode.value.mode == "light";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isLight
                  ? [const Color(0xFFF5F7FA), const Color(0xFFE8EDF2)]
                  : [const Color(0xFF1A1A2E), const Color(0xFF0F0F1E)],
            ),
          ),
          child: Column(
            children: [
              // Header Section with Glass Morphism Effect
              Container(
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isLight
                      ? Colors.white.withOpacity(0.7)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLight
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TopHeaderWidget(data: TopHeaderModel(title: data.title)),
              ),

              // Profile Card Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Profile Avatar with Status Ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer Ring
                          Container(
                            width: 110,
                            height: 110,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              ),
                            ),
                          ),
                          // Avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isLight
                                    ? Colors.white
                                    : const Color(0xFF1A1A2E),
                                width: 4,
                              ),
                              image: const DecorationImage(
                                image: AssetImage("assets/images/pfp.jpg"),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                          // Verified Badge
                          if (data.showProfileDetails == true)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isLight
                                        ? Colors.white
                                        : const Color(0xFF1A1A2E),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // User Name with Premium Badge
                      if (data.showProfileDetails == true)
                        Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  authDetailsController.user.value?.name ?? "",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isLight
                                        ? const Color(0xFF1F2937)
                                        : Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              
                              ],
                            )),

                      const SizedBox(height: 8),

                      // User ID Card
                      if (data.showProfileDetails == true)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isLight
                                ? const Color(0xFFF3F4F6)
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Obx(() => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.badge_outlined,
                                    size: 16,
                                    color: isLight
                                        ? const Color(0xFF6B7280)
                                        : Colors.white70,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ID: ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isLight
                                          ? const Color(0xFF6B7280)
                                          : Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    authDetailsController.user.value?.id
                                            .toString() ??
                                        "",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isLight
                                          ? const Color(0xFF374151)
                                          : Colors.white,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.content_copy,
                                    size: 14,
                                    color: isLight
                                        ? const Color(0xFF9CA3AF)
                                        : Colors.white54,
                                  ),
                                ],
                              )),
                        ),

                      const SizedBox(height: 24),

                     

                      Container(
                        width: Get.width,
                        // constraints: BoxConstraints(
                        //   // minHeight: Get.height - 400,
                        // ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.defaultLeftSpacing,
                          vertical: 24,
                        ),
                    
                        child: data.child,
                      ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
