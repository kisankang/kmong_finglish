import 'package:finglish/modules/quiz/quiz_controller.dart';
import 'package:finglish/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPage extends GetWidget<QuizController> {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.quizPlayService
        .getQuizData(controller.quizStartType)
        .isEmpty) {
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(controller.quizStartType.text),
          actions: [_renderPageIndicator(), const SizedBox(width: 10)],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          QuizCard(
                            quiz: controller.currentQuiz,
                            blankControllerList:
                                controller.quizPlayService.blankControllerList,
                            isCheckedHint: controller.isHintOn.value,
                            isCheckedCorrectAnswer:
                                controller.isCorrectAnswerOn.value,
                            correctCallBack: controller.quizCardCorrectCallback,
                          ),
                          Positioned(
                              bottom: 0, right: 0, child: _renderLikeButton()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _renderHelperButton(),
                    ],
                  ),
                ),
              ),
              _renderNavigationButton()
            ],
          ),
        ),
      );
    });
  }

  Row _renderPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
            '${controller.currentIndex.value + 1}/${controller.quizPlayService.getQuizData(controller.quizStartType).length}'),
      ],
    );
  }

  Row _renderLikeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: controller.onTapLikeButton,
            icon: Icon(
              controller.isLiked.value
                  ? Icons.favorite
                  : Icons.favorite_outline,
              color: Colors.red,
            )),
      ],
    );
  }

  Visibility _renderHelperButton() {
    return Visibility(
      visible: controller.quizResultIndex == -1 &&
          controller.isCorrect.value == false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (controller.isCorrectAnswerOn.value == false)
            ElevatedButton(
              onPressed: controller.onTapSeeCorrectAnswer,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('정답\n보기'),
              ),
            ),
          const SizedBox(width: 10),
          if (controller.isHintOn.value == false)
            ElevatedButton(
              onPressed: controller.onTapSeeHint,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('힌트\n보기'),
              ),
            ),
        ],
      ),
    );
  }

  Row _renderNavigationButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: controller.isFirst ? null : controller.onTapBefore,
          child: const Column(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 48,
              ),
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
                  Icon(
                    Icons.home,
                    size: 48,
                  ),
                  Text('홈으로'),
                ],
              ),
            ),
          ],
        ),
        if (controller.isLast)
          ElevatedButton(
            onPressed:
                controller.isCorrect.value ? controller.onTapComplete : null,
            child: const Column(
              children: [
                Icon(
                  Icons.done_all,
                  size: 48,
                ),
                Text('완료'),
              ],
            ),
          )
        else
          ElevatedButton(
            onPressed: controller.isCorrect.value ? controller.onTapNext : null,
            child: const Column(
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  size: 48,
                ),
                Text('다음 문제'),
              ],
            ),
          ),
      ],
    );
  }
}
