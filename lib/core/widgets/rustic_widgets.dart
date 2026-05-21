import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/rustic_models.dart';
import '../../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/money_formatter.dart';

class RusticScaffold extends StatelessWidget {
  const RusticScaffold({super.key, required this.child, this.title = 'Rustic Kitchen', this.currentIndex = 0, this.showBottomNav = true, this.isAdmin = false});
  final Widget child;
  final String title;
  final int currentIndex;
  final bool showBottomNav;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(padding: const EdgeInsets.all(9), child: CircleAvatar(backgroundColor: AppColors.softPink, child: Icon(isAdmin ? Icons.menu : Icons.person_outline, color: AppColors.primary))),
        title: Text(title),
        actions: [IconButton(onPressed: () => context.push('/cart'), icon: const Icon(Icons.shopping_bag_outlined))],
      ),
      body: child,
      bottomNavigationBar: showBottomNav ? RusticBottomNav(currentIndex: currentIndex, isAdmin: isAdmin) : null,
    );
  }
}

class RusticBottomNav extends StatelessWidget {
  const RusticBottomNav({super.key, required this.currentIndex, this.isAdmin = false});
  final int currentIndex;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final customer = [('/home', 'Home', Icons.home_outlined), ('/menu', 'Menu', Icons.restaurant_menu), ('/booking', 'Booking', Icons.calendar_month_outlined), ('/profile', 'Profile', Icons.person_outline)];
    final admin = [('/admin', 'Home', Icons.home_outlined), ('/admin/menu', 'Menu', Icons.restaurant_menu), ('/admin/reservations', 'Booking', Icons.calendar_month_outlined), ('/profile', 'Profile', Icons.person_outline)];
    final items = isAdmin ? admin : customer;
    return NavigationBar(
      selectedIndex: currentIndex,
      height: 72,
      backgroundColor: AppColors.card,
      indicatorColor: AppColors.softPink,
      onDestinationSelected: (index) => context.go(items[index].$1),
      destinations: [for (final item in items) NavigationDestination(icon: Icon(item.$3), selectedIcon: Icon(item.$3, color: AppColors.primary), label: item.$2)],
    );
  }
}

class RusticImage extends StatelessWidget {
  const RusticImage(this.url, {super.key, this.height, this.width, this.borderRadius = 16, this.fit = BoxFit.cover});
  final String url;
  final double? height;
  final double? width;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: CachedNetworkImage(imageUrl: url, height: height, width: width, fit: fit, placeholder: (context, url) => Container(height: height, width: width, color: AppColors.muted), errorWidget: (context, url, error) => Container(height: height, width: width, color: AppColors.muted, child: const Icon(Icons.restaurant))),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: Theme.of(context).textTheme.titleLarge), if (action != null) TextButton(onPressed: onAction, child: Text(action!, style: const TextStyle(color: AppColors.primary)))]);
}

class MenuFoodCard extends StatelessWidget {
  const MenuFoodCard({super.key, required this.item, this.compact = false});
  final MenuItemModel2 item;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favorite = state.favorites.contains(item.id);
    return Container(
      width: compact ? 282 : double.infinity,
      margin: EdgeInsets.only(right: compact ? 18 : 0, bottom: compact ? 0 : 24),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 18, offset: Offset(0, 8))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [RusticImage(item.imageUrl, height: compact ? 175 : 196, width: double.infinity, borderRadius: 14), Positioned(top: 12, right: 12, child: CircleAvatar(backgroundColor: Colors.white, child: IconButton(onPressed: () => context.read<AppState>().toggleFavorite(item.id), icon: Icon(favorite ? Icons.favorite : Icons.favorite_border, color: AppColors.textBrown))))]),
        Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: compact ? 16 : 18))), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.softPink.withValues(alpha: .5), borderRadius: BorderRadius.circular(6)), child: Text('☆ ${item.rating}', style: const TextStyle(color: AppColors.primary, fontSize: 12)))]),
          const SizedBox(height: 8),
          Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: Text(MoneyFormatter.vnd(item.price), style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w800))), CircleAvatar(backgroundColor: AppColors.primary, child: IconButton(onPressed: () => context.read<AppState>().addToCart(item), icon: const Icon(Icons.add, color: Colors.white)))])
        ]))
      ]),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(32), child: Text(message, textAlign: TextAlign.center)));
}



