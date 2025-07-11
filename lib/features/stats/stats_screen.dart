import 'package:bill_tracker_app/app/controllers/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsScreen extends StatelessWidget {
  final StatsController controller = Get.put(StatsController());

  StatsScreen({super.key});

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
              shadowColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.3),
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'Statistics',
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: _buildSummaryCards(context),
                    ),
                    const SizedBox(height: 24),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 100),
                      child: _buildChartSelector(context),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 200),
                      child: _buildChart(context),
                    ),
                    const SizedBox(height: 24),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      delay: const Duration(milliseconds: 300),
                      child: _buildCategoryBreakdown(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Total \nSpent',
            value: '\$${controller.totalSpent.value.toStringAsFixed(1)}',
            icon: Icons.attach_money,
            color: Theme.of(context).colorScheme.primary, // #FA980B
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Avg. Bill',
            value: '\$${controller.averageBill.value.toStringAsFixed(1)}',
            icon: Icons.calculate,
            color: Theme.of(context).colorScheme.secondary, // #0BBEFA
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            context: context,
            title: 'Bills Paid',
            value: controller.billsPaid.value.toString(),
            icon: Icons.check_circle,
            color: const Color(0xFF34C759), // Green for consistency
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              color: color.withOpacity(0.2),
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
                  Text(
                    title,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(icon, size: 16, color: color),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSelector(
            context: context,
            value: controller.selectedTimeRange.value,
            items: controller.timeRanges,
            onChanged: (value) {
              controller.selectedTimeRange.value = value!;
              // Would trigger data fetch for the selected range
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSelector(
            context: context,
            value: controller.selectedChartType.value,
            items: controller.chartTypes,
            onChanged: (value) {
              controller.selectedChartType.value = value!;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelector({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value.isEmpty ? null : value,
        underline: const SizedBox(),
        isExpanded: true,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: Get.textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text(
          'Select',
          style: Get.textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.primary,
        ),
        dropdownColor: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          child: SizedBox(
            height: 250,
            child: Obx(() {
              if (controller.selectedChartType.value == 'Pie') {
                return SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.bottom,
                    textStyle: Get.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    format: 'point.x: \$point.y',
                  ),
                  series: <CircularSeries>[
                    PieSeries<Map<String, dynamic>, String>(
                      dataSource: controller.getCategoryData(),
                      xValueMapper: (data, _) => data['category'],
                      yValueMapper: (data, _) => data['amount'],
                      pointColorMapper: (data, _) => data['color'],
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: Get.textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelStyle: Get.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: AxisTitle(
                      text: 'Month',
                      textStyle: Get.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.currency(symbol: '\$'),
                    labelStyle: Get.textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    title: AxisTitle(
                      text: 'Amount',
                      textStyle: Get.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    format: 'point.x: \$point.y',
                  ),
                  series: <CartesianSeries<Map<String, dynamic>, String>>[
                    if (controller.selectedChartType.value == 'Bar')
                      BarSeries<Map<String, dynamic>, String>(
                        dataSource: controller.getMonthlyData(),
                        xValueMapper: (data, _) => data['month'],
                        yValueMapper: (data, _) => data['amount'],
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      )
                    else
                      LineSeries<Map<String, dynamic>, String>(
                        dataSource: controller.getMonthlyData(),
                        xValueMapper: (data, _) => data['month'],
                        yValueMapper: (data, _) => data['amount'],
                        color: Theme.of(context).colorScheme.primary,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                          width: 6,
                          height: 6,
                        ),
                      ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              Text(
                'Category Breakdown',
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: controller.getCategoryData().asMap().entries.map((
                  entry,
                ) {
                  final index = entry.key;
                  final category = entry.value;
                  final percentage = controller.totalSpent.value == 0
                      ? 0.0
                      : (category['amount'] / controller.totalSpent.value) *
                            100;

                  return FadeInUp(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: category['color'],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    category['category'],
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '\$${category['amount'].toStringAsFixed(2)} '
                                '(${percentage.toStringAsFixed(1)}%)',
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.3),
                            color: category['color'],
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
