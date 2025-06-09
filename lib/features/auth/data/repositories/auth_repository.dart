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


  // ===== EMAIL VERIFICATION METHODS =====

  /// Send email verification code to user
  Future<void> sendEmailVerification(String email) async {
    try {
      final response = await apiClient.post(
        ApiUrl.auth_email_verification_send,
        data: {'email': email},
      );

      final responseData = response.data;
      if (responseData['status'] != 'success') {
        throw AppException(responseData['message'] ?? 'Failed to send verification code');
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null && responseData['message'].toString().isNotEmpty) {
        throw AppException("Failed to send verification code. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException("An unexpected error occurred while sending verification code.");
    }
  }

  /// Verify email with the provided code
  Future<void> verifyEmail(String email, String code) async {
    try {
      final response = await apiClient.post(
        ApiUrl.auth_email_verification_verify,
        data: {
          'email': email,
          'code': code,
        },
      );

      final responseData = response.data;
      if (responseData['status'] != 'success') {
        throw AppException(responseData['message'] ?? 'Email verification failed');
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null && responseData['message'].toString().isNotEmpty) {
        throw AppException("Verification failed. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException("An unexpected error occurred during email verification.");
    }
  }

  /// Resend email verification code
  Future<void> resendEmailVerification(String email) async {
    try {
      final response = await apiClient.post(
        ApiUrl.auth_email_verification_resend,
        data: {'email': email},
      );

      final responseData = response.data;
      if (responseData['status'] != 'success') {
        throw AppException(responseData['message'] ?? 'Failed to resend verification code');
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null && responseData['message'].toString().isNotEmpty) {
        throw AppException("Failed to resend code. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException("An unexpected error occurred while resending verification code.");
    }
  }

  /// Check email verification status
  Future<bool> checkEmailVerificationStatus(String email) async {
    try {
      final response = await apiClient.post(
        ApiUrl.auth_email_verification_status,
        data: {'email': email},
      );

      final responseData = response.data;
      if (responseData['status'] != 'success') {
        throw AppException(responseData['message'] ?? 'Failed to check verification status');
      }

      return responseData['is_verified'] ?? false;
    } on DioException catch (e) {
      final responseData = e.response?.data;

      if (responseData != null && responseData['message'].toString().isNotEmpty) {
        throw AppException("Status check failed. ${responseData['message']}");
      }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException("An unexpected error occurred while checking verification status.");
    }
  }
}
