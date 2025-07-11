import 'package:bill_tracker_app/core/data/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SearchControllers extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var selectedStatus = 'All'.obs;
  var selectedFrequency = 'All'.obs;

  final categories = ['All', 'Rent', 'Utilities', 'Subscription', 'Insurance', 'Other'];
  final statuses = ['All', 'Paid', 'Unpaid', 'Overdue'];
  final frequencies = ['All', 'Monthly', 'Weekly', 'Yearly'];

  Future<void> searchBills() async {
    try {
      isLoading(true);
      final allBills = await _databaseService.getBills();

      searchResults.value = allBills.where((bill) {
        final matchesName = searchQuery.value.isEmpty ||
            bill['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());

        final matchesCategory = selectedCategory.value == 'All' ||
            bill['category'] == selectedCategory.value;

        final matchesStatus = _matchesStatus(bill);

        final matchesFrequency = selectedFrequency.value == 'All' ||
            bill['frequency'] == selectedFrequency.value;

        return matchesName && matchesCategory && matchesStatus && matchesFrequency;
      }).toList();
    } finally {
      isLoading(false);
    }
  }

  bool _matchesStatus(Map<String, dynamic> bill) {
    if (selectedStatus.value == 'All') return true;
    if (selectedStatus.value == 'Paid') return bill['isPaid'] == 1;
    if (selectedStatus.value == 'Unpaid') return bill['isPaid'] == 0;

    // Overdue
    if (bill['isPaid'] == 1) return false;
    final dueDate = DateTime.parse(bill['dueDate']);
    return dueDate.isBefore(DateTime.now());
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'All';
    selectedStatus.value = 'All';
    selectedFrequency.value = 'All';
    searchResults.clear();
    searchBills(); // Refresh after clearing
  }

  String formatDueDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Color getStatusColor(Map<String, dynamic> bill) {
    if (bill['isPaid'] == 1) return Colors.green;
    final dueDate = DateTime.parse(bill['dueDate']);
    if (dueDate.isBefore(DateTime.now())) return Colors.red;
    return Colors.orange;
  }

  String getStatusText(Map<String, dynamic> bill) {
    if (bill['isPaid'] == 1) return 'Paid';
    final dueDate = DateTime.parse(bill['dueDate']);
    if (dueDate.isBefore(DateTime.now())) return 'Overdue';
    return 'Pending';
  }
}
