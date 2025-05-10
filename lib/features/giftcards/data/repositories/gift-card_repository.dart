import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/theme/colors.dart';
import 'package:davyking/features/giftcards/controllers/buy_giftcard_controller.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_list_model.dart';
import 'package:davyking/features/giftcards/data/model/giftcards_transaction_model.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:davyking/core/utils/upload_image_to_cloudinary.dart';
import 'package:dio/dio.dart' as dio; // For MultipartFile

class GiftCardRepository {
  final DioClient apiClient;

  GiftCardRepository() : apiClient = DioClient();
  // final BuyGiftcardController controller = Get.find<BuyGiftcardController>();

  Future<List<GiftcardsListModel>> getAllGiftCard() async {
    try {
      final response = await apiClient.get(ApiUrl.gift_cards_all);
      // Validate the status
      if (response.data['status'] != 'success') {
        throw AppException(
            'Failed to fetch gift cards: ${response.data['message'] ?? 'Unknown error'}');
      }
      // Extract the 'data' field, default to empty list if null
      final List<dynamic> giftCardsJson =
          response.data['data'] as List<dynamic>? ?? [];

      // Map each item to GiftcardsListModel
      return giftCardsJson
          .map((json) =>
              GiftcardsListModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException(
          "An unexpected error occurred while fetching gift cards.");
    }
  }

  Future<void> transactGiftCard(
      Map<String, dynamic> data, String filepath) async {
    try {
      String? file_url = await uploadImageToCloudinary(filepath);

      data['proof_file'] = file_url;

      final response = await apiClient.post(
        ApiUrl.gift_card_transaction,
        data: data,
      );

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
          "An unexpected error occurred during Giftcard transactions");
    }
  }

  Future<List<GiftCardTransactionModel>> getUserGiftCardTransaction() async {
    try {
      final response = await apiClient.get(ApiUrl.gift_card_transaction);
      // Validate the status
      if (response.data['status'] != 'success') {
        throw AppException(
            'Failed to fetch gift cards: ${response.data['message'] ?? 'Unknown error'}');
      }

      print(response.data['data'].runtimeType);
      // Extract the 'data' field, default to empty list if null
      final List<dynamic> giftCardsJson = response.data['data'];

      print(giftCardsJson);

      // Map each item to GiftcardsListModel
      return giftCardsJson
          .map((json) =>
              GiftCardTransactionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      print(e);
      throw AppException(
          "An unexpected error occurred while fetching gift cards.");
    }
  }
}
