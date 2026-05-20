import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/app_routes.dart';
import '../utils/money_utils.dart';
import '../widgets/empty_view.dart';

class PreOrderScreen extends StatelessWidget {
  const PreOrderScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mon dat truoc')),
    body: Consumer<CartProvider>(builder: (context, cart, child) {
      if (cart.items.isEmpty) return const EmptyView(message: 'Ban chua chon mon nao');
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cart.items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('${MoneyUtils.format(item.price)} x ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () => cart.decrease(item.menuItemId), icon: const Icon(Icons.remove_circle_outline)),
                      Text(MoneyUtils.format(item.lineTotal), style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Tong cong: ${MoneyUtils.format(cart.totalAmount)}', textAlign: TextAlign.right, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  FilledButton.icon(onPressed: () => Navigator.pushNamed(context, AppRoutes.booking), icon: const Icon(Icons.event_available), label: const Text('Tiep tuc dat ban')),
                  TextButton(onPressed: cart.clear, child: const Text('Xoa tat ca mon')),
                ],
              ),
            ),
          ),
        ],
      );
    }),
  );
}


