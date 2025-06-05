import 'package:bill_tracker_app/app/controllers/bill_controller.dart';
import 'package:bill_tracker_app/app/controllers/history_controller.dart';
import 'package:bill_tracker_app/app/controllers/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/payment_tile.dart';

class HistoryScreen extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History', style: Get.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: controller.applyFilter,
            itemBuilder: (context) {
              return controller.filters.map((filter) {
                return PopupMenuItem(value: filter, child: Text(filter));
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Obx(
                    () => Text(
                      controller.selectedFilter.value,
                      style: Get.textTheme.labelLarge,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.payments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No payments found',
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: Get.theme.colorScheme.onBackground.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Spent:', style: Get.textTheme.titleMedium),
                      Text(
                        '\$${controller.totalSpent.value.toStringAsFixed(2)}',
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.payments.length,
                itemBuilder: (context, index) {
                  final payment = controller.payments[index];
                  return PaymentTile(
                    payment: payment,
                    onDelete: () async {
                      await controller.deletePayment(payment['id']);

                      if (Get.isRegistered<StatsController>()) {
                        Get.find<StatsController>().fetchStats();
                      }
                      if (Get.isRegistered<HistoryController>()) {
                        Get.find<HistoryController>().fetchPayments();
                      }

                      BillController().fetchBills(); // Update bill list
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
