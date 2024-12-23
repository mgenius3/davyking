import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/dark_theme.dart';
import 'package:davyking/core/theme/light_theme.dart';
import 'package:davyking/features/common/controllers/mode_controller.dart';
import 'package:davyking/features/common/presentation/states/mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'routes.dart';

// import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Dependency Injection
  Get.put(LightningModeService()); // Service
  Get.put(LightningModeController(service: Get.find())); // Controller
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final LightningModeController controller =
      Get.find<LightningModeController>();
  Brightness? _currentBrightness;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Register as an observer to listen for system changes.
    WidgetsBinding.instance.addObserver(this);
    // Initial system brightness check
    _currentBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  void startBrightnessCheck() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      didChangePlatformBrightness();
    });
  }

  @override
  void didChangePlatformBrightness() {
    // Check for system theme change
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    controller.updateMode(brightness == Brightness.dark ? 'dark' : 'light');
    setState(() {
      _currentBrightness = brightness;
    });
  }

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
        initialRoute: RoutesConstant.splash,
        theme: controller.currentMode.value.mode == 'dark'
            ? darkTheme()
            : lightTheme(),
        getPages: AppRoutes.routes));
  }
}
