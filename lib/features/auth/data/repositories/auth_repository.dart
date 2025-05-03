import 'package:davyking/core/errors/dio_error_handler.dart';
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
      print(e);
      throw AppException("An unexpected error occurred during Sign-Up.");
    }
  }

  // Future<VerifyOtpResponse> verifyOtp(Map otp) async {
  //   try {
  //     final storageService = SecureStorageService();
  //     final user_reg_details = await storageService.getData('user_reg_details');
  //     final userId = jsonDecode(user_reg_details!)['id'];
  //     final response = await apiClient
  //         .patch('${ApiUrl.auth_signup}/$userId/verify_otp/', data: otp);

  //     return VerifyOtpResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     final responseData = e.response?.data;

  //     if (responseData is Map && responseData['success'] == false) {
  //       throw AppException(responseData['message']);
  //     }
  //     throw AppException("OTP verification failed, please check your email");
  //   } catch (e) {
  //     throw AppException(
  //         "An unexpected error occurred during OTP verification");
  //   }
  // }

  // Future<void> resendOtp() async {
  //   try {
  //     final storageService = SecureStorageService();
  //     final user_reg_details = await storageService.getData('user_reg_details');
  //     final userId = jsonDecode(user_reg_details!)['id'];
  //     await apiClient
  //         .patch('${ApiUrl.auth_signup}/$userId/resend_otp/', data: {});
  //   } on DioException catch (e) {
  //     final responseData = e.response?.data;

  //     if (responseData is Map && responseData['non_field_errors'] != null) {
  //       throw AppException(responseData['non_field_errors'].join(', '));
  //     }
  //     throw AppException("Sign-In failed. Please check your credentials.");
  //   } catch (e) {
  //     throw AppException("An unexpected error occurred during Sign-In.");
  //   }
  // }

  // Future<SignInResponse> resetPassword(ResetPasswordRequest request) async {
  //   try {
  //     final response = await apiClient.post(
  //       '${ApiUrl.auth_reset_password}:id/password_reset/',
  //       data: request.toJson(),
  //     );

  //     print(response.data);
  //     return SignInResponse.fromJson(response.data);
  //   } on DioException catch (e) {
  //     final responseData = e.response?.data;

  //     if (responseData is Map && responseData['non_field_errors'] != null) {
  //       throw AppException(responseData['non_field_errors'].join(', '));
  //     }
  //     throw AppException("Sign-In failed. Please check your credentials.");
  //   } catch (e) {
  //     throw AppException("An unexpected error occurred during Sign-In.");
  //   }
  // }
}
