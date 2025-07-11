import 'package:bill_tracker_app/app/controllers/bill_controller.dart';
import 'package:bill_tracker_app/app/controllers/history_controller.dart';
import 'package:bill_tracker_app/app/controllers/stats_controller.dart';
import 'package:bill_tracker_app/core/widgets/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class BillScreen extends StatelessWidget {
  final BillController controller = Get.put(BillController());

  BillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.background.withOpacity(0.8),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 4,
              shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'Upcoming Bills',
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => controller.fetchBills(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.bills.isEmpty) {
                  return FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'No Bills Added Yet',
                            style: Get.textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground
                                  .withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first bill',
                            style: Get.textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.bills.length,
                  itemBuilder: (context, index) {
                    final bill = controller.bills[index];
                    return FadeInUp(
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      child: BillCard(
                        bill: bill,
                        onPaid: bill['isPaid'] == 1
                            ? null
                            : () => _showMarkAsPaidDialog(bill, context),
                        onUnpaid: bill['isPaid'] == 1
                            ? () => controller.markAsUnpaid(bill['id'])
                            : null,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add-bill')?.then((_) {
            controller.fetchBills();
            if (Get.isRegistered<StatsController>()) {
              Get.find<StatsController>().fetchStats();
            }
            if (Get.isRegistered<HistoryController>()) {
              Get.find<HistoryController>().fetchPayments();
            }
          });
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  void _showMarkAsPaidDialog(Map<String, dynamic> bill, BuildContext context) {
    final amountController = TextEditingController(
      text: bill['amount'].toString(),
    );
    final notesController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        backgroundColor: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Mark as Paid',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                duration: const Duration(milliseconds: 400),
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                child: TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    prefixIcon: Icon(
                      Icons.note,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: Get.textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
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
                        controller.fetchBills();

                        Get.back();

                        Get.snackbar(
                          'Success',
                          'Bill marked as paid',
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to mark as paid: $e',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                      }
                    },
                    child: Text(
                      'Confirm',
                      style: Get.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
    );
  }
}
