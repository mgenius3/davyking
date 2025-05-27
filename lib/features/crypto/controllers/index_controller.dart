import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/features/crypto/data/model/crypto_list_model.dart';
import 'package:davyking/features/crypto/data/model/crypto_transaction_model.dart';
import 'package:davyking/features/crypto/data/repositories/crypto_repository.dart';

import 'package:get/get.dart';

class CryptoController extends GetxController {
  var buy_or_sell = 'buy'.obs;
  var all_crypto = <CryptoListModel>[].obs; // Reactive list of crypto
  var all_cryptoTransaction = <CryptoTransactionModel>[].obs;
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs; // Error message

  // Repository instance
  final CryptoRepository _repository = CryptoRepository();

  @override
  void onInit() {
    super.onInit();
    fetchAllCryptos(); // Fetch gift cards when the controller is initialized
    fetchAllCryptosTransaction(); // Fetch user gift card transactions
  }

  void updateBuyOrSell(String update) {
    buy_or_sell.value = update;
  }

  // Set the gift cards (used by fetchAllCryptos or manually)
  void getAllCrypto(List<CryptoListModel> giftcards) {
    all_crypto.assignAll(giftcards);
  }

  void getAllUserCryptoTransaction(
      List<CryptoTransactionModel> usergiftcardtransaction) {
    all_cryptoTransaction.assignAll(usergiftcardtransaction);
  }

  // Fetch all gift cards from the API
  Future<void> fetchAllCryptos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final cryptos = await _repository.getAllCrypto();
      getAllCrypto(cryptos); // Update the reactive list
    } catch (e) {
      Failure errormessage = ErrorMapper.map(e as Exception);

      errorMessage.value = errormessage.message;
    } finally {
      isLoading.value = false;
    }
  }

  //Fetch all crypto transactions from the API
  Future<void> fetchAllCryptosTransaction() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final usergiftcardtransaction =
          await _repository.getUserCryptoTransaction();
      getAllUserCryptoTransaction(
          usergiftcardtransaction); // Update the reactive list
    } catch (e) {
      Failure errormessage = ErrorMapper.map(e as Exception);
      errorMessage.value = errormessage.message;
    } finally {
      isLoading.value = false;
    }
  }

  //Getter for filtered transactions
  List<CryptoTransactionModel> get filteredTransactions {
    return all_cryptoTransaction
        .where((transaction) => transaction.type == buy_or_sell.value)
        .toList();
  }

  CryptoTransactionModel singleTransaction(String id) {
   
    return all_cryptoTransaction
        .firstWhere((transaction) => transaction.id.toString() == id);
  }
}
