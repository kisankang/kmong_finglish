import 'package:finglish/common/style/app_color.dart';
import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/utils/widget_span_builder.dart';
import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final List<TextEditingController?>? blankControllerList;
  final bool isHintOn;
  const QuizCard({
    super.key,
    required this.quiz,
    this.blankControllerList,
    this.isHintOn = false,
    this.formKey,
  });

  final GlobalKey<FormState>? formKey;

  final double radius = 18;

  quizDataBuilder({
    required List<String> textList,
    required List<bool> highightList,
    required Color highlightColor,
    required bool isQuiz,
    double fontSize = 28,
  }) {
    // textBuilder(String text, {Color? color}) => WidgetSpan(
    //       alignment: PlaceholderAlignment.top,
    //       child: Padding(
    //         padding: const EdgeInsets.only(right: 10),
    //         child: Text(
    //           text,
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontSize: fontSize,
    //             fontWeight: FontWeight.bold,
    //             color: color,
    //           ),
    //         ),
    //       ),
    //     );
    // blankBuilder(
    //   String text, {
    //   required TextEditingController blankEditingController,
    // }) =>
    //     WidgetSpan(
    //       alignment: PlaceholderAlignment.top,
    //       child: Padding(
    //         padding: const EdgeInsets.only(right: 10),
    //         child: SizedBox(
    //           width: 0.8 * fontSize * text.length,
    //           child: TextFormField(
    //             controller: blankEditingController,
    //             validator: (value) {
    //               if (value == '') {
    //                 return '정답을 입력해주세요';
    //               }
    //               return null;
    //             },
    //             style: TextStyle(
    //               fontSize: fontSize,
    //               fontWeight: FontWeight.bold,
    //             ),
    //             textAlign: TextAlign.center,
    //             decoration: const InputDecoration(
    //                 isDense: true,
    //                 contentPadding: EdgeInsets.all(0),
    //                 border: OutlineInputBorder(),
    //                 errorStyle: TextStyle(fontSize: 8)),
    //           ),
    //         ),
    //       ),
    //     );

    List<WidgetSpan> spans = List.generate(textList.length, (index) {
      String text = textList[index];
      if (highightList[index]) {
        if (isQuiz) {
          return WidgetSpanBuilder.blankBuilder(
              text: text,
              blankEditingController: putController(text, index),
              fontSize: fontSize);
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
    if (blankControllerList == null) {
      return TextEditingController(text: text);
    } else {
      TextEditingController controller = blankControllerList![index]!;
      if (isHintOn) {
        controller.text = text.substring(0, 1);
      }
      return blankControllerList![index]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: quizDataBuilder(
                      textList: quiz.title,
                      highightList: quiz.titleHighLight,
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
                  textList: quiz.kr,
                  highightList: quiz.krHighlight,
                  highlightColor: Colors.red,
                  isQuiz: false),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(28),
              child: quizDataBuilder(
                textList: quiz.en,
                highightList: quiz.enHighlight,
                highlightColor: Colors.blue,
                isQuiz: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
