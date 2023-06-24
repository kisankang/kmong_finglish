import 'package:finglish/modules/manager/manager_controller.dart';
import 'package:get/get.dart';

class ManagerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManagerController(quizRepository: Get.find()));
  }
}
