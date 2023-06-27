import 'package:finglish/modules/manager_manual/manager_manual_controller.dart';
import 'package:get/get.dart';

class ManagerManualBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ManagerManualController(
          quizRepository: Get.find(),
          quizDataService: Get.find(),
        ));
  }
}
