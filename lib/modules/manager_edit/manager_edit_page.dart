import 'package:finglish/modules/manager_edit/manager_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerEditPage extends GetWidget<ManagerEditController> {
  const ManagerEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('수정하기'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () {},
              child: Text('수정하기'),
            ),
          ],
        ),
      ),
    );
  }
}
