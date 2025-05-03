// BuyGiftcardController.dart
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/models/admin_bank_details_model.dart';
import 'package:davyking/core/models/transaction_log_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class AdminBankDetailsController extends GetxController {
  // ... existing code ...

  RxList<AdminBankDetailsModel> bank_details = <AdminBankDetailsModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final DioClient apiClient = DioClient();

  Future<void> fetchAdminBankDetails() async {
    try {
      final response = await apiClient.get(ApiUrl.admin_bank_details);
      final List<dynamic> data = response.data['data'];
      bank_details.assignAll(
        data.map((json) => AdminBankDetailsModel.fromJson(json)).toList(),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch bank details: $e');
    }
  }

  // Refresh the bank details
  Future<void> refreshBankDetails() async {
    await fetchAdminBankDetails();
  }

  // Call this in onInit or wherever appropriate
  @override
  void onInit() {
    super.onInit();
    // ... existing onInit code ...
    fetchAdminBankDetails(); // Fetch logs on initialization
  }

  // ... existing submitGiftCardPurchase remains unchanged ...
}
