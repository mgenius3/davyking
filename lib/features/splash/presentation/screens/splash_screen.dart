import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      Get.toNamed(RoutesConstant.splash1);
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = Container(
      decoration: BoxDecoration(color: LightThemeColors.primaryColor),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent unnecessary resizing
      body: Stack(
        children: [
          backgroundGradient, // Use the container as the background
        ],
      ),
    );
  }
}
