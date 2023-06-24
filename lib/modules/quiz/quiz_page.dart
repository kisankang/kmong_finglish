import 'package:finglish/modules/quiz/quiz_controller.dart';
import 'package:finglish/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPage extends GetWidget<QuizController> {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.quizDatas.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.quizStartType.text),
        ),
        body: Center(
            child: Text('준비된 ${controller.quizStartType.text} 퀴즈가 없습니다.')),
      );
    }

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.quizStartType.text),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        '${controller.selecteIndex.value + 1}/${controller.quizDatas.length}'),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.isLiked.toggle();
                            },
                            icon: Icon(
                              controller.isLiked.value
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: Colors.red,
                            )),
                      ],
                    ),
                    QuizCard(
                      quiz: controller.currentQuiz,
                      blankControllerList: controller.blankControllerList,
                      isHintOn: controller.isHintOn.value,
                      formKey: controller.formKey,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: controller.isFirst
                              ? null
                              : controller.onTapBefore,
                          child: const Column(
                            children: [
                              Icon(Icons.arrow_back_ios),
                              Text('이전 문제'),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: Get.back,
                              child: const Column(
                                children: [
                                  Icon(Icons.home),
                                  Text('홈으로'),
                                ],
                              ),
                            ),
                            if (controller.isHintOn.value == false)
                              ElevatedButton(
                                onPressed: controller.isHintOn.toggle,
                                child: const Column(
                                  children: [
                                    Icon(Icons.visibility_outlined),
                                    Text('힌트'),
                                  ],
                                ),
                              )
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: controller.isLast
                                  ? null
                                  : controller.onTapNext,
                              child: const Column(
                                children: [
                                  Icon(Icons.arrow_forward_ios),
                                  Text('다음 문제'),
                                ],
                              ),
                            ),
                            if (controller.isLast)
                              ElevatedButton(
                                onPressed: controller.onTapSubmit,
                                child: const Column(
                                  children: [
                                    Text('제출'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
