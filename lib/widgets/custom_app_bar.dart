import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Widget? leading, bool automaticallyImplyLeading = false})
      : super(
          automaticallyImplyLeading: automaticallyImplyLeading,
          leading: leading,
          centerTitle: true,
          title: const Text("Ha's Family"),
          backgroundColor: Get.theme.colorScheme.background,
          foregroundColor: Get.theme.colorScheme.onBackground,
        );
}
