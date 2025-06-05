import 'package:bill_tracker_app/core/data/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class StatsController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  var isLoading = true.obs;
  var selectedTimeRange = 'Monthly'.obs;
  var selectedChartType = 'Bar'.obs;
  var totalSpent = 0.0.obs;
  var averageBill = 0.0.obs;
  var billsPaid = 0.obs;
  var categoryData = <Map<String, dynamic>>[].obs;
  var monthlyData = <Map<String, dynamic>>[].obs;

  final timeRanges = ['Weekly', 'Monthly', 'Yearly'];
  final chartTypes = ['Bar', 'Pie', 'Line'];

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  List<Map<String, dynamic>> getCategoryData() {
    // This would be replaced with actual data from database
    return [
      {'category': 'Rent', 'amount': 1200, 'color': Colors.blueAccent},
      {'category': 'Utilities', 'amount': 350, 'color': Colors.orangeAccent},
      {'category': 'Subscriptions', 'amount': 75, 'color': Colors.purpleAccent},
      {'category': 'Insurance', 'amount': 200, 'color': Colors.greenAccent},
    ];
  }

  List<Map<String, dynamic>> getMonthlyData() {
    // This would be replaced with actual data from database
    return List.generate(12, (index) {
      final month = DateTime(DateTime.now().year, index + 1, 1);
      return {
        'month': DateFormat('MMM').format(month),
        'amount': (index + 1) * 150.0,
      };
    });
  }

  Future<void> fetchStats() async {
    try {
      isLoading(true);
      final payments = await _databaseService.getAllPayments();
      final bills = await _databaseService.getBills();

      // Calculate basic stats
      totalSpent.value = payments.fold(
        0.0,
        (sum, payment) => sum + (payment['amount'] ?? 0.0),
      );
      averageBill.value = payments.isNotEmpty
          ? totalSpent.value / payments.length
          : 0;
      billsPaid.value = payments.length;

      // Prepare category data
      final categories = [
        'Rent',
        'Utilities',
        'Subscription',
        'Insurance',
        'Other',
      ];
      categoryData.assignAll(
        categories
            .map((category) {
              final categoryPayments = payments.where((p) {
                final bill = bills.firstWhere(
                  (b) => b['id'] == p['billId'],
                  orElse: () => {'category': 'Other'},
                );
                return bill['category'] == category;
              }).toList();

              final amount = categoryPayments.fold(
                0.0,
                (sum, p) => sum + (p['amount'] ?? 0.0),
              );

              return {
                'category': category,
                'amount': amount,
                'color': _getCategoryColor(category),
                'percentage': totalSpent.value > 0
                    ? (amount / totalSpent.value) * 100
                    : 0,
              };
            })
            .where((data) => ((data['amount'] ?? 0) as num) > 0)
            .toList(),
      );

      // Prepare monthly data
      monthlyData.assignAll(_prepareMonthlyData(payments));
    } finally {
      isLoading(false);
    }
  }

  List<Map<String, dynamic>> _prepareMonthlyData(
    List<Map<String, dynamic>> payments,
  ) {
    final now = DateTime.now();
    final monthlySpending = List.generate(12, (index) => 0.0);

    for (final payment in payments) {
      final paymentDate = DateTime.parse(payment['paymentDate']);
      if (paymentDate.year == now.year) {
        monthlySpending[paymentDate.month - 1] += payment['amount'] ?? 0.0;
      }
    }

    return monthlySpending.asMap().entries.map((entry) {
      final month = DateTime(now.year, entry.key + 1, 1);
      return {'month': DateFormat('MMM').format(month), 'amount': entry.value};
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Rent':
        return Colors.blueAccent;
      case 'Utilities':
        return Colors.orangeAccent;
      case 'Subscription':
        return Colors.purpleAccent;
      case 'Insurance':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }
}
