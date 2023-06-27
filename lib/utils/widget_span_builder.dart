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
    required double fontSize,
    required bool isLastBlank,
    required Function()? correctCallback,
    required bool isDisabled,
  }) {
    getWidth(int textLength) => 0.8 * fontSize * textLength;
    double blankWidth = getWidth(text.length);
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
                  if (value.length >= text.length) {
                    blankWidth = getWidth(value.length);
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
