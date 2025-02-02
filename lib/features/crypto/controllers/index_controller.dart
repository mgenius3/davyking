import 'package:get/get.dart';

class CryptoController extends GetxController {
  var buy_or_sell = 'buy'.obs;

  void updateBuyOrSell(String update) {
    buy_or_sell.value = update;
  }
}
