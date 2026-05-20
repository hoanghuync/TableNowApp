import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_item_model.dart';
import '../providers/cart_provider.dart';
import '../utils/money_utils.dart';

class MenuDetailScreen extends StatelessWidget {
  const MenuDetailScreen({super.key, required this.item});

  final MenuItemModel item;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(item.name)),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(height: 220, decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.restaurant, size: 76)),
      const SizedBox(height: 18),
      Text(item.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      Text(MoneyUtils.format(item.price), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      Text(item.description),
      const SizedBox(height: 24),
      FilledButton.icon(onPressed: () { context.read<CartProvider>().add(item); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Da them mon vao dat truoc'))); }, icon: const Icon(Icons.add), label: const Text('Chon mon')),
    ]),
  );
}


