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

class QuizPlayService extends GetxService {
  final QuizDataService _quizDataService;
  final UserDataService _userDataService;
  QuizPlayService({
    required QuizDataService quizDataService,
    required UserDataService userDataService,
  })  : _quizDataService = quizDataService,
        _userDataService = userDataService;
  Map<
      QuizStartType,
      ({
        List<QuizResult> quizResultData,
        List<Quiz> quizData,
        Rx<int> currentIndex
      })> quizDatas = {};
  List<TextEditingController?> blankControllerList = [];

  startQuiz(QuizStartType quizStartType) {
    if (!quizDatas.containsKey(quizStartType)) {
      quizDatas.addAll({
        quizStartType: (
          quizData: _getQuizData(quizStartType),
          currentIndex: 0.obs,
          quizResultData: []
        )
      });
    }
  }

  List<Quiz> _getQuizData(QuizStartType quizStartType) {
    List<Quiz> result;
    switch (quizStartType) {
      case QuizStartType.today:
        result = _quizDataService.getTodayQuiz(QuizType.word) +
            _quizDataService.getTodayQuiz(QuizType.sentence);
        break;
      case QuizStartType.todayWord:
        result = _quizDataService.getTodayQuiz(QuizType.word);
        break;
      case QuizStartType.todaySentence:
        result = _quizDataService.getTodayQuiz(QuizType.sentence);
        break;
      case QuizStartType.todayWrong:
        result = _userDataService.todayWrongQuizResult.toQuizList();
        break;
      case QuizStartType.todayTried:
        result = _userDataService.todayWordQuizResult.toQuizList() +
            _userDataService.todaySentenceQuizResult.toQuizList();
        break;
      case QuizStartType.todayTriedWord:
        result = _userDataService.todayWordQuizResult.toQuizList();
        break;
      case QuizStartType.todayTriedSentence:
        result = _userDataService.todaySentenceQuizResult.toQuizList();
        break;
      case QuizStartType.important:
        result = _userDataService.importantWordQuizResult.toQuizList() +
            _userDataService.importantSentenceResult.toQuizList();
        break;
      case QuizStartType.importantWord:
        result = _userDataService.importantWordQuizResult.toQuizList();
        break;
      case QuizStartType.importantSentence:
        result = _userDataService.importantSentenceResult.toQuizList();
        break;
    }
    result.shuffle();
    return result;
  }

  completeQuiz(QuizStartType quizStartType) {
    for (var element in quizDatas[quizStartType]!.quizResultData) {
      _userDataService.triedQuiz(element);
    }
    quizDatas.remove(quizStartType);
  }

  increaseCurrentIndex(QuizStartType quizStartType) {
    quizDatas[quizStartType]!.currentIndex.value =
        quizDatas[quizStartType]!.currentIndex.value + 1;
  }

  decreaseCurrentIndex(QuizStartType quizStartType) {
    quizDatas[quizStartType]!.currentIndex.value =
        quizDatas[quizStartType]!.currentIndex.value - 1;
  }

  Rx<int> getCurrentIndex(QuizStartType quizStartType) {
    return quizDatas[quizStartType]!.currentIndex;
  }

  List<Quiz> getQuizData(QuizStartType quizStartType) {
    return quizDatas[quizStartType]!.quizData;
  }

  List<QuizResult> getQuizResultData(QuizStartType quizStartType) {
    return quizDatas[quizStartType]!.quizResultData;
  }

  bool isFirst(QuizStartType quizStartType) {
    return quizDatas[quizStartType]?.currentIndex.value == 0;
  }

  bool isLast(QuizStartType quizStartType) {
    return quizDatas[quizStartType]?.currentIndex.value ==
        quizDatas[quizStartType]!.quizData.length - 1;
  }

  Quiz currentQuiz(QuizStartType quizStartType) {
    return quizDatas[quizStartType]!
        .quizData[quizDatas[quizStartType]!.currentIndex.value];
  }
}
