// import 'package:davyking/core/constants/routes.dart';
// import 'package:davyking/core/controllers/user_auth_details_controller.dart';
// import 'package:davyking/core/theme/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:davyking/core/states/mode.dart';

// class HomeHeaderWidget extends StatelessWidget {
//   HomeHeaderWidget({super.key});

//   final LightningModeController lightningModeController =
//       Get.find<LightningModeController>();
//   final UserAuthDetailsController authController =
//       Get.find<UserAuthDetailsController>();

//   String getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) {
//       return "Good Morning";
//     } else if (hour < 17) {
//       return "Good Afternoon";
//     } else if (hour < 20) {
//       return "Good Evening";
//     } else {
//       return "Good Night";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Get.toNamed(RoutesConstant.profile);
//               },
//               child: Container(
//                 width: 32.22,
//                 height: 33.37,
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: DarkThemeColors.primaryColor),
//                 child: const Icon(Icons.person_2),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Obx(() => Text(
//                       'Hi, ${authController.user.value?.name ?? "User"}',
//                       style: Theme.of(context)
//                           .textTheme
//                           .displayMedium
//                           ?.copyWith(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               height: 1.17),
//                     )),
//                 const SizedBox(height: 5),
//                 Text(getGreeting(),
//                     style: Theme.of(context)
//                         .textTheme
//                         .displayMedium
//                         ?.copyWith(fontSize: 12, fontWeight: FontWeight.w400))
//               ],
//             )
//           ],
//         ),
//         Obx(
//           () => Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Get.toNamed(RoutesConstant.profileSecurity);
//                 },
//                 child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: ShapeDecoration(
//                       color: lightningModeController.currentMode.value.mode ==
//                               "light"
//                           ? const Color(0xFFDFF7E2)
//                           : DarkThemeColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Icon(Icons.settings)),
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:davyking/core/states/mode.dart';

class HomeHeaderWidget extends StatelessWidget {
  HomeHeaderWidget({super.key});

  final LightningModeController lightningModeController =
      Get.find<LightningModeController>();
  final UserAuthDetailsController authController =
      Get.find<UserAuthDetailsController>();

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    if (hour < 20) return "Good Evening";
    return "Good Night";
  }

  IconData getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny_rounded;
    if (hour < 17) return Icons.wb_sunny;
    if (hour < 20) return Icons.wb_twilight;
    return Icons.nights_stay;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLight = lightningModeController.currentMode.value.mode == "light";
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? [Colors.white, const Color(0xFFF9FAFB)]
                : [const Color(0xFF1F2937), const Color(0xFF111827)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Profile and greeting
            Expanded(
              child: Row(
                children: [
                  // Profile Avatar
                  GestureDetector(
                    onTap: () => Get.toNamed(RoutesConstant.profile),
                    child: Hero(
                      tag: 'profile_avatar',
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: DarkThemeColors.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Greeting Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Hi, ${authController.user.value?.name ?? "User"}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isLight
                                      ? const Color(0xFF111827)
                                      : Colors.white,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '👋',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Row(
                          children: [
                            Icon(
                              getGreetingIcon(),
                              size: 14,
                              color: isLight
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF9CA3AF),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              getGreeting(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isLight
                                    ? const Color(0xFF6B7280)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Right side - Actions
            Row(
              children: [
                // Notifications button (optional - you can remove if not needed)
                // Container(
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: isLight
                //         ? const Color(0xFFF3F4F6)
                //         : Colors.white.withOpacity(0.1),
                //     shape: BoxShape.circle,
                //   ),
                //   child: Icon(
                //     Icons.notifications_outlined,
                //     size: 20,
                //     color: isLight
                //         ? const Color(0xFF374151)
                //         : Colors.white70,
                //   ),
                // ),
                
                const SizedBox(width: 10),
                
                // Settings button
                GestureDetector(
                  onTap: () => Get.toNamed(RoutesConstant.profileSecurity),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLight
                            ? [const Color(0xFFDFF7E2), const Color(0xFFCBF3D0)]
                            : [
                                DarkThemeColors.primaryColor,
                                DarkThemeColors.primaryColor.withOpacity(0.8)
                              ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isLight 
                              ? const Color(0xFF10B981)
                              : DarkThemeColors.primaryColor
                          ).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      size: 20,
                      color: isLight
                          ? const Color(0xFF059669)
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}