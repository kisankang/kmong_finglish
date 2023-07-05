import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/models/quiz_result.dart';
import 'package:finglish/data/services/quiz_data_service.dart';
import 'package:finglish/data/services/quiz_play_service.dart';
import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/routes/app_pages.dart';
import 'package:finglish/utils/enums.dart';
import 'package:finglish/widgets/quiz_result_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class QuizController extends GetxController {
  // final QuizDataService _quizDataService;
  // final UserDataService _userDataService;
  final QuizPlayService quizPlayService;

  QuizController({
    // required QuizDataService quizDataService,
    // required UserDataService userDataService,
    required this.quizPlayService,
  });
  // _quizDataService = quizDataService,
  //       _userDataService = userDataService,

  int get quizResultIndex => quizResultData
      .indexWhere((element) => currentQuiz.quizId == element.quiz.quizId);

  loadQuizCard() {
    List<TextEditingController?> blankControllers = [];
    for (var element in currentQuiz.enHighlight) {
      element == true
          ? blankControllers.add(TextEditingController())
          : blankControllers.add(null);
    }
    quizPlayService.blankControllerList = blankControllers;
    if (quizResultIndex != -1) {
      QuizResult triedQuiz = quizResultData[quizResultIndex];
      isCorrect.value = triedQuiz.triedResult.last.isCorrect;
      isLiked.value = triedQuiz.isLiked;
      isHintOn.value = triedQuiz.triedResult.last.isHintOn;
      isCorrectAnswerOn.value = triedQuiz.triedResult.last.isCorrectAnswerOn;
      for (var i = 0; i < triedQuiz.quiz.en.length; i++) {
        if (triedQuiz.quiz.enHighlight[i]) {
          quizPlayService.blankControllerList[i]?.text = triedQuiz.quiz.en[i];
        }
      }
    } else {
      isCorrect.value = false;
      isLiked.value = false;
      isHintOn.value = false;
      isCorrectAnswerOn.value = false;
      if (quizStartType == QuizStartType.important ||
          quizStartType == QuizStartType.importantWord ||
          quizStartType == QuizStartType.importantSentence) {
        isLiked.value = true;
      }
    }
  }

  Rx<int> get currentIndex => quizPlayService.getCurrentIndex(quizStartType);
  bool get isFirst => quizPlayService.isFirst(quizStartType);
  bool get isLast => quizPlayService.isLast(quizStartType);
  late QuizStartType quizStartType;
  List<Quiz> get quizData => quizPlayService.getQuizData(quizStartType);
  Quiz get currentQuiz => quizPlayService.currentQuiz(quizStartType);
  List<QuizResult> get quizResultData =>
      quizPlayService.getQuizResultData(quizStartType);

  // List<TextEditingController?> _quizPlayService.blankControllerList = [];
  Rx<bool> isCorrect = false.obs;
  Rx<bool> isLiked = false.obs;
  Rx<bool> isHintOn = false.obs;
  Rx<bool> isCorrectAnswerOn = false.obs;

  onTapSeeHint() {
    isHintOn.value = true;
    for (var i = 0; i < quizPlayService.blankControllerList.length; i++) {
      if (quizPlayService.blankControllerList[i] != null) {
        quizPlayService.blankControllerList[i]!.text =
            currentQuiz.en[i].substring(0, 1);
      }
    }
  }

  onTapSeeCorrectAnswer() {
    isHintOn.value = true;
    isCorrectAnswerOn.value = true;
    for (var i = 0; i < quizPlayService.blankControllerList.length; i++) {
      if (quizPlayService.blankControllerList[i] != null) {
        quizPlayService.blankControllerList[i]!.text = currentQuiz.en[i];
      }
    }
    isCorrect.value = true;
    updateQuizResult();
  }

  @override
  onInit() {
    super.onInit();
    audioPlayer.setAsset('assets/good_sound.mp3');
    quizStartType = Get.arguments;
    quizPlayService.startQuiz(quizStartType);
    if (quizData.isNotEmpty) {
      loadQuizCard();
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

  updateQuizResult() async {
    if (quizResultIndex == -1) {
      quizResultData.add(QuizResult(
        quiz: currentQuiz,
        triedResult: [
          (
            triedTime: DateTime.now(),
            isCorrect: isCorrect.value,
            isCorrectAnswerOn: isCorrectAnswerOn.value,
            isHintOn: isHintOn.value
          )
        ],
        isLiked: isLiked.value,
      ));

      await updateState();
    }
  }

  updateState() async {
    UserDataService userDataService = Get.find();
    await userDataService.writeQuizPlayState(quizPlayService.quizDatas);
  }

  onTapLikeButton() {
    isLiked.toggle();
    if (quizResultIndex != -1) {
      quizResultData[quizResultIndex].isLiked = isLiked.value;
      updateState();
    }
  }

  onTapBefore() {
    quizPlayService.decreaseCurrentIndex(quizStartType);
    updateState();
    loadQuizCard();
  }

  onTapNext() {
    updateQuizResult();
    quizPlayService.increaseCurrentIndex(quizStartType);
    updateState();
    loadQuizCard();
  }

  onTapComplete() {
    updateQuizResult();
    Get.offNamedUntil(Routes.MAIN, (route) => false);
    Get.dialog(
      Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuizResultCard(quizResultDatas: quizResultData),
          ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('확인'))
        ],
      )),
    );
    quizPlayService.completeQuiz(quizStartType);
  }

  AudioPlayer audioPlayer = AudioPlayer();

  quizCardCorrectCallback() {
    isCorrect.value = true;
    audioPlayer.play();
    audioPlayer.load();
    updateQuizResult();
  }
}
