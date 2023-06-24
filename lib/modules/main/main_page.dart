import 'package:finglish/modules/home/home_page.dart';
import 'package:finglish/modules/main/main_controller.dart';
import 'package:finglish/modules/my/my_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends GetWidget<MainController> {
  const MainPage({super.key});

  pageView(expression) {
    switch (expression) {
      case 0:
        return const HomePage();
      case 3:
        return const MyPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          body: pageView(controller.pageIndex.value),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.onTapBottomNavigationBarItem,
            currentIndex: controller.pageIndex.value,
            selectedItemColor: Get.theme.colorScheme.primary,
            unselectedItemColor: Get.theme.colorScheme.secondary,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box), label: 'word'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.checklist), label: 'sentence'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'my'),
            ],
          )),
    );
  }
}
