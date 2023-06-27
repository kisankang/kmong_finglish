import 'package:finglish/modules/mode_select/mode_select_controller.dart';
import 'package:finglish/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeSelectPage extends GetWidget<ModeSelectController> {
  const ModeSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            body: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.toNamed(Routes.MAIN),
                    child: const Text('공부하기'),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {
                      TextEditingController pwEditingController =
                          TextEditingController();
                      final formKey = GlobalKey<FormState>();
                      Get.dialog(
                        Center(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('비밀번호'),
                                    SizedBox(
                                      width: Get.size.width * 0.6,
                                      child: TextFormField(
                                        controller: pwEditingController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value != '1541') {
                                            return '비밀번호가 틀렸습니다';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          Get.back();
                                          Get.toNamed(Routes.MANAGER_MAIN);
                                        }
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('관리자'),
                  ),
                ],
              ),
            ),
          ),
          if (!controller.quizDataService.isReady.value)
            Positioned.fill(
              child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: const Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text('퀴즈 데이터 동기화 중...')
                  ],
                )),
              ),
            ),
        ],
      ),
    );
  }
}
