import 'package:bill_tracker_app/core/data/database_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BillController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  var bills = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBills();
  }

  Future<void> fetchBills() async {
    try {
      isLoading(true);
      final result = await _databaseService.getBills();
      bills.assignAll(result);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addBill({
    required String name,
    required double amount,
    required DateTime dueDate,
    required String frequency,
    required String category,
  }) async {
    final bill = {
      'name': name,
      'amount': amount,
      'dueDate': DateFormat('yyyy-MM-dd').format(dueDate),
      'frequency': frequency,
      'category': category,
      'isPaid': 0, // 0 = unpaid, 1 = paid
      'createdAt': DateTime.now().toIso8601String(),
    };

    await _databaseService.insertBill(bill);
    await fetchBills();
  }

  Future<void> markAsPaid(int billId, double amount, String notes) async {
    // 1. Update the bill's isPaid status
    await _databaseService.updateBill({
      'id': billId,
      'isPaid': 1, // Mark as paid
    });

    // 2. Record the payment
    final payment = {
      'billId': billId,
      'amount': amount,
      'paymentDate': DateTime.now().toIso8601String(),
      'notes': notes,
    };

    await _databaseService.insertPayment(payment);
    await fetchBills(); // Refresh the bills list
  }

  Future<void> markAsUnpaid(int billId) async {
    await _databaseService.updateBill({
      'id': billId,
      'isPaid': 0, // Mark as unpaid
    });
    await fetchBills();
  }
}