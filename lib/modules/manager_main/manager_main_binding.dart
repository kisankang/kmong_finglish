import 'package:finglish/modules/manager_main/manager_main_controller.dart';
import 'package:get/get.dart';

class ManagerMainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManagerMainController());
  }
}
