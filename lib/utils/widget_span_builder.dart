import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetSpanBuilder {
  static WidgetSpan textBuilder({
    required String text,
    required Color? color,
    required double? fontSize,
  }) =>
      WidgetSpan(
        alignment: PlaceholderAlignment.top,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      );

  static WidgetSpan blankBuilder({
    required String text,
    required TextEditingController blankEditingController,
    FocusNode? focusNode,
    required double fontSize,
    required bool isLastBlank,
    required Function()? correctCallback,
    required bool isDisabled,
  }) {
    calWidth(String text) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
        textDirection: TextDirection.ltr,
      )..layout();
      return textPainter.size.width + 20;
    }

    double blankWidth = calWidth(text);

    bool isCorrect = false;
    return WidgetSpan(
      alignment: PlaceholderAlignment.top,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: blankWidth,
              child: TextFormField(
                focusNode: focusNode,
                readOnly: isDisabled,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isCorrect ? Colors.blue : null,
                  fontWeight: FontWeight.bold,
                ),
                textInputAction:
                    isLastBlank ? TextInputAction.done : TextInputAction.next,
                controller: blankEditingController,
                validator: (value) {
                  if (value == '') {
                    return '정답을 입력해주세요';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (calWidth(value) >= calWidth(text)) {
                    blankWidth = calWidth(value);
                  }
                  if (text.toLowerCase() ==
                      blankEditingController.text.toLowerCase()) {
                    isCorrect = true;
                    isLastBlank
                        ? Get.focusScope?.unfocus()
                        : Get.focusScope?.nextFocus();
                    if (correctCallback != null) {
                      correctCallback();
                    }
                  } else {
                    isCorrect = false;
                  }
                  setState(() {});
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(fontSize: 8)),
              ),
            );
          },
        ),
      ),
    );
  }
}
