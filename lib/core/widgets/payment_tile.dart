import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await Get.defaultDialog(
          title: 'Confirm Delete',
          middleText: 'Are you sure you want to delete this payment?',
          textConfirm: 'Delete',
          textCancel: 'Cancel',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back(result: true);
          },
          onCancel: () {
            Get.back(result: false);
          },
        );
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(payment['category']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      payment['category'] ?? 'Other',
                      style: Get.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
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
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$formattedDate at $formattedTime',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              if (payment['notes'] != null && payment['notes'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Notes: ${payment['notes']}',
                    style: Get.textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'rent':
        return Colors.blueAccent;
      case 'utilities':
        return Colors.orangeAccent;
      case 'subscription':
        return Colors.purpleAccent;
      case 'insurance':
        return Colors.greenAccent;
      default:
        return Get.theme.colorScheme.secondary;
    }
  }
}
