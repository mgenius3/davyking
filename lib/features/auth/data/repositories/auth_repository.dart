import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';
import 'package:davyking/core/errors/app_exception.dart';
import '../models/sign_in_request_model.dart';
import '../../../../core/models/user_auth_response_model.dart';
import '../models/sign_up_request_model.dart';
// import 'package:davyking/features/auth/data/models/otp_response.dart';
// import 'package:davyking/features/auth/data/models/reset_password_request.dart';

class AuthRepository {
  final DioClient apiClient;

  AuthRepository() : apiClient = DioClient();

  Future<UserAuthResponse> signIn(SignInRequest request) async {
    try {
      final response = await apiClient.post(
        ApiUrl.auth_signin,
        data: request.toJson(),
      );

      return UserAuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData['message'].toString().isNotEmpty) {
        throw AppException("Sign-In failed. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred during Sign-In.");
    }
  }

  Future<UserAuthResponse> signUp(SignUpRequest request) async {
    try {
      final response =
          await apiClient.post(ApiUrl.auth_signup, data: request.toJson());
      return UserAuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      final responseData = e.response?.data['errors'];
      if (responseData is Map) {
        final errorMessages = <String>[];
        responseData.forEach((key, value) {
          if (value is List) {
            errorMessages.add("$key: ${value.join(', ')}");
          }
        });
        if (errorMessages.isNotEmpty) {
          throw AppException(errorMessages.join('\n'));
        }
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred during Sign-Up.");
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await apiClient.post(ApiUrl.auth_reset_password, data: {'email': email});
      showSnackbar('Success', 'Check you email for otp code ', isError: false);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData['message'].toString().isNotEmpty) {
        throw AppException("email sent failed. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred during sending email");
    }
  }

  Future<void> sendOtp(Map data) async {
    try {
      await apiClient.post(ApiUrl.auth_verify_reset_password, data: data);
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData['message'].toString().isNotEmpty) {
        throw AppException("OTP sent failed. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred during sending OTP");
    }
  }

  Future<void> setNewPassword(String email, String password) async {
    try {
      await apiClient.post(ApiUrl.auth_set_new_password,
          data: {'email': email, 'password': password});
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData['message'].toString().isNotEmpty) {
        throw AppException("email sent failed. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred during sending email");
    }
  }
}
