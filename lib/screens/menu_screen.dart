import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_item_model.dart';
import '../providers/menu_provider.dart';
import '../providers/restaurant_provider.dart';
import '../screens/menu_detail_screen.dart';
import '../widgets/empty_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) async { final rp = context.read<RestaurantProvider>(); await rp.loadRestaurant(); if (rp.restaurant != null && mounted) context.read<MenuProvider>().loadMenu(rp.restaurant!.id); }); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Menu mon an')),
    body: Consumer<MenuProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      if (provider.items.isEmpty) return const EmptyView(message: 'Chua co mon an');
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.categories.length,
        itemBuilder: (_, index) {
          final category = provider.categories[index];
          final items = provider.byCategory(category);
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.all(8), child: Text(category, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
            GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .66, crossAxisSpacing: 10, mainAxisSpacing: 10), itemCount: items.length, itemBuilder: (_, i) => MenuItemCard(item: items[i], onTap: () => _openDetail(context, items[i]))),
          ]);
        },
      );
    }),
    floatingActionButton: FloatingActionButton.extended(onPressed: () => Navigator.pushNamed(context, '/pre-order'), icon: const Icon(Icons.shopping_bag_outlined), label: const Text('Mon da chon')),
  );

  void _openDetail(BuildContext context, MenuItemModel item) => Navigator.push(context, MaterialPageRoute(builder: (_) => MenuDetailScreen(item: item)));
}
