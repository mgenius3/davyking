import 'dart:convert';

import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/controllers/admin_bank_details_controller.dart';
import 'package:davyking/core/controllers/currency_rate_controller.dart';
import 'package:davyking/core/controllers/user_auth_details_controller.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:davyking/core/theme/dark_theme.dart';
import 'package:davyking/core/theme/light_theme.dart';
import 'package:davyking/core/controllers/mode_controller.dart';
import 'package:davyking/core/states/mode.dart';
import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Dependency Injection
  // Get.put(LightningModeService()); // Service
  Get.put(LightningModeController()); // Controller
  Get.put(UserAuthDetailsController());
  Get.put(AdminBankDetailsController());
  Get.put(CurrencyRateController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LightningModeController controller = Get.put(LightningModeController());
  final UserAuthDetailsController authController =
      Get.put(UserAuthDetailsController());

  Brightness? _currentBrightness;
  Timer? _timer;

  void _getUserAuthDetails() async {
    final storageService = SecureStorageService();
    var user_details = await storageService.getData('user_details');
    authController
        .saveUser(UserAuthResponse.fromJson(jsonDecode(user_details!)));
  }

  @override
  void initState() {
    super.initState();
    // Register as an observer to listen for system changes.
    WidgetsBinding.instance.addObserver(this);
    // Initial system brightness check
    _currentBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    _getUserAuthDetails();
  }

  // void startBrightnessCheck() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     didChangePlatformBrightness();
  //   });
  // }

  // @override
  // void didChangePlatformBrightness() {
  //   // Check for system theme change
  //   final brightness =
  //       WidgetsBinding.instance.platformDispatcher.platformBrightness;
  //   controller.updateMode(brightness == Brightness.dark ? 'dark' : 'light');
  //   setState(() {
  //     _currentBrightness = brightness;
  //   });
  // }

  @override
  void dispose() {
    // Remove observer when the widget is disposed of
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
        title: 'DavyKing',
        debugShowCheckedModeBanner: false,
        // initialRoute: RoutesConstant.splash,
        initialRoute: RoutesConstant.home,
        theme: controller.currentMode.value.mode == 'dark'
            ? darkTheme()
            : lightTheme(),
        getPages: AppRoutes.routes));
  }
}
