import 'dart:convert';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';

class DataRepository {
  final DioClient apiClient;

  DataRepository() : apiClient = DioClient();

  Future<void> buyData(
      {required String user_id,
      required double amount,
      required String phone,
      required String serviceId,
      required String variationId,
      required String requestId}) async {
    try {
      final response = await apiClient.post(
        '${ApiUrl.vtu_transaction}/buy-data',
        data: jsonEncode({
          'user_id': user_id,
          'amount': amount,
          'phone': phone,
          'service_id': serviceId,
          'variation_id': variationId,
          'request_id': requestId
        }),
      );

      if (response.data['status'] == "success") {
        Get.showSnackbar(
          GetSnackBar(
              title: 'Success',
              message: response.data['message'],
              duration: const Duration(seconds: 3),
              backgroundColor: DarkThemeColors.primaryColor),
        );
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
          await apiClient.get('${ApiUrl.vtu_transaction}/data-variations');

      if (response.data['status'] == "success") {
        return response.data['data'];
      } else {
        throw Exception(
            'Failed to fetch data variations: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      print(e);
      throw AppException(e.toString());
    }
  }
}
