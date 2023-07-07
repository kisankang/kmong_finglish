import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/repositories/quiz_repository.dart';
import 'package:finglish/data/services/quiz_data_service.dart';
import 'package:finglish/utils/app_reg_exp.dart';
import 'package:finglish/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerManualController extends GetxController {
  final QuizRepository _quizRepository;
  final QuizDataService _quizDataService;
  ManagerManualController(
      {required QuizRepository quizRepository,
      required QuizDataService quizDataService})
      : _quizRepository = quizRepository,
        _quizDataService = quizDataService;

  Quiz? isEditMode;

  late Rx<int> pageIndex;
  late GlobalKey<FormState> formKey;

  late Rx<Quiz> quiz;
  late TextEditingController titleEditingController;
  late TextEditingController krEditingController;
  late TextEditingController enEditingController;
  @override
  onInit() {
    super.onInit();
    isEditMode = Get.arguments;
    if (isEditMode != null) {
      pageIndex = 1.obs;
      quiz = Rx(isEditMode!);
    } else {
      pageIndex = 0.obs;
      quiz = Rx(Quiz(
        quizId: 0,
        type: QuizType.word,
        title: [],
        titleHighLight: [],
        kr: [],
        krHighlight: [],
        en: [],
        enHighlight: [],
      ));
    }
    formKey = GlobalKey<FormState>();

    titleEditingController = TextEditingController();
    krEditingController = TextEditingController();
    enEditingController = TextEditingController();
  }

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
      }
    } else if (pageIndex.value == 1 && isEditMode != null) {
      quiz.update((val) {
        val?.lastUpdatedAt = DateTime.now().millisecondsSinceEpoch;
      });
    }
    pageIndex.value++;
  }

  onTapBack() {
    pageIndex.value--;
    if (pageIndex.value == 0) {
      _convertFromQuizToControllerData();
    }
  }

  _convertFromQuizToControllerData() {
    String title = '';
    for (var i = 0; i < quiz.value.title.length; i++) {
      if (i != 0) {
        title = '$title ';
      }
      title = title + quiz.value.title[i];
    }
    String kr = '';
    for (var i = 0; i < quiz.value.kr.length; i++) {
      if (i != 0) {
        kr = '$kr ';
      }
      kr = kr + quiz.value.kr[i];
    }
    String en = '';
    for (var i = 0; i < quiz.value.en.length; i++) {
      if (i != 0) {
        en = '$en ';
      }
      en = en + quiz.value.en[i];
    }

    titleEditingController.text = title;
    krEditingController.text = kr;
    enEditingController.text = en;
  }

  _createQuestionData() {
    quiz.update((val) {
      if (isEditMode == null) {
        val?.quizId = DateTime.now().millisecondsSinceEpoch;
      }
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
    if (isEditMode == null) {
      if (await _quizRepository.createQuiz(quiz.value)) {
        await _quizDataService.writeQuizData(quiz.value);
        titleEditingController.clear();
        krEditingController.clear();
        enEditingController.clear();
        pageIndex.value = 0;
      }
    } else {
      if (await _quizRepository.updateQuiz(quiz.value)) {
        await _quizDataService.updateQuizData(quiz.value);
        Get.back(result: quiz.value);
      }
    }
    Loading.off();
  }
}
