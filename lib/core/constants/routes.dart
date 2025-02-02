class RoutesConstant {
  static const String splash = '/splash';
  static const String splash1 = '/splash1';
  static const String onboarding = '/onboarding';

  //auth
  static const String signin = '/auth_signin';
  static const String signup = '/auth_signup';
  static const String otpverify = '/auth_verify_otp';
  static const String forgotpassword = '/auth_resetpassword_forgot';
  static const String setnewpassword = '/auth_resetpassword_setnew';

  //home
  static const String home = '/';
  static const String notification = '/notifications';
  static const String airtime = '/airtime';
  static const String airtime_details = '/airtime/details';

  //profile
  static const String profile = '/profile';
  static const String editprofile = '/profile/edit';
  static const String helpAndFaq = '/profile/helpandfaq';
  static const String withdrawalBank = '/profile/withdrawalbank';

  //profile - security
  static const String profileSecurity = '/profile/secuity';
  static const String profileSecurityChangePin = '/profile/security/changepin';
  static const String profileSecurityTermsAndCondition =
      '/profile/security/termsandcondition';

  //giftcard
  static const String giftcard = '/giftcard';
  static const String buy_giftcard = '/giftcard/buy';
  static const String buy_giftcard_field = '/giftcard/buy/inputfield';
  static const String buy_giftcard_field_details =
      '/giftcard/buy/inputfield_details';

  static const String sell_giftcard = '/giftcard/sell';
  static const String sell_giftcard_field = '/giftcard/sell/inputfield';
  static const String sell_giftcard_field_details =
      '/giftcard/sell/inputfield_details';
}
