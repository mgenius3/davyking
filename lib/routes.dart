// app_routes.dart
import 'package:davyking/core/constants/routes.dart';
import 'package:davyking/features/airtime/presentation/screens/airtime_details_screen.dart';
import 'package:davyking/features/airtime/presentation/screens/index_screen.dart';
import 'package:davyking/features/airtime/presentation/screens/receipt_screen.dart';
import 'package:davyking/features/auth/presentation/screens/signin_screen.dart';
import 'package:davyking/features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:davyking/features/auth/presentation/screens/reset_password/forgot_password.dart';
import 'package:davyking/features/auth/presentation/screens/reset_password/set_a_new_password.dart';
import 'package:davyking/features/auth/presentation/screens/signup_screen.dart';
import 'package:davyking/features/betting/presentation/screens/details_screen.dart';
import 'package:davyking/features/betting/presentation/screens/index_screen.dart';
import 'package:davyking/features/betting/presentation/screens/receipt_screen.dart';
import 'package:davyking/features/crypto/presentation/screens/buy_crypto/field_screen.dart';
import 'package:davyking/features/crypto/presentation/screens/buy_crypto/index_screen.dart';
import 'package:davyking/features/crypto/presentation/screens/crypto_transaction_details_screen.dart';
import 'package:davyking/features/crypto/presentation/screens/sell_crypto/field_screen.dart';
import 'package:davyking/features/crypto/presentation/screens/sell_crypto/index_screen.dart';
import 'package:davyking/features/data/presentation/screens/data_details_screen.dart';
import 'package:davyking/features/data/presentation/screens/index_screen.dart';
import 'package:davyking/features/data/presentation/screens/receipt_screen.dart';
import 'package:davyking/features/deposit/presentation/screen/index_screen.dart';
import 'package:davyking/features/electricity/presentation/screens/details_screen.dart';
import 'package:davyking/features/electricity/presentation/screens/index_screen.dart';
import 'package:davyking/features/electricity/presentation/screens/receipt_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/buy_giftcards/field_details_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/buy_giftcards/field_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/buy_giftcards/index_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/giftcard_transaction_details_screen.dart';
import 'package:davyking/features/giftcards/presentation/screens/sell_giftcards/field_details_screen.dart';
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
import 'package:davyking/features/recent_transaction/presentation/screens/index_screen.dart';
import 'package:davyking/features/splash/presentation/screens/splash1_screen.dart';
import 'package:davyking/features/splash/presentation/screens/splash_screen.dart';
import 'package:davyking/features/tv/presentation/screens/index_screen.dart';
import 'package:davyking/features/tv/presentation/screens/receipt_screen.dart';
import 'package:davyking/features/tv/presentation/screens/tv_details_screen.dart';
import 'package:davyking/features/wallet/presentation/screens/details_screen.dart';
import 'package:davyking/features/wallet/presentation/screens/withdraw.dart';
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
        name: RoutesConstant.recent_transaction,
        page: () => RecentTransactionScreen(),
        transition: Transition.zoom),
    GetPage(
        name: RoutesConstant.airtime,
        page: () => AirtimeScreen(),
        transition: Transition.zoom),
    GetPage(
        name: RoutesConstant.airtime_details,
        page: () => AirtimeDetailsScreen()),
    GetPage(
        name: RoutesConstant.airtime_receipt,
        page: () => AirtimeReceiptScreen()),
    GetPage(
        name: RoutesConstant.data,
        page: () => DataScreen(),
        transition: Transition.zoom),
    GetPage(name: RoutesConstant.data_details, page: () => DataDetailsScreen()),
    GetPage(name: RoutesConstant.data_receipt, page: () => DataReceiptScreen()),
    GetPage(
        name: RoutesConstant.electricity,
        page: () => ElectricityScreen(),
        transition: Transition.zoom),
    GetPage(
        name: RoutesConstant.electricity_details,
        page: () => ElectricityDetailsScreen()),
    GetPage(
        name: RoutesConstant.electricity_receipt,
        page: () => ElectricityReceiptScreen()),
    GetPage(
        name: RoutesConstant.betting,
        page: () => BettingScreen(),
        transition: Transition.zoom),
    GetPage(
        name: RoutesConstant.betting_details,
        page: () => BettingDetailsScreen()),
    GetPage(
        name: RoutesConstant.betting_receipt,
        page: () => BettingReceiptScreen()),

    GetPage(
        name: RoutesConstant.tv,
        page: () => TvScreen(),
        transition: Transition.zoom),
    GetPage(name: RoutesConstant.tv_details, page: () => TvDetailsScreen()),
    GetPage(name: RoutesConstant.tv_receipt, page: () => TvReceiptScreen()),

    //Crypto
    GetPage(name: RoutesConstant.buy_crypto, page: () => BuyCryptoScreen()),
    GetPage(
        name: RoutesConstant.buy_crypto_field,
        page: () => BuyCryptoInputField()),
    GetPage(name: RoutesConstant.sell_crypto, page: () => SellCryptoScreen()),
    GetPage(
        name: RoutesConstant.sell_crypto_field,
        page: () => SellCryptoInputField()),
    GetPage(
        name: RoutesConstant.cryptoTransactionDetails,
        page: () => CryptoTransactionDetailsScreen()),

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
    GetPage(
        name: RoutesConstant.sell_giftcard_field_details,
        page: () => SellGiftCardDetailsScreen()),
    GetPage(
        name: RoutesConstant.giftCardTransactionDetails,
        page: () => GiftCardTransactionDetailsScreen()),

    //wallet
    GetPage(name: RoutesConstant.withdraw, page: () => WithdrawScreen()),
    GetPage(
        name: RoutesConstant.wallet_transaction_details,
        page: () => WalletTransactionDetailsScreen()),

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
        transition: Transition.rightToLeft),

    //deposit
    GetPage(name: RoutesConstant.deposit, page: () => DepositScreen())
  ];
}
