import 'dart:convert';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';

class AirtimeRepository {
  final DioClient apiClient;

  AirtimeRepository() : apiClient = DioClient();

  Future<void> buyAirtime(
      {required String user_id,
      required String phone,
      required String serviceId,
      required double amount,
      required String requestId}) async {
    try {
      final response = await apiClient.post(
        '${ApiUrl.vtu_transaction}/buy-airtime',
        data: jsonEncode({
          'user_id': user_id,
          'phone': phone,
          'service_id': serviceId,
          'amount': amount,
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
}
