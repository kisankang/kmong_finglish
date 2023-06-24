import 'package:finglish/data/models/quiz_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  String? name;
  List<QuizResult> quizResult;
  int targetWordNumber;
  int targetSentenceNumber;
  AppUser({
    required this.name,
    required this.quizResult,
    required this.targetWordNumber,
    required this.targetSentenceNumber,
  });
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
