import 'package:finglish/data/repositories/quiz_repository.dart';
import 'package:finglish/data/services/quiz_play_service.dart';
import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/data/services/quiz_data_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:finglish/common/theme/app_theme.dart';

import 'package:finglish/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  Get.put<QuizRepository>(QuizRepository(), permanent: true);
  Get.put<QuizDataService>(QuizDataService(), permanent: true);
  Get.put<UserDataService>(UserDataService(), permanent: true);
  Get.put<QuizPlayService>(QuizPlayService(), permanent: true);

  var getMaterialApp = GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: lightThemeData,
    getPages: AppPages.pages,
    initialRoute: Routes.MODESELECT,
    initialBinding: BindingsBuilder(() {}),
    builder: EasyLoading.init(
      builder: (context, child) => child!,
    ),
  );

  runApp(getMaterialApp);
}
