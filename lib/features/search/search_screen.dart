import 'package:bill_tracker_app/app/controllers/search_controller.dart';
import 'package:bill_tracker_app/core/widgets/bill_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(SearchControllers());

  SearchScreen({super.key}) {
    controller.searchBills(); // Load initial data
  }

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
                'Search Bills',
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(
                                0.2,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            controller.searchQuery.value = value;
                            controller.searchBills();
                          },
                          decoration: InputDecoration(
                            hintText: 'Search bills...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                controller.clearFilters();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface
                                .withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 100),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Obx(
                            () => _buildFilterDropdown(context: context,
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
                            () => _buildFilterDropdown(context: context,
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
                            () => _buildFilterDropdown(context: context,
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
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.searchResults.isEmpty) {
                      return FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  'No Bills Found',
                                  style: Get.textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground
                                        .withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search or filters',
                                  style: Get.textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final bill = controller.searchResults[index];
                        return FadeInUp(
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          child: BillCard(
                            bill: bill,
                            onPaid: () => _showMarkAsPaidDialog(bill),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
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
          hint,
          style: Get.textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
        dropdownColor: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _showMarkAsPaidDialog(Map<String, dynamic> bill) {
    // Implement your custom dialog here if needed.
  }
}
