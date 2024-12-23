import 'package:davyking/core/constants/images.dart';
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  _Splash1State createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    _controller.addListener(() {
      setState(() {
        _opacity = _animation.value;
      });
    });

    startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  startTimer() {
    Timer(const Duration(seconds: 3), () {
      Get.toNamed(RoutesConstant.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = Container(
      decoration: BoxDecoration(color: LightThemeColors.primaryColor),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          backgroundGradient,
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                ImagesConstant.logoBackground,
                width: 200,
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
