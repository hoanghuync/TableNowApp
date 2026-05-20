import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_item_model.dart';
import '../providers/cart_provider.dart';
import '../utils/bistro_theme.dart';
import '../utils/money_utils.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key, required this.item, this.onTap});

  final MenuItemModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl.isNotEmpty ? item.imageUrl : _fallbackDish;
    return Container(
      decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(22), boxShadow: BistroShadows.soft),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (imageContext, error, stackTrace) => Container(color: BistroColors.muted, child: const Icon(Icons.restaurant_menu, size: 42))),
                  Positioned(right: 10, top: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(18)), child: const Row(children: [Icon(Icons.star_border, color: BistroColors.ember, size: 14), SizedBox(width: 3), Text('4.8', style: TextStyle(fontWeight: FontWeight.w800))]))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(MoneyUtils.format(item.price), style: const TextStyle(color: BistroColors.ember, fontSize: 17, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => context.read<CartProvider>().add(item), icon: const Icon(Icons.add), label: const Text('Chon mon'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _fallbackDish = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80';


