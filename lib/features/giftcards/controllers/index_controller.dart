import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_transaction_model.dart';
import 'package:davyking/features/giftcards/data/repositories/gift-card_repository.dart';
import 'package:get/get.dart';

class GiftCardController extends GetxController {
  var buy_or_sell = 'buy'.obs;
  var all_giftCard = <GiftcardsListModel>[].obs; // Reactive list of gift cards
  var all_giftCardTransaction = <GiftCardTransactionModel>[].obs;
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs; // Error message

  // Repository instance
  final GiftCardRepository _repository = GiftCardRepository();

  @override
  void onInit() {
    super.onInit();
    fetchAllGiftCards(); // Fetch gift cards when the controller is initialized
    fetchAllGiftCardsTransaction(); // Fetch user gift card transactions
  }

  void updateBuyOrSell(String update) {
    buy_or_sell.value = update;
  }

  // Set the gift cards (used by fetchAllGiftCards or manually)
  void getAllGiftCard(List<GiftcardsListModel> giftcards) {
    all_giftCard.assignAll(giftcards);
  }

  void getAllUserGiftCardTransaction(
      List<GiftCardTransactionModel> usergiftcardtransaction) {
    all_giftCardTransaction.assignAll(usergiftcardtransaction);
  }

  // Fetch all gift cards from the API
  Future<void> fetchAllGiftCards() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final giftCards = await _repository.getAllGiftCard();
      getAllGiftCard(giftCards); // Update the reactive list
    } catch (e) {
      Failure errormessage = ErrorMapper.map(e as Exception);
      errorMessage.value = errormessage.message;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all gift card transactions from the API
  Future<void> fetchAllGiftCardsTransaction() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final usergiftcardtransaction =
          await _repository.getUserGiftCardTransaction();
      getAllUserGiftCardTransaction(
          usergiftcardtransaction); // Update the reactive list
    } catch (e) {
      Failure errormessage = ErrorMapper.map(e as Exception);
      errorMessage.value = errormessage.message;
    } finally {
      isLoading.value = false;
    }
  }

  // Getter for filtered transactions
  List<GiftCardTransactionModel> get filteredTransactions {
    return all_giftCardTransaction
        .where((transaction) => transaction.type == buy_or_sell.value)
        .toList();
  }
}
