import 'package:bill_tracker_app/app/controllers/search_controller.dart';
import 'package:bill_tracker_app/core/widgets/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(SearchControllers());

  SearchScreen({super.key}) {
    controller.searchBills(); // Load initial data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Bills', style: Get.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.searchBills();
              },
              decoration: InputDecoration(
                hintText: 'Search bills...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clearFilters();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Obx(
                  () => _buildFilterDropdown(
                    value: controller.selectedCategory.value,
                    items: controller.categories,
                    onChanged: (value) {
                      controller.selectedCategory.value = value!;
                      controller.searchBills();
                    },
                    hint: 'Category',
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => _buildFilterDropdown(
                    value: controller.selectedStatus.value,
                    items: controller.statuses,
                    onChanged: (value) {
                      controller.selectedStatus.value = value!;
                      controller.searchBills();
                    },
                    hint: 'Status',
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => _buildFilterDropdown(
                    value: controller.selectedFrequency.value,
                    items: controller.frequencies,
                    onChanged: (value) {
                      controller.selectedFrequency.value = value!;
                      controller.searchBills();
                    },
                    hint: 'Frequency',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return const Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.searchResults.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'No bills found',
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Get.theme.colorScheme.onBackground.withOpacity(
                        0.5,
                      ),
                    ),
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final bill = controller.searchResults[index];
                  return BillCard(
                    bill: bill,
                    onPaid: () => _showMarkAsPaidDialog(bill),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
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
        items: items.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        hint: Text(hint),
      ),
    );
  }

  void _showMarkAsPaidDialog(Map<String, dynamic> bill) {
    // Implement your custom dialog here if needed.
  }
}
