import 'package:bill_tracker_app/app/controllers/main_controller.dart';
import 'package:bill_tracker_app/app/routes/app_pages.dart';
import 'package:bill_tracker_app/core/widgets/custom_bottom_nav.dart';
import 'package:bill_tracker_app/features/bills/bill_screen.dart';
import 'package:bill_tracker_app/features/history/history_screen.dart';
import 'package:bill_tracker_app/features/search/search_screen.dart';
import 'package:bill_tracker_app/features/settings/settings_screen.dart';
import 'package:bill_tracker_app/features/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            Navigator(
              key: Get.nestedKey(0),
              initialRoute: AppPages.INITIAL,
              onGenerateRoute: (settings) {
                return GetPageRoute(
                  settings: settings,
                  page: () => BillScreen(),
                );
              },
            ),
            Navigator(
              key: Get.nestedKey(1),
              initialRoute: '/history',
              onGenerateRoute: (settings) {
                return GetPageRoute(
                  settings: settings,
                  page: () => HistoryScreen(),
                );
              },
            ),
            Navigator(
              key: Get.nestedKey(2),
              initialRoute: '/search',
              onGenerateRoute: (settings) {
                return GetPageRoute(
                  settings: settings,
                  page: () => SearchScreen(),
                );
              },
            ),
            Navigator(
              key: Get.nestedKey(3),
              initialRoute: '/stats',
              onGenerateRoute: (settings) {
                return GetPageRoute(
                  settings: settings,
                  page: () => StatsScreen(),
                );
              },
            ),
            Navigator(
              key: Get.nestedKey(4),
              initialRoute: '/settings',
              onGenerateRoute: (settings) {
                return GetPageRoute(
                  settings: settings,
                  page: () => SettingsScreen(),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.changePage(index);
          },
        ),
      );
    });
  }
}
