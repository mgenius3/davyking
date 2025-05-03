import 'package:davyking/api/api_client.dart';
import 'package:davyking/core/errors/error_mapper.dart';
import 'package:davyking/core/errors/failure.dart';
import 'package:davyking/core/utils/snackbar.dart';
import 'package:davyking/features/ads/data/models/ad_model.dart';
import 'package:davyking/features/ads/data/repositories/ad_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdController extends GetxController {
  var ads = <Ad>[].obs; // Observable list of ads
  var isLoading = true.obs; // Observable loading state
  var errorMessage = ''.obs; // Observable error message
  AdRepository adRepository = AdRepository();

  @override
  void onInit() {
    super.onInit();
    fetchAds();
  }

  Future<void> fetchAds() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<Ad> response = await adRepository.fetchAds();
      ads.value = response;
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   ads.value = (data['data'] as List)
      //       .map((json) => Ad.fromJson(json))
      //       .toList()
      //       .where((ad) => ad.isActive)
      //       .toList();
      // } else {
      //   throw Exception('Failed to load ads');
      // }

      //  ads.value = (data['data'] as List)
      //       .map((json) => Ad.fromJson(json))
      //       .toList()
      //       .where((ad) => ad.isActive)
      //       .toList();
    } catch (e) {
      Failure failure = ErrorMapper.map(e as Exception);
      print(failure.message);
      errorMessage.value = failure.message;
      showSnackbar("Error", failure.message);
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Refresh ads
  void refreshAds() {
    fetchAds();
  }
}
