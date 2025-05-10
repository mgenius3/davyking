import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/core/utils/upload_image_to_cloudinary.dart';
import 'package:davyking/features/crypto/data/model/crypto_list_model.dart';
import 'package:davyking/features/crypto/data/model/crypto_transaction_model.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio; // For MultipartFile

class CryptoRepository {
  final DioClient apiClient;
  CryptoRepository() : apiClient = DioClient();
  // final BuyGiftcardController controller = Get.find<BuyGiftcardController>();
  Future<List<CryptoListModel>> getAllCrypto() async {
    try {
      final response = await apiClient.get(ApiUrl.crypto_all);
      if (response.data['status'] != 'success') {
        throw AppException(
            'Failed to fetch crypto ${response.data['message'] ?? 'Unknown error'}');
      }
      final List<dynamic> cryptoJson =
          response.data['data'] as List<dynamic>? ?? [];
      return cryptoJson
          .map((json) => CryptoListModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred while fetching crypto.");
    }
  }

  // Future<void> transactCrypto(
  //     Map<String, dynamic> fields, String filepath) async {
  //   try {
  //     // Prepare files
  //     Map<String, dio.MultipartFile> files = {};
  //     if (filepath.isNotEmpty) {
  //       files['proof_file'] = await dio.MultipartFile.fromFile(
  //         filepath,
  //         filename:
  //             'payment_screenshot_${DateTime.now().millisecondsSinceEpoch}.jpg',
  //       );
  //     }
  //     final response = await apiClient.postMultipart(ApiUrl.crypto_transaction,
  //         fields: fields, files: files);
  //     if (response.data['status'] == "success") {
  //       Get.showSnackbar(
  //         GetSnackBar(
  //             title: 'Success',
  //             message: 'Transaction created successfully',
  //             duration: const Duration(seconds: 3),
  //             backgroundColor: DarkThemeColors.primaryColor),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw AppException(DioErrorHandler.handleDioError(e));
  //   } catch (e) {
  //     throw AppException(
  //         "An unexpected error occurred during crypto transactions");
  //   }
  // }

  Future<void> transactCrypto(
      Map<String, dynamic> data, String filepath) async {
    try {
      // Prepare files

      String? file_url = await uploadImageToCloudinary(filepath);

      data['proof_file'] = file_url;

      print(data);

      final response =
          await apiClient.post(ApiUrl.crypto_transaction, data: data);
      if (response.data['status'] == "success") {
        Get.showSnackbar(
          GetSnackBar(
              title: 'Success',
              message: 'Transaction created successfully',
              duration: const Duration(seconds: 3),
              backgroundColor: DarkThemeColors.primaryColor),
        );
      }
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(
          "An unexpected error occurred during crypto transactions");
    }
  }

  Future<List<CryptoTransactionModel>> getUserCryptoTransaction() async {
    try {
      final response = await apiClient.get(ApiUrl.crypto_transaction);
      // Validate the status
      if (response.data['status'] != 'success') {
        throw AppException(
            'Failed to fetch crypto: ${response.data['message'] ?? 'Unknown error'}');
      }
      // Extract the 'data' field, default to empty list if null
      final List<dynamic> cryptoJson =
          response.data['data'] as List<dynamic>? ?? [];
      // Map each item to CryptoListModel
      return cryptoJson
          .map((json) =>
              CryptoTransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred while fetching crypto.");
    }
  }
}
