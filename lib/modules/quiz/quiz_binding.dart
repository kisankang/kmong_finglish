import 'package:finglish/modules/quiz/quiz_controller.dart';
import 'package:get/get.dart';

class QuizBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController(
          quizDataService: Get.find(),
          userDataService: Get.find(),
        ));
  }
}
