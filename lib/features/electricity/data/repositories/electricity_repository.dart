import 'dart:convert';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';

class ElectricityRepository {
  final DioClient apiClient;

  ElectricityRepository() : apiClient = DioClient();

  Future<Map<String, dynamic>?> buyElectricity(
      {required String userId,
      required String customerId,
      required String serviceId,
      required String variationId,
      required double amount,
      required String requestId}) async {
    try {
      final response = await apiClient.post(
        '${ApiUrl.vtu_transaction}/buy-electricity',
        data: jsonEncode({
          'user_id': userId,
          'customer_id': customerId,
          'service_id': serviceId,
          'variation_id': variationId,
          'amount': amount,
          'request_id': requestId
        }),
      );

      if (response.data['status'] == 'success') {
        return response.data['data'];
      }
    } on DioException catch (e) {
      if (e.response?.data['message'] != null) {
        throw AppException(e.response?.data['message']);
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
