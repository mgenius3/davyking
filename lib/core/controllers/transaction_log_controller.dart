// BuyGiftcardController.dart
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/models/transaction_log_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class TransactionLogController extends GetxController {
  // ... existing code ...

  RxList<TransactionLogModel> transactionLogs = <TransactionLogModel>[].obs;

  final DioClient apiClient = DioClient();

  Future<void> fetchTransactionLogs() async {
    try {
      final response = await apiClient.get(ApiUrl.transactions_log);
      final List<dynamic> logsData = response.data['transaction_logs'];
      transactionLogs.assignAll(
        logsData.map((json) => TransactionLogModel.fromJson(json)).toList(),
      );
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to fetch transaction logs: $e');
    }
  }

  // Call this in onInit or wherever appropriate
  @override
  void onInit() {
    super.onInit();
    // ... existing onInit code ...
    fetchTransactionLogs(); // Fetch logs on initialization
  }

  // ... existing submitGiftCardPurchase remains unchanged ...
}
