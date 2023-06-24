// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      name: json['name'] as String?,
      quizResult: (json['quizResult'] as List<dynamic>)
          .map((e) => QuizResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetWordNumber: json['targetWordNumber'] as int,
      targetSentenceNumber: json['targetSentenceNumber'] as int,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'name': instance.name,
      'quizResult': instance.quizResult.map((e) => e.toJson()).toList(),
      'targetWordNumber': instance.targetWordNumber,
      'targetSentenceNumber': instance.targetSentenceNumber,
    };
