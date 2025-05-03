import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:davyking/features/profile/data/model/edit_profile_request_model.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import '../model/edit_profile_response_model.dart';

class EditProfileRepository {
  final DioClient apiClient;

  EditProfileRepository() : apiClient = DioClient();

  Future<User> editProfile(EditProfileRequest request) async {
    try {
      final response = await apiClient
          .patch('${ApiUrl.users}/${request.id}', data: request.toJson());

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData['message'].toString().isNotEmpty) {
        throw AppException("Edit profile failed ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred.");
    }
  }
}
