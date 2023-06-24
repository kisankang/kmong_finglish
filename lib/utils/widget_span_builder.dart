import 'package:flutter/material.dart';

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
  }) {
    double blankWidth = 0.8 * fontSize * text.length;
    return WidgetSpan(
      alignment: PlaceholderAlignment.top,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: blankWidth,
              child: TextFormField(
                controller: blankEditingController,
                validator: (value) {
                  if (value == '') {
                    return '정답을 입력해주세요';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length >= text.length) {
                    setState(() {
                      blankWidth = 0.8 * fontSize * value.length;
                    });
                  }
                },
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
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
