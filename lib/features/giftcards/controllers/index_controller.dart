import 'package:get/get.dart';

class GiftCardController extends GetxController {
  var buy_or_sell = 'buy'.obs;

  void updateBuyOrSell(String update) {
    buy_or_sell.value = update;
  }
}
