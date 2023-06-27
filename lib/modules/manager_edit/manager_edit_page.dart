import 'package:finglish/data/models/quiz.dart';
import 'package:finglish/modules/manager_edit/manager_edit_controller.dart';
import 'package:finglish/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerEditPage extends GetWidget<ManagerEditController> {
  const ManagerEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('수정하기'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    QuizCard(
                        quiz: controller
                            .quizData.value[controller.currentIndex.value]),
                    Positioned.fill(
                        child: Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () => controller.onTapStartEdit(controller
                              .quizData.value[controller.currentIndex.value]),
                          child: const Text('수정하러 가기'),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: controller.quizData.value.length,
                    itemBuilder: (context, index) {
                      Quiz quiz = controller.quizData.value[index];
                      return GestureDetector(
                        onTap: () {
                          controller.currentIndex.value = index;
                        },
                        child: Card(
                          child: ListTile(
                            selected: index == controller.currentIndex.value,
                            leading: Text((index + 1).toString()),
                            title: Text(
                              quiz.title.toString(),
                            ),
                            subtitle: Text(
                              DateTime.fromMillisecondsSinceEpoch(quiz.quizId)
                                  .toString(),
                            ),
                            trailing: index != controller.currentIndex.value
                                ? null
                                : quiz.deletedAt != null
                                    ? IconButton(
                                        onPressed: () =>
                                            controller.onTapUndoDelete(quiz),
                                        icon: const Icon(Icons.undo_outlined),
                                      )
                                    : IconButton(
                                        onPressed: () =>
                                            controller.onTapDelete(quiz),
                                        icon: const Icon(Icons.delete_outline),
                                      ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
