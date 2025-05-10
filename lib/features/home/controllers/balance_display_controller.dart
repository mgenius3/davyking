import 'package:get/get.dart';

class BalanceDisplayController extends GetxController {
  final showBalance = true.obs;

  void toggleBalanceVisibility() {
    showBalance.value = !showBalance.value;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
