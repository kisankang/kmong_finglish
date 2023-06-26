import 'package:finglish/data/models/app_user.dart';
import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/models/quiz_result.dart';
import 'package:finglish/utils/get_stroage_key.dart';
import 'package:finglish/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserDataService extends GetxService {
  @override
  Future<void> onInit() async {
    super.onInit();
    await init();
  }

  Future<void> init() async {
    await GetStorage.init(GetStorageKey.APP_USER_CONTAINER);
    AppUser? appUser;
    if (appUserStorage.read(GetStorageKey.APP_USER) != null) {
      appUser = AppUser.fromJson(appUserStorage.read(GetStorageKey.APP_USER));
    }
    if (appUser == null) {
      await appUserStorage.write(
        GetStorageKey.APP_USER,
        AppUser(
          name: null,
          quizResult: [],
          targetSentenceNumber: 20,
          targetWordNumber: 20,
        ).toJson(),
      );
    }
  }

  GetStorage? _appUserStorage;
  GetStorage get appUserStorage {
    _appUserStorage ??= GetStorage(GetStorageKey.APP_USER_CONTAINER);
    return _appUserStorage!;
  }

  AppUser get appUser =>
      AppUser.fromJson(appUserStorage.read(GetStorageKey.APP_USER));

  updateAppUser(AppUser user) async =>
      await appUserStorage.write(GetStorageKey.APP_USER, user.toJson());

  Future triedQuiz(QuizResult quizResult) async {
    AppUser user = appUser;
    int sameQuizIdIndex = user.quizResult
        .indexWhere((element) => element.quiz.quizId == quizResult.quiz.quizId);
    if (sameQuizIdIndex == -1) {
      user.quizResult.add(quizResult);
    } else {
      user.quizResult[sameQuizIdIndex] = quizResult;
    }
    await updateAppUser(user);
  }

  List<QuizResult> quizResultList(QuizType type) {
    List<QuizResult> quizResultList = appUser.quizResult.toList();
    quizResultList.sortBy(type);
    quizResultList.orderByTriedTime();
    return quizResultList;
  }

  List<QuizResult> quizResultListOnLastDay(QuizType type) {
    List<QuizResult> result = [];
    List<QuizResult> wordQuizResultList = quizResultList(type);
    if (wordQuizResultList.isEmpty) {
      return result;
    }
    QuizResult lastTriedQuiz = wordQuizResultList.last;

    DateTime lastDay = lastTriedQuiz.triedResult.first.triedTime;

    for (var element in wordQuizResultList) {
      DateTime triedTime = element.triedResult.first.triedTime;
      if (!(lastDay.year == triedTime.year &&
          lastDay.month == triedTime.month &&
          lastDay.day == triedTime.day)) {
        wordQuizResultList.remove(element);
      }
    }
    result = wordQuizResultList;
    return result;
  }

  targetNumber(QuizType type) {
    return type == QuizType.word
        ? appUser.targetWordNumber
        : appUser.targetSentenceNumber;
  }

  int loadHowManyQuizForToday(QuizType type) {
    int result;
    List<QuizResult> listOnLastDay = quizResultListOnLastDay(type);
    if (listOnLastDay.isEmpty) {
      return targetNumber(type);
    }
    DateTime lastDay = listOnLastDay.last.triedResult.last.triedTime;
    DateTime now = DateTime.now();
    if (lastDay.year == now.year &&
        lastDay.month == now.month &&
        lastDay.day == now.day) {
      if (targetNumber(type) > listOnLastDay.length) {
        result = targetNumber(type) - listOnLastDay.length;
      } else {
        result = targetNumber(type);
      }
    } else {
      result = targetNumber(type);
    }
    return result;
  }

  List<QuizResult> get importantQuizResult {
    List<QuizResult> result = [];
    for (var element in appUser.quizResult) {
      if (element.isLiked) {
        result.add(element);
      }
    }
    return result;
  }

  List<QuizResult> get importantWordQuizResult {
    List<QuizResult> result = [];
    for (var element in importantQuizResult) {
      if (element.quiz.type == QuizType.word) {
        result.add(element);
      }
    }
    return result;
  }

  List<QuizResult> get importantSentenceResult {
    List<QuizResult> result = [];
    for (var element in importantQuizResult) {
      if (element.quiz.type == QuizType.sentence) {
        result.add(element);
      }
    }
    return result;
  }

  List<QuizResult> get todayQuizResult {
    List<QuizResult> result = [];
    for (var element in appUser.quizResult) {
      DateTime lastTried = element.triedResult.last.triedTime;
      DateTime today = DateTime.now();
      if (lastTried.year == today.year &&
          lastTried.month == today.month &&
          lastTried.day == today.day) {
        result.add(element);
      }
    }
    return result;
  }

  List<QuizResult> get todayWordQuizResult {
    List<QuizResult> result = [];
    for (var element in todayQuizResult) {
      if (element.quiz.type == QuizType.word) {
        result.add(element);
      }
    }
    return result;
  }

  List<QuizResult> get todaySentenceQuizResult {
    List<QuizResult> result = [];
    for (var element in todayQuizResult) {
      if (element.quiz.type == QuizType.sentence) {
        result.add(element);
      }
    }
    return result;
  }

  List<QuizResult> get todayWrongQuizResult {
    List<QuizResult> result = [];
    for (var element in todayQuizResult) {
      if (element.triedResult.first.isCorrectAnswerOn ||
          element.triedResult.first.isHintOn) {
        result.add(element);
      }
    }
    return result;
  }

  eraseAll() async {
    await appUserStorage.erase();
  }
}
