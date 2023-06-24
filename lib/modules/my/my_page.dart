import 'package:finglish/data/models/quiz_result.dart';
import 'package:finglish/modules/my/my_controller.dart';
import 'package:finglish/utils/enums.dart';
import 'package:finglish/widgets/custom_app_bar.dart';
import 'package:finglish/widgets/quiz_result_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends GetWidget<MyController> {
  const MyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _renderTargetSetting(
                title: '내 단어 목표설정',
                groupValue: controller.targetWordNumber,
                onChanged: controller.onChangedWordNumber,
              ),
              const SizedBox(height: 10),
              _renderTargetSetting(
                title: '내 문장 목표설정',
                groupValue: controller.targetSentenceNumber,
                onChanged: controller.onChangedSentenceNumber,
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              _renderReviewForToday(
                  title: '오늘의 학습내용',
                  quizResultDatas:
                      controller.localAppUserDataService.todayQuizResult,
                  onTapReview: () =>
                      controller.goToQuizPage(QuizStartType.todayTried)),
              const SizedBox(height: 10),
              _renderReviewForToday(
                  title: '오늘 배운 단어',
                  quizResultDatas:
                      controller.localAppUserDataService.todayWordQuizResult,
                  onTapReview: () =>
                      controller.goToQuizPage(QuizStartType.todayTriedWord)),
              const SizedBox(height: 10),
              _renderReviewForToday(
                  title: '오늘 배운 문장',
                  quizResultDatas: controller
                      .localAppUserDataService.todaySentenceQuizResult,
                  onTapReview: () => controller
                      .goToQuizPage(QuizStartType.todayTriedSentence)),
              const SizedBox(height: 10),
              _renderReviewForToday(
                  title: '중요한 단어 문장',
                  quizResultDatas:
                      controller.localAppUserDataService.importantQuizResult,
                  onTapReview: () =>
                      controller.goToQuizPage(QuizStartType.important)),
              const SizedBox(height: 10),
              _renderReviewForToday(
                  title: '오늘 틀린 문제',
                  quizResultDatas:
                      controller.localAppUserDataService.todayWrongQuizResult,
                  onTapReview: () =>
                      controller.goToQuizPage(QuizStartType.todayWrong)),
            ],
          ),
        ),
      ),
    );
  }

  _renderTargetSetting({
    required String title,
    required Rx<int> groupValue,
    required Function(int?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Get.textTheme.headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Obx(
          () => Row(
            children:
                List.generate(controller.targetSettingList.length, (index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                    value: controller.targetSettingList[index],
                    groupValue: groupValue.value,
                    onChanged: onChanged,
                  ),
                  Text('${controller.targetSettingList[index]}개')
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  DefaultTextStyle _renderReviewForToday({
    required String title,
    required List<QuizResult> quizResultDatas,
    required void Function()? onTapReview,
  }) {
    bool isOpened = false;
    return DefaultTextStyle(
      style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isOpened = !isOpened;
                    });
                  },
                  icon: isOpened
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                )
              ],
            ),
            if (isOpened)
              QuizResultCard(
                quizResultDatas: quizResultDatas,
                height: 200,
              ),
            ElevatedButton(
              onPressed: onTapReview,
              child: Text(
                '복습',
                style:
                    TextStyle(fontSize: Get.textTheme.headlineSmall?.fontSize)
                        .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }
}
