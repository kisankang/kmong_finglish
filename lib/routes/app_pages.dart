import 'package:finglish/modules/home/home_binding.dart';
import 'package:finglish/modules/home/home_page.dart';
import 'package:finglish/modules/main/main_binding.dart';
import 'package:finglish/modules/main/main_page.dart';
import 'package:finglish/modules/manager/manager_binding.dart';
import 'package:finglish/modules/manager/manager_page.dart';
import 'package:finglish/modules/mode_select/mode_select_binding.dart';
import 'package:finglish/modules/mode_select/mode_select_page.dart';
import 'package:finglish/modules/my/my_binding.dart';
import 'package:finglish/modules/my/my_page.dart';
import 'package:finglish/modules/quiz/quiz_binding.dart';
import 'package:finglish/modules/quiz/quiz_page.dart';

import 'package:get/get.dart';

part 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.MAIN,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.QUIZ,
      page: () => const QuizPage(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: Routes.MY,
      page: () => const MyPage(),
      binding: MyBinding(),
    ),
    GetPage(
      name: Routes.MODESELECT,
      page: () => const ModeSelectPage(),
      binding: ModeSelectBinding(),
    ),
    GetPage(
      name: Routes.MANAGER,
      page: () => const ManagerPage(),
      binding: ManagerBinding(),
    ),
  ];
}
