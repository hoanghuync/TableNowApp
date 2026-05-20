import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_item_model.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/restaurant_provider.dart';
import '../screens/menu_detail_screen.dart';
import '../utils/app_routes.dart';
import '../utils/bistro_theme.dart';
import '../widgets/bistro_bottom_nav.dart';
import '../widgets/empty_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Tat ca';
  bool _showMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final restaurantProvider = context.read<RestaurantProvider>();
      await restaurantProvider.loadRestaurant();
      if (restaurantProvider.restaurant != null && mounted) {
        context.read<MenuProvider>().loadMenu(restaurantProvider.restaurant!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.map), icon: const Icon(Icons.location_on_outlined)),
      title: const Text('BistroFlow'),
      actions: [IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.preOrder), icon: const Icon(Icons.shopping_bag_outlined))],
    ),
    body: Consumer<MenuProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      if (provider.items.isEmpty) return const EmptyView(message: 'Chua co mon an');
      final featured = _sampleRestaurants;
      final visible = _showMore ? featured : featured.take(3).toList();
      final menuItems = _selectedCategory == 'Tat ca' ? provider.items : provider.items.where((item) => item.category.toLowerCase().contains(_selectedCategory.toLowerCase().replaceAll('mon ', ''))).toList();
      return ListView(
        padding: const EdgeInsets.fromLTRB(23, 48, 23, 96),
        children: [
          _SearchField(),
          const SizedBox(height: 46),
          SizedBox(height: 42, child: ListView(scrollDirection: Axis.horizontal, children: [
            _FilterChip(label: 'Tat ca', selected: _selectedCategory == 'Tat ca', onTap: () => setState(() => _selectedCategory = 'Tat ca')),
            _FilterChip(label: 'Mon A', selected: _selectedCategory == 'Mon A', onTap: () => setState(() => _selectedCategory = 'Mon A')),
            _FilterChip(label: 'Mon Au', selected: _selectedCategory == 'Mon Au', onTap: () => setState(() => _selectedCategory = 'Mon Au')),
            _FilterChip(label: 'Cafe', selected: _selectedCategory == 'Cafe', onTap: () => setState(() => _selectedCategory = 'Cafe')),
          ])),
          const SizedBox(height: 58),
          Text('Ket qua (${_showMore ? 24 : visible.length})', style: const TextStyle(fontSize: 16, color: BistroColors.ink)),
          const SizedBox(height: 24),
          ...visible.map((item) => _ExploreRestaurantCard(item: item, onTap: () => Navigator.pushNamed(context, AppRoutes.restaurantInfo))),
          const SizedBox(height: 20),
          OutlinedButton(onPressed: () => setState(() => _showMore = !_showMore), style: OutlinedButton.styleFrom(minimumSize: const Size(190, 54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))), child: Text(_showMore ? 'Thu gon ket qua' : 'Tai them ket qua')),
          const SizedBox(height: 38),
          Text('Mon an tu nha hang', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .62, crossAxisSpacing: 14, mainAxisSpacing: 14),
            itemCount: menuItems.length,
            itemBuilder: (context, index) => MenuItemCard(item: menuItems[index], onTap: () => _openDetail(context, menuItems[index])),
          ),
        ],
      );
    }),
    floatingActionButton: Selector<CartProvider, int>(selector: (context, cart) => cart.totalQuantity, builder: (context, quantity, child) => FloatingActionButton.extended(backgroundColor: BistroColors.ember, foregroundColor: Colors.white, onPressed: () => Navigator.pushNamed(context, AppRoutes.preOrder), icon: const Icon(Icons.shopping_bag_outlined), label: Text(quantity == 0 ? 'Mon da chon' : 'Mon da chon ($quantity)'))),
    bottomNavigationBar: const BistroBottomNav(currentIndex: 1),
  );

  void _openDetail(BuildContext context, MenuItemModel item) => Navigator.push(context, MaterialPageRoute(builder: (_) => MenuDetailScreen(item: item)));
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 60,
    decoration: BoxDecoration(color: BistroColors.card, border: Border.all(color: BistroColors.muted), boxShadow: BistroShadows.soft),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(children: [Icon(Icons.search, color: BistroColors.espresso.withValues(alpha: .65)), const SizedBox(width: 12), Expanded(child: Text('Tim kiem nha hang, mon an...', style: TextStyle(fontSize: 18, color: BistroColors.ember.withValues(alpha: .35)))), const Icon(Icons.tune, color: BistroColors.ember)]),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 12),
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(24), child: Container(width: 104, alignment: Alignment.center, decoration: BoxDecoration(color: selected ? BistroColors.ember : BistroColors.muted, borderRadius: BorderRadius.circular(24)), child: Text(label, style: TextStyle(color: selected ? Colors.white : BistroColors.espresso, fontWeight: FontWeight.w800)))),
  );
}

class _ExploreRestaurantCard extends StatelessWidget {
  const _ExploreRestaurantCard({required this.item, required this.onTap});
  final _ExploreItem item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(12), boxShadow: BistroShadows.soft),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [AspectRatio(aspectRatio: 1.78, child: Image.network(item.imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: BistroColors.muted))), Positioned(top: 14, right: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.star_border, color: BistroColors.ember, size: 15), const SizedBox(width: 4), Text(item.rating, style: const TextStyle(fontWeight: FontWeight.w900))])))]),
        Padding(padding: const EdgeInsets.fromLTRB(16, 18, 16, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))), Text(item.distance, style: const TextStyle(fontSize: 15, color: BistroColors.espresso))]), const SizedBox(height: 10), Text(item.tags, style: const TextStyle(fontSize: 16, color: BistroColors.espresso)), const SizedBox(height: 18), Row(children: [const Icon(Icons.schedule, size: 17), const SizedBox(width: 8), Text(item.openText, style: const TextStyle(color: BistroColors.espresso))])])),
      ]),
    ),
  );
}

class _ExploreItem {
  const _ExploreItem({required this.title, required this.tags, required this.distance, required this.openText, required this.rating, required this.imageUrl});
  final String title;
  final String tags;
  final String distance;
  final String openText;
  final String rating;
  final String imageUrl;
}

const _sampleRestaurants = [
  _ExploreItem(title: 'The Spice Terrace', tags: 'Mon A • Sang trong • Khong gian ngoai troi', distance: '1.2 km', openText: 'Dang mo cua • Dong luc 23:00', rating: '4.8', imageUrl: 'https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=900&q=80'),
  _ExploreItem(title: 'Lumina Bistro', tags: 'Mon Au • Lang man • Ruou vang', distance: '2.5 km', openText: 'Mo cua luc 17:00', rating: '4.9', imageUrl: 'https://images.unsplash.com/photo-1481931098730-318b6f776db0?auto=format&fit=crop&w=900&q=80'),
  _ExploreItem(title: 'Hearth & Home', tags: 'Mon A • Gia dinh • Khong gian rong', distance: '3.8 km', openText: 'Dang mo cua • Dong luc 22:00', rating: '4.6', imageUrl: 'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=900&q=80'),
  _ExploreItem(title: 'Maison Rouge', tags: 'Fusion • Fine Dining • Tasting Menu', distance: '4.1 km', openText: 'Mo cua luc 18:00', rating: '4.7', imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=900&q=80'),
];
