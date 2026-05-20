import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/restaurant_provider.dart';
import '../services/seed_service.dart';
import '../utils/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SeedService().seedDemoData();
      if (mounted) context.read<RestaurantProvider>().loadRestaurant();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final actions = [
      _HomeAction('Thong tin nha hang', Icons.storefront, AppRoutes.restaurantInfo),
      _HomeAction('Menu mon an', Icons.restaurant_menu, AppRoutes.menu),
      _HomeAction('Dat ban', Icons.event_available, AppRoutes.booking),
      _HomeAction('Lich su booking', Icons.history, AppRoutes.bookingHistory),
      _HomeAction('Thong bao', Icons.notifications_outlined, AppRoutes.notifications),
      _HomeAction('Ban do', Icons.map_outlined, AppRoutes.map),
      if (auth.isAdmin) _HomeAction('Admin booking', Icons.admin_panel_settings, AppRoutes.adminBookings),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableNow'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xin chao, ${auth.user?.fullName ?? 'ban'}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Hom nay minh giu cho ban mot chiec ban dep nhe.'),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.05, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: actions.length,
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.pushNamed(context, action.route),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(action.icon, size: 38),
                            const SizedBox(height: 12),
                            Text(action.title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction {
  const _HomeAction(this.title, this.icon, this.route);
  final String title;
  final IconData icon;
  final String route;
}
