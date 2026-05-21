import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/money_formatter.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../providers/app_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.cart.values.toList();
    return RusticScaffold(
      title: 'Gio hang',
      showBottomNav: false,
      child: ListView(padding: const EdgeInsets.all(22), children: [
        if (items.isEmpty) const EmptyState(message: 'Gio hang dang trong') else ...items.map((item) => Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [RusticImage(item.imageUrl, width: 78, height: 78, borderRadius: 12), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)), Text(MoneyFormatter.vnd(item.price))])), IconButton(onPressed: () => context.read<AppState>().decreaseCart(item.itemId), icon: const Icon(Icons.remove_circle_outline)), Text('${item.quantity}'), IconButton(onPressed: () { final menu = state.menuItems.firstWhere((m) => m.id == item.itemId); context.read<AppState>().addToCart(menu); }, icon: const Icon(Icons.add_circle_outline))])))),
        if (items.isNotEmpty) ...[const SizedBox(height: 20), _TotalRow(label: 'Subtotal', value: state.cartSubtotal), _TotalRow(label: 'Discount', value: -state.cartDiscount), const Divider(), _TotalRow(label: 'Total', value: state.cartTotal, bold: true), const SizedBox(height: 18), FilledButton(onPressed: () { context.read<AppState>().checkout(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Da tao order pending'))); Navigator.pop(context); }, child: const Text('Checkout'))]
      ]),
    );
  }
}

class _TotalRow extends StatelessWidget { const _TotalRow({required this.label, required this.value, this.bold = false}); final String label; final double value; final bool bold; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500)), Text(MoneyFormatter.vnd(value), style: TextStyle(color: AppColors.primary, fontWeight: bold ? FontWeight.w900 : FontWeight.w600))])); }
