import 'package:finglish/routes/app_pages.dart';
import 'package:finglish/utils/enums.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  Rx<int> pageIndex = Rx(0);
  onTapBottomNavigationBarItem(value) {
    switch (value) {
      case 0:
        pageIndex.value = value;
        break;
      case 1:
        Get.toNamed(Routes.QUIZ, arguments: QuizStartType.todayWord);
        break;
      case 2:
        Get.toNamed(Routes.QUIZ, arguments: QuizStartType.todaySentence);
        break;
      case 3:
        pageIndex.value = value;
        break;
    }
  }
}
