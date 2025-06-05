import 'package:bill_tracker_app/app/controllers/stats_controller.dart';
import 'package:bill_tracker_app/core/data/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatelessWidget {
  final StatsController controller = Get.put(StatsController());

  StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics', style: Get.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildChartSelector(),
              const SizedBox(height: 16),
              _buildChart(),
              const SizedBox(height: 24),
              _buildCategoryBreakdown(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Spent',
            value: '\$${controller.totalSpent.value.toStringAsFixed(2)}',
            icon: Icons.attach_money,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: 'Avg. Bill',
            value: '\$${controller.averageBill.value.toStringAsFixed(2)}',
            icon: Icons.calculate,
            color: Colors.purpleAccent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: 'Bills Paid',
            value: controller.billsPaid.value.toString(),
            icon: Icons.check_circle,
            color: Colors.greenAccent,
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
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildSelector(
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Get.theme.colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        isExpanded: true,
        items: items.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildChart() {
    return Card(
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
                ),
                series: <CircularSeries>[
                  PieSeries<Map<String, dynamic>, String>(
                    dataSource: controller.getCategoryData(),
                    xValueMapper: (data, _) => data['category'],
                    yValueMapper: (data, _) => data['amount'],
                    pointColorMapper: (data, _) => data['color'],
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              );
            } else {
              return SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.currency(symbol: '\$'),
                ),
                series: <CartesianSeries<Map<String, dynamic>, String>>[
                  if (controller.selectedChartType.value == 'Bar')
                    BarSeries<Map<String, dynamic>, String>(
                      dataSource: controller.getMonthlyData(),
                      xValueMapper: (data, _) => data['month'],
                      yValueMapper: (data, _) => data['amount'],
                      color: Get.theme.colorScheme.primary,
                    )
                  else
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: controller.getMonthlyData(),
                      xValueMapper: (data, _) => data['month'],
                      yValueMapper: (data, _) => data['amount'],
                      color: Get.theme.colorScheme.primary,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: controller.getCategoryData().map((category) {
                final percentage = controller.totalSpent.value == 0
                    ? 0.0
                    : (category['amount'] / controller.totalSpent.value) * 100;

                return Padding(
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
                              Text(category['category']),
                            ],
                          ),
                          Text(
                            '\$${category['amount'].toStringAsFixed(2)} '
                            '(${percentage.toStringAsFixed(1)}%)',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Get.theme.colorScheme.surface,
                        color: category['color'],
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
