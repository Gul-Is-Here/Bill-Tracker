// lib/app/routes/app_pages.dart

import 'package:bill_tracker_app/features/bills/add_bill_screen.dart';
import 'package:bill_tracker_app/features/bills/bill_screen.dart';
import 'package:bill_tracker_app/features/history/history_screen.dart';
import 'package:bill_tracker_app/features/search/search_screen.dart';
import 'package:bill_tracker_app/features/settings/settings_screen.dart';
import 'package:bill_tracker_app/features/stats/stats_screen.dart';
import 'package:bill_tracker_app/main_screen.dart';
import 'package:bill_tracker_app/splash_screen.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static const INITIAL = '/splash';

  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/main', page: () => MainScreen()),
    GetPage(name: '/home', page: () => BillScreen()),
    GetPage(name: '/history', page: () => HistoryScreen()),
    GetPage(name: '/search', page: () => SearchScreen()),
    GetPage(name: '/stats', page: () => StatsScreen()),
    GetPage(name: '/settings', page: () => SettingsScreen()),
    GetPage(name: '/add-bill', page: () => const AddBillScreen()),
  ];
}
