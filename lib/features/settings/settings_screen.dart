import 'package:bill_tracker_app/app/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsController extends GetxController {
  final MainController mainController = Get.find();
  var selectedFont = 'Poppins'.obs;
  var fontSize = 14.0.obs;

  final fonts = ['Poppins', 'Montserrat', 'Roboto', 'Open Sans'];
}

class SettingsScreen extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());
  final MainController mainController = Get.find();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Get.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeSwitch(),
            const SizedBox(height: 24),
            _buildFontSelector(),
            const SizedBox(height: 24),
            _buildFontSizeSlider(),
            const SizedBox(height: 32),

            const SizedBox(height: 16),

            const SizedBox(height: 32),
            _buildAppInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSwitch() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dark Mode', style: Get.textTheme.bodyLarge),
            Obx(
              () => FlutterSwitch(
                width: 50,
                height: 28,
                toggleSize: 24,
                value: mainController.isDarkMode.value,
                borderRadius: 15,
                padding: 2,
                activeColor: Get.theme.colorScheme.primary,
                onToggle: mainController.changeTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Font', style: Get.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Obx(
              () => DropdownButton<String>(
                value: controller.selectedFont.value,
                isExpanded: true,
                items: controller.fonts.map((font) {
                  return DropdownMenuItem<String>(
                    value: font,
                    child: Text(font, style: GoogleFonts.getFont(font)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedFont.value = value;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Font Size', style: Get.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Obx(
              () => Slider(
                value: controller.fontSize.value,
                min: 12,
                max: 18,
                divisions: 6,
                label: controller.fontSize.value.round().toString(),
                onChanged: (value) {
                  controller.fontSize.value = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Get.theme.colorScheme.primary),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildAppInfo() {
    return Center(
      child: Column(
        children: [
          Text(
            'Bill Tracker',
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: Get.textTheme.bodySmall?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '© 2025 Bill Tracker App',
            style: Get.textTheme.bodySmall?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  

  


  
}
