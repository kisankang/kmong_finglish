// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizResult _$QuizResultFromJson(Map<String, dynamic> json) => QuizResult(
      quiz: Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
      triedTime: (json['triedTime'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      myAnswer: (json['myAnswer'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String?).toList())
          .toList(),
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$QuizResultToJson(QuizResult instance) =>
    <String, dynamic>{
      'quiz': instance.quiz.toJson(),
      'triedTime': instance.triedTime.map((e) => e.toIso8601String()).toList(),
      'myAnswer': instance.myAnswer,
      'isLiked': instance.isLiked,
    };
