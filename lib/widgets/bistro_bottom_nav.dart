import 'package:flutter/material.dart';

import '../utils/app_routes.dart';
import '../utils/bistro_theme.dart';

class BistroBottomNav extends StatelessWidget {
  const BistroBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('Home', Icons.home_outlined, Icons.home, AppRoutes.home),
      _NavItem('Explore', Icons.explore_outlined, Icons.explore, AppRoutes.menu),
      _NavItem('Bookings', Icons.calendar_today_outlined, Icons.calendar_today, AppRoutes.bookingHistory),
      _NavItem('Profile', Icons.person_outline, Icons.person, AppRoutes.profile),
    ];
    return NavigationBar(
      selectedIndex: currentIndex,
      height: 72,
      backgroundColor: BistroColors.card,
      indicatorColor: BistroColors.ember.withValues(alpha: .1),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        if (index == currentIndex) return;
        Navigator.pushReplacementNamed(context, items[index].route);
      },
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon, color: BistroColors.ember),
            label: item.label,
          ),
      ],
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.selectedIcon, this.route);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
}


