import 'package:finglish/data/models/app_user.dart';
import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/routes/app_pages.dart';
import 'package:finglish/utils/enums.dart';
import 'package:get/get.dart';

class MyController extends GetxController {
  UserDataService localAppUserDataService;
  MyController({required this.localAppUserDataService});
  List<int> targetSettingList = [20, 30, 50, 100];

  late Rx<int> targetWordNumber;
  late Rx<int> targetSentenceNumber;

  Function(int?)? onChangedWordNumber(int? v) {
    if (v != null) {
      targetWordNumber.value = v;
      AppUser user = localAppUserDataService.appUser;
      user.targetWordNumber = v;
      localAppUserDataService.updateAppUser(user);
    }
    return null;
  }

  Function(int?)? onChangedSentenceNumber(int? v) {
    if (v != null) {
      targetSentenceNumber.value = v;
      AppUser user = localAppUserDataService.appUser;
      user.targetSentenceNumber = v;
      localAppUserDataService.updateAppUser(user);
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    targetSentenceNumber =
        Rx(localAppUserDataService.appUser.targetSentenceNumber);
    targetWordNumber = Rx(localAppUserDataService.appUser.targetWordNumber);
  }

  goToQuizPage(QuizStartType quizStartType) {
    Get.toNamed(Routes.QUIZ, arguments: quizStartType);
  }
}
