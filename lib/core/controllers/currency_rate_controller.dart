import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/models/currency_rate_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class CurrencyRateController extends GetxController {
  final RxList<CurrencyRateModel> currencyRates = <CurrencyRateModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final DioClient apiClient = DioClient();

  /// Fetch currency rates from the backend
  Future<void> fetchCurrencyRates() async {
    isLoading.value = true;
    try {
      final response = await apiClient.get(ApiUrl.currency_rates);
      final List<dynamic> data = response.data['data'];

      currencyRates.assignAll(
        data.map((json) => CurrencyRateModel.fromJson(json)).toList(),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch currency rates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh rates manually
  Future<void> refreshRates() async {
    await fetchCurrencyRates();
  }

  /// Automatically fetch rates on controller init
  @override
  void onInit() {
    super.onInit();
    fetchCurrencyRates();
  }
}
