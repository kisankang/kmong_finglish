import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finglish/data/models/quiz.dart';
import 'package:flutter_excel/excel.dart';
import 'package:get/get.dart';

class ExcelHelper {
  static Future<Excel?> load() async {
    Excel? excel;

    try {
      File? file;
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
      if (pickedFile != null) {
        file = File(pickedFile.files.single.path!);
      } else {
        // User canceled the picker
      }
      if (file != null) {
        var bytes = file.readAsBytesSync();
        excel = Excel.decodeBytes(bytes);
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(message: e.toString()));
    }

    return excel;
  }

  static List<Quiz> convertFromExcel(Excel excel) {
    List<Quiz>? result = [];
    int quizId = DateTime.now().millisecondsSinceEpoch;
    for (String table in excel.tables.keys) {
      List<List<Data?>> fourRows = [];
      for (List<Data?> row in excel.tables[table]!.rows) {
        if (fourRows.length == 4) {
          fourRows = [];
        }
        row.removeWhere((element) => element == null);
        fourRows.add(row);
        if (fourRows.length == 4) {
          Quiz? quiz = _convertToQuizData(fourRows, quizId: quizId);
          if (quiz != null) {
            result.add(quiz);
          }
          quizId++;
        }
      }
    }
    return result;
  }

  static Quiz? _convertToQuizData(List<List<Data?>> fourRows,
      {required int quizId}) {
    Quiz? quiz;
    try {
      if (fourRows.length != 4) {
        return null;
      }
      QuizType type;
      List<String> title = [];
      List<bool> titleHighLight = [];
      List<String> kr = [];
      List<bool> krHighlight = [];
      List<String> en = [];
      List<bool> enHighlight = [];

      var typeRaw = (fourRows[0].first?.value);
      if (typeRaw == QuizType.word.text) {
        type = QuizType.word;
      } else if (typeRaw == QuizType.sentence.text) {
        type = QuizType.sentence;
      } else {
        return null;
      }

      var titleRaw = fourRows[1];
      for (var element in titleRaw) {
        var value = element?.value;
        var fontColor = element?.cellStyle?.fontColor;
        title.add(value);
        titleHighLight.add(!_isBlack(fontColor));
      }

      var krRaw = fourRows[2];
      for (var element in krRaw) {
        var value = element?.value;
        var fontColor = element?.cellStyle?.fontColor;
        kr.add(value);
        krHighlight.add(!_isBlack(fontColor));
      }

      var enRaw = fourRows[3];
      for (var element in enRaw) {
        var value = element?.value;
        var fontColor = element?.cellStyle?.fontColor;
        en.add(value);
        enHighlight.add(!_isBlack(fontColor));
      }

      quiz = Quiz(
          quizId: quizId,
          type: type,
          title: title,
          titleHighLight: titleHighLight,
          kr: kr,
          krHighlight: krHighlight,
          en: en,
          enHighlight: enHighlight);
    } catch (e) {}

    return quiz;
  }

  static bool _isBlack(String? fontColor) {
    bool result = true;
    if (fontColor != 'FF000000') {
      result = false;
    }
    return result;
  }
}
