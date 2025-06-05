import 'package:bill_tracker_app/app/controllers/bill_controller.dart';
import 'package:bill_tracker_app/app/controllers/history_controller.dart';
import 'package:bill_tracker_app/app/controllers/stats_controller.dart';
import 'package:bill_tracker_app/core/widgets/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class BillScreen extends StatelessWidget {
  final BillController controller = Get.put(BillController());

  BillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Bills', style: Get.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchBills(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bills.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  'No bill added yet',
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: Get.theme.colorScheme.onBackground.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first bill',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.colorScheme.onBackground.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.bills.length,
          itemBuilder: (context, index) {
            final bill = controller.bills[index];
            return BillCard(
              bill: bill,
              onPaid: bill['isPaid'] == 1
                  ? null
                  : () => _showMarkAsPaidDialog(bill),
              onUnpaid: bill['isPaid'] == 1
                  ? () => controller.markAsUnpaid(bill['id'])
                  : null,
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.toNamed('/add-bill')?.then((_) {
            controller.fetchBills(); // Refresh bill list

            if (Get.isRegistered<StatsController>()) {
              Get.find<StatsController>().fetchStats();
            }
            if (Get.isRegistered<HistoryController>()) {
              Get.find<HistoryController>().fetchPayments();
            }
          });
        },
      ),
    );
  }

  void _showMarkAsPaidDialog(Map<String, dynamic> bill) {
    final amountController = TextEditingController(
      text: bill['amount'].toString(),
    );
    final notesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Mark as Paid', style: Get.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: Get.textTheme.labelLarge),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.primary,
            ),
            onPressed: () async {
              if (amountController.text.isEmpty) return;

              try {
                await controller.markAsPaid(
                  bill['id'],
                  double.parse(amountController.text),
                  notesController.text,
                );
                if (Get.isRegistered<StatsController>()) {
                  Get.find<StatsController>().fetchStats();
                }
                if (Get.isRegistered<HistoryController>()) {
                  Get.find<HistoryController>().fetchPayments();
                }
                controller.fetchBills(); // refresh bill list

                Get.back();

                Get.snackbar('Success', 'Bill marked as paid');
              } catch (e) {
                Get.snackbar('Error', 'Failed to mark as paid: $e');
              }
            },
            child: Text(
              'Confirm',
              style: Get.textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
