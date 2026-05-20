import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../utils/money_utils.dart';
import '../widgets/empty_view.dart';

class PreOrderScreen extends StatelessWidget {
  const PreOrderScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mon dat truoc')),
    body: Consumer<CartProvider>(builder: (context, cart, child) {
      if (cart.items.isEmpty) return const EmptyView(message: 'Ban chua chon mon nao');
      return Column(children: [
        Expanded(child: ListView.builder(itemCount: cart.items.length, itemBuilder: (_, i) { final item = cart.items[i]; return ListTile(title: Text(item.name), subtitle: Text('${MoneyUtils.format(item.price)} x ${item.quantity}'), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(onPressed: () => cart.decrease(item.menuItemId), icon: const Icon(Icons.remove_circle_outline)), Text(MoneyUtils.format(item.lineTotal))])); })),
        Padding(padding: const EdgeInsets.all(16), child: FilledButton(onPressed: () => Navigator.pushNamed(context, '/booking'), child: Text('Dat ban - Tong ${MoneyUtils.format(cart.totalAmount)}'))),
      ]);
    }),
  );
}
