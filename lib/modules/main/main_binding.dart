import 'package:finglish/modules/home/home_controller.dart';
import 'package:finglish/modules/main/main_controller.dart';
import 'package:finglish/modules/my/my_controller.dart';
import 'package:finglish/modules/quiz/quiz_controller.dart';
import 'package:get/get.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(userDataService: Get.find()));
    Get.lazyPut(() => QuizController(
          quizDataService: Get.find(),
          userDataService: Get.find(),
        ));
    Get.lazyPut(() => MyController(localAppUserDataService: Get.find()));
    Get.lazyPut(
      () => MainController(),
    );
  }
}
