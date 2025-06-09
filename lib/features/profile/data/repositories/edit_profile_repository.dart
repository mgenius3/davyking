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
      final response = await apiClient.patch('${ApiUrl.users}/${request.id}',
          data: request.toJson());

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

  Future<User> updateWithdrawalBank(String url, Map body) async {
    try {
      final response = await apiClient.patch(url, data: body);

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData['message'].toString().isNotEmpty) {
        throw AppException("Update withdrawal bank ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred.");
    }
  }

  /// Delete user account permanently
  Future<bool> deleteAccount(String userId) async {
    try {
      final response = await apiClient.delete('${ApiUrl.users}/$userId');

      // Check if deletion was successful
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      
      // Handle API response with success flag
      if (response.data != null && response.data['success'] == true) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      final responseData = e.response?.data;

      // Handle specific delete account errors
      if (responseData != null && responseData['message'] != null) {
        final message = responseData['message'].toString();
        
        // Handle common delete account scenarios
        if (message.contains('pending transactions')) {
          throw AppException("Cannot delete account: You have pending transactions. Please wait for them to complete or contact support.");
        } else if (message.contains('outstanding balance')) {
          throw AppException("Cannot delete account: Please withdraw your remaining balance first.");
        } else if (message.contains('not found')) {
          throw AppException("Account not found or already deleted.");
        } else if (message.contains('unauthorized')) {
          throw AppException("You are not authorized to delete this account.");
        } else {
          throw AppException("Delete account failed: $message");
        }
      }
      
      // Handle HTTP status code errors
      if (e.response?.statusCode == 403) {
        throw AppException("You are not authorized to delete this account.");
      } else if (e.response?.statusCode == 404) {
        throw AppException("Account not found or already deleted.");
      } else if (e.response?.statusCode == 409) {
        throw AppException("Cannot delete account due to active transactions or pending operations.");
      }
      
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException("An unexpected error occurred while deleting your account. Please try again later.");
    }
  }


}