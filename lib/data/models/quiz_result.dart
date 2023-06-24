import 'package:finglish/data/models/quiz.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_result.g.dart';

@JsonSerializable(explicitToJson: true)
class QuizResult {
  Quiz quiz;
  List<DateTime> triedTime;
  List<List<String?>> myAnswer;
  List<bool> get isCorrect {
    List<bool> result = [];
    for (var index = 0; index < myAnswer.length; index++) {
      bool isCorrect = true;
      for (var i = 0; i < quiz.enHighlight.length; i++) {
        if (quiz.enHighlight[i]) {
          if (quiz.en[i] != myAnswer[index][i]) {
            isCorrect = false;
            break;
          }
        }
      }
      result.add(isCorrect);
    }
    return result;
  }

  bool isLiked;
  QuizResult({
    required this.quiz,
    required this.triedTime,
    required this.myAnswer,
    required this.isLiked,
  });
  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);
  Map<String, dynamic> toJson() => _$QuizResultToJson(this);
}
