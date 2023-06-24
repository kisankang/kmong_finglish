import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/models/quiz_result.dart';

extension OrderQuizList on List<Quiz> {
  /// Earlier comes first
  void orderByQuizId() {
    sort((a, b) => a.quizId.compareTo(b.quizId));
  }

  void sortBy(QuizType type) {
    List<Quiz> copy = toList();
    for (var element in copy) {
      if (element.type != type) {
        remove(element);
      }
    }
  }

  void removeTriedQuiz(List<QuizResult> quizResult) {
    List<Quiz> copy = toList();
    for (var element in copy) {
      if (quizResult.containsQuiz(element)) {
        remove(element);
      }
    }
  }
}

extension OrderQuizResultList on List<QuizResult> {
  /// Earlier comes first
  void orderByTriedTime() {
    sort((a, b) => a.triedTime.first.compareTo(b.triedTime.first));
  }

  void sortBy(QuizType type) {
    List<QuizResult> copy = toList();
    for (var element in copy) {
      if (element.quiz.type != type) {
        remove(element);
      }
    }
  }

  bool containsQuiz(Quiz quiz) {
    return indexWhere((element) => element.quiz.quizId == quiz.quizId) != -1;
  }

  List<Quiz> toQuizList() {
    List<Quiz> result = [];
    forEach((element) {
      result.add(element.quiz);
    });
    return result;
  }
}

extension countNumber on Quiz {
  int get howManyBlank {
    return enHighlight.where((element) => element == true).length;
  }
}
