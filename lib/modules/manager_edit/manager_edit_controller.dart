import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/repositories/quiz_repository.dart';
import 'package:finglish/data/services/quiz_data_service.dart';
import 'package:finglish/routes/app_pages.dart';
import 'package:finglish/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerEditController extends GetxController {
  final QuizDataService _quizDataService;
  final QuizRepository _quizRepository;
  ManagerEditController({
    required QuizDataService quizDataService,
    required QuizRepository quizRepository,
  })  : _quizDataService = quizDataService,
        _quizRepository = quizRepository;
  late Rx<List<Quiz>> quizData;

  Rx<int> currentIndex = 0.obs;
  initQuizData() {
    quizData = Rx(_quizDataService.readAll());
  }

  @override
  void onInit() {
    initQuizData();
    super.onInit();
  }

  onTapStartEdit(Quiz quiz) {
    Get.toNamed(Routes.MANAGER_MANUAL, arguments: quiz)?.then((value) {
      Quiz updatedQuiz = value as Quiz;
      int index = quizData.value
          .indexWhere((element) => element.quizId == updatedQuiz.quizId);
      quizData.update((val) {
        val?[index] = updatedQuiz;
      });
    });
  }

  onTapDelete(Quiz quiz) async {
    Get.dialog(
      Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('해당 퀴즈를 삭제하시겠습니까'),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        quiz.deletedAt = DateTime.now().millisecondsSinceEpoch;
                        Loading.on();
                        if (await _quizRepository.updateQuiz(quiz)) {
                          await _quizDataService.updateQuizData(quiz);
                          int index = quizData.value.indexWhere(
                              (element) => element.quizId == quiz.quizId);
                          quizData.update((val) {
                            val?[index] = quiz;
                          });
                        }
                        Loading.off();
                        Get.back();
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

  onTapUndoDelete(Quiz quiz) async {
    Get.dialog(
      Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('해당 퀴즈를 복구하시겠습니까'),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        quiz.deletedAt = null;
                        Loading.on();
                        if (await _quizRepository.updateQuiz(quiz)) {
                          await _quizDataService.updateQuizData(quiz);
                          int index = quizData.value.indexWhere(
                              (element) => element.quizId == quiz.quizId);
                          quizData.update((val) {
                            val?[index] = quiz;
                          });
                        }
                        Loading.off();
                        Get.back();
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
