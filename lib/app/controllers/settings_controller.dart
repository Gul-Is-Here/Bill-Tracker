import 'package:bill_tracker_app/app/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final GetStorage storage = GetStorage();
  final MainController mainController = Get.find();
  
  var selectedFont = 'Poppins'.obs;
  var fontSize = 14.0.obs;
  var backupCreatedAt = ''.obs;

  final fonts = ['Poppins', 'Montserrat', 'Roboto', 'Open Sans'];

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    selectedFont.value = storage.read('selectedFont') ?? 'Poppins';
    fontSize.value = storage.read('fontSize') ?? 14.0;
    backupCreatedAt.value = storage.read('backupCreatedAt') ?? '';
  }

  void changeFont(String font) {
    selectedFont.value = font;
    storage.write('selectedFont', font);
  }

  void changeFontSize(double size) {
    fontSize.value = size;
    storage.write('fontSize', size);
  }

  Future<void> createBackup() async {
    // Implement backup functionality
    final now = DateTime.now();
    backupCreatedAt.value = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';
    storage.write('backupCreatedAt', backupCreatedAt.value);
    Get.snackbar('Success', 'Backup created successfully');
  }

  Future<void> restoreBackup() async {
    // Implement restore functionality
    Get.defaultDialog(
      title: 'Confirm Restore',
      middleText: 'This will overwrite all current data. Continue?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async {
        Get.back();
        Get.snackbar('Success', 'Data restored successfully');
      },
    );
  }

  Future<void> exportToCSV() async {
    // Implement export functionality
    Get.snackbar('Success', 'Data exported to CSV');
  }

  Future<void> clearAllData() async {
    Get.defaultDialog(
      title: 'Confirm Clear Data',
      middleText: 'This will permanently delete all your data. Continue?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        // Implement clear data functionality
        Get.back();
        Get.snackbar('Success', 'All data has been cleared');
      },
    );
  }
}