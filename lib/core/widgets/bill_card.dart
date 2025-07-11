import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class BillCard extends StatelessWidget {
  final Map<String, dynamic> bill;
  final VoidCallback? onPaid;
  final VoidCallback? onUnpaid;

  const BillCard({super.key, required this.bill, this.onPaid, this.onUnpaid});

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.parse(bill['dueDate']);
    final isPaid = bill['isPaid'] == 1;

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                  FadeIn(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      bill['name'],
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isPaid ? TextDecoration.lineThrough : null,
                        color: isPaid
                            ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6)
                            : Theme.of(context).colorScheme.onSurface,
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
                          _getCategoryColor(bill['category'], context),
                          _getCategoryColor(
                            bill['category'],
                            context,
                          ).withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor(
                            bill['category'],context
                          ).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      bill['category'],
                      style: Get.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 100),
                child: Text(
                  '\$${bill['amount'].toStringAsFixed(2)}',
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPaid
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(dueDate),
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.repeat,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      bill['frequency'],
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 300),
                child: isPaid
                    ? OutlinedButton(
                        style:
                            OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withOpacity(0.5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ).copyWith(
                              overlayColor: MaterialStateProperty.all(
                                Theme.of(
                                  context,
                                ).colorScheme.secondary.withOpacity(0.2),
                              ),
                            ),
                        onPressed: onUnpaid,
                        child: Text(
                          'Mark as Unpaid',
                          style: Get.textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ).copyWith(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.transparent,
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                        onPressed: onPaid,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Text(
                            'Mark as Paid',
                            style: Get.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category, BuildContext context) {
    switch (category.toLowerCase()) {
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
