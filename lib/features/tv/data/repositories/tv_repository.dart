import 'dart:convert';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';

class TvRepository {
  final DioClient apiClient;

  TvRepository() : apiClient = DioClient();

  Future<Map<String, dynamic>?> buyTv(
      {required String user_id,
      required double amount,
      required String customerId,
      required String serviceId,
      required String variationId,
      required String requestId}) async {
    try {
      final response = await apiClient.post(
        '${ApiUrl.vtu_transaction}/buy-tv',
        data: jsonEncode({
          'user_id': user_id,
          'amount': amount,
          'customer_id': customerId,
          'service_id': serviceId,
          'variation_id': variationId,
          'request_id': requestId
        }),
      );

      if (response.data['status'] == "success") {
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

  Future<Map<String, dynamic>> getDataVariations() async {
    try {
      final response =
          await apiClient.get('${ApiUrl.vtu_transaction}/tv-variations');

      if (response.data['status'] == "success") {
        return response.data['data'];
      } else {
        throw Exception(
            'Failed to fetch data variations: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
