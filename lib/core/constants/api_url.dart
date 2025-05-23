class ApiUrl {
  //Base Url

  // static const base_url = 'http://192.168.0.5:8000/api/v1';
  static const domain = 'http://192.168.14.74:8000/';
  // static const domain = 'https://davykingexchange.com.ng/';
  static const base_url = '${domain}api/v1';

  //Auth
  static const auth_signin = '/user/login';
  static const auth_signup = '/user/register';
  static const auth_reset_password = '/auth/reset/forgot_password';
  static const users = '/users';

  //get ADS
  static const get_ads = '/ads';

  //GIFT CARDS
  static const gift_cards_all = '/gift-cards';
  static const gift_card_transaction = '/gift-cards/transactions';

  //CRYPTO
  static const crypto_all = '/crypto';
  static const crypto_transaction = '/crypto/transactions';

  //transactions_log
  static const transactions_log = '/transaction-logs';

  //admin_bank details
  static const admin_bank_details = '/bank-details';

  //currency_rates
  static const currency_rates = '/exchange-rates';

  //wallet
  static const wallet_transactions = '/payment/wallet-transactions';

  //vtu
  static const vtu_transaction = '/vtu';
}
