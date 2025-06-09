import 'dart:convert';

import 'package:davyking/core/errors/app_exception.dart';
import 'package:davyking/core/errors/dio_error_handler.dart';
import 'package:davyking/core/models/user_auth_response_model.dart';
import 'package:davyking/core/services/secure_storage_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/constants/api_url.dart';

class UserAuthDetailsController extends GetxController {
  var user = Rxn<User>(); // Holds the user object
  var token = "".obs; // Holds the authentication token

  final DioClient apiClient = DioClient();

  // Method to store user details
  void saveUser(UserAuthResponse response) {
    user.value = response.user;
    token.value = response.token;
  }

  //method to update user details
  void updateUser(User response) {
    user.value = response;
  }

  // Method to clear user details on logout
  Future<void> logout() async {
    final storageService = SecureStorageService();
    user.value = null;
    token.value = "no_token";
    await storageService.clearAll();
    await storageService.saveData("user_has", "log_out");
  }

  Future<void> getUserDetail() async {
    try {
      final response = await apiClient.get('${ApiUrl.users}/${user.value?.id}');
      User user_response = User.fromJson(response.data['user']);
      Get.find<UserAuthDetailsController>().updateUser(user_response);
      updateUser(user_response);
      await _storeAuthDetails(user_response);
    } on DioException catch (e) {
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred.");
    }
  }

  void loadUserDetails() async {
    try {
      final storageService = SecureStorageService();
      var user_details = await storageService.getData('user_details');

      if (user_details != null) {
        var user_details_decode = jsonDecode(user_details);
        updateUser(User.fromJson(user_details_decode));
      }
      //refech user details
      await getUserDetail();
    } catch (e) {}
  }

  // Store authentication details
  Future<void> _storeAuthDetails(User response) async {
    final storageService = SecureStorageService();
    await storageService.saveData(
        'user_details', jsonEncode(response.toJson()));
  }

  @override
  void onInit() {
    super.onInit();
    loadUserDetails();
    // getUserDetail();
  }
}
