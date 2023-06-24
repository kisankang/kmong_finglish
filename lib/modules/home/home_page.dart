import 'package:finglish/common/style/app_color.dart';
import 'package:finglish/common/style/app_style.dart';
import 'package:finglish/modules/home/home_controller.dart';
import 'package:finglish/utils/enums.dart';
import 'package:finglish/widgets/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(automaticallyImplyLeading: true),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              TextButton.icon(
                onPressed: () => controller.onTapDrawerItem(0),
                icon: const Icon(Icons.home),
                label: const Text('home'),
              ),
              TextButton.icon(
                onPressed: () => controller.onTapDrawerItem(1),
                icon: const Icon(Icons.check_box),
                label: const Text('word'),
              ),
              TextButton.icon(
                onPressed: () => controller.onTapDrawerItem(2),
                icon: const Icon(Icons.checklist),
                label: const Text('sentence'),
              ),
              TextButton.icon(
                onPressed: () => controller.onTapDrawerItem(3),
                icon: const Icon(Icons.person),
                label: const Text('my'),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.whiteBlue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _renderTodayStatus(),
                  const SizedBox(height: 20),
                  _renderStartButton(
                    title: '오늘의 단어 시작',
                    onTap: () =>
                        controller.goToQuizPage(QuizStartType.todayWord),
                  ),
                  const SizedBox(height: 10),
                  _renderStartButton(
                    title: '오늘의 문장 시작',
                    onTap: () =>
                        controller.goToQuizPage(QuizStartType.todaySentence),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            _renderCheerUpCommentBox(),
            const SizedBox(height: 10),
            _renderResultOfToday(),
            const SizedBox(height: 12),
            _renderReviewForImportant(
              title: '중요한 단어',
              onTap: () => controller.goToQuizPage(QuizStartType.importantWord),
            ),
            const SizedBox(height: 12),
            _renderReviewForImportant(
              title: '중요한 문장',
              onTap: () =>
                  controller.goToQuizPage(QuizStartType.importantSentence),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _renderReviewForToday(
                    title: '오늘 틀린 문제',
                    howMany: controller.theNumberOfTodayWrong(),
                    onTap: () =>
                        controller.goToQuizPage(QuizStartType.todayWrong),
                  ),
                  _renderReviewForToday(
                    title: '오늘 배운 단어',
                    howMany: controller.theNumberOfTodayWord(),
                    onTap: () =>
                        controller.goToQuizPage(QuizStartType.todayTriedWord),
                  ),
                  _renderReviewForToday(
                    title: '오늘 배운 문장',
                    howMany: controller.theNumberOfTodaySentence(),
                    onTap: () => controller
                        .goToQuizPage(QuizStartType.todayTriedSentence),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _renderTodayStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            "HA's",
            style: TextStyle(fontSize: Get.textTheme.headlineSmall?.fontSize)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 40),
        Text(
          '${controller.todayTargetRate()}\n오늘의 목표',
          textAlign: TextAlign.center,
          style: Get.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  ElevatedButton _renderStartButton({
    required String title,
    required Function()? onTap,
  }) {
    return ElevatedButton(
      style: AppStyle.roundElevatedButton,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Text(
          title,
          style: TextStyle(fontSize: Get.textTheme.headlineSmall?.fontSize)
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  DefaultTextStyle _renderResultOfToday() {
    return DefaultTextStyle(
      style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('오늘의 정답률'),
          const SizedBox(width: 50),
          Text(controller.todayCorrectAnswerRate()),
        ],
      ),
    );
  }

  Container _renderCheerUpCommentBox() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      color: AppColors.yellow,
      child: Text(
        '용돈 받으려면 열심히',
        style: TextStyle(
                fontSize: Get.textTheme.headlineSmall?.fontSize,
                color: Get.theme.colorScheme.onPrimary)
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  DefaultTextStyle _renderReviewForImportant({
    required String title,
    required Function()? onTap,
  }) {
    return DefaultTextStyle(
      style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(width: 20),
          ElevatedButton(
            style: AppStyle.roundElevatedButton,
            onPressed: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                '복습하기',
                style:
                    TextStyle(fontSize: Get.textTheme.headlineSmall?.fontSize)
                        .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DefaultTextStyle _renderReviewForToday({
    required String title,
    required String howMany,
    required void Function()? onTap,
  }) {
    return DefaultTextStyle(
      style: Get.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              const SizedBox(width: 20),
              Text(howMany),
            ],
          ),
          ElevatedButton(
            style: AppStyle.roundElevatedButton,
            onPressed: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                '복습하기',
                style:
                    TextStyle(fontSize: Get.textTheme.headlineSmall?.fontSize)
                        .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
