import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainController extends GetxController {
  final storage = GetStorage();
  var isDarkMode = false.obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = storage.read('isDarkMode') ?? false;
  }

  void changeTheme(bool value) {
    isDarkMode.value = value;
    storage.write('isDarkMode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}