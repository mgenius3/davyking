import 'package:get/get.dart';

class HelpFaqController extends GetxController {
  int binary = 0;

  void setBinary(int value) {
    binary = value;
    update();
  }
}
