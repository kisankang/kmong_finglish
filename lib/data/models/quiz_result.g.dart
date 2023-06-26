// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizResult _$QuizResultFromJson(Map<String, dynamic> json) => QuizResult(
      quiz: Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
      triedResult: (json['triedResult'] as List<dynamic>)
          .map((e) => _$recordConvert(
                e,
                ($jsonValue) => (
                  isCorrect: $jsonValue['isCorrect'] as bool,
                  isCorrectAnswerOn: $jsonValue['isCorrectAnswerOn'] as bool,
                  isHintOn: $jsonValue['isHintOn'] as bool,
                  triedTime: DateTime.parse($jsonValue['triedTime'] as String),
                ),
              ))
          .toList(),
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$QuizResultToJson(QuizResult instance) =>
    <String, dynamic>{
      'quiz': instance.quiz.toJson(),
      'isLiked': instance.isLiked,
      'triedResult': instance.triedResult
          .map((e) => {
                'isCorrect': e.isCorrect,
                'isCorrectAnswerOn': e.isCorrectAnswerOn,
                'isHintOn': e.isHintOn,
                'triedTime': e.triedTime.toIso8601String(),
              })
          .toList(),
    };

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
