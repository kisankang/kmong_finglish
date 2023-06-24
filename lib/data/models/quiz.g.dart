// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      quizId: json['quizId'] as int,
      type: $enumDecode(_$QuizTypeEnumMap, json['type']),
      title: (json['title'] as List<dynamic>).map((e) => e as String).toList(),
      titleHighLight: (json['titleHighLight'] as List<dynamic>)
          .map((e) => e as bool)
          .toList(),
      kr: (json['kr'] as List<dynamic>).map((e) => e as String).toList(),
      krHighlight:
          (json['krHighlight'] as List<dynamic>).map((e) => e as bool).toList(),
      en: (json['en'] as List<dynamic>).map((e) => e as String).toList(),
      enHighlight:
          (json['enHighlight'] as List<dynamic>).map((e) => e as bool).toList(),
    );

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'quizId': instance.quizId,
      'type': _$QuizTypeEnumMap[instance.type]!,
      'title': instance.title,
      'titleHighLight': instance.titleHighLight,
      'kr': instance.kr,
      'krHighlight': instance.krHighlight,
      'en': instance.en,
      'enHighlight': instance.enHighlight,
    };

const _$QuizTypeEnumMap = {
  QuizType.word: 'word',
  QuizType.sentence: 'sentence',
};
