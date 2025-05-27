import 'dart:convert';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:davyking/api/api_client.dart';

class VtuRepository {
  final DioClient apiClient;

  VtuRepository() : apiClient = DioClient();

  Future<Map<String, dynamic>?> verifyCustomer(
      {required String customerId,
      required String serviceId,
      String? variationId}) async {
    final payload = {'customer_id': customerId, 'service_id': serviceId};

    try {
      if (variationId != null) {
        payload['variation_id'] = variationId;
      }

      final response = await apiClient
          .post('${ApiUrl.vtu_transaction}/verify-customer', data: payload);

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

  Future<Map<String, dynamic>?> getVtuTransaction(
      {required String requestId}) async {
    try {
      final response = await apiClient.post(
          '${ApiUrl.vtu_transaction}/order-status',
          data: {'request_id': requestId});

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
}
