import 'package:finglish/data/repositories/quiz_repository.dart';
import 'package:get/get.dart';

class ManagerEditController extends GetxController {
  final QuizRepository _quizRepository;
  ManagerEditController({required QuizRepository quizRepository})
      : _quizRepository = quizRepository;
}
