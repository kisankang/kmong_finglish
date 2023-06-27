import 'package:finglish/modules/manager_edit/manager_edit_controller.dart';
import 'package:get/get.dart';

class ManagerEditlBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManagerEditController(quizRepository: Get.find()));
  }
}
