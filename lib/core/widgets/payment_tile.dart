import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class PaymentTile extends StatelessWidget {
  final Map<String, dynamic> payment;
  final Function onDelete;

  const PaymentTile({super.key, required this.payment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final paymentDate = DateTime.parse(payment['paymentDate']);
    final formattedDate = DateFormat('MMM dd, yyyy').format(paymentDate);
    final formattedTime = DateFormat('hh:mm a').format(paymentDate);

    return Dismissible(
      key: Key(payment['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.withOpacity(0.8), Colors.redAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await Get.defaultDialog(
          title: 'Confirm Delete',
          titleStyle: Get.textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          middleText: 'Are you sure you want to delete this payment?',
          middleTextStyle: Get.textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          radius: 12,
          textConfirm: 'Delete',
          textCancel: 'Cancel',
          confirmTextColor: Colors.white,
          buttonColor: Theme.of(context).colorScheme.primary,
          cancelTextColor: Theme.of(context).colorScheme.onSurface,
          onConfirm: () {
            Get.back(result: true);
          },
          onCancel: () {
            Get.back(result: false);
          },
        );
      },
      onDismissed: (direction) => onDelete(),
      child: FadeInUp(
        duration: const Duration(milliseconds: 400),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          payment['name'] ?? 'Unknown Bill',
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getCategoryColor(payment['category'], context),
                              _getCategoryColor(
                                payment['category'],context
                              ).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _getCategoryColor(
                                payment['category'],context
                              ).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          payment['category'] ?? 'Other',
                          style: Get.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(payment['amount'] ?? 0.0).toStringAsFixed(2)}',
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$formattedDate at $formattedTime',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (payment['notes'] != null && payment['notes'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Notes: ${payment['notes']}',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category, BuildContext context) {
    switch (category?.toLowerCase()) {
      case 'rent':
        return Theme.of(context).colorScheme.primary; // #FA980B
      case 'utilities':
        return const Color(0xFFFF6B6B); // Coral for contrast
      case 'subscription':
        return const Color(0xFF6B7280); // Gray for neutrality
      case 'insurance':
        return Theme.of(context).colorScheme.secondary; // #0BBEFA
      case 'loan':
        return const Color(0xFF34C759); // Green for financial
      default:
        return Theme.of(context).colorScheme.secondary; // #0BBEFA
    }
  }
}
