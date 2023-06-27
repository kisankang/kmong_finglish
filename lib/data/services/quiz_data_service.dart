import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/models/quiz_result.dart';
import 'package:finglish/data/repositories/quiz_repository.dart';
import 'package:finglish/data/services/user_data_service.dart';
import 'package:finglish/utils/get_stroage_key.dart';
import 'package:finglish/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QuizDataService extends GetxService {
  @override
  Future<void> onInit() async {
    super.onInit();
    await init();
  }

  Rx<bool> isReady = false.obs;

  Future<void> init() async {
    await GetStorage.init(GetStorageKey.QUIZ_CONTAINER);

    QuizRepository quizRepository = Get.find();

    List<Quiz> result = [];
    List<Quiz>? quiz = await quizRepository.getAllAfter(lastQuizId);
    result.addAll(quiz as Iterable<Quiz>);
    for (var element in result) {
      await writeQuizData(element);
    }
    List<Quiz> resultForUpdatedQuiz = [];
    List<Quiz>? updatedQuiz = await quizRepository.getAllUpdatedQuiz();
    resultForUpdatedQuiz.addAll(updatedQuiz as Iterable<Quiz>);
    for (var element in resultForUpdatedQuiz) {
      await updateQuizData(element);
    }
    List<Quiz> resultForDeletedQuiz = [];
    List<Quiz>? deletedQuiz = await quizRepository.getAllDeletededQuiz();
    resultForDeletedQuiz.addAll(deletedQuiz as Iterable<Quiz>);
    for (var element in resultForDeletedQuiz) {
      await updateQuizData(element);
    }

    isReady.value = true;
  }

  GetStorage? _quizStorage;
  GetStorage get quizStorage {
    _quizStorage ??= GetStorage(GetStorageKey.QUIZ_CONTAINER);
    return _quizStorage!;
  }

  int get lastQuizId {
    Iterable iterableKeys = quizStorage.getKeys();
    if (iterableKeys.isEmpty) {
      return 0;
    }
    List<String> keys = iterableKeys.toList() as List<String>;
    String result = keys.reduce(
        (curr, next) => int.parse(curr) > int.parse(next) ? curr : next);
    return int.parse(result);
  }

  Future writeQuizData(Quiz quiz) async {
    Iterable iterableKeys = quizStorage.getKeys();
    List<String> keys = iterableKeys.toList() as List<String>;
    if (!keys.contains(quiz.quizId.toString())) {
      await quizStorage.write(quiz.quizId.toString(), quiz.toJson());
    }
  }

  Future updateQuizData(Quiz quiz) async {
    Iterable iterableKeys = quizStorage.getKeys();
    List<String> keys = iterableKeys.toList() as List<String>;
    if (keys.contains(quiz.quizId.toString())) {
      await quizStorage.write(quiz.quizId.toString(), quiz.toJson());
    }
  }

  List<Quiz> readAll() {
    List<Quiz> result = [];
    Iterable list = quizStorage.getValues();
    for (var element in list) {
      Quiz quiz = Quiz.fromJson(element);
      if (quiz.deletedAt == null) {
        result.add(quiz);
      }
    }
    return result;
  }

  List<Quiz> getTodayQuiz(QuizType type) {
    List<Quiz> result = [];
    List<Quiz> quizList = readAll();
    quizList.sortBy(type);

    UserDataService userDataService = Get.find();
    List<QuizResult> triedList = userDataService.quizResultList(type);
    quizList.removeTriedQuiz(triedList);

    int howManyLoadMore = userDataService.loadHowManyQuizForToday(type);
    if (howManyLoadMore > quizList.length) {
      howManyLoadMore = quizList.length;
    }
    for (var i = 0; i < howManyLoadMore; i++) {
      result.add(quizList[i]);
    }

    return result;
  }

  eraseAll() async {
    await quizStorage.erase();
  }
}
