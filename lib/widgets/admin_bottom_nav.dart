import 'package:flutter/material.dart';

import '../utils/app_routes.dart';
import '../utils/bistro_theme.dart';

class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final items = [
      _AdminNavItem('Dashboard', Icons.grid_view_outlined, AppRoutes.adminDashboard),
      _AdminNavItem('Bookings', Icons.chair_outlined, AppRoutes.adminBookings),
      _AdminNavItem('Floor Plan', Icons.layers_outlined, AppRoutes.adminFloorPlan),
      _AdminNavItem('Alerts', Icons.notifications_none, AppRoutes.adminAlerts),
    ];
    return NavigationBar(
      selectedIndex: currentIndex,
      height: 84,
      backgroundColor: BistroColors.card,
      indicatorColor: BistroColors.ember.withValues(alpha: .1),
      onDestinationSelected: (index) {
        if (index == currentIndex) return;
        Navigator.pushReplacementNamed(context, items[index].route);
      },
      destinations: [for (final item in items) NavigationDestination(icon: Icon(item.icon), selectedIcon: Icon(item.icon, color: BistroColors.ember), label: item.label)],
    );
  }
}

class _AdminNavItem {
  const _AdminNavItem(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}
