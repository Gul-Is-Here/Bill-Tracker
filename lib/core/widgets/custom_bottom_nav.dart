import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNav extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomBottomNav({
    Key? key,
    required this.onTap,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            index: 0,
            currentIndex: currentIndex,
            icon: Icons.home,
            label: 'Home',
            onTap: onTap,
          ),
          _NavItem(
            index: 1,
            currentIndex: currentIndex,
            icon: Icons.history,
            label: 'History',
            onTap: onTap,
          ),
          _NavItem(
            index: 2,
            currentIndex: currentIndex,
            icon: Icons.search,
            label: 'Search',
            onTap: onTap,
          ),
          _NavItem(
            index: 3,
            currentIndex: currentIndex,
            icon: Icons.bar_chart,
            label: 'Stats',
            onTap: onTap,
          ),
          _NavItem(
            index: 4,
            currentIndex: currentIndex,
            icon: Icons.settings,
            label: 'Settings',
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final Function(int) onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive
                ? Get.theme.colorScheme.primary
                : Get.theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Get.textTheme.labelSmall?.copyWith(
              color: isActive
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
