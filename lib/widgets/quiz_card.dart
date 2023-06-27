import 'package:finglish/common/style/app_color.dart';
import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/utils/widget_span_builder.dart';
import 'package:flutter/material.dart';

class QuizCard extends StatefulWidget {
  final Quiz quiz;
  final bool? isCheckedHint;
  final bool? isCheckedCorrectAnswer;
  final List<TextEditingController?>? blankControllerList;
  final Function()? correctCallBack;
  const QuizCard({
    super.key,
    required this.quiz,
    this.isCheckedHint,
    this.isCheckedCorrectAnswer,
    this.blankControllerList,
    this.correctCallBack,
  });

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  final double radius = 18;

  List<bool?> get isCorrect {
    if (widget.blankControllerList == null) {
      return [];
    }
    List<bool?> result = [];
    for (var i = 0; i < widget.quiz.enHighlight.length; i++) {
      if (widget.quiz.enHighlight[i]) {
        result.add(widget.quiz.en[i].toLowerCase() ==
            widget.blankControllerList?[i]?.text.toLowerCase());
      } else {
        result.add(null);
      }
    }
    return result;
  }

  bool get isAllCorrect {
    bool result = true;
    for (var element in isCorrect) {
      if (element == false) {
        result = false;
      }
    }
    return result;
  }

  bool isLastBlank(int index) {
    bool result = true;
    if (widget.blankControllerList == null) {
      return false;
    }
    for (var i = index; i < widget.blankControllerList!.length; i++) {
      if (i != index && widget.blankControllerList![i] != null) {
        result = false;
        break;
      }
    }

    return result;
  }

  quizDataBuilder({
    required List<String> textList,
    required List<bool> highightList,
    required Color highlightColor,
    required bool isQuiz,
    double fontSize = 28,
  }) {
    List<WidgetSpan> spans = List.generate(textList.length, (index) {
      String text = textList[index];
      if (highightList[index]) {
        if (isQuiz) {
          return WidgetSpanBuilder.blankBuilder(
            isDisabled: widget.blankControllerList == null,
            text: text,
            blankEditingController: putController(text, index),
            fontSize: fontSize,
            isLastBlank: isLastBlank(index),
            correctCallback: () {
              if (widget.correctCallBack != null && isAllCorrect) {
                widget.correctCallBack!();
                setState(() {});
              }
            },
          );
        } else {
          return WidgetSpanBuilder.textBuilder(
              text: text, color: highlightColor, fontSize: fontSize);
        }
      } else {
        return WidgetSpanBuilder.textBuilder(
            text: text, color: null, fontSize: fontSize);
      }
    });

    return Text.rich(TextSpan(children: spans));
  }

  TextEditingController putController(String text, int index) {
    if (widget.blankControllerList == null) {
      return TextEditingController(text: text);
    } else {
      // TextEditingController controller = widget.blankControllerList![index]!;
      // if (widget.isHintOn) {
      //   controller.text = text.substring(0, 1);
      // }
      return widget.blankControllerList![index]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: quizDataBuilder(
                          textList: widget.quiz.title,
                          highightList: widget.quiz.titleHighLight,
                          highlightColor: Colors.red,
                          fontSize: 16,
                          isQuiz: false),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  color: AppColors.grey,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(28),
                  child: quizDataBuilder(
                      textList: widget.quiz.kr,
                      highightList: widget.quiz.krHighlight,
                      highlightColor: Colors.red,
                      isQuiz: false),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(28),
                  child: quizDataBuilder(
                    textList: widget.quiz.en,
                    highightList: widget.quiz.enHighlight,
                    highlightColor: Colors.blue,
                    isQuiz: true,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isAllCorrect && widget.blankControllerList != null,
              child: Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.7),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: Icon(
                    widget.isCheckedHint == true ||
                            widget.isCheckedCorrectAnswer == true
                        ? Icons.check
                        : Icons.circle_outlined,
                    color: Colors.green,
                    size: 150,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
