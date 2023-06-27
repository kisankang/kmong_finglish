import 'package:excel/excel.dart';
import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/repositories/quiz_repository.dart';
import 'package:finglish/data/services/quiz_data_service.dart';
import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/routes/app_pages.dart';
import 'package:finglish/utils/excel_loader.dart';
import 'package:finglish/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerMainController extends GetxController {
  onTapManualUpload() {
    Get.toNamed(Routes.MANAGER_MANUAL);
  }

  onTapExcelUpload() async {
    Excel? excel = await ExcelHelper.load();
    if (excel != null) {
      List<Quiz> quizData = ExcelHelper.convertFromExcel(excel);
      if (quizData.isEmpty) {
        Get.dialog(
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('퀴즈 데이터를 감지할 수 없습니다.'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        Get.dialog(
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${quizData.length}개의 퀴즈 데이터가 감지되었습니다.\n업로드 하시겠습니까?'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            Get.back();
                          },
                          child: const Text('취소'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            Loading.onWithProgress();
                            QuizRepository _quizRepository = Get.find();
                            for (var i = 0; i < quizData.length; i++) {
                              double done = i / quizData.length;
                              Loading.updateProgress(done,
                                  status: '$i / ${quizData.length}');
                              await _quizRepository.createQuiz(quizData[i]);
                            }
                            Loading.off();
                            Get.back();
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  onTapEdit() {
    Get.toNamed(Routes.MANAGER_EDIT);
  }

  onTapDeleteLocalData() {
    Get.dialog(
      Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('로컬 데이터(학습 내용)를 모두 삭제하시겠습니까?'),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        Get.back();
                        UserDataService userDataService = Get.find();
                        QuizDataService quizDataService = Get.find();
                        await userDataService.eraseAll();
                        await quizDataService.eraseAll();
                        await userDataService.init();
                        await quizDataService.init();
                      },
                      child: const Text('확인'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('취소'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
