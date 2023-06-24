import 'package:json_annotation/json_annotation.dart';

part 'quiz.g.dart';

@JsonSerializable()
class Quiz {
  int quizId; // createdAt
  QuizType type;
  List<String> title;
  List<bool> titleHighLight;
  List<String> kr;
  List<bool> krHighlight;
  List<String> en;
  List<bool> enHighlight;

  Quiz({
    required this.quizId,
    required this.type,
    required this.title,
    required this.titleHighLight,
    required this.kr,
    required this.krHighlight,
    required this.en,
    required this.enHighlight,
  });
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

enum QuizType {
  word('word'),
  sentence('sentence');

  final String text;
  const QuizType(this.text);
}
