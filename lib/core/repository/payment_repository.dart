import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/models/paystack_bank_model.dart';
import 'package:dio/dio.dart';

class PaymentRepository {
  final DioClient apiClient;

  PaymentRepository() : apiClient = DioClient();

  Future<String?> depositFunds(
      String paymentGatewayType, String url, Map json) async {
    try {
      final response = await apiClient.post(url, data: json);

      if (paymentGatewayType == 'paystack') {
        return response.data['data']['authorization_url'];
      } else {
        return response.data['data']['link'];
      }
    } on DioException catch (e) {
      throw AppException(e.response?.data['message']);
    } catch (e) {
      print(e);
      throw AppException(
          "An unexpected error initializing $paymentGatewayType.");
    }
  }

  Future<bool> verifyPayment(String url, paymentGatewayType) async {
    try {
      final response = await apiClient.get(url);
      if ((paymentGatewayType == 'paystack' &&
              response.data['status'] == 'success' &&
              response.data['data']['data']['status'] == 'success') ||
          (paymentGatewayType == 'flutterwave' &&
              response.data['status'] == 'success')) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException('Payment verification failed');
    }
  }

  Future<List<PaystackBankModel>> fetchBanks(String url) async {
    try {
      final response = await apiClient.get(url);

      if (response.data['status']) {
        final List<dynamic> bank_list =
            response.data['data'] as List<dynamic>? ?? [];
        return bank_list
            .map((json) =>
                PaystackBankModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw AppException('Error in fetching bank');
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      print(e);
      throw AppException('Failed to fetch banks');
    }
  }
}
