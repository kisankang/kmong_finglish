import 'package:finglish/modules/manager_main/manager_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerMainPage extends GetWidget<ManagerMainController> {
  const ManagerMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('관리자 페이지'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.onTapManualUpload,
                  label: const Text('매뉴얼 업로드'),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.onTapExcelUpload,
                  label: const Text('엑셀 업로드'),
                  icon: const Icon(Icons.upload_outlined),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.onTapEdit,
                  label: const Text('수정하기'),
                  icon: const Icon(Icons.change_circle_outlined),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.onTapDeleteLocalData,
                  label: const Text('로컬 데이터 삭제'),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
