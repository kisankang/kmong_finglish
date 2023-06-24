import 'package:finglish/modules/mode_select/mode_select_controller.dart';
import 'package:get/get.dart';

class ModeSelectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ModeSelectController());
  }
}
