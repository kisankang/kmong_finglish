import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/repositories/quiz_repository.dart';
import 'package:finglish/data/services/quiz_data_service.dart';
import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/utils/app_reg_exp.dart';
import 'package:finglish/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerController extends GetxController {
  QuizRepository _quizRepository;
  ManagerController({required QuizRepository quizRepository})
      : _quizRepository = quizRepository;

  Rx<int> pageIndex = 0.obs;
  final formKey = GlobalKey<FormState>();

  Rx<Quiz> quiz = Rx(Quiz(
    quizId: 0,
    type: QuizType.word,
    title: [],
    titleHighLight: [],
    kr: [],
    krHighlight: [],
    en: [],
    enHighlight: [],
  ));
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController krEditingController = TextEditingController();
  TextEditingController enEditingController = TextEditingController();

  titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '입력해주세요.';
    }
  }

  krValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '입력해주세요.';
    }
    if (AppRegExp.en.hasMatch(value)) {
      return '한글로 입력하세요';
    }
  }

  enValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '입력해주세요.';
    }
    if (AppRegExp.kr.hasMatch(value)) {
      return '영어로 입력하세요';
    }
  }

  onTapNext() {
    if (pageIndex.value == 0) {
      if (formKey.currentState?.validate() == true) {
        _createQuestionData();
      } else {
        return;
      }
    }

    pageIndex.value++;
  }

  onTapBack() {
    pageIndex.value--;
  }

  _createQuestionData() {
    quiz.update((val) {
      val?.quizId = DateTime.now().millisecondsSinceEpoch;
      val?.title = titleEditingController.text.split(AppRegExp.space);
      val?.titleHighLight = List.generate(val.title.length, (index) => false);
      val?.kr = krEditingController.text.split(AppRegExp.space);
      val?.krHighlight = List.generate(val.kr.length, (index) => false);
      val?.en = enEditingController.text.split(AppRegExp.space);
      val?.enHighlight = List.generate(val.en.length, (index) => false);
    });
  }

  onTapTitleSpan(int index) {
    quiz.update((val) {
      val?.titleHighLight[index] = !val.titleHighLight[index];
    });
  }

  onTapKrSpan(int index) {
    quiz.update((val) {
      val?.krHighlight[index] = !val.krHighlight[index];
    });
  }

  onTapEnSpan(int index) {
    quiz.update((val) {
      val?.enHighlight[index] = !val.enHighlight[index];
    });
  }

  onTapSave() async {
    Loading.on();
    if (await _quizRepository.createQuiz(quiz.value)) {
      titleEditingController.clear();
      krEditingController.clear();
      enEditingController.clear();
      pageIndex.value = 0;
    }
    Loading.off();
  }

  eraseLocalData() async {
    QuizDataService quiz = Get.find();
    UserDataService user = Get.find();
    await quiz.eraseAll();
    await user.eraseAll();
  }
}
