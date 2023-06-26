import 'package:finglish/data/models/quiz_result.dart';
import 'package:finglish/utils/widget_span_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizResultCard extends StatelessWidget {
  final List<QuizResult> quizResultDatas;
  final double? height;
  final bool hideFirstRow;
  const QuizResultCard({
    super.key,
    required this.quizResultDatas,
    this.height,
    this.hideFirstRow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: quizResultDatas.isEmpty
          ? const ListTile(title: Text('내용이 없습니다.'))
          : SizedBox(
              height: height ?? Get.size.height * 0.5,
              child: Column(
                children: [
                  if (!hideFirstRow)
                    const ListTile(
                      leading: Text('문제\n번호'),
                      title: Text('문제 제목'),
                      trailing: Text('정답\n결과'),
                    ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: quizResultDatas.length,
                      itemBuilder: (context, index) {
                        List<WidgetSpan> list = List.generate(
                            quizResultDatas[index].quiz.title.length, (i) {
                          return WidgetSpanBuilder.textBuilder(
                              text: quizResultDatas[index].quiz.title[i],
                              color: Colors.black,
                              fontSize: 14);
                        });

                        return ListTile(
                          leading: Text((index + 1).toString()),
                          title: Text.rich(TextSpan(children: list)),
                          trailing: quizResultDatas[index]
                                      .triedResult
                                      .last
                                      .isCorrectAnswerOn ||
                                  quizResultDatas[index]
                                      .triedResult
                                      .last
                                      .isHintOn
                              ? const Icon(Icons.check)
                              : const Icon(Icons.circle_outlined),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
