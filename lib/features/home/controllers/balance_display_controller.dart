import 'package:get/get.dart';

class BalanceDisplayController extends GetxController {
  final showBalance = false.obs;

  void toggleBalanceVisibility() {
    showBalance.value = !showBalance.value;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
