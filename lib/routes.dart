// app_routes.dart
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/auth/presentation/screens/login_screen.dart';
import 'package:davyking/features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:davyking/features/auth/presentation/screens/reset_password/forgot_password.dart';
import 'package:davyking/features/auth/presentation/screens/reset_password/set_a_new_password.dart';
import 'package:davyking/features/auth/presentation/screens/signup_screen.dart';
import 'package:davyking/features/onboarding/presentation/screens/onboard_screen.dart';
import 'package:davyking/features/splash/presentation/screens/splash1_screen.dart';
import 'package:davyking/features/splash/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage<dynamic>> routes = [
    //splash
    GetPage(name: RoutesConstant.splash, page: () => Splash()),
    GetPage(
        name: RoutesConstant.splash1,
        page: () => Splash1(),
        transition: Transition.zoom),
    //onboarding
    GetPage(name: RoutesConstant.onboarding, page: () => OnboardingScreen()),
    //authentication
    GetPage(name: RoutesConstant.signin, page: () => LoginScreen()),
    GetPage(name: RoutesConstant.signup, page: () => SignupScreen()),
    GetPage(name: RoutesConstant.otpverify, page: () => OtpVerifyScreen()),
    GetPage(
        name: RoutesConstant.forgotpassword,
        page: () => ForgotPasswordScreen()),
    GetPage(
        name: RoutesConstant.setnewpassword,
        page: () => SetANewPasswordScreen())
  ];
}
