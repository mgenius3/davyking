// app_routes.dart
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/airtime/presentation/screens/airtime_details_screen.dart';
import 'package:davyking/features/airtime/presentation/screens/index_screen.dart';
import 'package:davyking/features/auth/presentation/screens/login_screen.dart';
import 'package:davyking/features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:davyking/features/auth/presentation/screens/reset_password/forgot_password.dart';
import 'package:davyking/features/auth/presentation/screens/reset_password/set_a_new_password.dart';
import 'package:davyking/features/auth/presentation/screens/signup_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/buy_giftcards/field_details_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/buy_giftcards/field_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/buy_giftcards/index_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/sell_giftcards/field_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/sell_giftcards/index_screen.dart';
import 'package:davyking/features/home/presentation/screens/home_screen.dart';
import 'package:davyking/features/notifications/presentation/screens/index.dart';
import 'package:davyking/features/onboarding/presentation/screens/onboard_screen.dart';
import 'package:davyking/features/profile/presentation/screen/edit_profile_screen.dart';
import 'package:davyking/features/profile/presentation/screen/help_faq/index_screen.dart';
import 'package:davyking/features/profile/presentation/screen/index_screen.dart';
import 'package:davyking/features/profile/presentation/screen/security/change_pin_screen.dart';
import 'package:davyking/features/profile/presentation/screen/security/index_screen.dart';
import 'package:davyking/features/profile/presentation/screen/security/terms_conditions.dart';
import 'package:davyking/features/profile/presentation/screen/withdrawal_bank/index_screen.dart';
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
    GetPage(
        name: RoutesConstant.onboarding,
        page: () => OnboardingScreen(),
        transition: Transition.zoom),

    //authentication
    GetPage(name: RoutesConstant.signin, page: () => LoginScreen()),
    GetPage(name: RoutesConstant.signup, page: () => SignupScreen()),
    GetPage(name: RoutesConstant.otpverify, page: () => OtpVerifyScreen()),
    GetPage(
        name: RoutesConstant.forgotpassword,
        page: () => ForgotPasswordScreen()),
    GetPage(
        name: RoutesConstant.setnewpassword,
        page: () => SetANewPasswordScreen()),
    //home
    GetPage(
        name: RoutesConstant.home,
        page: () => HomeScreen(),
        transition: Transition.zoom),
    GetPage(
        name: RoutesConstant.notification,
        page: () => NotificationScreen(),
        transition: Transition.zoom),
    GetPage(
        name: RoutesConstant.airtime,
        page: () => AirtimeScreen(),
        transition: Transition.zoom),
    GetPage(
        name: RoutesConstant.airtime_details,
        page: () => AirtimeDetailsScreen()),

    //crypto
    // GetPage(name: RoutesConstant., page: () =>)

    //GiftCards
    GetPage(name: RoutesConstant.buy_giftcard, page: () => BuyGiftCardScreen()),
    GetPage(
        name: RoutesConstant.buy_giftcard_field,
        page: () => BuyGiftCardInputField()),
    GetPage(
        name: RoutesConstant.buy_giftcard_field_details,
        page: () => BuyGiftCardDetailsScreen()),
    GetPage(
        name: RoutesConstant.sell_giftcard, page: () => SellGiftCardScreen()),
    GetPage(
        name: RoutesConstant.sell_giftcard_field,
        page: () => SellGiftCardInputField()),

    //profile
    GetPage(name: RoutesConstant.profile, page: () => ProfileIndexScreen()),
    GetPage(
        name: RoutesConstant.editprofile,
        page: () => EditProfileScreen(),
        transition: Transition.rightToLeft),

    //profile - security
    GetPage(
        name: RoutesConstant.profileSecurity,
        page: () => SecurityIndexScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConstant.profileSecurityChangePin,
        page: () => ChangePinScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RoutesConstant.profileSecurityTermsAndCondition,
        page: () => TermsConditionsScreen(),
        transition: Transition.rightToLeft),

    //profile - help and faq
    GetPage(
        name: RoutesConstant.helpAndFaq,
        page: () => HelpFaqScreen(),
        transition: Transition.rightToLeft),

    //profile - withdral bank
    GetPage(
        name: RoutesConstant.withdrawalBank,
        page: () => WithdrawalBankScreen(),
        transition: Transition.rightToLeft)
  ];
}
