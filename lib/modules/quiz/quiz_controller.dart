import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/models/quiz_result.dart';
import 'package:finglish/data/services/quiz_data_service.dart';
import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/routes/app_pages.dart';
import 'package:finglish/utils/enums.dart';
import 'package:finglish/utils/extensions.dart';
import 'package:finglish/widgets/quiz_result_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizController extends GetxController {
  final QuizDataService _quizDataService;
  final UserDataService _userDataService;

  QuizController({
    required QuizDataService quizDataService,
    required UserDataService userDataService,
  })  : _quizDataService = quizDataService,
        _userDataService = userDataService;

  Rx<int> selecteIndex = 0.obs;
  Quiz get currentQuiz => quizDatas[selecteIndex.value];
  late List<Quiz> quizDatas;
  late QuizStartType quizStartType;
  List<TextEditingController?> blankControllerList = [];
  setBlankControllers() {
    List<TextEditingController?> _blankControllerList = [];
    for (var element in currentQuiz.enHighlight) {
      element == true
          ? _blankControllerList.add(TextEditingController())
          : _blankControllerList.add(null);
    }
    blankControllerList = _blankControllerList;
    int findQuizResult = quizResultDatas.indexWhere((element) =>
        quizDatas[selecteIndex.value].quizId == element.quiz.quizId);
    if (findQuizResult != -1) {
      QuizResult triedQuiz = quizResultDatas[findQuizResult];
      for (var i = 0; i < triedQuiz.myAnswer.last.length; i++) {
        if (triedQuiz.myAnswer.last[i] != null) {
          blankControllerList[i]?.text = triedQuiz.myAnswer.last[i]!;
        }
      }
    }
  }

  Rx<bool> isHintOn = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<QuizResult> quizResultDatas = [];
  Rx<bool> isLiked = false.obs;

  @override
  void onInit() {
    super.onInit();
    quizStartType = Get.arguments;
    switch (quizStartType) {
      case QuizStartType.today:
        quizDatas = _quizDataService.getTodayQuiz(QuizType.word) +
            _quizDataService.getTodayQuiz(QuizType.sentence);
        break;
      case QuizStartType.todayWord:
        quizDatas = _quizDataService.getTodayQuiz(QuizType.word);
        break;
      case QuizStartType.todaySentence:
        quizDatas = _quizDataService.getTodayQuiz(QuizType.sentence);
        break;
      case QuizStartType.todayWrong:
        quizDatas = _userDataService.todayWrongQuizResult.toQuizList();
        break;
      case QuizStartType.todayTried:
        quizDatas = _userDataService.todayWordQuizResult.toQuizList() +
            _userDataService.todaySentenceQuizResult.toQuizList();
      case QuizStartType.todayTriedWord:
        quizDatas = _userDataService.todayWordQuizResult.toQuizList();
        break;
      case QuizStartType.todayTriedSentence:
        quizDatas = _userDataService.todaySentenceQuizResult.toQuizList();
        break;
      case QuizStartType.important:
        quizDatas = _userDataService.importantWordQuizResult.toQuizList() +
            _userDataService.importantSentenceResult.toQuizList();
        break;
      case QuizStartType.importantWord:
        quizDatas = _userDataService.importantWordQuizResult.toQuizList();
        break;
      case QuizStartType.importantSentence:
        quizDatas = _userDataService.importantSentenceResult.toQuizList();
        break;
    }
    if (quizDatas.isNotEmpty) {
      quizDatas.shuffle();
      setBlankControllers();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.back();
        Get.showSnackbar(GetSnackBar(
          title: '알림',
          message: '준비된 ${quizStartType.text} 퀴즈가 없습니다.',
          duration: const Duration(seconds: 2),
        ));
      });
    }
  }

  QuizResult getQuizResult(Quiz quiz) {
    List<String?> answer = [];
    for (var i = 0; i < blankControllerList.length; i++) {
      answer.add(blankControllerList[i]?.text);
    }
    QuizResult quizResult = QuizResult(
      quiz: quiz,
      triedTime: [DateTime.now()],
      myAnswer: [answer],
      isLiked: isLiked.value,
    );
    return quizResult;
  }

  bool get isFirst => selecteIndex.value == 0;

  bool get isLast => selecteIndex.value == quizDatas.length - 1;

  onTapBefore() {
    selecteIndex.value = selecteIndex.value - 1;
    int findQuizResult = quizResultDatas.indexWhere((element) =>
        quizDatas[selecteIndex.value].quizId == element.quiz.quizId);
    if (findQuizResult != -1) {
      isLiked.value = quizResultDatas[findQuizResult].isLiked;
    }
    setBlankControllers();
    isHintOn.value = false;
  }

  addQuizResult(Quiz quiz) {
    int sameIndex = quizResultDatas
        .indexWhere((element) => element.quiz.quizId == quiz.quizId);
    if (sameIndex == -1) {
      quizResultDatas.add(getQuizResult(quiz));
    } else {
      quizResultDatas[sameIndex] = getQuizResult(quiz);
    }
  }

  onTapNext() {
    if (formKey.currentState!.validate()) {
      addQuizResult(currentQuiz);
      selecteIndex.value = selecteIndex.value + 1;
      setBlankControllers();
      isLiked.value = false;
      isHintOn.value = false;
    }
  }

  onTapSubmit() {
    if (formKey.currentState!.validate()) {
      addQuizResult(currentQuiz);
      Get.offNamedUntil(Routes.MAIN, (route) => false);
      for (var element in quizResultDatas) {
        _userDataService.triedQuiz(element);
      }
      Get.dialog(
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QuizResultCard(quizResultDatas: quizResultDatas),
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('확인'))
          ],
        )),
      );
    }
  }
}
