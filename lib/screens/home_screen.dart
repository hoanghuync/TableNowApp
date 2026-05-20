import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/restaurant_provider.dart';
import '../services/seed_service.dart';
import '../utils/app_routes.dart';
import '../utils/bistro_theme.dart';
import '../widgets/bistro_bottom_nav.dart';

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
      if (!mounted) return;
      final restaurantProvider = context.read<RestaurantProvider>();
      await restaurantProvider.loadRestaurant();
      if (!mounted) return;
      if (restaurantProvider.restaurant != null) {
        context.read<MenuProvider>().loadMenu(restaurantProvider.restaurant!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final restaurant = context.watch<RestaurantProvider>().restaurant;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.map), icon: const Icon(Icons.location_on_outlined)),
        title: const Text('BistroFlow'),
        actions: [IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.menu), icon: const Icon(Icons.search))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        children: [
          const Text('VI TRI HIEN TAI', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.4, color: BistroColors.espresso)),
          const SizedBox(height: 6),
          Row(children: [Text('Quan 1, TP. HCM', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: BistroColors.ink)), const SizedBox(width: 6), const Icon(Icons.keyboard_arrow_down, color: BistroColors.espresso)]),
          const SizedBox(height: 20),
          _SearchBox(onTap: () => Navigator.pushNamed(context, AppRoutes.menu)),
          const SizedBox(height: 34),
          SizedBox(
            height: 42,
            child: ListView(scrollDirection: Axis.horizontal, children: const [
              _CategoryChip(label: 'Tat ca', icon: Icons.restaurant, selected: true),
              _CategoryChip(label: 'Fine Dining', icon: Icons.wine_bar_outlined),
              _CategoryChip(label: 'Cafe', icon: Icons.local_cafe_outlined),
              _CategoryChip(label: 'Bistro', icon: Icons.dinner_dining_outlined),
            ]),
          ),
          const SizedBox(height: 46),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Pho bien gan day', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.restaurantInfo), child: const Text('Xem tat ca')),
          ]),
          const SizedBox(height: 14),
          _RestaurantCard(
            title: restaurant?.name ?? 'L\'Aura Moderne',
            subtitle: 'Fine Dining',
            distance: '1.2 km',
            price: r'$$$',
            rating: '4.9',
            imageUrl: restaurant?.imageUrl.isNotEmpty == true ? restaurant!.imageUrl : _Images.restaurantWarm,
            onTap: () => Navigator.pushNamed(context, AppRoutes.restaurantInfo),
          ),
          const SizedBox(height: 28),
          _RestaurantCard(title: 'The Morning Brew', subtitle: 'Cafe & Brunch', distance: '2.5 km', price: r'$$', rating: '4.7', imageUrl: _Images.cafe, onTap: () => Navigator.pushNamed(context, AppRoutes.menu)),
          const SizedBox(height: 28),
          _RestaurantCard(title: 'Rustic Hearth', subtitle: 'Bistro', distance: '3.1 km', price: r'$$', rating: '4.8', imageUrl: _Images.steak, onTap: () => Navigator.pushNamed(context, AppRoutes.restaurantInfo)),
          if (auth.isAdmin) ...[const SizedBox(height: 24), FilledButton.icon(onPressed: () => Navigator.pushNamed(context, AppRoutes.adminDashboard), icon: const Icon(Icons.admin_panel_settings), label: const Text('Trang quan tri booking'))],
        ],
      ),
      bottomNavigationBar: const BistroBottomNav(currentIndex: 0),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(28),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(28), boxShadow: BistroShadows.soft),
      child: Row(children: [const Icon(Icons.search, color: BistroColors.espresso), const SizedBox(width: 10), Expanded(child: Text('Tim kiem nha hang, mon an...', style: TextStyle(color: BistroColors.espresso.withValues(alpha: .55)))), Container(width: 38, height: 38, decoration: const BoxDecoration(shape: BoxShape.circle, color: BistroColors.muted), child: const Icon(Icons.tune, size: 20))]),
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.icon, this.selected = false});

  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: BoxDecoration(color: selected ? BistroColors.ember : BistroColors.card, borderRadius: BorderRadius.circular(24), boxShadow: selected ? null : BistroShadows.soft),
    child: Row(children: [Icon(icon, size: 17, color: selected ? Colors.white : BistroColors.espresso), const SizedBox(width: 8), Text(label, style: TextStyle(color: selected ? Colors.white : BistroColors.espresso, fontWeight: FontWeight.w800))]),
  );
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.title, required this.subtitle, required this.distance, required this.price, required this.rating, required this.imageUrl, required this.onTap});

  final String title;
  final String subtitle;
  final String distance;
  final String price;
  final String rating;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(20), boxShadow: BistroShadows.soft),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [AspectRatio(aspectRatio: 1.45, child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: BistroColors.muted, child: const Icon(Icons.restaurant, size: 54)))), Positioned(top: 14, right: 14, child: _RatingBadge(rating: rating))]),
        Padding(padding: const EdgeInsets.fromLTRB(22, 20, 22, 22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500))), _PriceBadge(price: price)]), const SizedBox(height: 12), Row(children: [Text(subtitle), const SizedBox(width: 8), const Text('•', style: TextStyle(color: BistroColors.ember)), const SizedBox(width: 8), const Icon(Icons.location_on_outlined, size: 15, color: BistroColors.espresso), Text(' $distance')])])),
      ]),
    ),
  );
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});
  final String rating;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(22)), child: Row(children: [const Icon(Icons.star_border, color: BistroColors.ember, size: 16), const SizedBox(width: 4), Text(rating, style: const TextStyle(fontWeight: FontWeight.w800))]));
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price});
  final String price;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: BistroColors.cream, borderRadius: BorderRadius.circular(8)), child: Text(price, style: const TextStyle(fontWeight: FontWeight.w800)));
}

class _Images {
  static const restaurantWarm = 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=80';
  static const cafe = 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=900&q=80';
  static const steak = 'https://images.unsplash.com/photo-1558030006-450675393462?auto=format&fit=crop&w=900&q=80';
}
