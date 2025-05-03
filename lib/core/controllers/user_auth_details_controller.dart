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
    user.value = response as User;
  }

  // Method to clear user details on logout
  void logout() async {
    final storageService = SecureStorageService();
    user.value = null;
    token.value = "";
    await storageService.clearAll();
  }

  @override
  void onInit() {
    super.onInit();
    getUserDetail();
  }

  Future<void> getUserDetail() async {
    try {
      final response = await apiClient.get('${ApiUrl.users}/${user.value!.id}');

      User user_response = User.fromJson(response.data['user']);
      Get.find<UserAuthDetailsController>().updateUser(user_response);
    } on DioException catch (e) {
      // final responseData = e.response?.data;

      // if (responseData['message'].toString().isNotEmpty) {
      //   throw AppException("Edit profile failed ${responseData['message']}");
      // }
      throw AppException(DioErrorHandler.handleDioError(e));
    } catch (e) {
      throw AppException("An unexpected error occurred.");
    }
  }
}
