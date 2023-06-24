import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/utils/enums.dart';
import 'package:get/get.dart';

class QuizPlayService extends GetxService {
  Map<QuizStartType, (List<Quiz> data, int currentIndex)> quizDatas = {};
}
