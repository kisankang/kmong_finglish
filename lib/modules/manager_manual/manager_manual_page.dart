import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/modules/manager_manual/manager_manual_controller.dart';
import 'package:finglish/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerManualPage extends GetWidget<ManagerManualController> {
  const ManagerManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('매뉴얼 업로드'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: controller.pageIndex.value != 0 &&
                        !(controller.pageIndex.value == 1 &&
                            controller.isEditMode != null),
                    child: OutlinedButton(
                      onPressed: controller.onTapBack,
                      child: const Text('뒤로'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Visibility(
                    visible: controller.pageIndex.value != 2,
                    child: ElevatedButton(
                      onPressed: controller.onTapNext,
                      child: const Text('다음'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: _renderPage(controller.pageIndex.value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderPage(expression) {
    switch (expression) {
      case 0:
        return _render1stPage();
      case 1:
        return _render2ndPage();
      case 2:
        return _render3rdPage();
    }
  }

  Widget _render3rdPage() {
    return Obx(
      () => Column(
        children: [
          QuizCard(
            quiz: controller.quiz.value,
          ),
          ElevatedButton(
              onPressed: controller.onTapSave, child: const Text('저장'))
        ],
      ),
    );
  }

  Widget _render2ndPage() {
    widgetSpans({
      required List<String> list,
      required List<bool> highlightList,
      required Function(int) onTap,
      required Color higlightColor,
    }) {
      return RichText(
        text: TextSpan(
          children: List.generate(
            list.length,
            (index) {
              return WidgetSpan(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    minimumSize: const Size(30, 30),
                  ),
                  onPressed: () => onTap(index),
                  child: Text(
                    list[index],
                    style: highlightList[index]
                        ? TextStyle(
                            fontSize: 24,
                            color: higlightColor,
                            fontWeight: FontWeight.bold,
                          )
                        : const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('퀴즈 타입'),
          _renderSelectQuizType(),
          const SizedBox(height: 15),
          const Text('제목, 주제, 핵심어구'),
          widgetSpans(
              list: controller.quiz.value.title,
              highlightList: controller.quiz.value.titleHighLight,
              onTap: controller.onTapTitleSpan,
              higlightColor: Colors.red),
          const SizedBox(height: 15),
          const Text('한국어'),
          widgetSpans(
              list: controller.quiz.value.kr,
              highlightList: controller.quiz.value.krHighlight,
              onTap: controller.onTapKrSpan,
              higlightColor: Colors.red),
          const SizedBox(height: 15),
          const Text('영어'),
          widgetSpans(
              list: controller.quiz.value.en,
              highlightList: controller.quiz.value.enHighlight,
              onTap: controller.onTapEnSpan,
              higlightColor: Colors.blue),
        ],
      ),
    );
  }

  Widget _render1stPage() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          _renderSelectQuizType(),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller.titleEditingController,
            validator: (value) => controller.titleValidator(value),
            decoration: const InputDecoration(
              labelText: '제목, 주제, 핵심어구',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller.krEditingController,
            validator: (value) => controller.krValidator(value),
            decoration: const InputDecoration(
              labelText: '(한글) 문장 입력',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller.enEditingController,
            validator: (value) => controller.enValidator(value),
            decoration: const InputDecoration(
              labelText: '(영어) 문장 입력',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Obx _renderSelectQuizType() {
    return Obx(
      () => SegmentedButton<QuizType>(
        segments: <ButtonSegment<QuizType>>[
          ButtonSegment<QuizType>(
            value: QuizType.word,
            label: Text(QuizType.word.text),
          ),
          ButtonSegment<QuizType>(
            value: QuizType.sentence,
            label: Text(QuizType.sentence.text),
          ),
        ],
        selected: <QuizType>{controller.quiz.value.type},
        onSelectionChanged: (Set<QuizType> newSelection) {
          controller.quiz.update((val) {
            val?.type = newSelection.first;
          });
        },
      ),
    );
  }
}
