import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/data/models/quiz_result.dart';
import 'package:finglish/utils/enums.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

class JsonConvertor {
  static Map<String, dynamic> quizPlayStateToJson(
      Map<
              QuizStartType,
              ({
                List<QuizResult> quizResultData,
                List<Quiz> quizData,
                Rx<int> currentIndex
              })>
          state) {
    return state.map((k, e) => MapEntry(_$QuizStartTypeEnumMap[k]!, {
          'currentIndex': e.currentIndex.value,
          'quizData': e.quizData.map((e) => e.toJson()).toList(),
          'quizResultData': e.quizResultData.map((e) => e.toJson()).toList(),
        }));
  }

  static Map<
      QuizStartType,
      ({
        List<QuizResult> quizResultData,
        List<Quiz> quizData,
        Rx<int> currentIndex
      })> quizPlayStateFromJson(Map<String, dynamic> json) {
    return json.map(
      (k, e) => MapEntry(
          $enumDecode(_$QuizStartTypeEnumMap, k),
          _$recordConvert(
            e,
            ($jsonValue) => (
              currentIndex: Rx($jsonValue['currentIndex'] as int),
              quizData: ($jsonValue['quizData'] as List<dynamic>)
                  .map((e) => Quiz.fromJson(e as Map<String, dynamic>))
                  .toList(),
              quizResultData: ($jsonValue['quizResultData'] as List<dynamic>)
                  .map((e) => QuizResult.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          )),
    );
  }
}

const _$QuizStartTypeEnumMap = {
  QuizStartType.today: 'today',
  QuizStartType.todayWord: 'todayWord',
  QuizStartType.todaySentence: 'todaySentence',
  QuizStartType.todayWrong: 'todayWrong',
  QuizStartType.todayTried: 'todayTried',
  QuizStartType.todayTriedWord: 'todayTriedWord',
  QuizStartType.todayTriedSentence: 'todayTriedSentence',
  QuizStartType.important: 'important',
  QuizStartType.importantWord: 'importantWord',
  QuizStartType.importantSentence: 'importantSentence',
};

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
