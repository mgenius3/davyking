import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/features/ads/data/models/ad_model.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
// import 'package:davyking/features/auth/data/models/otp_response.dart';
// import 'package:davyking/features/auth/data/models/reset_password_request.dart';

class AdRepository {
  final DioClient apiClient;

  AdRepository() : apiClient = DioClient();

  Future<List<Ad>> fetchAds() async {
    List<Ad> ads = [];

    try {
      final response = await apiClient.get(ApiUrl.get_ads);
      ads = (response.data['data'] as List)
          .map((json) => Ad.fromJson(json))
          .toList()
          .where((ad) => ad.isActive)
          .toList();
      return ads;
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred during fetching data.");
    }
  }
}
