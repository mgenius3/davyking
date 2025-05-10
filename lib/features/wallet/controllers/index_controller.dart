import 'package:davyking/features/wallet/data/model/wallet_transaction.dart';
import 'package:davyking/features/wallet/data/repository/wallet_repository.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  var all_wallet_transaction = <WalletTransactionModel>[].obs;
  var walletBalance = 0.0.obs;
  var isLoading = false.obs;
  final WalletRepository walletRepository = WalletRepository();
  final RxString selectedBankCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData(); // Fetch transactions and balance on init
  }

  Future<void> fetchWalletTransactions() async {
    try {
      isLoading(true);
      final walletTransaction = await walletRepository.walletTransaction();
      all_wallet_transaction.assignAll(walletTransaction);
    } catch (err) {
      Get.snackbar('Error', 'Failed to fetch transactions: $err');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchWalletData() async {
    await Future.wait([fetchWalletTransactions()]);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
