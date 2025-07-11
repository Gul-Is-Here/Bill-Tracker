import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/main'); // Navigate to main app screen
    });

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long,
              size: 100,
              color: Get.theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'BillGuard',
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
