import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/money_formatter.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../models/rustic_models.dart';
import '../../providers/app_state.dart';

class ManageMenuScreen extends StatelessWidget {
  const ManageMenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.menuItems.where((item) => item.isActive).toList();
    return RusticScaffold(
      isAdmin: true,
      currentIndex: 1,
      child: ListView(padding: const EdgeInsets.fromLTRB(36, 36, 36, 110), children: [
        Text('Quan Ly Mon An', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        const Text('Quan ly thuc don, cap nhat gia va thay doi trang thai phuc vu cua cac mon an trong nha hang.', style: TextStyle(fontSize: 20, height: 1.45)),
        const SizedBox(height: 34),
        FilledButton.icon(onPressed: () => _showEditor(context), icon: const Icon(Icons.add), label: const Text('Them mon moi')),
        const SizedBox(height: 34),
        TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tim kiem mon an...')),
        const SizedBox(height: 28),
        ...items.map((item) => _AdminMenuCard(item: item)),
      ]),
    );
  }

  void _showEditor(BuildContext context, {MenuItemModel2? item}) {
    final state = context.read<AppState>();
    final name = TextEditingController(text: item?.name ?? 'Mon moi Rustic');
    final price = TextEditingController(text: '${(item?.price ?? 99000).round()}');
    final description = TextEditingController(text: item?.description ?? 'Mo ta ngan gon ve mon an.');
    showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (_) => Padding(padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(item == null ? 'Them mon moi' : 'Sua mon', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 14), TextField(controller: name, decoration: const InputDecoration(labelText: 'Ten mon')), const SizedBox(height: 12), TextField(controller: description, decoration: const InputDecoration(labelText: 'Mo ta')), const SizedBox(height: 12), TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gia')), const SizedBox(height: 12), OutlinedButton.icon(onPressed: () => ImagePicker().pickImage(source: ImageSource.gallery), icon: const Icon(Icons.image_outlined), label: const Text('Chon anh tu may')), const SizedBox(height: 14), FilledButton(onPressed: () { final now = DateTime.now(); final edited = MenuItemModel2(id: item?.id ?? 'item-${now.millisecondsSinceEpoch}', name: name.text, description: description.text, price: double.tryParse(price.text) ?? 0, categoryId: item?.categoryId ?? 'main', imageUrl: item?.imageUrl ?? 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=80', createdAt: item?.createdAt ?? now, updatedAt: now); state.upsertMenuItem(edited); Navigator.pop(context); }, child: const Text('Luu mon'))])));
  }
}

class _AdminMenuCard extends StatelessWidget {
  const _AdminMenuCard({required this.item});
  final MenuItemModel2 item;
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 28), clipBehavior: Clip.antiAlias, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Stack(children: [RusticImage(item.imageUrl, height: 290, width: double.infinity, borderRadius: 0), Positioned(left: 24, top: 24, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: AppColors.textBrown.withValues(alpha: .8), borderRadius: BorderRadius.circular(8)), child: const Text('MON CHINH', style: TextStyle(color: Colors.white))))]), Padding(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(item.name, style: Theme.of(context).textTheme.headlineMedium)), PopupMenuButton<String>(onSelected: (value) { if (value == 'delete') context.read<AppState>().softDeleteMenuItem(item.id); }, itemBuilder: (_) => const [PopupMenuItem(value: 'delete', child: Text('Xoa mem'))])]), const SizedBox(height: 12), Text(item.description, style: const TextStyle(fontSize: 18)), const Divider(height: 34), Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)), child: Text(MoneyFormatter.vnd(item.price), style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w900))), const Spacer(), const Text('Con hang', style: TextStyle(fontSize: 18)), Switch(value: item.isAvailable, onChanged: (_) => context.read<AppState>().toggleMenuAvailability(item.id), activeThumbColor: Colors.blue)])]))]));
}
