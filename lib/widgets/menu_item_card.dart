import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_item_model.dart';
import '../providers/cart_provider.dart';
import '../utils/money_utils.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key, required this.item, this.onTap});

  final MenuItemModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(16)), child: Center(child: Icon(Icons.restaurant_menu, size: 42, color: Theme.of(context).colorScheme.onSecondaryContainer)))),
            const SizedBox(height: 10),
            Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
            Text(MoneyUtils.format(item.price), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => context.read<CartProvider>().add(item), icon: const Icon(Icons.add), label: const Text('Chon mon'))),
          ]),
        ),
      ),
    );
  }
}
