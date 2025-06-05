import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BillCard extends StatelessWidget {
  final Map<String, dynamic> bill;
  final VoidCallback? onPaid;
  final VoidCallback? onUnpaid;

  const BillCard({super.key, required this.bill, this.onPaid, this.onUnpaid});

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.parse(bill['dueDate']);
    final isPaid = bill['isPaid'] == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bill['name'],
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isPaid ? TextDecoration.lineThrough : null,
                    color: isPaid ? Colors.grey : null,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(bill['category']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bill['category'],
                    style: Get.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${bill['amount'].toStringAsFixed(2)}',
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isPaid ? Colors.green : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(dueDate),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.repeat,
                  size: 16,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  bill['frequency'],
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isPaid)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onUnpaid,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text('Mark as Unpaid'),
                ),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onPaid,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text(
                    'Mark as Paid',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
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
