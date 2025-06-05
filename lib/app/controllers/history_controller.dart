import 'package:get/get.dart';

import '../../core/data/database_service.dart';

class HistoryController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  var payments = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var selectedFilter = 'All'.obs;
  final filters = ['All', 'This Month', 'Last 3 Months', 'This Year'];
  var totalSpent = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  Future<void> fetchPayments({String? filter}) async {
    try {
      isLoading(true);
      final allPayments = await _databaseService.getAllPayments();
      
      // Join with bills to get bill names and categories
      final bills = await _databaseService.getBills();
      final joinedPayments = allPayments.map((payment) {
        final bill = bills.firstWhere(
          (b) => b['id'] == payment['billId'],
          orElse: () => {'name': 'Unknown Bill', 'category': 'Other'},
        );
        return {
          ...payment,
          'name': bill['name'],
          'category': bill['category'],
        };
      }).toList();
      
      payments.assignAll(joinedPayments);
      totalSpent.value = payments.fold(0.0, (sum, payment) => sum + (payment['amount'] ?? 0.0));
      
      if (filter != null && filter != 'All') {
        _applyTimeFilter(filter);
      }
    } finally {
      isLoading(false);
    }
  }

  void _applyTimeFilter(String filter) {
    final now = DateTime.now();
    DateTime startDate;
    
    switch (filter) {
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Last 3 Months':
        startDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case 'This Year':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        startDate = DateTime(1970);
    }
    
    payments.value = payments.where((payment) {
      final paymentDate = DateTime.parse(payment['paymentDate']);
      return paymentDate.isAfter(startDate);
    }).toList();
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    fetchPayments(filter: filter);
  }

  Future<void> deletePayment(int paymentId) async {
    try {
      isLoading(true);
      await _databaseService.deletePayment(paymentId);
      await fetchPayments(filter: selectedFilter.value);
      Get.snackbar('Success', 'Payment deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete payment: $e');
    } finally {
      isLoading(false);
    }
  }
}