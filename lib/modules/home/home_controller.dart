import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/modules/main/main_controller.dart';
import 'package:finglish/routes/app_pages.dart';
import 'package:finglish/utils/enums.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  UserDataService userDataService;
  HomeController({required this.userDataService});

  String todayTargetRate() {
    int ttlTarget = userDataService.appUser.targetSentenceNumber +
        userDataService.appUser.targetWordNumber;
    int did = userDataService.todayQuizResult.length;
    return '${((did / ttlTarget) * 100).floor()}%';
  }

  String todayCorrectAnswerRate() {
    if (userDataService.todayQuizResult.isEmpty) {
      return '-';
    }
    return '${((1 - userDataService.todayWrongQuizResult.length / userDataService.todayQuizResult.length) * 100).floor()}%';
  }

  String theNumberOfTodayWrong() {
    return '${userDataService.todayWrongQuizResult.length}개';
  }

  String theNumberOfTodayWord() {
    return '${userDataService.todayWordQuizResult.length}개';
  }

  String theNumberOfTodaySentence() {
    return '${userDataService.todaySentenceQuizResult.length}개';
  }

  goToQuizPage(QuizStartType quizStartType) {
    Get.toNamed(Routes.QUIZ, arguments: quizStartType);
  }

  onTapDrawerItem(int index) {
    Get.back();
    MainController mainController = Get.find();
    mainController.onTapBottomNavigationBarItem(index);
  }
}
